import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/assets/assets.gen.dart';
import 'package:flutter_pos/core/components/menu_button.dart';
import 'package:flutter_pos/core/components/spaces.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/core/utils/connectivity_utils.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/datasources/delivery_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/order_local_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/models/response/service_charge_response_model.dart';
import 'package:flutter_pos/data/models/response/customer_response_model.dart';
import 'package:flutter_pos/data/models/response/tax_response_model.dart';
import 'package:flutter_pos/data/models/order_item_model.dart';
import 'package:flutter_pos/core/utils/discount_utils.dart';
import 'package:flutter_pos/data/models/request/delivery_request_model.dart';
import 'package:flutter_pos/data/models/request/order_request_model.dart';
import 'package:flutter_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_pos/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_pos/presentation/order/bloc/order/order_bloc.dart';
import 'package:flutter_pos/presentation/order/pages/delivery/delivery_form_dialog.dart';
import 'package:flutter_pos/presentation/order/pages/delivery/delivery_map_page.dart';
import 'package:flutter_pos/presentation/order/widgets/order_card.dart';
import 'package:flutter_pos/presentation/order/widgets/payment_cash_dialog.dart';
import 'package:flutter_pos/presentation/order/widgets/payment_qris_dialog.dart';
import 'package:flutter_pos/presentation/order/widgets/process_button.dart';

