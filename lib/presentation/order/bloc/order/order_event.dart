part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.started() = _Started;
  const factory OrderEvent.addPaymentMethod(
          String paymentMethod, List<OrderItem> orders, String customerName) =
      _AddPaymentMethod;
  const factory OrderEvent.addNominalBayar(int nominal) = _AddNominalBayar;
  const factory OrderEvent.syncOfflineOrders() = _SyncOfflineOrders;
  const factory OrderEvent.applyAutoDiscount(
      List<int> validDays, int percentage) = _ApplyAutoDiscount;
  const factory OrderEvent.applyManualDiscount(int percentage) =
      _ApplyManualDiscount;
  const factory OrderEvent.applyDiscounts(
      List<DiscountResponseModel> discounts) = _ApplyDiscounts;
  const factory OrderEvent.applyTax(TaxResponseModel tax) = _ApplyTax;
  const factory OrderEvent.applyServiceCharge(
      ServiceChargeResponseModel serviceCharge) = _ApplyServiceCharge;
  const factory OrderEvent.updateSyncStatus(int orderId, bool isSynced) =
      _UpdateSyncStatus;
  const factory OrderEvent.processOrder({
    required int customerId,
    required String customerName,
    required String paymentMethod,
    required double paymentAmount,
    required String orderType,
    String? customerOrderNotes,
    int? taxId,
    double? taxRate,
    int? serviceChargeId,
    double? serviceChargeRate,
    int? discountId,
  }) = _ProcessOrder;
}
