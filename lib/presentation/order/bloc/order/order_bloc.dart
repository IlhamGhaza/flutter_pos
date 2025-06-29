import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/datasources/discount_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/order_local_datasource.dart';
import 'package:flutter_pos/data/datasources/order_remote_datasource.dart';
import 'package:flutter_pos/data/models/order_item_model.dart';
import 'package:flutter_pos/data/models/response/discount_response_model.dart';
import 'package:flutter_pos/data/models/response/service_charge_response_model.dart';
import 'package:flutter_pos/data/models/response/tax_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  // Data sources will be used in future implementations
  @visibleForTesting
  final OrderRemoteDatasource orderRemoteDatasource;
  @visibleForTesting
  final OrderLocalDatasource orderLocalDatasource;
  @visibleForTesting
  final DiscountRemoteDatasource discountRemoteDatasource;
  final AuthLocalDatasource _authLocalDatasource;

  OrderBloc({
    required this.orderRemoteDatasource,
    required this.orderLocalDatasource,
    required this.discountRemoteDatasource,
    required AuthLocalDatasource authLocalDatasource,
  })  : _authLocalDatasource = authLocalDatasource,
        super(const OrderState.initial()) {
    on<OrderEvent>((event, emit) async {
      if (event is _Started) {
        await _onStarted(emit);
      } else if (event is _AddPaymentMethod) {
        await _onAddPaymentMethod(event, emit);
      } else if (event is _AddNominalBayar) {
        await _onAddNominalBayar(event, emit);
      } else if (event is _SyncOfflineOrders) {
        await _onSyncOfflineOrders(emit);
      } else if (event is _ApplyAutoDiscount) {
        await _onApplyAutoDiscount(event, emit);
      } else if (event is _ApplyManualDiscount) {
        await _onApplyManualDiscount(event, emit);
      } else if (event is _ApplyTax) {
        await _onApplyTax(event, emit);
      } else if (event is _ApplyServiceCharge) {
        await _onApplyServiceCharge(event, emit);
      } else if (event is _UpdateSyncStatus) {
        await _onUpdateSyncStatus(event, emit);
      }
    });
  }

  Future<void> _onStarted(Emitter<OrderState> emit) async {
    emit(const OrderState.initial());
  }

  Future<void> _onAddPaymentMethod(
      _AddPaymentMethod event, Emitter<OrderState> emit) async {
    try {
      final user = await _authLocalDatasource.getAuthData();
      final totalQuantity =
          event.orders.fold(0, (sum, item) => sum + item.quantity);
      final subTotal = event.orders.fold(
          0, (sum, item) => sum + (item.product.price.toInt() * item.quantity));

      emit(OrderState.success(
        event.orders,
        totalQuantity,
        subTotal, // totalPrice
        subTotal: subTotal,
        discountPercentage: 0.0,
        appliedDiscount: null,
        paymentMethod: event.paymentMethod,
        nominalBayar: 0,
        idKasir: user.user.id ?? 0,
        namaKasir: user.user.name ?? 'Kasir',
        customerName: event.customerName,
      ));
    } catch (e) {
      emit(OrderState.error('Failed to add payment method: $e'));
    }
  }

  Future<void> _onAddNominalBayar(
      _AddNominalBayar event, Emitter<OrderState> emit) async {
    final state = this.state;
    if (state is _Success) {
      emit(state.copyWith(nominalBayar: event.nominal));
    }
  }

  Future<void> _onSyncOfflineOrders(Emitter<OrderState> emit) async {
    try {
      emit(const OrderState.syncing());
      // Sync offline orders with the server
      // This is a placeholder - implement actual sync logic here
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      emit(const OrderState.initial());
    } catch (e) {
      emit(OrderState.error('Failed to sync offline orders: $e'));
    }
  }

  Future<void> _onApplyAutoDiscount(
      _ApplyAutoDiscount event, Emitter<OrderState> emit) async {
    try {
      final state = this.state;
      if (state is! _Success) return;

      final currentDay = DateTime.now().weekday;
      if (!event.validDays.contains(currentDay)) return;

      // Calculate new subtotal
      final newSubTotal = state.products.fold(
          0, (sum, item) => sum + (item.product.price.toInt() * item.quantity));
      final discountAmount = (newSubTotal * event.percentage / 100).round();
      // Using the discounted price directly in the state update

      // Create a temporary discount model
      final discount = DiscountResponseModel(
        message: 'Auto Discount ${event.percentage}%',
        data: [
          DiscountModel(
            id: 0, // Temporary ID for auto discount
            name: 'Auto Discount ${event.percentage}%',
            description: 'Auto applied discount',
            value: event.percentage.toDouble(),
            status: 'active',
            expiredDate: DateTime.now().add(const Duration(days: 1)),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            type: 'percentage',
            minQuantity: 0,
            maxQuantity: 0,
            minAmount: 0,
            applyTo: 'all',
            customerType: 'all',
            validDays: [],
            combinable: false,
            usageCount: 0,
            startDate: DateTime.now(),
          ),
        ],
        syncTime: DateTime.now(),
        total: 1,
      );

      emit(state.copyWith(
        subTotal: newSubTotal,
        totalPrice: newSubTotal - discountAmount,
        discountPercentage: event.percentage.toDouble(),
        appliedDiscount: discount,
        paymentMethod: state.paymentMethod,
        nominalBayar: state.nominalBayar,
        idKasir: state.idKasir,
        namaKasir: state.namaKasir,
        customerName: state.customerName,
      ));
    } catch (e) {
      emit(OrderState.error('Failed to apply auto discount: $e'));
    }
  }

  Future<void> _onApplyTax(OrderEvent event, Emitter<OrderState> emit) async {
    try {
      final tax = (event as dynamic).tax as TaxResponseModel;

      // If state is not Success, initialize a new state with empty values
      if (state is! _Success) {
        final newState = OrderState.success(
          [], // Empty products list
          0, // totalQuantity
          0, // totalPrice
          subTotal: 0,
          discountPercentage: 0,
          appliedDiscount: null,
          paymentMethod: '',
          nominalBayar: 0,
          idKasir: 0,
          namaKasir: 'Kasir',
          customerName: '',
          tax: 0,
          taxRate: tax.rate,
        ) as _Success;

        final taxAmount = (newState.subTotal * tax.rate / 100).round();
        final newTotal =
            newState.subTotal + taxAmount + (newState.serviceCharge ?? 0);

        emit(newState.copyWith(
          totalPrice: newTotal,
          tax: taxAmount,
          taxRate: tax.rate,
        ));
        return;
      }

      // If state is Success, update the existing state
      final currentState = state as _Success;
      final taxAmount = (currentState.subTotal * tax.rate / 100).round();
      final newTotal =
          currentState.subTotal + taxAmount + (currentState.serviceCharge ?? 0);

      emit(currentState.copyWith(
        totalPrice: newTotal,
        tax: taxAmount,
        taxRate: tax.rate,
      ));
    } catch (e) {
      emit(OrderState.error('Failed to apply tax: $e'));
    }
  }

  Future<void> _onApplyServiceCharge(
      OrderEvent event, Emitter<OrderState> emit) async {
    try {
      final serviceCharge =
          (event as dynamic).serviceCharge as ServiceChargeResponseModel;

      // If state is not Success, initialize a new state with empty values
      if (state is! _Success) {
        final newState = OrderState.success(
          [], // Empty products list
          0, // totalQuantity
          0, // totalPrice
          subTotal: 0,
          discountPercentage: 0,
          appliedDiscount: null,
          paymentMethod: '',
          nominalBayar: 0,
          idKasir: 0,
          namaKasir: 'Kasir',
          customerName: '',
          serviceCharge: 0,
          serviceChargeRate: serviceCharge.rate,
        ) as _Success;

        final serviceChargeAmount =
            (newState.subTotal * serviceCharge.rate / 100).round();
        final newTotal =
            newState.subTotal + serviceChargeAmount + (newState.tax ?? 0);

        emit(newState.copyWith(
          totalPrice: newTotal,
          serviceCharge: serviceChargeAmount,
          serviceChargeRate: serviceCharge.rate,
        ));
        return;
      }

      // If state is Success, update the existing state
      final currentState = state as _Success;
      final serviceChargeAmount =
          (currentState.subTotal * serviceCharge.rate / 100).round();
      final newTotal =
          currentState.subTotal + serviceChargeAmount + (currentState.tax ?? 0);

      emit(currentState.copyWith(
        totalPrice: newTotal,
        serviceCharge: serviceChargeAmount,
        serviceChargeRate: serviceCharge.rate,
      ));
    } catch (e) {
      emit(OrderState.error('Failed to apply service charge: $e'));
    }
  }

  Future<void> _onApplyManualDiscount(
      _ApplyManualDiscount event, Emitter<OrderState> emit) async {
    try {
      final state = this.state;
      if (state is! _Success) return;

      if (event.percentage < 0 || event.percentage > 100) {
        emit(const OrderState.error('Invalid discount percentage'));
        return;
      }

      // Calculate new subtotal
      final newSubTotal = state.products
          .fold(0, (sum, item) => sum + (item.product.price.toInt() * item.quantity));
      final discountAmount = (newSubTotal * event.percentage / 100).round();

      // Create a temporary discount model for manual discount
      final discount = DiscountResponseModel(
        message: 'Manual Discount ${event.percentage}%',
        data: [
          DiscountModel(
            id: -1, // Special ID for manual discount
            name: 'Manual Discount ${event.percentage}%',
            description: 'Manually applied discount',
            value: event.percentage.toDouble(),
            status: 'active',
            expiredDate: DateTime.now().add(const Duration(days: 1)),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            type: 'percentage',
            minQuantity: 0,
            maxQuantity: 0,
            minAmount: 0,
            applyTo: 'all',
            customerType: 'all',
            validDays: [],
            combinable: false,
            usageCount: 0,
            startDate: DateTime.now(),
          ),
        ],
        syncTime: DateTime.now(),
        total: 1,
      );

      emit(state.copyWith(
        subTotal: newSubTotal,
        totalPrice: newSubTotal - discountAmount,
        discountPercentage: event.percentage.toDouble(),
        appliedDiscount: discount,
        paymentMethod: state.paymentMethod,
        nominalBayar: state.nominalBayar,
        idKasir: state.idKasir,
        namaKasir: state.namaKasir,
        customerName: state.customerName,
      ));
    } catch (e) {
      emit(OrderState.error('Failed to apply manual discount: $e'));
    }
  }

  Future<void> _onUpdateSyncStatus(
      _UpdateSyncStatus event, Emitter<OrderState> emit) async {
    emit(OrderState.syncStatusUpdated(event.orderId, event.isSynced));
  }
}
