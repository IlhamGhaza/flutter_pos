import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_pos/data/datasources/order_local_datasource.dart';
import 'package:flutter_pos/data/datasources/order_remote_datasource.dart';
import 'package:flutter_pos/data/models/request/order_request_model.dart' as request_models;

import '../../../../data/models/request/order_request_model.dart';

part 'sync_order_bloc.freezed.dart';
part 'sync_order_event.dart';
part 'sync_order_state.dart';

class SyncOrderBloc extends Bloc<SyncOrderEvent, SyncOrderState> {
  final OrderRemoteDatasource _remoteDatasource;
  final OrderLocalDatasource _localDatasource;
  
  SyncOrderBloc(
    this._remoteDatasource, {
    OrderLocalDatasource? localDatasource,
  })  : _localDatasource = localDatasource ?? OrderLocalDatasource.instance,
        super(const _Initial()) {
    on<_SendOrder>(_onSendOrder);
    on<_SendOrderForCloseChasier>(_onSendOrderForCloseCashier);
  }

  Future<void> _onSendOrder(_SendOrder event, Emitter<SyncOrderState> emit) async {
    try {
      emit(const SyncOrderState.loading());
      
      // Get all unsynced orders
      final unsyncedOrders = await _localDatasource.getUnsyncedOrders();
      
      if (unsyncedOrders.isEmpty) {
        emit(const SyncOrderState.success(syncedCount: 0));
        return;
      }
      
      int successCount = 0;
      
      // Process each unsynced order
      for (final orderData in unsyncedOrders) {
        final order = orderData['order'] as Map<String, dynamic>;
        final items = orderData['items'] as List<dynamic>;
        
        // Convert items to OrderItemModel
        final orderItems = items.map((item) => request_models.OrderItemModel(
          productId: item['product_id'] as int,
          quantity: item['quantity'] as int,
          price: (item['price'] as num).toDouble(),
        )).toList();
        
        // Create order request
        final orderRequest = OrderRequestModel(
          transactionTime: order['transaction_time'] as String,
          kasirId: order['kasir_id'] as int,
          customerId: order['customer_id'] as int,
          subTotal: (order['sub_total'] as num).toDouble(),
          totalPrice: (order['total_price'] as num).toDouble(),
          totalItem: order['total_item'] as int,
          paymentMethod: order['payment_method'] as String,
          paymentAmount: (order['payment_amount'] as num).toDouble(),
          changeAmount: (order['change_amount'] as num).toDouble(),
          orderType: order['order_type'] as String? ?? 'in-person',
          taxId: order['tax_id'] as int?,
          taxRate: (order['tax_rate'] as num?)?.toDouble(),
          serviceChargeId: order['service_charge_id'] as int?,
          serviceChargeRate: (order['service_charge_rate'] as num?)?.toDouble(),
          discountId: order['discount_id'] as int?,
          customerOrderNotes: order['customer_order_notes'] as String?,
          orderItems: orderItems,
        );
        
        // Send to server
        final response = await _remoteDatasource.createOrder(orderRequest);
        
        if (response['success'] as bool) {
          // Mark order as synced
          await _localDatasource.updateSyncStatus(
            order['id'] as int,
            true,
          );
          successCount++;
        }
      }
      
      // Emit success with count of synced orders
      emit(SyncOrderState.success(syncedCount: successCount));
      
    } catch (e, stackTrace) {
      emit(SyncOrderState.error(
        e.toString(),
        stackTrace: stackTrace.toString(),
      ));
    }
  }
  
  Future<void> _onSendOrderForCloseCashier(
    _SendOrderForCloseChasier event, 
    Emitter<SyncOrderState> emit,
  ) async {
    try {
      emit(const SyncOrderState.loading());
      
      // Get all unsynced orders
      final unsyncedOrders = await _localDatasource.getUnsyncedOrders();
      
      if (unsyncedOrders.isEmpty) {
        emit(const SyncOrderState.successCloseChasier(syncedCount: 0));
        return;
      }
      
      int successCount = 0;
      
      // Process each unsynced order (same as _onSendOrder but with different success state)
      for (final orderData in unsyncedOrders) {
        final order = orderData['order'] as Map<String, dynamic>;
        final items = orderData['items'] as List<dynamic>;
        
        // Convert items to OrderItemModel
        final orderItems = items.map((item) => request_models.OrderItemModel(
          productId: item['product_id'] as int,
          quantity: item['quantity'] as int,
          price: (item['price'] as num).toDouble(),
        )).toList();
        
        // Create order request
        final orderRequest = OrderRequestModel(
          transactionTime: order['transaction_time'] as String,
          kasirId: order['kasir_id'] as int,
          customerId: order['customer_id'] as int,
          subTotal: (order['sub_total'] as num).toDouble(),
          totalPrice: (order['total_price'] as num).toDouble(),
          totalItem: order['total_item'] as int,
          paymentMethod: order['payment_method'] as String,
          paymentAmount: (order['payment_amount'] as num).toDouble(),
          changeAmount: (order['change_amount'] as num).toDouble(),
          orderType: order['order_type'] as String? ?? 'in-person',
          taxId: order['tax_id'] as int?,
          taxRate: (order['tax_rate'] as num?)?.toDouble(),
          serviceChargeId: order['service_charge_id'] as int?,
          serviceChargeRate: (order['service_charge_rate'] as num?)?.toDouble(),
          discountId: order['discount_id'] as int?,
          customerOrderNotes: order['customer_order_notes'] as String?,
          orderItems: orderItems,
        );
        
        // Send to server
        final response = await _remoteDatasource.createOrder(orderRequest);
        
        if (response['success'] as bool) {
          // Mark order as synced
          await _localDatasource.updateSyncStatus(
            order['id'] as int,
            true,
          );
          successCount++;
        }
      }
      
      // Emit success with count of synced orders
      emit(SyncOrderState.successCloseChasier(syncedCount: successCount));
      
    } catch (e, stackTrace) {
      emit(SyncOrderState.error(
        e.toString(),
        stackTrace: stackTrace.toString(),
      ));
    }
  }
}
