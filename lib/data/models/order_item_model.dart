import 'package:equatable/equatable.dart';
import 'package:flutter_pos/data/models/response/product_response_model.dart';

class OrderItem extends Equatable {
  final Product product;
  final int quantity;
  final int? id;
  final int? orderId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderItem({
    required this.product,
    required this.quantity,
    this.id,
    this.orderId,
    this.createdAt,
    this.updatedAt,
  });

  int get totalPrice => quantity * product.price.round();

  @override
  List<Object?> get props => [
        product,
        quantity,
        id,
        orderId,
        createdAt,
        updatedAt,
      ];

  OrderItem copyWith({
    Product? product,
    int? quantity,
    int? id,
    int? orderId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  OrderItem withQuantity(int newQuantity) {
    return copyWith(quantity: newQuantity);
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': product.id,
      'quantity': quantity,
      'price': product.price,
      'subtotal': totalPrice,
    };
  }

  Map<String, dynamic> toMapForLocal(int orderId) {
    return {
      'product_id': product.id,
      'quantity': quantity,
      'price': product.price,
      'subtotal': totalPrice,
      'order_id': orderId,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'] as int,
      id: map['id'] as int?,
      orderId: map['order_id'] as int?,
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }
}
