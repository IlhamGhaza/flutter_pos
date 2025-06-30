import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_pos/data/models/response/discount_response_model.dart';
import 'package:flutter_pos/data/models/response/product_response_model.dart';

/// Enum for discount types
enum DiscountType {
  fixed,
  percentage,
  buyXGetY,
  quantityBased,
  bulkDiscount,
  unknown
}

/// Extension to parse string to DiscountType
extension DiscountTypeExtension on String {
  DiscountType toDiscountType() {
    switch (toLowerCase()) {
      case 'fixed':
        return DiscountType.fixed;
      case 'percentage':
      case 'persen':
        return DiscountType.percentage;
      case 'buy_x_get_y':
        return DiscountType.buyXGetY;
      case 'quantity_based':
        return DiscountType.quantityBased;
      case 'bulk_discount':
        return DiscountType.bulkDiscount;
      default:
        return DiscountType.unknown;
    }
  }
}

/// Extension to format discount value for display
extension DiscountDisplay on DiscountResponseModel {
  String get displayValue {
    switch (data[0].type.toLowerCase()) {
      case 'percentage':
      case 'persen':
        return '${data[0].value.toStringAsFixed(0)}%';
      case 'fixed':
        return 'Rp${data[0].value.toStringAsFixed(0)}';
      case 'buy_x_get_y':
        return 'Beli ${data[0].minQuantity.toString()} Gratis ${data[0].maxQuantity.toString() ?? '1'}';
      case 'quantity_based':
        return '${data[0].value.toStringAsFixed(0)}% (Min. ${data[0].minQuantity.toString()} pcs)';
      case 'bulk_discount':
        return '${data[0].value.toStringAsFixed(0)}% (Min. Rp${data[0].minAmount ?? '0'})';
      default:
        return data[0].value.toString();
    }
  }
}

/// Enum for customer types
enum CustomerType {
  all,
  retail,
  wholesale,
  member,
}

/// Enum for discount application targets
enum DiscountApplyTo {
  all,
  category,
  product,
}

class DiscountUtils {
  /// Check if today is included in valid days
  /// validDays: 1=Monday, 7=Sunday
  static bool isTodayDiscount(List<int> validDays) {
    if (validDays.isEmpty) return true; // If no validDays, applies every day

    final now = DateTime.now();
    // DateTime weekday: 1=Monday, 7=Sunday
    return validDays.contains(now.weekday);
  }

  /// Check if current time is within the specified time range
  static bool _isWithinTimeRange(TimeOfDay start, TimeOfDay end) {
    final now = TimeOfDay.now();

    // Convert all times to minutes since midnight for easier comparison
    int nowInMinutes = now.hour * 60 + now.minute;
    int startInMinutes = start.hour * 60 + start.minute;
    int endInMinutes = end.hour * 60 + end.minute;

    debugPrint(
        'Time check - Now: ${now.hour}:${now.minute.toString().padLeft(2, '0')} (${nowInMinutes}m), '
        'Start: ${start.hour}:${start.minute.toString().padLeft(2, '0')} (${startInMinutes}m), '
        'End: ${end.hour}:${end.minute.toString().padLeft(2, '0')} (${endInMinutes}m)');

    // Handle normal case (start < end, e.g., 09:00-17:00)
    if (startInMinutes < endInMinutes) {
      return nowInMinutes >= startInMinutes && nowInMinutes <= endInMinutes;
    }
    // Handle overnight case (end < start, e.g., 22:00-06:00)
    else if (startInMinutes > endInMinutes) {
      return nowInMinutes >= startInMinutes || nowInMinutes <= endInMinutes;
    }
    // Handle case where start == end (24-hour validity)
    else {
      return true;
    }
  }

  /// Check if customer type matches discount criteria
  /// 'reguler' is treated as an alias for 'retail'
  static bool isValidCustomerType(
      String customerType, String discountCustomerType) {
    if (discountCustomerType.isEmpty ||
        discountCustomerType.toLowerCase() == 'all') {
      return true;
    }

    // Handle multiple customer types (comma-separated)
    final allowedTypes = discountCustomerType
        .toLowerCase()
        .split(',')
        .map((e) => e.trim())
        .toList();

    // Map 'reguler' and 'regular' to 'retail' for backward compatibility
    final normalizedCustomerType = customerType.toLowerCase() == 'reguler' ||
            customerType.toLowerCase() == 'regular'
        ? 'retail'
        : customerType.toLowerCase();

    // Check if any of the allowed types match the customer type
    return allowedTypes.any((type) {
      final match = normalizedCustomerType == type;
      if (!match) {
        debugPrint('Customer type mismatch: $normalizedCustomerType vs $type');
      }
      return match;
    });
  }

