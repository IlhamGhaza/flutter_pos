import 'dart:convert';

class OrderItemModel {
  final int productId;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(String str) => OrderItemModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderItemModel.fromMap(Map<String, dynamic> json) => OrderItemModel(
        productId: json["product_id"] as int,
        quantity: json["quantity"] as int,
        price: (json["price"] as num).toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'product_id': productId,
        'quantity': quantity,
        'price': price,
      };
}

class OrderRequestModel {
  final String transactionTime;
  final int kasirId;
  final int customerId;
  final double subTotal;
  final int? taxId;
  // final double? taxRate;
  final int? serviceChargeId;
  // final double? serviceChargeRate;
  final int? discountId;
  final double totalPrice;
  final int totalItem;
  final String paymentMethod;
  final double paymentAmount;
  final double changeAmount;
  final String orderType;
  final String? customerOrderNotes;
  final List<OrderItemModel> orderItems;

  OrderRequestModel({
    required this.transactionTime,
    required this.kasirId,
    required this.customerId,
    required this.subTotal,
    this.taxId,
    // this.taxRate,
    this.serviceChargeId,
    // this.serviceChargeRate,
    this.discountId,
    required this.totalPrice,
    required this.totalItem,
    required this.paymentMethod,
    required this.paymentAmount,
    required this.changeAmount,
    required this.orderType,
    this.customerOrderNotes,
    required this.orderItems,
  });

  factory OrderRequestModel.fromJson(String str) => OrderRequestModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderRequestModel.fromMap(Map<String, dynamic> json) => OrderRequestModel(
        transactionTime: json["transaction_time"] as String,
        kasirId: json["kasir_id"] as int,
        customerId: json["customer_id"] as int,
        subTotal: (json["sub_total"] as num).toDouble(),
        taxId: json["tax_id"],
        // taxRate: json["tax_rate"]?.toDouble(),
        serviceChargeId: json["service_charge_id"],
        // serviceChargeRate: json["service_charge_rate"]?.toDouble(),
        discountId: json["discount_id"],
        totalPrice: (json["total_price"] as num).toDouble(),
        totalItem: json["total_item"] as int,
        paymentMethod: json["payment_method"] as String,
        paymentAmount: (json["payment_amount"] as num).toDouble(),
        changeAmount: (json["change_amount"] as num).toDouble(),
        orderType: json["order_type"] as String,
        customerOrderNotes: json["customer_order_notes"],
        orderItems: List<OrderItemModel>.from(
            (json["order_items"] as List).map((x) => OrderItemModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'transaction_time': transactionTime,
        'kasir_id': kasirId,
        'customer_id': customerId,
        'sub_total': subTotal,
        if (taxId != null) 'tax_id': taxId,
        // if (taxRate != null) 'tax_rate': taxRate,
        if (serviceChargeId != null) 'service_charge_id': serviceChargeId,
        // if (serviceChargeRate != null) 'service_charge_rate': serviceChargeRate,
        if (discountId != null) 'discount_id': discountId,
        'total_price': totalPrice,
        'total_item': totalItem,
        'payment_method': paymentMethod,
        'payment_amount': paymentAmount,
        'change_amount': changeAmount,
        'order_type': orderType,
        if (customerOrderNotes != null) 'customer_order_notes': customerOrderNotes,
        'order_items': orderItems.map((item) => item.toMap()).toList(),
      };
}
