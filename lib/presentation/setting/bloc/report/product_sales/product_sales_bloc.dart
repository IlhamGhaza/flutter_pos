import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_pos/data/datasources/order_local_datasource.dart';
import '../../../../../data/models/response/product_sales_report.dart';

part 'product_sales_bloc.freezed.dart';
part 'product_sales_event.dart';
part 'product_sales_state.dart';

class ProductSalesBloc extends Bloc<ProductSalesEvent, ProductSalesState> {
  ProductSalesBloc() : super(const _Initial()) {
    on<_GetProductSales>((event, emit) async {
      emit(const _Loading());
      try {
        final orders = await OrderLocalDatasource.instance.getAllOfflineOrdersWithProductJoin();
        final Map<int, ProductSales> productMap = {};
        for (final order in orders) {
          final items = (order['items'] as List).cast<Map<String, dynamic>>();
          for (final item in items) {
            final int productId = item['product_id'] is int ? item['product_id'] : int.tryParse(item['product_id'].toString()) ?? 0;
            final String productName = item['product_name']?.toString() ?? 'Unknown';
            final int productPrice = item['price'] is int ? item['price'] : int.tryParse(item['price'].toString()) ?? 0;
            final int qty = item['quantity'] is int ? item['quantity'] : int.tryParse(item['quantity'].toString()) ?? 0;
            final int totalPrice = (item['total_price'] is int ? item['total_price'] : int.tryParse(item['total_price'].toString()) ?? 0);
            if (!productMap.containsKey(productId)) {
              productMap[productId] = ProductSales(
                productId: productId,
                productName: productName,
                productPrice: productPrice,
                totalQuantity: qty.toString(),
                totalPrice: totalPrice.toString(),
              );
            } else {
              final existing = productMap[productId]!;
              productMap[productId] = ProductSales(
                productId: productId,
                productName: productName,
                productPrice: productPrice,
                totalQuantity: (int.parse(existing.totalQuantity) + qty).toString(),
                totalPrice: (int.parse(existing.totalPrice) + totalPrice).toString(),
              );
            }
          }
        }
        final productSalesList = productMap.values.toList();
        emit(_Success(ProductSalesResponseModel(status: 'success', data: productSalesList)));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