import '../../../data/models/response/discount_response_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final ValueNotifier<int> indexValue = ValueNotifier(0);
  final TextEditingController orderNameController = TextEditingController();
  final TextEditingController tableNumberController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  // Track selected tax, service charge, and customer
  TaxResponseModel? _selectedTax;
  ServiceChargeResponseModel? _selectedServiceCharge;
  CustomerResponseModel? _selectedCustomer;
  bool _isDiscountActive = false;
  bool _isTaxActive = false;
  bool _isServiceChargeActive = false;
  bool _isCustomerActive = false;
  bool _isDeliveryLoading = false;
  LatLng? deliveryPoint;
  String? deliveryAddress;
  List<OrderItem> orders = [];
  bool isOnline = true;
  bool hasOfflineOrders = false;
  int totalPrice = 0;

  int calculateTotalPrice(List<OrderItem> orders) {
    return orders.fold(
      0,
      (previousValue, element) =>
          previousValue + element.product.price.toInt() * element.quantity,
    );
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _checkOfflineOrders();
    // Fetch available discounts when the page loads
    // context.read<DiscountBloc>().add(const DiscountEvent.getTodayDiscounts());
    // Load tax and service charge data
    _loadTaxAndServiceCharge();
  }

  // Load tax, service charge, and customer from local database
  Future<void> _loadTaxAndServiceCharge() async {
    try {
      final productLocalDatasource = ProductLocalDatasource.instance;
      final taxes = await productLocalDatasource.getAllTax();
      final serviceCharges = await productLocalDatasource.getAllServiceCharge();
      final customers = await productLocalDatasource.getAllCustomers();

      if (taxes.isNotEmpty) {
        setState(() {
          _selectedTax = taxes.first;
        });
      }

      if (serviceCharges.isNotEmpty) {
        setState(() {
          _selectedServiceCharge = serviceCharges.first;
        });
      }

      if (customers.isNotEmpty) {
        setState(() {
          _selectedCustomer = customers.first;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data pajak dan service charge: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Handle tax button press
  void _onTaxPressed() async {
    if (_selectedTax == null) return;

    // Toggle tax active state
    setState(() {
      _isTaxActive = !_isTaxActive;
    });

    // Only apply tax if it's being activated
    if (_isTaxActive) {
      context.read<OrderBloc>().add(OrderEvent.applyTax(_selectedTax!));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Pajak ${_selectedTax!.name} (${_selectedTax!.rate}%) berhasil diterapkan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      // Remove tax if being deactivated
      context.read<OrderBloc>().add(OrderEvent.applyTax(TaxResponseModel(
            id: 0,
            name: '',
            rate: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )));
    }
  }

  // Handle service charge button press
  void _onServiceChargePressed() async {
    if (_selectedServiceCharge == null) return;

    // Toggle service charge active state
    setState(() {
      _isServiceChargeActive = !_isServiceChargeActive;
    });

    // Only apply service charge if it's being activated
    if (_isServiceChargeActive) {
      context
          .read<OrderBloc>()
          .add(OrderEvent.applyServiceCharge(_selectedServiceCharge!));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Service charge ${_selectedServiceCharge!.name} (${_selectedServiceCharge!.rate}%) berhasil diterapkan'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      // Remove service charge if being deactivated
      context
          .read<OrderBloc>()
          .add(OrderEvent.applyServiceCharge(ServiceChargeResponseModel(
            id: 0,
            name: '',
            rate: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          )));
    }
  }

  // Show tax info on long press
  void _showTaxInfo() {
    if (_selectedTax == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Info Pajak'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${_selectedTax!.name}'),
            Text('Rate: ${_selectedTax!.rate}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // Show service charge info on long press
  void _showServiceChargeInfo() {
    if (_selectedServiceCharge == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Info Service Charge'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama: ${_selectedServiceCharge!.name}'),
            Text('Rate: ${_selectedServiceCharge!.rate}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // Show customer selection bottom modal
  void _showCustomerSelection() {
    final productLocalDatasource = ProductLocalDatasource.instance;
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Pilih Pelanggan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari pelanggan...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onChanged: (value) {
                    setModalState(() {});
                  },
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<CustomerResponseModel>>(
                  future: searchController.text.isEmpty
                      ? productLocalDatasource.getAllCustomers()
                      : productLocalDatasource
                          .searchCustomers(searchController.text),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Gagal memuat data pelanggan'));
                    }

                    final customers = snapshot.data ?? [];

                    if (customers.isEmpty) {
                      return const Center(
                          child: Text('Tidak ada data pelanggan'));
                    }

                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          return ListTile(
                            title: Text(customer.name),
                            subtitle: Text(customer.phoneNumber!),
                            trailing: Text(customer.customerType),
                            onTap: () {
                              setState(() {
                                _selectedCustomer = customer;
                                _isCustomerActive = true;
                              });
                              Navigator.pop(context);
                              SnackbarUtils(
                                      text:
                                          'Pelanggan ${customer.name} dipilih',
                                      backgroundColor: Colors.green)
                                  .showSuccessSnackBar(context);
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _checkConnectivity() async {
    final connected = await ConnectivityUtils.isConnected();
    setState(() {
      isOnline = connected;
    });
  }

  Future<void> _checkOfflineOrders() async {
    try {
      final unsyncedOrders =
          await OrderLocalDatasource.instance.getUnsyncedOrders();
      if (mounted) {
        setState(() {
          hasOfflineOrders = unsyncedOrders.isNotEmpty;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasOfflineOrders = false;
        });
        debugPrint('Error checking offline orders: $e');
      }
    }
  }

  // Track selected discounts
  final List<DiscountResponseModel> _selectedDiscounts = [];
  bool _isDiscountLoading = false;
  // final TextEditingController _discountController = TextEditingController();

  // Parse time string to TimeOfDay
  TimeOfDay? _parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      debugPrint('Error parsing time: $e');
    }
    return null;
  }

  // Format currency
  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return format.format(amount);
  }

  // Check if discount is valid for current time
  bool _isDiscountValidNow(DiscountResponseModel discount) {
    final now = DateTime.now();

    // Check if today is in valid days (1=Monday, 7=Sunday)
    if (discount.data[0].validDays.isNotEmpty &&
        !discount.data[0].validDays.contains(now.weekday)) {
      return false;
    }

    // Check date range
    if (discount.data[0].startDate != null &&
        now.isBefore(discount.data[0].startDate!)) {
      return false;
    }
    if (discount.data[0].expiredDate != null &&
        now.isAfter(discount.data[0].expiredDate!)) {
      return false;
    }

    // Check time window if specified
    if (discount.data[0].startTime != null &&
        discount.data[0].endTime != null) {
      final currentTime = TimeOfDay.now();
      final startTime = _parseTime(discount.data[0].startTime!);
      final endTime = _parseTime(discount.data[0].endTime!);

      if (startTime == null || endTime == null) return false;

      if (startTime.hour < endTime.hour) {
        // Same day time window
        if (currentTime.hour < startTime.hour ||
            currentTime.hour > endTime.hour) {
          return false;
        }
        if (currentTime.hour == startTime.hour &&
            currentTime.minute < startTime.minute) {
          return false;
        }
        if (currentTime.hour == endTime.hour &&
            currentTime.minute > endTime.minute) {
          return false;
        }
      } else {
        // Crosses midnight
        if (currentTime.hour < startTime.hour &&
            currentTime.hour > endTime.hour) {
          return false;
        }
        if (currentTime.hour == startTime.hour &&
            currentTime.minute < startTime.minute) {
          return false;
        }
        if (currentTime.hour == endTime.hour &&
            currentTime.minute > endTime.minute) {
          return false;
        }
      }
    }

    return true;
  }

  Future<void> _showDiscountDialog() async {
    try {
      setState(() {
        _isDiscountLoading = true;
        _selectedDiscounts.clear();
      });

      if (!mounted) return;

      // Get current checkout state
      final checkoutState = context.read<CheckoutBloc>().state;

      // Get order items from checkout state
      final orderItems = checkoutState.maybeWhen(
        success: (products, totalQuantity, totalPrice, draftName) {
          debugPrint('Checkout state - Products count: ${products.length}');
          if (products.isNotEmpty) {
            debugPrint(
                'Order product IDs: ${products.map((item) => item.product.id).toList()}');
            debugPrint(
                'Order product names: ${products.map((item) => item.product.name).toList()}');
            debugPrint(
                'Order quantities: ${products.map((item) => item.quantity).toList()}');
          } else {
            debugPrint('No products in checkout state');
          }
          return products;
        },
        orElse: () {
          debugPrint('Checkout state is not success');
          return [];
        },
      );

      // If no order items, show error message
      if (orderItems.isEmpty) {
        if (!mounted) return;

        setState(() {
          _isDiscountLoading = false;
        });

        // Show a message that discounts can't be applied to an empty order
        if (!mounted) return;
        SnackbarUtils(
          text:
              'Tidak ada produk dalam pesanan. Silakan tambahkan produk terlebih dahulu.',
          backgroundColor: Colors.red,
        ).showErrorSnackBar(context);
        return;
      }

      // Load all discounts
      final productLocalDatasource = ProductLocalDatasource.instance;
      final allDiscounts = await productLocalDatasource.getAllDiscount();

      debugPrint('All discounts count: ${allDiscounts.length}');

      // Filter discounts that are valid for today, active, and applicable to products in the order
      final validDiscounts = allDiscounts.where((discount) {
        final discountData = discount.data[0];
        debugPrint(
            '\n=== Checking Discount: ${discountData.name} (ID: ${discountData.id}) ===');
        debugPrint('- Status: ${discountData.status}');
        debugPrint('- Customer Type: ${discountData.customerType}');
        debugPrint('- Apply To: ${discountData.applyTo}');
        debugPrint('- Applicable Items: ${discountData.applicableItems}');

        // Check discount status
        if (discountData.status.toLowerCase() != 'active') {
          debugPrint('❌ Skipped: Discount is not active');
          return false;
        }

        // Check if discount is valid for current date/time
        if (!_isDiscountValidNow(discount)) {
          debugPrint('❌ Skipped: Not valid for current date/time');
          return false;
        }

        // Check customer type
        final customerType =
            (_selectedCustomer?.customerType ?? 'reguler').toLowerCase();
        final customerTypeValid = DiscountUtils.isValidCustomerType(
          customerType,
          discountData.customerType,
        );

        if (!customerTypeValid) {
          debugPrint(
              '❌ Skipped: Customer type "$customerType" not eligible for this discount');
          return false;
        }

        // Check if discount applies to all products
        if (discountData.applyTo.toLowerCase() == 'all' ||
            discountData.applyTo.isEmpty) {
          debugPrint('✅ Included: Applies to all products');
          return true;
        }

        // Check if discount applies to specific products
        try {
          final applyTo = discountData.applyTo.toLowerCase();
          final applicableItems =
              (discountData.applicableItems?.toString() ?? '')
                  .split(',')
                  .map((e) => e.trim())
                  .toList();

          debugPrint('- Apply To: $applyTo');
          debugPrint('- Applicable Items: $applicableItems');

          bool isApplicable = false;

          if (applyTo == 'product' && applicableItems.isNotEmpty) {
            // Check if any product in the order matches the discount's applicable items
            isApplicable = orderItems.any(
                (item) => applicableItems.contains(item.product.id.toString()));
            debugPrint('🔍 Product match: $isApplicable');
          } else if (applyTo == 'category' && applicableItems.isNotEmpty) {
            // Check if any product's category matches the discount's applicable categories
            isApplicable = orderItems.any((item) =>
                applicableItems.contains(item.product.categoryId.toString()));
            debugPrint('🔍 Category match: $isApplicable');
          }

          if (isApplicable) {
            debugPrint('✅ Included: Matches product/category criteria');
          } else {
            debugPrint('❌ Skipped: No matching products/categories in order');
          }

          return isApplicable;
        } catch (e) {
          debugPrint('❌ Error checking product applicability: $e');
          return false;
        }
      }).toList();

      debugPrint('Valid discounts count: ${validDiscounts.length}');

      if (!mounted) return;

      setState(() {
        _isDiscountLoading = false;
      });

      // Show the discount selection dialog
      final selectedDiscounts = await showDialog<List<DiscountResponseModel>>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Pilih Diskon'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: _isDiscountLoading
                    ? const Center(child: CircularProgressIndicator())
                    : validDiscounts.isEmpty
                        ? const Text(
                            'Tidak ada diskon yang tersedia untuk saat ini')
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...validDiscounts.map((discount) {
                                  final isSelected = _selectedDiscounts.any(
                                      (d) =>
                                          d.data[0].id == discount.data[0].id);
                                  return CheckboxListTile(
                                    title: Text(discount.data[0].name),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${discount.data[0].value}% - ${discount.data[0].description ?? ''}'),
                                        if ((discount.data[0].minAmount ?? 0) >
                                            0)
                                          Text(
                                            'Min. belanja: ${_formatCurrency(discount.data[0].minAmount ?? 0)}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                      ],
                                    ),
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      setDialogState(() {
                                        if (value == true) {
                                          _selectedDiscounts.add(discount);
                                        } else {
                                          _selectedDiscounts.removeWhere((d) =>
                                              d.data[0].id ==
                                              discount.data[0].id);
                                        }
                                      });
                                    },
                                  );
                                }),
                              ],
                            ),
                          ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: _selectedDiscounts.isEmpty
                      ? null
                      : () => Navigator.pop(context,
                          List<DiscountResponseModel>.from(_selectedDiscounts)),
                  child: const Text('Terapkan'),
                ),
              ],
            );
          },
        ),
      );

      if (selectedDiscounts != null && selectedDiscounts.isNotEmpty) {
        // Calculate total discount percentage
        final totalDiscount = selectedDiscounts.fold<double>(
          0,
          (sum, discount) => sum + discount.data[0].value,
        );

        // Apply the discount
        context.read<OrderBloc>().add(
              OrderEvent.applyAutoDiscount(
                const [1, 2, 3, 4, 5, 6, 7], // All days
                totalDiscount.toInt(),
              ),
            );

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Diskon berhasil diterapkan (${totalDiscount.toStringAsFixed(0)}%)',
              ),
              backgroundColor: Colors.green,
            ),
          );

          // Update the discount active state
          setState(() {
            _isDiscountActive = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat diskon: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDiscountLoading = false;
        });
      }
    }
  }

  Future<void> _showOpenBillDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Open Bill'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Table Number',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  keyboardType: TextInputType.number,
                  controller: tableNumberController,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Order Name',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  controller: orderNameController,
                  textCapitalization: TextCapitalization.words,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  success: (data, qty, total, draftName) {
                    return TextButton(
                      onPressed: () async {
                        if (tableNumberController.text.isEmpty ||
                            orderNameController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill in all fields'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        try {
                          await AuthLocalDatasource().getAuthData();
                          if (!mounted) return;

                          context.read<CheckoutBloc>().add(
                                CheckoutEvent.saveDraftOrder(
                                  int.tryParse(tableNumberController.text) ?? 0,
                                  orderNameController.text,
                                ),
                              );

                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Order saved successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Error saving order: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Save'),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    final paddingHorizontal = EdgeInsets.symmetric(
      horizontal: isSmallScreen ? 12.0 : 16.0,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.push(const DashboardPage()),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: Text(
          'Order Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 6 : 8,
              vertical: 2,
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isOnline ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOnline ? Icons.wifi : Icons.wifi_off,
                  color: Colors.white,
                  size: isSmallScreen ? 12 : 14,
                ),
                const SizedBox(width: 4),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 10 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (hasOfflineOrders)
            IconButton(
              iconSize: isSmallScreen ? 20 : 24,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                context.read<OrderBloc>().add(
                      const OrderEvent.syncOfflineOrders(),
                    );
              },
              icon: const Icon(Icons.sync),
              tooltip: 'Sinkronisasi Order Offline',
            ),
          IconButton(
            iconSize: isSmallScreen ? 20 : 24,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _showOpenBillDialog(context),
            icon: const Icon(Icons.save_as_outlined),
            tooltip: 'Open Bill',
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              return state.maybeWhen(
                syncing: () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.blue,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sinkronisasi Order Offline...',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                error: (message) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  color: Colors.red,
                  child: Text(
                    'Error: $message',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(orElse: () {
                  return const Center(
                    child: Text('No Data'),
                  );
                }, success: (data, qty, total, draftName) {
                  if (data.isEmpty) {
                    return const Center(
                      child: Text('No Data'),
                    );
                  }

                  totalPrice = total;
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: data.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20.0),
                    itemBuilder: (context, index) => OrderCard(
                      padding: paddingHorizontal,
                      data: data[index],
                      onDeleteTap: () {
                        context.read<CheckoutBloc>().add(
                              CheckoutEvent.removeProduct(data[index].product),
                            );
                      },
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.only(top: 8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () {
                        return const SizedBox.shrink();
                      },
                      success: (data, qty, total, draftName) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: MenuButton(
                                    iconPath: Assets.icons.cash.path,
                                    label: 'Pelanggan',
                                    isActive: _isCustomerActive,
                                    onPressed: _showCustomerSelection,
                                  ),
                                ),
                                const SpaceWidth(16.0),
                                Flexible(
                                  child: MenuButton(
                                    iconPath: Assets.icons.cash.path,
                                    label: 'Diskon',
                                    isActive: _isDiscountActive,
                                    onPressed: _showDiscountDialog,
                                  ),
                                ),
                                const SpaceWidth(16.0),
                                Flexible(
                                  child: GestureDetector(
                                    onLongPress: _showTaxInfo,
                                    child: MenuButton(
                                      iconPath: Assets.icons.cash.path,
                                      label: 'Tax',
                                      isActive: _isTaxActive,
                                      onPressed: _onTaxPressed,
                                    ),
                                  ),
                                ),
                                const SpaceWidth(16.0),
                                Flexible(
                                  child: GestureDetector(
                                    onLongPress: _showServiceChargeInfo,
                                    child: MenuButton(
                                      iconPath: Assets.icons.cash.path,
                                      label: 'Service Charge',
                                      isActive: _isServiceChargeActive,
                                      onPressed: _onServiceChargePressed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SpaceHeight(20.0),
                            ValueListenableBuilder(
                              valueListenable: indexValue,
                              builder: (context, value, _) => Row(
                                children: [
                                  Flexible(
                                    child: MenuButton(
                                      iconPath: Assets.icons.cash.path,
                                      label: 'CASH',
                                      isActive: value == 1,
                                      onPressed: () {
                                        indexValue.value = 1;
                                        context.read<OrderBloc>().add(
                                            OrderEvent.addPaymentMethod(
                                                'Tunai', data, draftName));
                                      },
                                    ),
                                  ),
                                  const SpaceWidth(16.0),
                                  Flexible(
                                    child: MenuButton(
                                      iconPath: Assets.icons.qrCode.path,
                                      label: 'QR',
                                      isActive: value == 2,
                                      onPressed: () {
                                        indexValue.value = 2;
                                        context.read<OrderBloc>().add(
                                            OrderEvent.addPaymentMethod(
                                                'QRIS', data, draftName));
                                      },
                                    ),
                                  ),
                                  const SpaceWidth(16.0),
                                  Flexible(
                                    child: MenuButton(
                                      iconPath: Assets.icons.debit.path,
                                      label: 'TRANSFER',
                                      isActive: value == 3,
                                      onPressed: () {
                                        indexValue.value = 3;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SpaceWidth(16.0),
                            const SizedBox(height: 12.0),
                            // Container(
                            //   padding: const EdgeInsets.symmetric(
                            //       horizontal: 8.0, vertical: 4.0),
                            //   decoration: BoxDecoration(
                            //     color: Colors.grey.shade100,
                            //     borderRadius: BorderRadius.circular(8.0),
                            //   ),
                            //   child: Row(
                            //     children: [
                            //       Flexible(
                            //         child: MenuButton(
                            //           iconPath: Assets.icons.cash.path,
                            //           label: 'Pilih Lokasi',
                            //           isActive: false,
                            //           onPressed: () async {
                            //             final result = await Navigator.push(
                            //               context,
                            //               MaterialPageRoute(
                            //                 builder: (context) =>
                            //                     const DeliveryMapPage(),
                            //               ),
                            //             );
                            //             if (result != null &&
                            //                 result is LatLng) {
                            //               setState(() {
                            //                 deliveryPoint = result;
                            //                 deliveryAddress = null;
                            //               });
                            //               // Ambil alamat dari koordinat
                            //               try {
                            //                 List<Placemark> placemarks =
                            //                     await placemarkFromCoordinates(
                            //                         result.latitude,
                            //                         result.longitude);
                            //                 if (placemarks.isNotEmpty) {
                            //                   final placemark =
                            //                       placemarks.first;
                            //                   String address = '';
                            //                   if (placemark.street != null &&
                            //                       placemark
                            //                           .street!.isNotEmpty) {
                            //                     address += placemark.street!;
                            //                   }
                            //                   if (placemark.subLocality !=
                            //                           null &&
                            //                       placemark.subLocality!
                            //                           .isNotEmpty) {
                            //                     address +=
                            //                         ', ${placemark.subLocality!}';
                            //                   }
                            //                   if (placemark.locality != null &&
                            //                       placemark
                            //                           .locality!.isNotEmpty) {
                            //                     address +=
                            //                         ', ${placemark.locality!}';
                            //                   }
                            //                   if (placemark
                            //                               .administrativeArea !=
                            //                           null &&
                            //                       placemark.administrativeArea!
                            //                           .isNotEmpty) {
                            //                     address +=
                            //                         ', ${placemark.administrativeArea!}';
                            //                   }
                            //                   if (placemark.postalCode !=
                            //                           null &&
                            //                       placemark
                            //                           .postalCode!.isNotEmpty) {
                            //                     address +=
                            //                         ', ${placemark.postalCode!}';
                            //                   }
                            //                   if (placemark.country != null &&
                            //                       placemark
                            //                           .country!.isNotEmpty) {
                            //                     address +=
                            //                         ', ${placemark.country!}';
                            //                   }
                            //                   setState(() {
                            //                     deliveryAddress = address;
                            //                   });
                            //                 } else {
                            //                   setState(() {
                            //                     deliveryAddress =
                            //                         '${result.latitude}, ${result.longitude}';
                            //                   });
                            //                 }
                            //               } catch (e) {
                            //                 setState(() {
                            //                   deliveryAddress =
                            //                       '${result.latitude}, ${result.longitude}';
                            //                 });
                            //               }
                            //             }
                            //           },
                            //         ),
                            //       ),
                            //       const SpaceWidth(12.0),
                            //       Flexible(
                            //         child: _isDeliveryLoading
                            //             ? const Center(
                            //                 child: SizedBox(
                            //                   width: 24,
                            //                   height: 24,
                            //                   child: CircularProgressIndicator(
                            //                     strokeWidth: 2,
                            //                     valueColor:
                            //                         AlwaysStoppedAnimation<
                            //                             Color>(Colors.blue),
                            //                   ),
                            //                 ),
                            //               )
                            //             : MenuButton(
                            //                 iconPath: Assets.icons.cash.path,
                            //                 label: 'Delivery',
                            //                 isActive: false,
                            //                 onPressed: () async {
                            //                   if (deliveryPoint == null) {
                            //                     ScaffoldMessenger.of(context)
                            //                         .showSnackBar(
                            //                       const SnackBar(
                            //                         content: Text(
                            //                             'Pilih lokasi pengiriman terlebih dahulu'),
                            //                         backgroundColor:
                            //                             Colors.orange,
                            //                       ),
                            //                     );
                            //                     return;
                            //                   }
                            //                   if (_isDeliveryLoading) return;
                            //                   setState(() {
                            //                     _isDeliveryLoading = true;
                            //                   });
                            //                   try {
                            //                     final orderId = DateTime.now()
                            //                         .millisecondsSinceEpoch;
                            //                     final deliveryRequest =
                            //                         await showDialog<
                            //                             DeliveryRequestModel>(
                            //                       context: context,
                            //                       builder: (context) =>
                            //                           DeliveryFormDialog(
                            //                         orderId: orderId,
                            //                         selectedLocation:
                            //                             deliveryPoint,
                            //                       ),
                            //                     );
                            //                     if (deliveryRequest != null) {
                            //                       final response =
                            //                           await DeliveryRemoteDatasource()
                            //                               .createDelivery(
                            //                                   deliveryRequest);
                            //                       if (!mounted) return;
                            //                       setState(() {
                            //                         deliveryPoint = null;
                            //                       });
                            //                       ScaffoldMessenger.of(context)
                            //                           .showSnackBar(
                            //                         SnackBar(
                            //                           content: Text(
                            //                             'Pengiriman berhasil dibuat: ${response['data']['tracking_number']}',
                            //                             style: const TextStyle(
                            //                                 color:
                            //                                     Colors.white),
                            //                           ),
                            //                           backgroundColor:
                            //                               Colors.green,
                            //                           behavior: SnackBarBehavior
                            //                               .floating,
                            //                           duration: const Duration(
                            //                               seconds: 3),
                            //                         ),
                            //                       );
                            //                     }
                            //                   } catch (e) {
                            //                     if (!mounted) return;
                            //                     SnackbarUtils(
                            //                             text:
                            //                                 'Gagal membuat pengiriman',
                            //                             backgroundColor:
                            //                                 Colors.red)
                            //                         .showErrorSnackBar(context);
                            //                   } finally {
                            //                     if (mounted) {
                            //                       setState(() {
                            //                         _isDeliveryLoading = false;
                            //                       });
                            //                     }
                            //                   }
                            //                 },
                            //               ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // const SizedBox(height: 8.0),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SpaceHeight(20.0),
                ProcessButton(
                  price: 0,
                  onPressed: () async {
                    // Check if customer is selected
                    if (!_isCustomerActive || _selectedCustomer == null) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Silakan pilih pelanggan terlebih dahulu'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                      return;
                    }

                    final isConnected = await ConnectivityUtils.isConnected();

                    if (!isConnected) {
                      final currentState = context.read<OrderBloc>().state;
                      final successData = currentState.maybeWhen(
                        orElse: () => null,
                      );
                      if (successData != null) {
                        final orderRequest = OrderRequestModel(
                          transactionTime: DateTime.now().toIso8601String(),
                          kasirId: successData['idKasir'] as int,
                          paymentMethod: successData['paymentMethod'] as String,
                          paymentAmount:
                              (successData['totalPrice'] as int).toDouble(),
                          customerId: _selectedCustomer!.id,
                          subTotal:
                              (successData['totalPrice'] as int).toDouble(),
                          taxId: _isTaxActive ? _selectedTax?.id : null,
                          taxRate: _isTaxActive
                              ? _selectedTax?.rate.toDouble() ?? 0.0
                              : 0.0,
                          serviceChargeId: _isServiceChargeActive
                              ? _selectedServiceCharge?.id
                              : null,
                          serviceChargeRate: _isServiceChargeActive
                              ? _selectedServiceCharge?.rate.toDouble() ?? 0.0
                              : 0.0,
                          discountId: _isDiscountActive
                              ? 1
                              : null, // Assuming discount ID 1 as default
                          totalPrice:
                              (successData['totalPrice'] as int).toDouble(),
                          totalItem: successData['totalQuantity'] as int,
                          changeAmount:
                              0.0, // Will be calculated based on payment
                          orderType: 'in-person',
                          customerOrderNotes: null,
                          orderItems:
                              (successData['products'] as List<OrderItem>)
                                  .map((item) => OrderItemModel(
                                        productId: item.product.id!,
                                        quantity: item.quantity,
                                        price: item.product.price.toDouble(),
                                      ))
                                  .toList(),
                        );

                        // Save customer information for offline orders
                        successData['customerName'] =
                            _selectedCustomer?.name ?? 'Walk-in Customer';

                        final kasirData =
                            await AuthLocalDatasource().getAuthData();
                        await OrderLocalDatasource.instance.saveOfflineOrder(
                          orderRequest,
                          kasirName:
                              kasirData != null ? kasirData.user.name : 'Kasir',
                          customerName: _selectedCustomer != null
                              ? _selectedCustomer!.name
                              : 'Walk-in Customer',
                        );

                        setState(() {
                          hasOfflineOrders = true;
                        });

                        SnackbarUtils(
                          text: 'Order disimpan offline',
                          backgroundColor: Colors.orange,
                        ).showSuccessSnackBar(context);
                      }
                      return;
                    }

                    if (indexValue.value == 0) {
                    } else if (indexValue.value == 1) {
                      showDialog(
                        context: context,
                        builder: (context) => PaymentCashDialog(
                          price: totalPrice,
                          customerName: _selectedCustomer?.name,
                          customerPhone: _selectedCustomer?.phoneNumber,
                        ),
                      );
                    } else if (indexValue.value == 2) {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => PaymentQrisDialog(
                          price: totalPrice,
                          customerName: _selectedCustomer?.name,
                          customerPhone: _selectedCustomer?.phoneNumber,
                        ),
                      );
                    }
                  },
                ),
                BlocBuilder<OrderBloc, OrderState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      discountApplied: (discount, totalAfterDiscount) =>
                          Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Diskon: $discount% | Total setelah diskon: Rp$totalAfterDiscount',
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ),
                      orElse: () => const SizedBox.shrink(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
