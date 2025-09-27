class DiscountRequestModel {
  final String name;
  final String? description;
  final String type; // 'fixed' or 'percentage'
  final double value;
  final int? minQuantity;
  final int? maxQuantity;
  final double? minAmount;
  final String applyTo; // 'all', 'category', 'product'
  final String customerType; // 'all', 'retail', 'wholesale', 'member'
  final bool combinable;
  final String status; // 'active' or 'inactive'
  final String? startDate;
  final String? expiredDate;
  final String? startTime;
  final String? endTime;
  final List<int>? validDays; // 1-7 representing Monday-Sunday

  DiscountRequestModel({
    required this.name,
    this.description,
    required this.type,
    required this.value,
    this.minQuantity,
    this.maxQuantity,
    this.minAmount,
    required this.applyTo,
    required this.customerType,
    this.combinable = false,
    this.status = 'active',
    this.startDate,
    this.expiredDate,
    this.startTime,
    this.endTime,
    this.validDays,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description ?? '',
      'type': type,
      'value': value,
      'min_quantity': minQuantity,
      'max_quantity': maxQuantity,
      'min_amount': minAmount,
      'apply_to': applyTo,
      'customer_type': customerType,
      'combinable': combinable,
      'status': status,
      'start_date': startDate,
      'expired_date': expiredDate,
      'start_time': startTime,
      'end_time': endTime,
      'valid_days': validDays,
    };
  }
}
