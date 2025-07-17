class CustomerRequestModel {
  final String name;
  final String phoneNumber;
  final String email;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String customerType;

  CustomerRequestModel({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.customerType,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'address': address,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'customer_type': customerType,
    };
  }

  Map<String, dynamic> toJson() => toMap();
} 