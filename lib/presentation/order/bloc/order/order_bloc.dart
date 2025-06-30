import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/datasources/order_local_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/models/order_item_model.dart';
import 'package:flutter_pos/data/models/response/discount_response_model.dart';
import 'package:flutter_pos/data/models/response/service_charge_response_model.dart';
import 'package:flutter_pos/data/models/response/tax_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/models/request/order_request_model.dart';
import '../../../../core/utils/discount_utils.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  // Data sources will be used in future implementations
  @visibleForTesting
  // final OrderRemoteDatasource orderRemoteDatasource;
  @visibleForTesting
  final OrderLocalDatasource orderLocalDatasource;
  @visibleForTesting
  // final DiscountRemoteDatasource discountRemoteDatasource;
  final AuthLocalDatasource _authLocalDatasource;

  OrderBloc({
    // required this.orderRemoteDatasource,
    required this.orderLocalDatasource,
    // required this.discountRemoteDatasource,
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
      } else if (event is _ProcessOrder) {
        await _onProcessOrder(event, emit);
      } else if (event is _ApplyDiscounts) {
        await _onApplyDiscounts(event, emit);
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

      // Ambil diskon yang aktif dari event/orders (implementasi UI harus supply list diskon)
      // Untuk contoh, kita asumsikan tidak ada diskon aktif di sini
      final List<DiscountResponseModel> appliedDiscounts = [];

      // Stack diskon
      double afterDiscount = subTotal.toDouble();
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

      // Tax & Service Charge (ambil dari event atau state jika ada)
      double taxRate = 0;
      double serviceChargeRate = 0;
      int? taxId;
      int? serviceChargeId;
      // TODO: Ambil tax/service charge dari event atau state jika ada

      final taxAmount = afterDiscount * (taxRate / 100);
      final serviceChargeAmount = afterDiscount * (serviceChargeRate / 100);
      final totalPrice = afterDiscount + taxAmount + serviceChargeAmount;

      emit(OrderState.success(
        event.orders,
        totalQuantity,
        totalPrice.toInt(),
        subTotal: subTotal,
        discountPercentage: totalDiscountAmount > 0
            ? (totalDiscountAmount / subTotal) * 100
            : 0.0,
        appliedDiscount:
            appliedDiscounts.isNotEmpty ? appliedDiscounts.last : null,
        appliedDiscounts: appliedDiscounts,
        paymentMethod: event.paymentMethod,
        nominalBayar: 0,
        idKasir: user.user.id ?? 0,
        namaKasir: user.user.name ?? 'Kasir',
        customerName: event.customerName,
        tax: taxAmount.toInt(),
        taxRate: taxRate,
        serviceCharge: serviceChargeAmount.toInt(),
        serviceChargeRate: serviceChargeRate,
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
          appliedDiscounts: [],
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
          appliedDiscounts: [],
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
      final newSubTotal = state.products.fold(
          0, (sum, item) => sum + (item.product.price.toInt() * item.quantity));
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

  Future<void> _onProcessOrder(
      _ProcessOrder event, Emitter<OrderState> emit) async {
    try {
      final state = this.state;
      if (state is! _Success) {
        emit(const OrderState.error('No order data available'));
        return;
      }

      final user = await _authLocalDatasource.getAuthData();

      // Calculate discount
      double afterDiscount = state.subTotal.toDouble();
      double totalDiscountAmount = 0;
      for (final discount in state.appliedDiscounts) {
        final result = DiscountUtils.applyDiscount(
          originalPrice: afterDiscount,
          discount: discount,
          quantity: state.totalQuantity,
        );
        totalDiscountAmount += result.discountAmount;
        afterDiscount = result.finalPrice;
      }

      // Calculate tax and service charge (default to 1 for both IDs)
      final taxId = state.tax != null ? 1 : null;
      final serviceChargeId = state.serviceCharge != null ? 1 : null;

      final taxAmount =
          state.tax != null ? (afterDiscount * (state.taxRate ?? 0) / 100) : 0;
      final serviceChargeAmount = state.serviceCharge != null
          ? (afterDiscount * (state.serviceChargeRate ?? 0) / 100)
          : 0;

      final totalPrice = afterDiscount + taxAmount + serviceChargeAmount;

      // Ensure payment amount is at least the total price
      final paymentAmount =
          event.paymentAmount >= totalPrice ? event.paymentAmount : totalPrice;
      final changeAmount = paymentAmount - totalPrice;

      // Create order request with fixed values
      final orderRequest = OrderRequestModel(
        transactionTime: DateTime.now()
            .toLocal()
            .toString()
            .substring(0, 19), // Format: YYYY-MM-DD HH:MM:SS
        kasirId: user.user.id ?? 0,
        customerId: event.customerId,
        subTotal: afterDiscount,
        taxId: taxId, // Will be 1 if tax is applied
        serviceChargeId:
            serviceChargeId, // Will be 1 if service charge is applied
        discountId: event.discountId,
        totalPrice: totalPrice,
        totalItem: state.totalQuantity,
        paymentMethod: event.paymentMethod,
        paymentAmount: paymentAmount,
        changeAmount: changeAmount,
        orderType: 'in-person', // Fixed value as requested
        customerOrderNotes: event.customerOrderNotes,
        orderItems: state.products
            .map((item) => OrderItemModel(
                  productId: item.product.id,
                  quantity: item.quantity,
                  price: item.product.price.toDouble(),
                ))
            .toList(),
      );

      // Save order locally
      final orderId = await orderLocalDatasource.saveOfflineOrder(
        orderRequest,
        kasirName: user.user.name ?? 'Kasir',
        customerName: event.customerName,
      );

      // Update usage count for applied discounts
      if (state.appliedDiscounts.isNotEmpty) {
        try {
          final productLocalDatasource = ProductLocalDatasource.instance;
          for (final discount in state.appliedDiscounts) {
            // Update usage count in local database
            await productLocalDatasource.updateDiscountUsageCount(
              discount.data[0].id,
              discount.data[0].usageCount + 1,
            );
          }
        } catch (e) {
          // Log error but don't fail the order
          debugPrint('Failed to update discount usage count: $e');
        }
      }

      emit(OrderState.orderProcessed(orderId));
    } catch (e) {
      emit(OrderState.error('Failed to process order: $e'));
    }
  }

  Future<void> _onApplyDiscounts(
      _ApplyDiscounts event, Emitter<OrderState> emit) async {
    try {
      final state = this.state;
      if (state is! _Success) return;

      // Stack diskon
      double afterDiscount = state.subTotal.toDouble();
      double totalDiscountAmount = 0;
      for (final discount in event.discounts) {
        final result = DiscountUtils.applyDiscount(
          originalPrice: afterDiscount,
          discount: discount,
          quantity: state.totalQuantity,
        );
        totalDiscountAmount += result.discountAmount;
        afterDiscount = result.finalPrice;
      }

      // Tax & Service Charge
      final taxAmount = afterDiscount * (state.taxRate ?? 0) / 100;
      final serviceChargeAmount =
          afterDiscount * (state.serviceChargeRate ?? 0) / 100;
      final totalPrice = afterDiscount + taxAmount + serviceChargeAmount;

      emit(state.copyWith(
        totalPrice: totalPrice.toInt(),
        discountPercentage: totalDiscountAmount > 0
            ? (totalDiscountAmount / state.subTotal) * 100
            : 0.0,
        appliedDiscount:
            event.discounts.isNotEmpty ? event.discounts.last : null,
        appliedDiscounts: event.discounts,
        tax: taxAmount.toInt(),
        serviceCharge: serviceChargeAmount.toInt(),
      ));
    } catch (e) {
      emit(OrderState.error('Failed to apply discounts: $e'));
    }
  }
}
