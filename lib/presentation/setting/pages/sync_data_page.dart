import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/constants/colors.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_pos/core/utils/connectivity_utils.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/datasources/order_local_datasource.dart';

// Home Blocs
import 'package:flutter_pos/presentation/home/bloc/category/category_bloc.dart';
import 'package:flutter_pos/presentation/home/bloc/product/product_bloc.dart';
// Setting Blocs
import 'package:flutter_pos/presentation/setting/bloc/sync_order/sync_order_bloc.dart';

import 'package:flutter_pos/presentation/setting/bloc/customer/customer_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/customer/customer_event.dart';
import 'package:flutter_pos/presentation/setting/bloc/customer/customer_state.dart';

import 'package:flutter_pos/presentation/setting/bloc/sync_discount/sync_discount_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_discount/sync_discount_event.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_discount/sync_discount_state.dart';

import 'package:flutter_pos/presentation/setting/bloc/sync_tax/sync_tax_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_tax/sync_tax_event.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_tax/sync_tax_state.dart';

import 'package:flutter_pos/presentation/setting/bloc/sync_service_charge/sync_service_charge_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_service_charge/sync_service_charge_event.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_service_charge/sync_service_charge_state.dart';

import 'package:flutter_pos/presentation/setting/bloc/sync_customer/sync_customer_bloc.dart';

