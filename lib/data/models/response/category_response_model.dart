import 'dart:convert';

class CategoryResponseModel {
  final bool? status;
  final String? message;
  final List<Category>? data;

  CategoryResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CategoryResponseModel.fromJson(String str) {
    try {
      return CategoryResponseModel.fromMap(json.decode(str));
    } catch (e) {
      throw FormatException('Failed to parse CategoryResponseModel: $e');
    }
  }

  String toJson() => json.encode(toMap());

  factory CategoryResponseModel.fromMap(Map<String, dynamic> json) {
    try {
      return CategoryResponseModel(
        status: json["status"] as bool? ?? false,
        message: json["message"] as String? ?? '',
        data: json["data"] != null 
            ? List<Category>.from((json["data"] as List).map((x) => Category.fromMap(x)))
            : <Category>[],
      );
    } catch (e) {
      throw FormatException('Failed to create CategoryResponseModel from map: $e');
    }
  }

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data != null ? List<dynamic>.from(data!.map((x) => x.toMap())) : [],
      };
}

class Category {
  final int id;
  final String name;

  Category({
    required this.id,
    required this.name,
  });

  factory Category.fromJson(String str) {
    try {
      return Category.fromMap(json.decode(str));
    } catch (e) {
      throw FormatException('Failed to parse Category: $e');
    }
  }

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) {
    try {
      return Category(
        id: (json["id"] as num?)?.toInt() ?? 0,
        name: (json["name"] as String?) ?? 'Unknown Category',
      );
    } catch (e) {
      throw FormatException('Failed to create Category from map: $e');
    }
  }

  factory Category.fromLocal(Map<String, dynamic> json) {
    try {
      return Category(
        id: (json["category_id"] as num?)?.toInt() ?? 0,
        name: (json["name"] as String?) ?? 'Unknown Category',
      );
    } catch (e) {
      throw FormatException('Failed to create Category from local map: $e');
    }
  }

  Map<String, dynamic> toMap() => {
        "category_id": id,
        "name": name,
      };

  @override
  String toString() => name;
}