  /// Check if discount applies to product based on apply_to and apply_to_value
  /// applyTo: 'all', 'category', or 'product'
  /// applyToValue: comma-separated IDs when applyTo is 'category' or 'product'
  static bool isProductApplicable(
    Product product,
    String applyTo,
    String? applyToValue,
  ) {
    debugPrint('Checking product applicability:');
    debugPrint(
        '- Product ID: ${product.id}, Category ID: ${product.categoryId}');
    debugPrint('- Apply To: $applyTo, Apply To Value: $applyToValue');

    // If applyTo is 'all' or empty, discount applies to all products
    if (applyTo.isEmpty || applyTo.toLowerCase() == 'all') {
      debugPrint('  - Applies to all products');
      return true;
    }

    // If no specific values provided but apply_to is not 'all', then it doesn't apply
    if (applyToValue == null || applyToValue.isEmpty) {
      debugPrint('  - No applyToValue provided for applyTo: $applyTo');
      return false;
    }

    // Parse the applyToValue into a list of IDs
    final applyToValues = applyToValue
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    debugPrint('  - Parsed applyToValues: $applyToValues');

    bool isApplicable = false;

    switch (applyTo.toLowerCase()) {
      case 'category':
        isApplicable = applyToValues
            .any((categoryId) => product.categoryId.toString() == categoryId);
        debugPrint('  - Category match: $isApplicable');
        break;

      case 'product':
        isApplicable = applyToValues
            .any((productId) => product.id.toString() == productId);
        debugPrint('  - Product ID match: $isApplicable');
        break;

      default:
        debugPrint('  - Unknown apply_to type: $applyTo');
        isApplicable = false;
    }

    debugPrint('  - Final applicability: $isApplicable');
    return isApplicable;
  }

  /// Check if current date is within discount's valid date range
  static bool isWithinDateRange(DiscountResponseModel discount) {
    final now = DateTime.now();
    final discountData = discount.data.isNotEmpty ? discount.data[0] : null;
    if (discountData == null) return false;

    // Check start date
    final startDate = DateTime(
      discountData.startDate.year,
      discountData.startDate.month,
      discountData.startDate.day,
    );
    final currentDate = DateTime(now.year, now.month, now.day);

    if (currentDate.isBefore(startDate)) {
      return false;
    }

    // Check expired date if exists
    if (discountData.expiredDate != null) {
      final expiredDate = DateTime(
        discountData.expiredDate!.year,
        discountData.expiredDate!.month,
        discountData.expiredDate!.day,
        23, 59, 59, // End of day
      );

      if (now.isAfter(expiredDate)) {
        return false;
      }
    }

    return true;
  }

  /// Check if current time is within discount's valid time window
  static bool isWithinTimeWindow(DiscountResponseModel discount) {
    if (discount.data[0].startTime == null ||
        discount.data[0].startTime!.isEmpty ||
        discount.data[0].endTime == null ||
        discount.data[0].endTime!.isEmpty) {
      return true; // If no time constraints, valid all day
    }

    try {
      final startParts = discount.data[0].startTime!.split(':');
      final endParts = discount.data[0].endTime!.split(':');

      if (startParts.length < 2 || endParts.length < 2) {
        return false;
      }

      final startHour = int.tryParse(startParts[0]) ?? 0;
      final startMinute = int.tryParse(startParts[1]) ?? 0;
      final endHour = int.tryParse(endParts[0]) ?? 23;
      final endMinute = int.tryParse(endParts[1]) ?? 59;

      // Create TimeOfDay objects for comparison
      final startTime = TimeOfDay(hour: startHour, minute: startMinute);
      final endTime = TimeOfDay(hour: endHour, minute: endMinute);

      return _isWithinTimeRange(startTime, endTime);
    } catch (e) {
      debugPrint('Error parsing discount time window: $e');
      return false;
    }
  }

