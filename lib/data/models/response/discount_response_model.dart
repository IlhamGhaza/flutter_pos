import 'dart:convert';

class DiscountResponseModel {
  final String message;
  final List<DiscountModel> data;
  final DateTime syncTime;
  final int total;

  DiscountResponseModel({
    required this.message,
    required this.data,
    required this.syncTime,
    required this.total,
  });

  factory DiscountResponseModel.fromJson(String str) =>
      DiscountResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DiscountResponseModel.fromMap(Map<String, dynamic> json) {
    // Handle null or non-list data field
    final data = json['data'];
    List<DiscountModel> discounts = [];
    
    if (data != null) {
      if (data is List) {
        discounts = data.map<DiscountModel>((x) => DiscountModel.fromMap(x)).toList();
      } else if (data is Map<String, dynamic>) {
        // Handle case where data is a single object
        discounts = [DiscountModel.fromMap(data)];
      }
    }
    
    return DiscountResponseModel(
      message: json['message'] ?? '',
      data: discounts,
      syncTime: json['sync_time'] != null
          ? DateTime.parse(json['sync_time']).toLocal()
          : DateTime.now().toUtc(),
      total: json['total'] is int ? json['total'] : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'data': List<dynamic>.from(data.map((x) => x.toMap())),
        'sync_time': syncTime.toIso8601String(),
        'total': total,
      };
}

class DiscountModel {
  final int id;
  final String name;
  final String description;
  final String type; // percentage, fixed, quantity_based, etc.
  final double value;
  final double? minQuantity;
  final double? maxQuantity;
  final double? minAmount;
  final int? buyQuantity;
  final int? getQuantity;
  final dynamic quantityTiers; // Can be null, array, or object
  final String applyTo; // all, specific
  final dynamic applicableItems; // Can be null or array of item IDs
  final String customerType; // all, retail, wholesale, member
  final bool combinable;
  final int? usageLimit;
  final int usageCount;
  final String status; // active, inactive
  final DateTime startDate;
  final DateTime? expiredDate;
  final String? startTime;
  final String? endTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final List<int> validDays; // 1-7 representing days of the week

  DiscountModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    this.minQuantity,
    this.maxQuantity,
    this.minAmount,
    this.buyQuantity,
    this.getQuantity,
    this.quantityTiers,
    required this.applyTo,
    this.applicableItems,
    required this.customerType,
    required this.combinable,
    this.usageLimit,
    required this.usageCount,
    required this.status,
    required this.startDate,
    this.expiredDate,
    this.startTime,
    this.endTime,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.validDays,
  });
  //from map to map
  factory DiscountModel.fromMap(Map<String, dynamic> json) => DiscountModel(
        id: json['id'],
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        type: json['type'] ?? 'percentage',
        value: json['value'] is String
            ? double.tryParse(json['value']) ?? 0.0
            : (json['value']?.toDouble() ?? 0.0),
        minQuantity: json['min_quantity'] is String
            ? double.tryParse(json['min_quantity'])
            : json['min_quantity']?.toDouble(),
        maxQuantity: json['max_quantity'] is String
            ? double.tryParse(json['max_quantity'])
            : json['max_quantity']?.toDouble(),
        minAmount: json['min_amount'] is String
            ? double.tryParse(json['min_amount'])
            : json['min_amount']?.toDouble(),
        buyQuantity: json['buy_quantity'],
        getQuantity: json['get_quantity'],
        quantityTiers: json['quantity_tiers'],
        applyTo: json['apply_to'] ?? 'all',
        applicableItems: json['applicable_items'],
        customerType: json['customer_type'] ?? 'all',
        combinable: (json['combinable'] ?? 0) == 1,
        usageLimit: json['usage_limit'],
        usageCount: json['usage_count'] ?? 0,
        status: json['status'] ?? 'active',
        startDate: json['start_date'] != null
            ? DateTime.parse(json['start_date']).toLocal()
            : DateTime.now(),
        expiredDate: json['expired_date'] != null
            ? DateTime.parse(json['expired_date']).toLocal()
            : null,
        startTime: json['start_time'],
        endTime: json['end_time'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at']).toLocal()
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at']).toLocal()
            : DateTime.now(),
        deletedAt: json['deleted_at'] != null
            ? DateTime.parse(json['deleted_at']).toLocal()
            : null,
        validDays: json['valid_days'] != null && json['valid_days'] is List
            ? List<int>.from(json['valid_days'].map((x) => x is int ? x : int.tryParse(x.toString()) ?? 0).toList())
            : <int>[],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type,
        'value': value,
        if (minQuantity != null) 'min_quantity': minQuantity,
        if (maxQuantity != null) 'max_quantity': maxQuantity,
        if (minAmount != null) 'min_amount': minAmount,
        if (buyQuantity != null) 'buy_quantity': buyQuantity,
        if (getQuantity != null) 'get_quantity': getQuantity,
        if (quantityTiers != null) 'quantity_tiers': quantityTiers,
        'apply_to': applyTo,
        if (applicableItems != null) 'applicable_items': applicableItems,
        'customer_type': customerType,
        'combinable': combinable ? 1 : 0,
        if (usageLimit != null) 'usage_limit': usageLimit,
        'usage_count': usageCount,
        'status': status,
        'start_date': startDate.toIso8601String(),
        if (expiredDate != null) 'expired_date': expiredDate?.toIso8601String(),
        if (startTime != null) 'start_time': startTime,
        if (endTime != null) 'end_time': endTime,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        if (deletedAt != null) 'deleted_at': deletedAt?.toIso8601String(),
        'valid_days': List<dynamic>.from(validDays.map((x) => x)),
      };

  // Helper methods
  bool get isActive => status.toLowerCase() == 'active';
  bool get isPercentage => type == 'percentage';
  bool get isFixed => type == 'fixed';
  bool get isQuantityBased => type == 'quantity_based';
  bool get isBuyXGetY => type == 'buy_x_get_y';

  // Check if discount is currently valid
  bool get isValid {
    final now = DateTime.now();
    
    // Check date range
    if (now.isBefore(startDate) || 
        (expiredDate != null && now.isAfter(expiredDate!))) {
      return false;
    }
    
    // Check time of day if specified
    if (startTime != null && endTime != null) {
      final nowTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      if (nowTime.compareTo(startTime!) < 0 || nowTime.compareTo(endTime!) > 0) {
        return false;
      }
    }
    
    // Check day of week if specified
    if (validDays.isNotEmpty) {
      // 1 = Monday, 7 = Sunday in the API, but DateTime.weekday is 1-7 where 1 is Monday
      if (!validDays.contains(now.weekday)) {
        return false;
      }
    }
    
    // Check usage limit if specified
    if (usageLimit != null && usageCount >= usageLimit!) {
      return false;
    }
    
    return true;
  }
}