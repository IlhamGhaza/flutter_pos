import 'dart:convert';

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
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        data: List<Product>.from(
            (json["data"] as List?)?.map((x) => Product.fromMap(x)) ?? []),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class Product {
  final int id;
  final String name;
  final int categoryId;
  final String sku;
  final String description;
  final double price;
  final String unitOfMeasure;
  final DateTime? expiredDate;
  final int stock;
  final String image;
  final bool isBestSeller;
  final bool isReady;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.sku,
    required this.description,
    required this.price,
    required this.unitOfMeasure,
    this.expiredDate,
    required this.stock,
    required this.image,
    this.isBestSeller = false,
    this.isReady = false,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        categoryId: json['category_id'] as int? ?? 0,
        sku: json['sku'] as String? ?? '',
        description: json['description'] as String? ?? '',
        price: json['price'] is String
            ? double.tryParse(json['price']) ?? 0.0
            : (json['price']?.toDouble() ?? 0.0),
        unitOfMeasure: json['unit_of_measure'] as String? ?? 'pcs',
        expiredDate: json['expired_date'] != null
            ? DateTime.tryParse(json['expired_date'])
            : null,
        stock: json['stock'] as int? ?? 0,
        image: json['image'] as String? ?? 'products/default-product.jpg',
        isBestSeller: json['is_best_seller'] is bool 
            ? json['is_best_seller'] as bool 
            : (json['is_best_seller'] as int?) == 1,
        isReady: json['is_ready'] is bool 
            ? json['is_ready'] as bool 
            : (json['is_ready'] as int?) == 1,
        createdAt: DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(json['updated_at'] as String? ?? DateTime.now().toIso8601String()),
        deletedAt: json['deleted_at'] != null
            ? DateTime.tryParse(json['deleted_at'] as String)
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category_id': categoryId,
        'sku': sku,
        'description': description,
        'price': price,
        'unit_of_measure': unitOfMeasure,
        'expired_date': expiredDate?.toIso8601String(),
        'stock': stock,
        'image': image,
        'is_best_seller': isBestSeller,
        'isReady': isReady,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };

  Map<String, dynamic> toLocalMap() => {
        'id': id,
        'name': name,
        'category_id': categoryId,
        'sku': sku,
        'description': description,
        'price': price,
        'unit_of_measure': unitOfMeasure,
        'expired_date': expiredDate?.toIso8601String(),
        'stock': stock,
        'image': image,
        'is_best_seller': isBestSeller ? 1 : 0,
        'is_ready': isReady ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
      };

  Product copyWith({
    int? id,
    String? name,
    int? categoryId,
    String? sku,
    String? description,
    double? price,
    String? unitOfMeasure,
    DateTime? expiredDate,
    int? stock,
    String? image,
    bool? isBestSeller,
    bool? isReady,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      price: price ?? this.price,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      expiredDate: expiredDate ?? this.expiredDate,
      stock: stock ?? this.stock,
      image: image ?? this.image,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      isReady: isReady ?? this.isReady,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.categoryId == categoryId &&
        other.sku == sku &&
        other.description == description &&
        other.price == price &&
        other.unitOfMeasure == unitOfMeasure &&
        other.expiredDate == expiredDate &&
        other.stock == stock &&
        other.image == image &&
        other.isBestSeller == isBestSeller &&
        other.isReady == isReady &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        categoryId.hashCode ^
        sku.hashCode ^
        description.hashCode ^
        price.hashCode ^
        unitOfMeasure.hashCode ^
        expiredDate.hashCode ^
        stock.hashCode ^
        image.hashCode ^
        isBestSeller.hashCode ^
        isReady.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }
}