  /// Check if discount is valid for current date and time
  static bool isDiscountValidNow(DiscountResponseModel discount) {
    // Check discount status
    if (discount.data[0].status.toLowerCase() != 'active') {
      debugPrint('Discount ${discount.data[0].id} is not active');
      return false;
    }

    // Check valid days
    if (!isTodayDiscount(discount.data[0].validDays)) {
      debugPrint('Discount ${discount.data[0].id} not valid for today');
      return false;
    }

    // Check date range
    if (!isWithinDateRange(discount)) {
      debugPrint('Discount ${discount.data[0].id} not within date range');
      return false;
    }

    // Check time window
    if (!isWithinTimeWindow(discount)) {
      debugPrint('Discount ${discount.data[0].id} not within time window');
      return false;
    }

    // Check usage limits if any
    if (discount.data[0].usageLimit != null &&
        discount.data[0].usageCount >= discount.data[0].usageLimit!) {
      debugPrint('Discount ${discount.data[0].id} has reached usage limit');
      return false;
    }

    return true;
  }

  /// Check if discount is applicable to the current customer
  static bool isCustomerEligible(
    DiscountResponseModel discount,
    String? customerType,
  ) {
    // If no customer type is provided, only apply to 'all' customer types
    if (customerType == null) {
      return discount.data[0].customerType.toLowerCase() == 'all';
    }

    final isEligible =
        isValidCustomerType(customerType, discount.data[0].customerType);
    if (!isEligible) {
      debugPrint(
          'Customer type $customerType not eligible for discount ${discount.data[0].id}');
    }
    return isEligible;
  }

  /// Check if discount is applicable to the product
  static bool isProductEligible(
    DiscountResponseModel discount,
    Product product,
  ) {
    final isEligible = isProductApplicable(
      product,
      discount.data[0].applyTo ?? 'all',
      discount.data[0].applicableItems,
    );

    if (!isEligible) {
      debugPrint(
          'Product ${product.id} not eligible for discount ${discount.data[0].id}');
    }

    return isEligible;
  }

  /// Check if order meets minimum requirements for discount
  static bool meetsMinimumRequirements(
    double totalPrice,
    int totalQuantity,
    DiscountResponseModel discount,
  ) {
    final discountData = discount.data[0];

    // Check minimum purchase amount
    if (discountData.minAmount != null && discountData.minAmount! > 0) {
      if (totalPrice < discountData.minAmount!) {
        debugPrint(
            'Total price $totalPrice is less than minimum amount ${discountData.minAmount}');
        return false;
      }
    }

    // Check minimum quantity
    if (discountData.minQuantity != null && discountData.minQuantity! > 0) {
      if (totalQuantity < discountData.minQuantity!) {
        debugPrint(
            'Quantity $totalQuantity is less than minimum ${discountData.minQuantity}');
        return false;
      }
    }

    // Check maximum quantity if specified
    if (discountData.maxQuantity != null && discountData.maxQuantity! > 0) {
      if (totalQuantity > discountData.maxQuantity!) {
        debugPrint(
            'Quantity $totalQuantity exceeds maximum ${discountData.maxQuantity}');
        return false;
      }
    }

    // Check buy quantity for buy X get Y discounts
    if (discountData.type.toLowerCase() == 'buy_x_get_y' &&
        discountData.buyQuantity != null &&
        discountData.buyQuantity! > 0) {
      if (totalQuantity < discountData.buyQuantity!) {
        debugPrint(
            'Quantity $totalQuantity is less than buy quantity ${discountData.buyQuantity} for buy X get Y discount');
        return false;
      }
    }

    // Check get quantity for buy X get Y discounts
    if (discountData.type.toLowerCase() == 'buy_x_get_y' &&
        discountData.getQuantity != null &&
        discountData.getQuantity! > 0) {
      // This is more of a validation for the discount configuration
      // The actual application logic is handled in applyDiscount method
      debugPrint(
          'Buy X Get Y discount: Buy ${discountData.buyQuantity}, Get ${discountData.getQuantity}');
    }

    return true;
  }

  /// Check if discount usage limit is valid
  static bool isUsageLimitValid(DiscountResponseModel discount) {
    final discountData = discount.data[0];

    // Check usage limit if specified
    if (discountData.usageLimit != null && discountData.usageLimit! > 0) {
      if (discountData.usageCount >= discountData.usageLimit!) {
        debugPrint(
            'Discount ${discountData.id} has reached usage limit (${discountData.usageCount}/${discountData.usageLimit})');
        return false;
      }
    }

    return true;
  }

