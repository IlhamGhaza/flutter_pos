import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class ProductResponseModel {
  final bool success;
  final String message;
  final List<Product> data;

  ProductResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductResponseModel.fromJson(String str) =>
      ProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductResponseModel(
        success: json["success"],
        message: json["message"],
        data: List<Product>.from(json["data"].map((x) => Product.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Product {
  final int? id;
  final int? productId;
  final String name;
  final String? description;
  final int price;
  final int stock;
  final String category;
  final int categoryId;
  final String image;
  final bool isBestSeller;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    this.id,
    this.productId,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.categoryId,
    required this.image,
    this.isBestSeller = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        productId: json["product_id"],
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        price: json["price"] ?? 0,
        stock: json["stock"] ?? 0,
        category: json["category"] ?? '',
        categoryId: json["category_id"] != null
            ? (json["category_id"] is String
                ? int.tryParse(json["category_id"]) ?? 0
                : json["category_id"])
            : 0,
        image: json["image"] ?? '',
        isBestSeller: json["is_best_seller"] == 1 ? true : false,

        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),

        // createdAt: json["created_at"] != null
        //     ? DateTime.parse(json["created_at"])
        //     : null,
        // updatedAt: json["updated_at"] != null
        //     ? DateTime.parse(json["updated_at"])
        //     : null,
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "price": price,
        "stock": stock,
        "category": category,
        "category_id": categoryId,
        "image": image,
        "is_best_seller": isBestSeller ? 1 : 0,
        "product_id": productId,
      };
  Map<String, dynamic> toLocalMap() => {
        "name": name,
        "price": price,
        "stock": stock,
        "category": category,
        "category_id": categoryId,
        "image": image,
        "is_best_seller": isBestSeller ? 1 : 0,
        "product_id": id,
      };

  Product copyWith({
    int? id,
    int? productId,
    String? name,
    String? description,
    int? price,
    int? stock,
    String? category,
    int? categoryId,
    String? image,
    bool? isBestSeller,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      image: image ?? this.image,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.stock == stock &&
        other.category == category &&
        other.image == image &&
        other.isBestSeller == isBestSeller &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        stock.hashCode ^
        category.hashCode ^
        image.hashCode ^
        isBestSeller.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
