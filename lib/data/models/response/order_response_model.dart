import 'dart:convert';

class OrderResponseModel {
  final bool success;
  final String message;
  final OrderModel? data;

  OrderResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory OrderResponseModel.fromJson(String str) => 
      OrderResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory OrderResponseModel.fromMap(Map<String, dynamic> json) => OrderResponseModel(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null ? OrderModel.fromMap(json['data']) : null,
      );

  Map<String, dynamic> toMap() => {
        'success': success,
        'message': message,
        if (data != null) 'data': data?.toMap(),
      };
}

class DiscountDetails {
  final String type;
  final double value;

  DiscountDetails({
    required this.type,
    required this.value,
  });

  factory DiscountDetails.fromMap(Map<String, dynamic> json) => DiscountDetails(
        type: json['type'] ?? 'percentage',
        value: json['value'] is String
            ? double.tryParse(json['value']) ?? 0.0
            : (json['value']?.toDouble() ?? 0.0),
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'value': value,
      };
}

class OrderModel {
  final int id;
  final String? orderNumber;
  final String status;
  final String orderType;
  final int kasirId;
  final String kasirName;
  final int customerId;
  final String customerName;
  final String? customerOrderNotes;
  final double subTotal;
  final double totalPrice;
  final int totalItem;
  final int? taxId;
  final double taxRate;
  final double taxAmount;
  final int? serviceChargeId;
  final double serviceChargeRate;
  final double serviceCharge;
  final int? discountId;
  final double discountAmount;
  final DiscountDetails? discountDetails;
  final String paymentMethod;
  final double paymentAmount;
  final double changeAmount;
  final DateTime transactionTime;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? paidAt;
  final String? midtransTransactionId;
  final String? midtransOrderId;
  final dynamic paymentGatewayResponse;
  final bool isSyncedFromMobile;
  final String? mobileSyncValidationStatus;
  final String? mobileSyncNotes;
  final DateTime? mobileSyncedAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    this.orderNumber,
    required this.status,
    required this.orderType,
    required this.kasirId,
    required this.kasirName,
    required this.customerId,
    required this.customerName,
    this.customerOrderNotes,
    required this.subTotal,
    required this.totalPrice,
    required this.totalItem,
    this.taxId,
    required this.taxRate,
    required this.taxAmount,
    this.serviceChargeId,
    required this.serviceChargeRate,
    required this.serviceCharge,
    this.discountId,
    required this.discountAmount,
    this.discountDetails,
    required this.paymentMethod,
    required this.paymentAmount,
    required this.changeAmount,
    required this.transactionTime,
    required this.createdAt,
    this.updatedAt,
    this.paidAt,
    this.midtransTransactionId,
    this.midtransOrderId,
    this.paymentGatewayResponse,
    this.isSyncedFromMobile = false,
    this.mobileSyncValidationStatus,
    this.mobileSyncNotes,
    this.mobileSyncedAt,
    required this.items,
  });

  factory OrderModel.fromMap(Map<String, dynamic> json) => OrderModel(
        id: json['id'] ?? 0,
        orderNumber: json['order_number'],
        status: json['status'] ?? 'pending',
        orderType: json['order_type'] ?? 'in-person',
        kasirId: json['kasir_id'] ?? 0,
        kasirName: json['kasir_name'] ?? '',
        customerId: json['customer_id'] ?? 0,
        customerName: json['customer_name'] ?? '',
        customerOrderNotes: json['customer_order_notes'],
        subTotal: json['sub_total'] is String 
            ? double.tryParse(json['sub_total']) ?? 0.0 
            : (json['sub_total']?.toDouble() ?? 0.0),
        totalPrice: json['total_price'] is String 
            ? double.tryParse(json['total_price']) ?? 0.0 
            : (json['total_price']?.toDouble() ?? 0.0),
        totalItem: json['total_item'] ?? 0,
        taxId: json['tax_id'],
        taxRate: json['tax_rate'] is String 
            ? double.tryParse(json['tax_rate']) ?? 0.0 
            : (json['tax_rate']?.toDouble() ?? 0.0),
        taxAmount: json['tax_amount'] is String 
            ? double.tryParse(json['tax_amount']) ?? 0.0 
            : (json['tax_amount']?.toDouble() ?? 0.0),
        serviceChargeId: json['service_charge_id'],
        serviceChargeRate: json['service_charge_rate'] is String 
            ? double.tryParse(json['service_charge_rate']) ?? 0.0 
            : (json['service_charge_rate']?.toDouble() ?? 0.0),
        serviceCharge: json['service_charge'] is String 
            ? double.tryParse(json['service_charge']) ?? 0.0 
            : (json['service_charge']?.toDouble() ?? 0.0),
        discountId: json['discount_id'],
        discountAmount: json['discount_amount'] is String 
            ? double.tryParse(json['discount_amount']) ?? 0.0 
            : (json['discount_amount']?.toDouble() ?? 0.0),
        discountDetails: json['discount_details'] != null 
            ? DiscountDetails.fromMap(json['discount_details'] is String 
                ? jsonDecode(json['discount_details']) 
                : json['discount_details'])
            : null,
        paymentMethod: json['payment_method'] ?? 'cash',
        paymentAmount: json['payment_amount'] is String 
            ? double.tryParse(json['payment_amount']) ?? 0.0 
            : (json['payment_amount']?.toDouble() ?? 0.0),
        changeAmount: json['change_amount'] is String 
            ? double.tryParse(json['change_amount']) ?? 0.0 
            : (json['change_amount']?.toDouble() ?? 0.0),
        transactionTime: DateTime.parse(json['transaction_time'] ?? DateTime.now().toIso8601String()),
        createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
        paidAt: json['paid_at'] != null ? DateTime.tryParse(json['paid_at']) : null,
        midtransTransactionId: json['midtrans_transaction_id'],
        midtransOrderId: json['midtrans_order_id'],
        paymentGatewayResponse: json['payment_gateway_response'],
        isSyncedFromMobile: json['is_synced_from_mobile'] ?? false,
        mobileSyncValidationStatus: json['mobile_sync_validation_status'],
        mobileSyncNotes: json['mobile_sync_notes'],
        mobileSyncedAt: json['mobile_synced_at'] != null ? DateTime.tryParse(json['mobile_synced_at']) : null,
        items: json['items'] != null 
            ? List<OrderItemModel>.from(
                (json['items'] as List).map((x) => OrderItemModel.fromMap(x)),
              )
            : [],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'order_number': orderNumber,
        'status': status,
        'order_type': orderType,
        'kasir_id': kasirId,
        'kasir_name': kasirName,
        'customer_id': customerId,
        'customer_name': customerName,
        if (customerOrderNotes != null) 'customer_order_notes': customerOrderNotes,
        'sub_total': subTotal,
        'total_price': totalPrice,
        'total_item': totalItem,
        if (taxId != null) 'tax_id': taxId,
        'tax_rate': taxRate,
        'tax_amount': taxAmount,
        if (serviceChargeId != null) 'service_charge_id': serviceChargeId,
        'service_charge_rate': serviceChargeRate,
        'service_charge': serviceCharge,
        if (discountId != null) 'discount_id': discountId,
        'discount_amount': discountAmount,
        if (discountDetails != null) 'discount_details': discountDetails?.toMap(),
        'payment_method': paymentMethod,
        'payment_amount': paymentAmount,
        'change_amount': changeAmount,
        'transaction_time': transactionTime.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt?.toIso8601String(),
        if (paidAt != null) 'paid_at': paidAt?.toIso8601String(),
        if (midtransTransactionId != null) 'midtrans_transaction_id': midtransTransactionId,
        if (midtransOrderId != null) 'midtrans_order_id': midtransOrderId,
        if (paymentGatewayResponse != null) 'payment_gateway_response': paymentGatewayResponse,
        'is_synced_from_mobile': isSyncedFromMobile,
        if (mobileSyncValidationStatus != null) 'mobile_sync_validation_status': mobileSyncValidationStatus,
        if (mobileSyncNotes != null) 'mobile_sync_notes': mobileSyncNotes,
        if (mobileSyncedAt != null) 'mobile_synced_at': mobileSyncedAt?.toIso8601String(),
        'items': items.map((x) => x.toMap()).toList(),
      };
}

class OrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> json) => OrderItemModel(
        id: json['id'],
        orderId: json['order_id'],
        productId: json['product_id'],
        productName: json['product_name'] ?? '',
        price: json['price'] is String 
            ? double.tryParse(json['price']) ?? 0.0 
            : (json['price']?.toDouble() ?? 0.0),
        quantity: json['quantity'] ?? 1,
        totalPrice: json['total_price'] is String 
            ? double.tryParse(json['total_price']) ?? 0.0 
            : (json['total_price']?.toDouble() ?? 0.0),
        createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
        deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'order_id': orderId,
        'product_id': productId,
        'product_name': productName,
        'price': price,
        'quantity': quantity,
        'total_price': totalPrice,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deleted_at': deletedAt?.toIso8601String(),
      };
}