  /// Comprehensive discount validation for order processing
  static DiscountValidationResult validateDiscountForOrder({
    required DiscountResponseModel discount,
    required double orderTotal,
    required int orderQuantity,
    required String customerType,
    required List<Product> products,
  }) {
    final discountData = discount.data[0];
    final validationResult = DiscountValidationResult(
      isValid: true,
      discount: discount,
      errors: [],
    );

    debugPrint(
        'Validating discount: ${discountData.name} (ID: ${discountData.id})');

    // 1. Check discount status
    if (discountData.status.toLowerCase() != 'active') {
      validationResult.addError('Diskon tidak aktif');
    }

    // 2. Check if discount is valid for current date/time
    if (!isDiscountValidNow(discount)) {
      validationResult.addError('Diskon tidak berlaku untuk waktu saat ini');
    }

    // 3. Check customer type eligibility
    if (!isValidCustomerType(customerType, discountData.customerType)) {
      validationResult.addError('Tipe pelanggan tidak memenuhi syarat diskon');
    }

    // 4. Check minimum requirements
    if (!meetsMinimumRequirements(orderTotal, orderQuantity, discount)) {
      if (discountData.minAmount != null &&
          discountData.minAmount! > 0 &&
          orderTotal < discountData.minAmount!) {
        validationResult.addError(
            'Total belanja minimal Rp${discountData.minAmount!.toStringAsFixed(0)}');
      }
      if (discountData.minQuantity != null &&
          discountData.minQuantity! > 0 &&
          orderQuantity < discountData.minQuantity!) {
        validationResult.addError(
            'Minimal ${discountData.minQuantity!.toStringAsFixed(0)} item');
      }
      if (discountData.maxQuantity != null &&
          discountData.maxQuantity! > 0 &&
          orderQuantity > discountData.maxQuantity!) {
        validationResult.addError(
            'Maksimal ${discountData.maxQuantity!.toStringAsFixed(0)} item');
      }
      if (discountData.type.toLowerCase() == 'buy_x_get_y' &&
          discountData.buyQuantity != null &&
          discountData.buyQuantity! > 0 &&
          orderQuantity < discountData.buyQuantity!) {
        validationResult.addError(
            'Minimal beli ${discountData.buyQuantity} item untuk diskon ini');
      }
    }

    // 5. Check usage limit
    if (!isUsageLimitValid(discount)) {
      validationResult.addError('Diskon telah mencapai batas penggunaan');
    }

    // 6. Check product applicability
    final applyTo = discountData.applyTo.toLowerCase();
    if (applyTo != 'all') {
      final applicableItems = (discountData.applicableItems?.toString() ?? '')
          .split(',')
          .map((e) => e.trim())
          .toList();

      bool hasEligibleProduct = false;
      if (applyTo == 'product' && applicableItems.isNotEmpty) {
        hasEligibleProduct = products
            .any((item) => applicableItems.contains(item.id.toString()));
      } else if (applyTo == 'category' && applicableItems.isNotEmpty) {
        hasEligibleProduct = products.any(
            (item) => applicableItems.contains(item.categoryId.toString()));
      }

      if (!hasEligibleProduct) {
        validationResult
            .addError('Tidak ada produk yang memenuhi syarat diskon');
      }
    }

    return validationResult;
  }

  /// Apply discount to price based on discount type
  static DiscountResult applyDiscount({
    required double originalPrice,
    required DiscountResponseModel discount,
    int quantity = 1,
    String? customerType,
  }) {
    final result = DiscountResult(
      originalPrice: originalPrice,
      finalPrice: originalPrice,
      discountAmount: 0,
      discount: discount,
    );

    // Validate discount first
    if (!isDiscountValidNow(discount)) {
      debugPrint('Discount ${discount.data[0].id} is not valid now');
      return result;
    }

    // Check customer eligibility if customer type is provided
    if (customerType != null && !isCustomerEligible(discount, customerType)) {
      debugPrint(
          'Customer type $customerType is not eligible for discount ${discount.data[0].id}');
      return result;
    }

    // Check minimum requirements
    if (!meetsMinimumRequirements(originalPrice, quantity, discount)) {
      debugPrint(
          'Minimum requirements not met for discount ${discount.data[0].id}');
      return result;
    }

    final discountType = discount.data[0].type.toLowerCase().toDiscountType();
    double discountAmount = 0;

    switch (discountType) {
      case DiscountType.percentage:
        // Percentage discount (e.g., 10% off)
        discountAmount = originalPrice * (discount.data[0].value / 100);
        break;

      case DiscountType.fixed:
        // Fixed amount discount (e.g., Rp10.000 off)
        discountAmount = min(originalPrice, discount.data[0].value);
        break;

      case DiscountType.buyXGetY:
        // Buy X Get Y Free (e.g., Buy 2 Get 1 Free)
        if (quantity >=
            discount.data[0].minQuantity! / discount.data[0].buyQuantity!) {
          final freeItems = (quantity ~/
                  discount.data[0].minQuantity! /
                  discount.data[0].buyQuantity!) *
              (discount.data[0].maxQuantity ?? 1);
          final itemPrice = originalPrice / quantity;
          discountAmount = freeItems * itemPrice;
        }
        break;

      case DiscountType.quantityBased:
        // Quantity based discount (e.g., 10% off when buying 5 or more)
        if (quantity >= (discount.data[0].minQuantity ?? 1)) {
          discountAmount = originalPrice * (discount.data[0].value / 100);
        }
        break;

      case DiscountType.bulkDiscount:
        // Bulk discount (e.g., 15% off for orders over Rp500.000)
        if (originalPrice >= (discount.data[0].minAmount ?? 0)) {
          discountAmount = originalPrice * (discount.data[0].value / 100);
        }
        break;

      case DiscountType.unknown:
      default:
        debugPrint('Unknown discount type: ${discount.data[0].type}');
        return result;
    }

    // Ensure discount doesn't exceed original price
    discountAmount = discountAmount.clamp(0, originalPrice);

    return DiscountResult(
      originalPrice: originalPrice,
      finalPrice: originalPrice - discountAmount,
      discountAmount: discountAmount,
      discount: discount,
    );
  }

