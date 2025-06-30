import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/datasources/order_local_datasource.dart';
import 'package:flutter_pos/data/models/order_item_model.dart';
import 'package:flutter_pos/data/models/response/product_response_model.dart';
import 'package:flutter_pos/presentation/order/bloc/qris/models/order_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      emit(const HistoryState.loading());
      try {
        // Retrieve offline orders with their items
        final rawData = await OrderLocalDatasource.instance.getAllOfflineOrders();

        // Convert to OrderModel list expected by UI
        final histories = await Future.wait(rawData.map((e) async {
          final orderMap = e['order'] as Map<String, dynamic>;
          final itemsMap = (e['items'] as List).cast<Map<String, dynamic>>();

          // Build order items with product detail lookup
          final orderItems = await Future.wait(itemsMap.map((item) async {
            final productId = item['product_id'] as int? ?? 0;
            Product? product = await ProductLocalDatasource.instance.getProductById(productId);

            product ??= Product(
              id: productId,
              name: item['product_name'] as String? ?? 'Unknown',
              categoryId: 0,
              sku: '',
              description: '',
              price: (item['price'] as num?)?.toDouble() ?? 0.0,
              unitOfMeasure: 'pcs',
              expiredDate: null,
              stock: 0,
              image: '',
              isBestSeller: false,
              isReady: true,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            return OrderItem(
              product: product,
              quantity: item['quantity'] as int? ?? 0,
              id: item['id'] as int?,
              orderId: item['order_id'] as int?,
              createdAt: item['created_at'] != null ? DateTime.tryParse(item['created_at']) : null,
              updatedAt: item['updated_at'] != null ? DateTime.tryParse(item['updated_at']) : null,
            );
          }));

          return OrderModel(
            id: orderMap['id'] as int?,
            paymentMethod: orderMap['payment_method'] as String? ?? 'Cash',
            nominalBayar: (orderMap['payment_amount'] ?? 0).toInt(),
            orders: orderItems,
            totalQuantity: orderMap['total_item']?.toInt() ?? orderItems.fold<int>(0, (sum, item) => sum + item.quantity),
            totalPrice: (orderMap['total_price'] ?? 0).toInt(),
            idKasir: orderMap['kasir_id']?.toInt() ?? 0,
            namaKasir: orderMap['kasir_name'] as String? ?? 'Kasir',
            isSync: (orderMap['is_sync'] as int?) == 1,
            transactionTime: orderMap['transaction_time'] as String? ?? '',
            customerName: orderMap['customer_name'] as String?,
            customerPhone: orderMap['customer_phone'] as String?,
          );
        }));

        emit(HistoryState.success(histories));
      } catch (e) {
        emit(HistoryState.error('Failed to load history: $e'));
      }
    });
  }
}
