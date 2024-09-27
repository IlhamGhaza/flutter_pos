import 'dart:convert';

class ProductSalesResponseModel {
  final String status;
  final List<ProductSales> data;

  ProductSalesResponseModel({
    required this.status,
    required this.data,
  });

  factory ProductSalesResponseModel.fromMap(Map<String, dynamic> map) {
    return ProductSalesResponseModel(
      status: map['status'] as String,
      data: List<ProductSales>.from(
          map["data"].map((x) => ProductSales.fromMap(x))),
    );
  }

  factory ProductSalesResponseModel.fromJson(String source) =>
      ProductSalesResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class ProductSales {
  final int productId;
  final String productName;
  final int productPrice;
  final String totalQuantity;
  final String totalPrice;

  ProductSales({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.totalQuantity,
    required this.totalPrice,
  });

  factory ProductSales.fromMap(Map<String, dynamic> map) {
    return ProductSales(
      productId: map['product_id'] as int,
      productName: map['product_name'] as String,
      productPrice: map['product_price'] as int,
      totalQuantity: map['total_quantity'] as String,
      totalPrice: map['total_price'] as String,
    );
  }

  factory ProductSales.fromJson(String source) =>
      ProductSales.fromMap(json.decode(source) as Map<String, dynamic>);
}