  /// Apply multiple discounts to an order
  static List<DiscountResult> applyDiscounts({
    required List<Map<String, dynamic>> items,
    required List<DiscountResponseModel> availableDiscounts,
    String? customerType,
  }) {
    final List<DiscountResult> appliedDiscounts = [];

    for (final discount in availableDiscounts) {
      // Skip if discount is not combinable and we already have applied discounts
      if (appliedDiscounts.isNotEmpty && !discount.data[0].combinable) {
        continue;
      }

      // Calculate total price for items that match discount criteria
      double totalEligiblePrice = 0;
      int totalEligibleQuantity = 0;

      for (final item in items) {
        final product = item['product'] as Product;
        final quantity = item['quantity'] as int;
        final price = product.price ?? 0;
        if (isProductEligible(discount, product)) {
          totalEligiblePrice += price * quantity;
          totalEligibleQuantity += quantity;
        }
      }

      // Skip if no items are eligible for this discount
      if (totalEligiblePrice <= 0) {
        continue;
      }

      // Apply discount to eligible items
      final result = applyDiscount(
        originalPrice: totalEligiblePrice,
        discount: discount,
        quantity: totalEligibleQuantity,
        customerType: customerType,
      );

      // Add to applied discounts if discount was applied
      if (result.discountAmount > 0) {
        appliedDiscounts.add(result);

        // If discount is not combinable, stop after first application
        if (!discount.data[0].combinable) {
          break;
        }
      }
    }

    return appliedDiscounts;
  }

  /// Check if a discount is applicable to an order based on all conditions
  /// including customer type, date/time, minimum requirements, and product applicability
  static bool isDiscountApplicable({
    required DiscountResponseModel discount,
    required String customerType,
    required double orderTotal,
    required int itemCount,
    required List<Product> products,
  }) {
    final discountData = discount.data.isNotEmpty ? discount.data[0] : null;
    if (discountData == null) {
      debugPrint('  - No discount data available');
      return false;
    }

    debugPrint(
        'Checking discount applicability for: ${discountData.name} (ID: ${discountData.id})');

    // 1. Check customer type
    if (!isValidCustomerType(customerType, discountData.customerType)) {
      debugPrint(
          '  - Customer type "$customerType" is not eligible for this discount');
      return false;
    }

    // 3. Check date range
    final now = DateTime.now();
    if (now.isBefore(discountData.startDate)) {
      debugPrint('  - Discount starts at ${discountData.startDate}');
      return false;
    }

    // Check if discount has expired (only if expiredDate is not null)
    if (discountData.expiredDate != null &&
        now.isAfter(discountData.expiredDate!)) {
      debugPrint('  - Discount expired on ${discountData.expiredDate}');
      return false;
    }

    // 4. Check time window if specified
    if (discountData.startTime != null && discountData.endTime != null) {
      final startTime = _parseTime(discountData.startTime!);
      final endTime = _parseTime(discountData.endTime!);

      if (!_isWithinTimeRange(startTime, endTime)) {
        debugPrint(
            '  - Current time is outside discount time window (${discountData.startTime} - ${discountData.endTime})');
        return false;
      }
    }

    // 5. Check valid days if specified
    if (discountData.validDays.isNotEmpty) {
      final currentWeekday = now.weekday; // 1=Monday, 7=Sunday
      if (!discountData.validDays.contains(currentWeekday)) {
        debugPrint(
            '  - Today is not a valid day for this discount (valid days: ${discountData.validDays})');
        return false;
      }
    }

    // 6. Check minimum requirements
    final minAmount = discountData.minAmount;
    if (minAmount != null && minAmount > 0 && orderTotal < minAmount) {
      debugPrint(
          '  - Order total ($orderTotal) is less than minimum amount ($minAmount)');
      return false;
    }

    final minQuantity = discountData.minQuantity;
    if (minQuantity != null && minQuantity > 0 && itemCount < minQuantity) {
      debugPrint(
          '  - Item count ($itemCount) is less than minimum quantity ($minQuantity)');
      return false;
    }

    // 7. Check product applicability if not 'all' products
    final applyTo = discountData.applyTo.toLowerCase();
    if (applyTo != 'all') {
      final allProductsEligible = products.every((product) =>
          isProductApplicable(
              product, applyTo, discountData.applicableItems.toString()));

      if (!allProductsEligible) {
        debugPrint(
            '  - Not all products in cart are eligible for this discount');
        return false;
      }
    }

    debugPrint('  - Discount is applicable');
    return true;
  }

