import 'dart:convert';


import 'package:flutter_pos/data/models/order_item_model.dart';

class OrderModel {
  final int? id;
  final String paymentMethod;
  final int nominalBayar;
  final List<OrderItem> orders;
  final int totalQuantity;
  final int totalPrice;
  final int idKasir;
  final String namaKasir;
  final String transactionTime;
  final bool isSync;
  final String? customerName;
  final String? customerPhone;
  OrderModel({
    this.id,
    required this.paymentMethod,
    required this.nominalBayar,
    required this.orders,
    required this.totalQuantity,
    required this.totalPrice,
    required this.idKasir,
    required this.namaKasir,
    required this.isSync,
    required this.transactionTime,
    this.customerName,
    this.customerPhone,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentMethod': paymentMethod,
      'nominalBayar': nominalBayar,
      'orders': orders.map((x) => x.toMap()).toList(),
      'totalQuantity': totalQuantity,
      'totalPrice': totalPrice,
      'idKasir': idKasir,
      'namaKasir': namaKasir,
      'isSync': isSync,
      'customerName': customerName,
      'customerPhone': customerPhone,
    };
  }

  //  mominal INTEGER,
  //       payment_method TEXT
  //       total_item INTEGER,
  //       id_kasir INTEGER,
  //       nama_kasir TEXT,
  //       is_sync INTEGER DEFAULT 0

  Map<String, dynamic> toMapForLocal() {
    return {
      'payment_method': paymentMethod,
      'total_item': totalQuantity,
      'nominal': totalPrice,
      'id_kasir': idKasir,
      'nama_kasir': namaKasir,
      'is_sync': isSync ? 1 : 0,
      'transaction_time': transactionTime,
      'customer_name': customerName,
      'customer_phone': customerPhone,
    };
  }

  factory OrderModel.fromLocalMap(Map<String, dynamic> map) {
    return OrderModel(
      paymentMethod: map['payment_method'] ?? '',
      nominalBayar: map['nominal']?.toInt() ?? 0,
      orders: [],
      totalQuantity: map['total_item']?.toInt() ?? 0,
      totalPrice: map['nominal']?.toInt() ?? 0,
      idKasir: map['id_kasir']?.toInt() ?? 0,
      isSync: map['is_sync'] == 1 ? true : false,
      namaKasir: map['nama_kasir'] ?? '',
      id: map['id']?.toInt() ?? 0,
      transactionTime: map['transaction_time'] ?? '',
      customerName: map['customer_name'],
      customerPhone: map['customer_phone'],
    );
  }

  factory OrderModel.newFromLocalMap(Map<String, dynamic> map, List<OrderItem> orders) {
    return OrderModel(
      paymentMethod: map['payment_method'] ?? '',
      nominalBayar: map['nominal']?.toInt() ?? 0,
      orders: orders,
      totalQuantity: map['total_item']?.toInt() ?? 0,
      totalPrice: map['nominal']?.toInt() ?? 0,
      idKasir: map['id_kasir']?.toInt() ?? 0,
      isSync: map['is_sync'] == 1 ? true : false,
      namaKasir: map['nama_kasir'] ?? '',
      id: map['id']?.toInt() ?? 0,
      transactionTime: map['transaction_time'] ?? '',
      customerName: map['customer_name'],
      customerPhone: map['customer_phone'],
    );
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      paymentMethod: map['paymentMethod'] ?? '',
      nominalBayar: map['nominalBayar']?.toInt() ?? 0,
      orders:
          List<OrderItem>.from(map['orders']?.map((x) => OrderItem.fromMap(x))),
      totalQuantity: map['totalQuantity']?.toInt() ?? 0,
      totalPrice: map['totalPrice']?.toInt() ?? 0,
      idKasir: map['idKasir']?.toInt() ?? 0,
      customerName: map['customerName'],
      customerPhone: map['customerPhone'],
      isSync: map['isSync'] ?? false,
      namaKasir: map['namaKasir'] ?? '',
      id: map['id']?.toInt() ?? 0,
      transactionTime: map['transactionTime'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));
}
