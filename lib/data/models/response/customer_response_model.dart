import 'dart:convert';

class CustomerResponseModel {
  final int id;
  final String name;
  final String phoneNumber;
  final String email;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String customerType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String? requestJson;

  CustomerResponseModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.customerType,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.requestJson,
  });

  factory CustomerResponseModel.fromMap(Map<String, dynamic> map) {
    return CustomerResponseModel(
      id: map['id'] as int,
      name: map['name'] as String,
      phoneNumber: map['phone_number'] as String? ?? '',
      email: map['email'] as String? ?? '',
      address: map['address'] as String? ?? '',
      city: map['city'] as String? ?? '',
      state: map['state'] as String? ?? '',
      postalCode: map['postal_code'] as String? ?? '',
      customerType: map['customer_type'] as String? ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.tryParse(map['updated_at'])
          : null,
      deletedAt: map['deleted_at'] != null
          ? DateTime.tryParse(map['deleted_at'])
          : null,
      requestJson: map['request_json'] as String?,
    );
  }

  static List<CustomerResponseModel> fromList(List<dynamic> list) =>
      list.map((e) => CustomerResponseModel.fromMap(e)).toList();

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'phone_number': phoneNumber,
        'email': email,
        'address': address,
        'city': city,
        'state': state,
        'postal_code': postalCode,
        'customer_type': customerType,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt?.toIso8601String(),
        'request_json': requestJson,
      };

  String toJson() => json.encode(toMap());
  factory CustomerResponseModel.fromJson(String source) =>
      CustomerResponseModel.fromMap(json.decode(source));
}