  /// Helper method to parse time string (HH:mm) to TimeOfDay
  static TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  /// Apply percentage discount to price
  static double applyPercentageDiscount(double price, double percentage) {
    if (price <= 0 || percentage <= 0) return price;
    final discountAmount = price * (percentage / 100);
    return (price - discountAmount).clamp(0, double.infinity);
  }

  /// Apply fixed amount discount to price
  static double applyFixedDiscount(double price, double fixedAmount) {
    if (price <= 0 || fixedAmount <= 0) return price;
    return (price - fixedAmount).clamp(0, double.infinity);
  }
}

/// Class to hold discount validation result
class DiscountValidationResult {
  bool isValid;
  final DiscountResponseModel discount;
  final List<String> errors;

  DiscountValidationResult({
    required this.isValid,
    required this.discount,
    required this.errors,
  });

  void addError(String error) {
    errors.add(error);
    isValid = false;
  }

  String get errorMessage {
    if (errors.isEmpty) return '';
    return errors.join(', ');
  }

  @override
  String toString() {
    return 'DiscountValidationResult{\n      isValid: $isValid,\n      discount: ${discount.data[0].name},\n      errors: $errors\n    }';
  }
}

/// Class to hold discount application result
class DiscountResult {
  final double originalPrice;
  final double finalPrice;
  final double discountAmount;
  final DiscountResponseModel discount;

  DiscountResult({
    required this.originalPrice,
    required this.finalPrice,
    required this.discountAmount,
    required this.discount,
  });

  /// Get discount percentage (0-100)
  double get discountPercentage {
    if (originalPrice <= 0) return 0;
    return (discountAmount / originalPrice) * 100;
  }

  /// Get discount description for display
  String get description {
    if (discount.data.isEmpty) return 'Diskon';

    final discountData = discount.data[0];
    switch (discountData.type.toLowerCase()) {
      case 'percentage':
      case 'persen':
        return 'Diskon ${discountData.value.toStringAsFixed(0)}%';

      case 'fixed':
        return 'Potongan Rp${discount.data[0].value.toStringAsFixed(0)}';

      case 'buy_x_get_y':
        return 'Beli ${discount.data[0].minQuantity} Gratis ${discount.data[0].maxQuantity ?? 1}';

      case 'quantity_based':
        return 'Diskon ${discount.data[0].value.toStringAsFixed(0)}% (Min. ${discount.data[0].minQuantity} pcs)';

      case 'bulk_discount':
        return 'Diskon ${discount.data[0].value.toStringAsFixed(0)}% (Min. Rp${discount.data[0].minAmount ?? '0'})';

      default:
        return 'Diskon';
    }
  }

  /// Apply percentage discount to price
  static double applyPercentageDiscount(double price, double percentage) {
    return price - (price * percentage / 100);
  }

  /// Apply fixed amount discount to price
  static double applyFixedDiscount(double price, double fixedAmount) {
    final discountAmount = fixedAmount > price ? price : fixedAmount;
    return price - discountAmount;
  }

  @override
  String toString() {
    return 'DiscountResult{\n      originalPrice: $originalPrice,\n      finalPrice: $finalPrice,\n      discountAmount: $discountAmount,\n      discount: $discount\n    }';
  }
}
