import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/constants/colors.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_pos/core/utils/connectivity_utils.dart';

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

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connected = await ConnectivityUtils.isConnected();
    if (mounted) {
      setState(() {
        _isOnline = connected;
      });
    }
  }

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

      if (mounted) {
        SnackbarUtils(
          text: 'Sync started for all data',
          backgroundColor: AppColors.primary,
        ).showSuccessSnackBar(context);
      }
    } catch (e) {
      if (mounted) {
        SnackbarUtils(
          text: 'Failed to start sync: $e',
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
        title: const Text('Sync Data'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sync All Button
            _buildSyncAllButton(
              context: context,
              onPressed: _isOnline ? _syncAllData : null,
              icon: Icons.sync,
              label: 'SYNC ALL DATA',
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),

            // Master Data Section
            _buildSectionHeader('Master Data'),
            const SizedBox(height: 8),

            // Products
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return _buildSyncStatusCard(
                  title: 'Products',
                  state: state,
                  onSync: _isOnline
                      ? () => context
                          .read<ProductBloc>()
                          .add(const ProductEvent.fetch())
                      : null,
                );
              },
            ),
            const SizedBox(height: 8),

            // Categories
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                return _buildSyncStatusCard(
                  title: 'Categories',
                  state: state,
                  onSync: _isOnline
                      ? () => context
                          .read<CategoryBloc>()
                          .add(const CategoryEvent.getCategories())
                      : null,
                );
              },
            ),
            const SizedBox(height: 8),

            // Customers
            BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                return _buildSyncStatusCard(
                  title: 'Customers',
                  state: state,
                  onSync: _isOnline
                      ? () => context
                          .read<CustomerBloc>()
                          .add(const CustomerEvent.fetch())
                      : null,
                );
              },
            ),

            const SizedBox(height: 16),
            _buildSectionHeader('Settings'),
            const SizedBox(height: 8),

            // Discounts
            BlocBuilder<SyncDiscountBloc, SyncDiscountState>(
              builder: (context, state) {
                return _buildSyncStatusCard(
                  title: 'Discounts',
                  state: state,
                  onSync: _isOnline
                      ? () => context
                          .read<SyncDiscountBloc>()
                          .add(const SyncDiscountEvent.sync())
                      : null,
                );
              },
            ),
            const SizedBox(height: 8),

            // Taxes
            BlocBuilder<SyncTaxBloc, SyncTaxState>(
              builder: (context, state) {
                return _buildSyncStatusCard(
                  title: 'Taxes',
                  state: state,
                  onSync: _isOnline
                      ? () => context
                          .read<SyncTaxBloc>()
                          .add(const SyncTaxEvent.sync())
                      : null,
                );
              },
            ),
            const SizedBox(height: 8),

            // Service Charges
            BlocBuilder<SyncServiceChargeBloc, SyncServiceChargeState>(
              builder: (context, state) {
                return _buildSyncStatusCard(
                  title: 'Service Charges',
                  state: state,
                  onSync: _isOnline
                      ? () => context
                          .read<SyncServiceChargeBloc>()
                          .add(const SyncServiceChargeEvent.sync())
                      : null,
                );
              },
            ),

            const SizedBox(height: 24),
            // Sync Orders Section
            _buildSectionHeader('Orders'),
            const SizedBox(height: 8),

            // Orders
            BlocConsumer<SyncOrderBloc, SyncOrderState>(
              listener: (context, state) {
                state.maybeWhen(
                  success: (syncedCount) {
                    if (mounted) {
                      SnackbarUtils(
                        text: 'Successfully synced $syncedCount order${syncedCount != 1 ? 's' : ''}',
                        backgroundColor: Colors.green,
                      ).showSuccessSnackBar(context);
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
                  title: 'Send Pending Orders',
                  state: state,
                  onSync: _isOnline
                      ? () => context
                          .read<SyncOrderBloc>()
                          .add(const SyncOrderEvent.sendOrder())
                      : null,
                );
              },
            ),
          ],
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
  }) {
    bool isLoading = false;
    bool hasError = false;
    bool isSynced = false;
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
        loadedLocal: (categories) => isSynced = true,
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
                  const Icon(Icons.error, color: Colors.red, size: 24)
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
          ],
        ),
      ),
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
          : const Text('Sync Now', style: TextStyle(fontSize: 12)),
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
