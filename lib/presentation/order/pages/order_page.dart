import 'dart:async';
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
import 'package:flutter_pos/core/utils/discount_utils.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/datasources/order_local_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/models/response/service_charge_response_model.dart';
import 'package:flutter_pos/data/models/response/customer_response_model.dart';
import 'package:flutter_pos/data/models/response/tax_response_model.dart';
import 'package:flutter_pos/data/models/response/product_response_model.dart';
import 'package:flutter_pos/data/models/order_item_model.dart';
import 'package:flutter_pos/data/models/request/order_request_model.dart';
import 'package:flutter_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_pos/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_pos/presentation/order/bloc/order/order_bloc.dart';
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
  List<DiscountResponseModel> _selectedDiscounts = [];
  bool _isDiscountActive = false;
  bool _isTaxActive = false;
  bool _isServiceChargeActive = false;
  bool _isCustomerActive = false;
  final bool _isDeliveryLoading = false;
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
                            subtitle: Text(customer.phoneNumber),
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
    if (now.isBefore(discount.data[0].startDate)) {
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

        // Calculate order totals for validation
        double orderTotal = 0.0;
        int orderQuantity = 0;
        for (final item in orderItems) {
          orderTotal += item.product.price * item.quantity;
          orderQuantity = (orderQuantity + item.quantity).toInt();
        }
        final customerType =
            (_selectedCustomer?.customerType ?? 'reguler').toLowerCase();
        final products =
            orderItems.map((item) => item.product).cast<Product>().toList();

        // Basic validation - only check essential criteria for showing in dialog
        // 1. Check discount status
        if (discountData.status.toLowerCase() != 'active') {
          debugPrint('❌ Skipped: Discount is not active');
          return false;
        }

        // 2. Check if discount is valid for current date/time
        if (!_isDiscountValidNow(discount)) {
          debugPrint('❌ Skipped: Not valid for current date/time');
          return false;
        }

        // 3. Check customer type
        if (!DiscountUtils.isValidCustomerType(
            customerType, discountData.customerType)) {
          debugPrint(
              '❌ Skipped: Customer type "$customerType" not eligible for this discount');
          return false;
        }

        // 4. Check usage limit
        if (!DiscountUtils.isUsageLimitValid(discount)) {
          debugPrint('❌ Skipped: Discount has reached usage limit');
          return false;
        }

        // 5. Check product applicability
        final applyTo = discountData.applyTo.toLowerCase();
        if (applyTo != 'all') {
          final applicableItems =
              (discountData.applicableItems?.toString() ?? '')
                  .split(',')
                  .map((e) => e.trim())
                  .toList();

          bool hasEligibleProduct = false;
          if (applyTo == 'product' && applicableItems.isNotEmpty) {
            hasEligibleProduct = products
                .any((item) => applicableItems.contains(item.id.toString()));
          } else if (applyTo == 'category' && applicableItems.isNotEmpty) {
            hasEligibleProduct = products.any(
                (item) => applicableItems.contains(item.categoryId.toString()));
          }

          if (!hasEligibleProduct) {
            debugPrint('❌ Skipped: No matching products/categories in order');
            return false;
          }
        }

        debugPrint('✅ Included: Basic validation passed');
        return true;
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

                                  // Check if discount meets all requirements for this order
                                  double orderTotal = 0.0;
                                  int orderQuantity = 0;
                                  for (final item in orderItems) {
                                    orderTotal +=
                                        item.product.price * item.quantity;
                                    orderQuantity =
                                        (orderQuantity + item.quantity).toInt();
                                  }
                                  final customerType =
                                      (_selectedCustomer?.customerType ??
                                              'reguler')
                                          .toLowerCase();
                                  final products = orderItems
                                      .map((item) => item.product)
                                      .cast<Product>()
                                      .toList();

                                  final validationResult =
                                      DiscountUtils.validateDiscountForOrder(
                                    discount: discount,
                                    orderTotal: orderTotal,
                                    orderQuantity: orderQuantity,
                                    customerType: customerType,
                                    products: products,
                                  );

                                  final isFullyValid = validationResult.isValid;

                                  return Opacity(
                                    opacity: isFullyValid ? 1.0 : 0.6,
                                    child: CheckboxListTile(
                                      title: Row(
                                        children: [
                                          Expanded(
                                              child:
                                                  Text(discount.data[0].name)),
                                          if (!isFullyValid)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'Syarat tidak terpenuhi',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              '${discount.data[0].value}% - ${discount.data[0].description ?? ''}'),
                                          if ((discount.data[0].minAmount ??
                                                  0) >
                                              0)
                                            Text(
                                              'Min. belanja: ${_formatCurrency(discount.data[0].minAmount ?? 0)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: orderTotal <
                                                        (discount.data[0]
                                                                .minAmount ??
                                                            0)
                                                    ? Colors.orange
                                                    : Colors.green,
                                                fontWeight: orderTotal <
                                                        (discount.data[0]
                                                                .minAmount ??
                                                            0)
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          if ((discount.data[0].minQuantity ??
                                                  0) >
                                              0)
                                            Text(
                                              'Min. item: ${discount.data[0].minQuantity!.toStringAsFixed(0)}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: orderQuantity <
                                                        (discount.data[0]
                                                                .minQuantity ??
                                                            0)
                                                    ? Colors.orange
                                                    : Colors.green,
                                                fontWeight: orderQuantity <
                                                        (discount.data[0]
                                                                .minQuantity ??
                                                            0)
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          if (!isFullyValid &&
                                              validationResult
                                                  .errors.isNotEmpty)
                                            Container(
                                              margin:
                                                  const EdgeInsets.only(top: 4),
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.orange
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                    color: Colors.orange
                                                        .withOpacity(0.3)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ...validationResult.errors
                                                      .map((error) => Text(
                                                            '• $error',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 11,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                          ))
                                                      ,
                                                  if (!isFullyValid)
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                      child: Text(
                                                        'Tidak dapat dipilih',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      value: isSelected,
                                      onChanged: isFullyValid
                                          ? (bool? value) {
                                              setDialogState(() {
                                                if (value == true) {
                                                  _selectedDiscounts
                                                      .add(discount);
                                                } else {
                                                  _selectedDiscounts
                                                      .removeWhere((d) =>
                                                          d.data[0].id ==
                                                          discount.data[0].id);
                                                }
                                              });
                                            }
                                          : null, // Disable selection if not fully valid
                                    ),
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
        // Simpan diskon yang dipilih
        setState(() {
          _selectedDiscounts =
              List<DiscountResponseModel>.from(selectedDiscounts);
          _isDiscountActive = true;
        });

        // Apply the discounts using the new event
        context.read<OrderBloc>().add(
              OrderEvent.applyDiscounts(selectedDiscounts),
            );

        // Show success message
        if (mounted) {
          final totalDiscount = selectedDiscounts.fold<double>(
            0,
            (sum, discount) => sum + discount.data[0].value,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Diskon berhasil diterapkan (${totalDiscount.toStringAsFixed(0)}%)',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Clear discounts if none selected
        setState(() {
          _selectedDiscounts.clear();
          _isDiscountActive = false;
        });
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
          'Order',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w700,
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
          // if (hasOfflineOrders)
          //   IconButton(
          //     iconSize: isSmallScreen ? 20 : 24,
          //     padding: EdgeInsets.zero,
          //     constraints: const BoxConstraints(),
          //     onPressed: () {
          //       context.read<OrderBloc>().add(
          //             const OrderEvent.syncOfflineOrders(),
          //           );
          //     },
          //     icon: const Icon(Icons.sync),
          //     tooltip: 'Sinkronisasi Order Offline',
          //   ),
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
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, checkoutState) {
          checkoutState.maybeWhen(
            success: (products, totalQuantity, totalPrice, draftName) {
              // Update OrderBloc state when checkout changes
              final currentOrderState = context.read<OrderBloc>().state;
              currentOrderState.maybeWhen(
                success: (orderProducts,
                    orderTotalQuantity,
                    orderTotalPrice,
                    subTotal,
                    discountPercentage,
                    appliedDiscount,
                    appliedDiscounts,
                    paymentMethod,
                    nominalBayar,
                    idKasir,
                    namaKasir,
                    customerName,
                    tax,
                    taxRate,
                    serviceCharge,
                    serviceChargeRate) {
                  // Recalculate with new products
                  double subtotal = totalPrice.toDouble();

                  // Apply discounts
                  double afterDiscount = subtotal;
                  double totalDiscountAmount = 0;
                  for (final discount in appliedDiscounts) {
                    final result = DiscountUtils.applyDiscount(
                      originalPrice: afterDiscount,
                      discount: discount,
                      quantity: totalQuantity,
                    );
                    totalDiscountAmount += result.discountAmount;
                    afterDiscount = result.finalPrice;
                  }

                  // Apply tax and service charge
                  final taxAmount = afterDiscount * (taxRate ?? 0) / 100;
                  final serviceChargeAmount =
                      afterDiscount * (serviceChargeRate ?? 0) / 100;
                  final finalTotal =
                      afterDiscount + taxAmount + serviceChargeAmount;

                  // Update OrderBloc state
                  context.read<OrderBloc>().add(OrderEvent.addPaymentMethod(
                        paymentMethod,
                        products,
                        customerName,
                      ));
                },
                orElse: () {
                  // Initialize OrderBloc state if not exists
                  context.read<OrderBloc>().add(OrderEvent.addPaymentMethod(
                        'cash',
                        products,
                        'Walk-in Customer',
                      ));
                },
              );
            },
            orElse: () {},
          );
        },
        child: Column(
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
                                CheckoutEvent.removeProduct(
                                    data[index].product),
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
                          ],
                        );
                      },
                    );
                  },
                ),
                const SpaceHeight(20.0),
                ProcessButton(
                  price: context.select<OrderBloc, int>((bloc) {
                    final state = bloc.state;
                    return state.maybeWhen(
                      success: (
                        products,
                        totalQuantity,
                        totalPrice,
                        subTotal,
                        discountPercentage,
                        appliedDiscount,
                        appliedDiscounts,
                        paymentMethod,
                        nominalBayar,
                        idKasir,
                        namaKasir,
                        customerName,
                        tax,
                        taxRate,
                        serviceCharge,
                        serviceChargeRate,
                      ) =>
                          totalPrice,
                      orElse: () => 0,
                    );
                  }),
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

                    // Enhanced discount validation
                    if (_isDiscountActive && _selectedDiscounts.isNotEmpty) {
                      final currentState = context.read<OrderBloc>().state;
                      final orderData = currentState.maybeWhen(
                        success: (products,
                            totalQuantity,
                            totalPrice,
                            subTotal,
                            discountPercentage,
                            appliedDiscount,
                            appliedDiscounts,
                            paymentMethod,
                            nominalBayar,
                            idKasir,
                            namaKasir,
                            customerName,
                            tax,
                            taxRate,
                            serviceCharge,
                            serviceChargeRate) {
                          return {
                            'products': products,
                            'totalQuantity': totalQuantity,
                            'subTotal': subTotal,
                          };
                        },
                        orElse: () => null,
                      );

                      if (orderData != null) {
                        final products =
                            orderData['products'] as List<OrderItem>;
                        final totalQuantity = orderData['totalQuantity'] as int;
                        final subTotal = orderData['subTotal'] as int;
                        final customerType =
                            _selectedCustomer?.customerType ?? 'reguler';

                        // Validate each selected discount
                        List<String> validationErrors = [];
                        List<String> invalidDiscountNames = [];

                        for (final discount in _selectedDiscounts) {
                          final validationResult =
                              DiscountUtils.validateDiscountForOrder(
                            discount: discount,
                            orderTotal: subTotal.toDouble(),
                            orderQuantity: totalQuantity,
                            customerType: customerType,
                            products:
                                products.map((item) => item.product).toList(),
                          );

                          if (!validationResult.isValid) {
                            invalidDiscountNames.add(discount.data[0].name);
                            validationErrors.add(
                                '${discount.data[0].name}: ${validationResult.errorMessage}');
                          }
                        }

                        // If there are validation errors, show them and prevent checkout
                        if (validationErrors.isNotEmpty) {
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title:
                                    const Text('Diskon Tidak Dapat Diterapkan'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Diskon berikut tidak dapat diterapkan karena tidak memenuhi syarat:',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    ...validationErrors
                                        .map((error) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Text(
                                                '• $error',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ))
                                        ,
                                    const SizedBox(height: 12),
                                    Text(
                                      'Silakan tambahkan item atau pilih diskon lain yang sesuai.',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                          return;
                        }
                      }
                    }

                    final isConnected = await ConnectivityUtils.isConnected();

                    if (!isConnected) {
                      final currentState = context.read<OrderBloc>().state;
                      final successData = currentState.maybeWhen(
                        orElse: () => null,
                      );
                      if (successData != null) {
                        // Ambil diskon yang dipilih
                        List<DiscountResponseModel> selectedDiscounts = [];
                        if (_isDiscountActive &&
                            _selectedDiscounts.isNotEmpty) {
                          selectedDiscounts = _selectedDiscounts;
                        }

                        // Hitung total dengan diskon, tax, service charge
                        double subtotal =
                            (successData['subTotal'] as int).toDouble();

                        // Stack diskon
                        double afterDiscount = subtotal;
                        double totalDiscountAmount = 0;
                        for (final discount in selectedDiscounts) {
                          final result = DiscountUtils.applyDiscount(
                            originalPrice: afterDiscount,
                            discount: discount,
                            quantity: successData['totalQuantity'] as int,
                          );
                          totalDiscountAmount += result.discountAmount;
                          afterDiscount = result.finalPrice;
                        }

                        // Tax & Service Charge
                        final taxAmount =
                            afterDiscount * (successData['taxRate'] ?? 0) / 100;
                        final serviceChargeAmount = afterDiscount *
                            (successData['serviceChargeRate'] ?? 0) /
                            100;
                        final totalPrice =
                            afterDiscount + taxAmount + serviceChargeAmount;

                        final orderRequest = OrderRequestModel(
                          transactionTime: DateTime.now().toIso8601String(),
                          kasirId: successData['idKasir'] as int,
                          paymentMethod: successData['paymentMethod'] as String,
                          paymentAmount: totalPrice,
                          customerId: _selectedCustomer!.id,
                          subTotal: subtotal,
                          taxId: _isTaxActive ? _selectedTax?.id : null,
                          serviceChargeId: _isServiceChargeActive
                              ? _selectedServiceCharge?.id
                              : null,
                          discountId: selectedDiscounts.isNotEmpty
                              ? selectedDiscounts.first.data.first.id
                              : null,
                          totalPrice: totalPrice,
                          totalItem: successData['totalQuantity'] as int,
                          changeAmount:
                              0.0, // Will be calculated based on payment
                          orderType: 'in-person',
                          customerOrderNotes: null,
                          orderItems:
                              (successData['products'] as List<OrderItem>)
                                  .map((item) => OrderItemModel(
                                        productId: item.product.id,
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
                      // Process order online
                      final currentState = context.read<OrderBloc>().state;
                      currentState.maybeWhen(
                        success: (products,
                            totalQuantity,
                            totalPrice,
                            subTotal,
                            discountPercentage,
                            appliedDiscount,
                            appliedDiscounts,
                            paymentMethod,
                            nominalBayar,
                            idKasir,
                            namaKasir,
                            customerName,
                            tax,
                            taxRate,
                            serviceCharge,
                            serviceChargeRate) {
                          // Ambil diskon yang dipilih
                          List<DiscountResponseModel> selectedDiscounts = [];
                          if (_isDiscountActive &&
                              _selectedDiscounts.isNotEmpty) {
                            selectedDiscounts = _selectedDiscounts;
                          }

                          // Hitung total dengan diskon, tax, service charge
                          double subtotal = subTotal.toDouble();

                          // Stack diskon
                          double afterDiscount = subtotal;
                          double totalDiscountAmount = 0;
                          for (final discount in selectedDiscounts) {
                            final result = DiscountUtils.applyDiscount(
                              originalPrice: afterDiscount,
                              discount: discount,
                              quantity: totalQuantity,
                            );
                            totalDiscountAmount += result.discountAmount;
                            afterDiscount = result.finalPrice;
                          }

                          // Tax & Service Charge
                          final taxAmount =
                              afterDiscount * (taxRate ?? 0) / 100;
                          final serviceChargeAmount =
                              afterDiscount * (serviceChargeRate ?? 0) / 100;
                          final totalPrice =
                              afterDiscount + taxAmount + serviceChargeAmount;

                          // Update state dengan perhitungan yang benar
                          context
                              .read<OrderBloc>()
                              .add(OrderEvent.addPaymentMethod(
                                paymentMethod,
                                products,
                                customerName,
                              ));

                          // Process order
                          context.read<OrderBloc>().add(OrderEvent.processOrder(
                                customerId: _selectedCustomer!.id,
                                customerName: _selectedCustomer!.name,
                                paymentMethod: paymentMethod,
                                paymentAmount: totalPrice,
                                orderType: 'in-person',
                                customerOrderNotes: null,
                                taxId: _isTaxActive ? _selectedTax?.id : null,
                                taxRate: _isTaxActive
                                    ? _selectedTax?.rate.toDouble()
                                    : null,
                                serviceChargeId: _isServiceChargeActive
                                    ? _selectedServiceCharge?.id
                                    : null,
                                serviceChargeRate: _isServiceChargeActive
                                    ? _selectedServiceCharge?.rate.toDouble()
                                    : null,
                                discountId: selectedDiscounts.isNotEmpty
                                    ? selectedDiscounts.first.data.first.id
                                    : null,
                              ));
                        },
                        orElse: () {
                          // Handle case when state is not success
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tidak ada data order yang valid'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    } else if (indexValue.value == 1) {
                      // Cash payment
                      final currentState = context.read<OrderBloc>().state;
                      currentState.maybeWhen(
                        success: (products,
                            totalQuantity,
                            totalPrice,
                            subTotal,
                            discountPercentage,
                            appliedDiscount,
                            appliedDiscounts,
                            paymentMethod,
                            nominalBayar,
                            idKasir,
                            namaKasir,
                            customerName,
                            tax,
                            taxRate,
                            serviceCharge,
                            serviceChargeRate) {
                          // Ambil diskon yang dipilih
                          List<DiscountResponseModel> selectedDiscounts = [];
                          if (_isDiscountActive &&
                              _selectedDiscounts.isNotEmpty) {
                            selectedDiscounts = _selectedDiscounts;
                          }

                          // Hitung total dengan diskon, tax, service charge
                          double subtotal = subTotal.toDouble();

                          // Stack diskon
                          double afterDiscount = subtotal;
                          double totalDiscountAmount = 0;
                          for (final discount in selectedDiscounts) {
                            final result = DiscountUtils.applyDiscount(
                              originalPrice: afterDiscount,
                              discount: discount,
                              quantity: totalQuantity,
                            );
                            totalDiscountAmount += result.discountAmount;
                            afterDiscount = result.finalPrice;
                          }

                          // Tax & Service Charge
                          final taxAmount =
                              afterDiscount * (taxRate ?? 0) / 100;
                          final serviceChargeAmount =
                              afterDiscount * (serviceChargeRate ?? 0) / 100;
                          final totalPrice =
                              afterDiscount + taxAmount + serviceChargeAmount;

                          // Validate that customer is selected and has valid ID
                          if (_selectedCustomer == null ||
                              _selectedCustomer!.id <= 0) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Silakan pilih pelanggan terlebih dahulu'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                            return;
                          }

                          debugPrint(
                              '[OrderPage] Selected customer: ${_selectedCustomer?.name} (ID: ${_selectedCustomer?.id})');

                          showDialog(
                            context: context,
                            builder: (context) => PaymentCashDialog(
                              price: totalPrice.toInt(),
                              customerName: _selectedCustomer?.name,
                              customerPhone: _selectedCustomer?.phoneNumber,
                              customerId: _selectedCustomer!
                                  .id, // Now we know it's not null
                            ),
                          );
                        },
                        orElse: () {
                          // Handle case when state is not success
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tidak ada data order yang valid'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      );
                    } else if (indexValue.value == 2) {
                      // QRIS payment
                      final currentState = context.read<OrderBloc>().state;
                      currentState.maybeWhen(
                        success: (products,
                            totalQuantity,
                            totalPrice,
                            subTotal,
                            discountPercentage,
                            appliedDiscount,
                            appliedDiscounts,
                            paymentMethod,
                            nominalBayar,
                            idKasir,
                            namaKasir,
                            customerName,
                            tax,
                            taxRate,
                            serviceCharge,
                            serviceChargeRate) {
                          // Ambil diskon yang dipilih
                          List<DiscountResponseModel> selectedDiscounts = [];
                          if (_isDiscountActive &&
                              _selectedDiscounts.isNotEmpty) {
                            selectedDiscounts = _selectedDiscounts;
                          }

                          // Hitung total dengan diskon, tax, service charge
                          double subtotal = subTotal.toDouble();

                          // Stack diskon
                          double afterDiscount = subtotal;
                          double totalDiscountAmount = 0;
                          for (final discount in selectedDiscounts) {
                            final result = DiscountUtils.applyDiscount(
                              originalPrice: afterDiscount,
                              discount: discount,
                              quantity: totalQuantity,
                            );
                            totalDiscountAmount += result.discountAmount;
                            afterDiscount = result.finalPrice;
                          }

                          // Tax & Service Charge
                          final taxAmount =
                              afterDiscount * (taxRate ?? 0) / 100;
                          final serviceChargeAmount =
                              afterDiscount * (serviceChargeRate ?? 0) / 100;
                          final totalPrice =
                              afterDiscount + taxAmount + serviceChargeAmount;

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => PaymentQrisDialog(
                              price: totalPrice.toInt(),
                              customerName: _selectedCustomer?.name,
                              customerPhone: _selectedCustomer?.phoneNumber,
                            ),
                          );
                        },
                        orElse: () {
                          // Handle case when state is not success
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tidak ada data order yang valid'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
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