import '../../../l10n/app_localizations.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  bool _isOnline = true;
  Map<String, bool> _syncStatus = {};
  bool _isLoadingStatus = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _checkSyncStatus();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh sync status when page is revisited
    if (!_isLoadingStatus) {
      _checkSyncStatus();
    }
  }

  Future<void> _checkConnectivity() async {
    final connected = await ConnectivityUtils.isConnected();
    if (mounted) {
      setState(() {
        _isOnline = connected;
      });
    }
  }

  Future<void> _checkSyncStatus() async {
    if (!mounted) return;

    setState(() {
      _isLoadingStatus = true;
    });

    try {
      final localDataSource = ProductLocalDatasource.instance;

      // Check each data type's sync status
      final products = await localDataSource.getAllProduct();
      final categories = await localDataSource.getAllCategories();
      final customers = await localDataSource.getAllCustomer();
      final discounts = await localDataSource.getAllDiscount();
      final taxes = await localDataSource.getAllTax();
      final serviceCharges = await localDataSource.getAllServiceCharge();
      final pendingOrders =
          await OrderLocalDatasource.instance.getUnsyncedOrders();
      final pendingCustomer = await localDataSource.getUnsyncedCustomers();

      if (mounted) {
        setState(() {
          _syncStatus = {
            'products': products.isNotEmpty,
            'categories': categories.isNotEmpty,
            'customers': customers.isNotEmpty,
            'discounts': discounts.isNotEmpty,
            'taxes': taxes.isNotEmpty,
            'service_charges': serviceCharges.isNotEmpty,
            'orders': pendingOrders.isEmpty,
            'customer': pendingCustomer.isEmpty,
          };
          _isLoadingStatus = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _syncStatus = {};
          _isLoadingStatus = false;
          _isOnline ? _syncAllData() : null;
        });
      }
    }
  }

  // Sync all data
  Future<void> _syncAllData() async {
    if (!mounted || !_isOnline) return;

    try {
      // Trigger all sync operations
      context.read<ProductBloc>().add(const ProductEvent.fetch());
      context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
      context.read<CustomerBloc>().add(const CustomerEvent.fetch());
      context.read<SyncDiscountBloc>().add(const SyncDiscountEvent.sync());
      context.read<SyncTaxBloc>().add(const SyncTaxEvent.sync());
      context
          .read<SyncServiceChargeBloc>()
          .add(const SyncServiceChargeEvent.sync());
      context.read<SyncCustomerBloc>().add(SyncCustomerEvent.started());
      if (mounted) {
        SnackbarUtils(
          text: AppLocalizations.of(context)!.syncStartedForAllData,
          backgroundColor: AppColors.primary,
        ).showSuccessSnackBar(context);
        // Refresh sync status after a delay to allow sync operations to complete
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _checkSyncStatus();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils(
          text: AppLocalizations.of(context)!.failedToStartSync,
          backgroundColor: Colors.red,
        ).showErrorSnackBar(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.syncData),
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 6 : 8,
              vertical: 2,
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: _isOnline ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isOnline ? Icons.wifi : Icons.wifi_off,
                  color: Colors.white,
                  size: isSmallScreen ? 12 : 14,
                ),
                const SizedBox(width: 4),
                Text(
                  _isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 10 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _checkSyncStatus,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sync All Button
              _buildSyncAllButton(
                context: context,
                onPressed: _isOnline ? _syncAllData : null,
                icon: Icons.sync,
                label: AppLocalizations.of(context)!.syncAllData,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),

              // Master Data Section
              _buildSectionHeader(AppLocalizations.of(context)!.masterData),
              const SizedBox(height: 8),

              // Products
              BlocConsumer<ProductBloc, ProductState>(
                listener: (context, state) {
                  state.when(
                    initial: () {},
                    loading: () {},
                    success: (products) {
                      if (mounted) {
                        _checkSyncStatus();
                      }
                    },
                    error: (message) {},
                  );
                },
                builder: (context, state) {
                  return _buildSyncStatusCard(
                    title: AppLocalizations.of(context)!.products,
                    state: state,
                    onSync: _isOnline
                        ? () => context
                            .read<ProductBloc>()
                            .add(const ProductEvent.fetch())
                        : null,
                    onRetry: _isOnline
                        ? () => context
                            .read<ProductBloc>()
                            .add(const ProductEvent.fetch())
                        : null,
                  );
                },
              ),
              const SizedBox(height: 8),

              // Categories
              BlocConsumer<CategoryBloc, CategoryState>(
                listener: (context, state) {
                  state.when(
                    initial: () {},
                    loading: () {},
                    loaded: (categories) {
                      if (mounted) {
                        // Update sync status when category is loaded from remote
                        setState(() {
                          _syncStatus['categories'] = true;
                        });
                        _checkSyncStatus();
                      }
                    },
                    loadedLocal: (categories) {
                      if (mounted) {
                        // Update sync status when category is loaded from local
                        setState(() {
                          _syncStatus['categories'] = categories.isNotEmpty;
                        });
                      }
                    },
                    error: (message) {},
                  );
                },
                builder: (context, state) {
                  return _buildSyncStatusCard(
                    title: AppLocalizations.of(context)!.categories,
                    state: state,
                    onSync: _isOnline
                        ? () => context
                            .read<CategoryBloc>()
                            .add(const CategoryEvent.getCategories())
                        : null,
                    onRetry: _isOnline
                        ? () => context
                            .read<CategoryBloc>()
                            .add(const CategoryEvent.getCategories())
                        : null,
                  );
                },
              ),
              const SizedBox(height: 8),

              // Customers
              BlocConsumer<CustomerBloc, CustomerState>(
                listener: (context, state) {
                  state.when(
                    initial: () {},
                    loading: () {},
                    success: () {
                      if (mounted) {
                        _checkSyncStatus();
                      }
                    },
                    error: (message) {},
                  );
                },
                builder: (context, state) {
                  return _buildSyncStatusCard(
                    title: AppLocalizations.of(context)!.customer,
                    state: state,
                    onSync: _isOnline
                        ? () => context
                            .read<CustomerBloc>()
                            .add(const CustomerEvent.fetch())
                        : null,
                    onRetry: _isOnline
                        ? () => context
                            .read<CustomerBloc>()
                            .add(const CustomerEvent.fetch())
                        : null,
                  );
                },
              ),

              const SizedBox(height: 16),
              _buildSectionHeader(AppLocalizations.of(context)!.menuSetting),
              const SizedBox(height: 8),

              // Discounts
              BlocConsumer<SyncDiscountBloc, SyncDiscountState>(
                listener: (context, state) {
                  state.when(
                    initial: () {},
                    loading: () {},
                    success: () {
                      if (mounted) {
                        _checkSyncStatus();
                      }
                    },
                    error: (message) {},
                  );
                },
                builder: (context, state) {
                  return _buildSyncStatusCard(
                    title: AppLocalizations.of(context)!.discount,
                    state: state,
                    onSync: _isOnline
                        ? () => context
                            .read<SyncDiscountBloc>()
                            .add(const SyncDiscountEvent.sync())
                        : null,
                    onRetry: _isOnline
                        ? () => context
                            .read<SyncDiscountBloc>()
                            .add(const SyncDiscountEvent.sync())
                        : null,
                  );
                },
              ),
              const SizedBox(height: 8),

              // Taxes
              BlocConsumer<SyncTaxBloc, SyncTaxState>(
                listener: (context, state) {
                  state.when(
                    initial: () {},
                    loading: () {},
                    success: () {
                      if (mounted) {
                        _checkSyncStatus();
                      }
                    },
                    error: (message) {},
                  );
                },
                builder: (context, state) {
                  return _buildSyncStatusCard(
                    title: AppLocalizations.of(context)!.tax,
                    state: state,
                    onSync: _isOnline
                        ? () => context
                            .read<SyncTaxBloc>()
                            .add(const SyncTaxEvent.sync())
                        : null,
                    onRetry: _isOnline
                        ? () => context
                            .read<SyncTaxBloc>()
                            .add(const SyncTaxEvent.sync())
                        : null,
                  );
                },
              ),
              const SizedBox(height: 8),

              // Service Charges
              BlocConsumer<SyncServiceChargeBloc, SyncServiceChargeState>(
                listener: (context, state) {
                  state.when(
                    initial: () {},
                    loading: () {},
                    success: () {
                      if (mounted) {
                        _checkSyncStatus();
                      }
                    },
                    error: (message) {},
                  );
                },
                builder: (context, state) {
                  return _buildSyncStatusCard(
                    title: AppLocalizations.of(context)!.serviceCharge,
                    state: state,
                    onSync: _isOnline
                        ? () => context
                            .read<SyncServiceChargeBloc>()
                            .add(const SyncServiceChargeEvent.sync())
                        : null,
                    onRetry: _isOnline
                        ? () => context
                            .read<SyncServiceChargeBloc>()
                            .add(const SyncServiceChargeEvent.sync())
                        : null,
                  );
                },
              ),

              const SizedBox(height: 24),
              // Sync Orders Section
              _buildSectionHeader(AppLocalizations.of(context)!.syncData),
              const SizedBox(height: 8),

              // Orders
              BlocConsumer<SyncOrderBloc, SyncOrderState>(
                listener: (context, state) {
                  state.maybeWhen(
                    success: (syncedCount) {
                      if (mounted) {
                        SnackbarUtils(
                          text:
                              // 'Successfully synced $syncedCount order${syncedCount != 1 ? 's' : ''}',
                              '${AppLocalizations.of(context)!.syncedSuccessfully} $syncedCount ${AppLocalizations.of(context)!.order}${syncedCount != 1 ? 's' : ''}',
                          backgroundColor: Colors.green,
                        ).showSuccessSnackBar(context);
                        // Refresh sync status after successful sync
                        _checkSyncStatus();
                      }
                    },
                    error: (message, _) {
                      if (mounted) {
                        SnackbarUtils(
                          text: message,
                          backgroundColor: Colors.red,
                        ).showErrorSnackBar(context);
                      }
                    },
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return _buildSyncStatusCard(
                    title: AppLocalizations.of(context)!.sendPendingOrders,
                    state: state,
                    onSync: _isOnline
                        ? () => context
                            .read<SyncOrderBloc>()
                            .add(const SyncOrderEvent.sendOrder())
                        : null,
                    onRetry: _isOnline
                        ? () => context
                            .read<SyncOrderBloc>()
                            .add(const SyncOrderEvent.sendOrder())
                        : null,
                  );
                },
              ),
              const SizedBox(height: 8),
              // Sync Customers
              BlocConsumer<SyncCustomerBloc, SyncCustomerState>(
                listener: (context, state) {
                  state.maybeWhen(
                    success: (syncedCount) {
                      if (mounted) {
                        SnackbarUtils(
                          text:
                              '${AppLocalizations.of(context)!.syncedSuccessfully} $syncedCount ${AppLocalizations.of(context)!.customer}${syncedCount != 1 ? 's' : ''}',
                          backgroundColor: Colors.green,
                        ).showSuccessSnackBar(context);
                        _checkSyncStatus();
                      }
                    },
                    readyToFetch: (syncedCount) {
                      if (mounted) {
                        context
                            .read<SyncCustomerBloc>()
                            .add(const SyncCustomerEvent.fetchFromServer());
                      }
                    },
                    error: (message, _) {
                      if (mounted) {
                        SnackbarUtils(
                          text: message,
                          backgroundColor: Colors.red,
                        ).showErrorSnackBar(context);
                      }
                    },
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return _buildSyncStatusCard(
                    title: AppLocalizations.of(context)!.sendPendingCustomer,
                    state: state,
                    onSync: _isOnline
                        ? () => context
                            .read<SyncCustomerBloc>()
                            .add(const SyncCustomerEvent.sendCustomer())
                        : null,
                    onRetry: _isOnline
                        ? () => context
                            .read<SyncCustomerBloc>()
                            .add(const SyncCustomerEvent.sendCustomer())
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  // Helper method to build a sync status card
  Widget _buildSyncStatusCard<T>({
    required String title,
    required T state,
    required VoidCallback? onSync,
    required VoidCallback? onRetry,
  }) {
    bool isLoading = false;
    bool hasError = false;
    bool isSynced = false;
    bool hasLocalData = false;
    String? errorMessage;

    // Handle different state types
    if (state is ProductState) {
      state.when(
        initial: () {},
        loading: () => isLoading = true,
        success: (products) => isSynced = true,
        error: (message) {
          hasError = true;
          errorMessage = message;
        },
      );
    } else if (state is CategoryState) {
      state.when(
        initial: () {},
        loading: () => isLoading = true,
        loaded: (categories) => isSynced = true,
        loadedLocal: (categories) {
          hasLocalData = categories.isNotEmpty;
        },
        error: (message) {
          hasError = true;
          errorMessage = message;
        },
      );
    } else if (state is CustomerState) {
      state.when(
        initial: () {},
        loading: () => isLoading = true,
        success: () => isSynced = true,
        error: (message) {
          hasError = true;
          errorMessage = message;
        },
      );
    } else if (state is SyncDiscountState) {
      state.when(
        initial: () {},
        loading: () => isLoading = true,
        success: () => isSynced = true,
        error: (message) {
          hasError = true;
          errorMessage = message;
          debugPrint(message);
        },
      );
    } else if (state is SyncTaxState) {
      state.when(
        initial: () {},
        loading: () => isLoading = true,
        success: () => isSynced = true,
        error: (message) {
          hasError = true;
          errorMessage = message;
        },
      );
    } else if (state is SyncServiceChargeState) {
      state.when(
        initial: () {},
        loading: () => isLoading = true,
        success: () => isSynced = true,
        error: (message) {
          hasError = true;
          errorMessage = message;
        },
      );
    } else if (state is SyncOrderState) {
      state.maybeWhen(
        orElse: () {},
        initial: () {},
        loading: () => isLoading = true,
        success: (syncedCount) => isSynced = true,
        error: (message, _) {
          hasError = true;
          errorMessage = message;
        },
      );
    } else if (state is SyncCustomerState) {
      state.maybeWhen(
        orElse: () {},
        initial: () {},
        loading: () => isLoading = true,
        success: (syncedCount) => isSynced = true,
        error: (message, _) {
          hasError = true;
          errorMessage = message;
        },
      );
    }

    // Check persistent sync status if not currently syncing/error
    if (!isLoading && !hasError && !isSynced) {
      final statusKey = _getStatusKey(title);
      final persistentStatus = _syncStatus[statusKey] ?? false;

      // For categories, we need to be more careful about sync status
      if (title.toLowerCase() == 'categories') {
        if (hasLocalData) {
          // If we have local data but not synced, show sync button
          isSynced = false;
        } else {
          isSynced = persistentStatus;
        }
      } else {
        isSynced = persistentStatus;
      }
    }

    // For categories, if we have persistent sync status, override the local data check
    if (title.toLowerCase() == 'categories' &&
        _syncStatus['categories'] == true) {
      isSynced = true;
      hasLocalData = false; // Don't show local data message if we're synced
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                if (isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (hasError)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 24),
                      const SizedBox(width: 8),
                      if (onRetry != null) _buildRetryButton(onRetry),
                    ],
                  )
                else if (isSynced)
                  const Icon(Icons.check_circle, color: Colors.green, size: 24)
                else if (onSync != null)
                  _buildSyncButton(onSync, isLoading: false),
              ],
            ),
            if (hasError && errorMessage != null) ...[
              const SizedBox(height: 4),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            // Show info for categories with local data but not synced
            if (title.toLowerCase() == 'categories' &&
                hasLocalData &&
                !isSynced &&
                !isLoading &&
                !hasError) ...[
              const SizedBox(height: 4),
              Text(
                '${AppLocalizations.of(context)!.localDataAvailable}, ${AppLocalizations.of(context)!.syncToUpdateFromServer}',
                style: const TextStyle(color: Colors.orange, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper to get status key for persistent sync status
  String _getStatusKey(String title) {
    switch (title.toLowerCase()) {
      case 'products':
        return 'products';
      case 'categories':
        return 'categories';
      case 'customers':
        return 'customers';
      case 'discounts':
        return 'discounts';
      case 'taxes':
        return 'taxes';
      case 'service charges':
        return 'service_charges';
      case 'send pending orders':
        return 'orders';
      case 'send pending customer':
        return 'customer';
      default:
        return title.toLowerCase().replaceAll(' ', '_');
    }
  }

  // Helper to build a retry button
  Widget _buildRetryButton(VoidCallback onRetry) {
    return ElevatedButton(
      onPressed: onRetry,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(AppLocalizations.of(context)!.retry, style: const TextStyle(fontSize: 12)),
    );
  }

  // Helper to build a sync button
  Widget _buildSyncButton(VoidCallback onSync, {bool isLoading = false}) {
    return ElevatedButton(
      onPressed: isLoading ? null : onSync,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(AppLocalizations.of(context)!.syncNow, style: const TextStyle(fontSize: 12)),
    );
  }

  // Helper method to build a sync all button
  Widget _buildSyncAllButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
    );
  }
}
