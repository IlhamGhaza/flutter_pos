part of 'order_bloc.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState.initial() = _Initial;
  const factory OrderState.loading() = _Loading;
  const factory OrderState.success(
    List<OrderItem> products,
    int totalQuantity,
    int totalPrice, {
    required int subTotal,
    required double discountPercentage,
    required DiscountResponseModel? appliedDiscount,
    required String paymentMethod,
    required int nominalBayar,
    required int idKasir,
    required String namaKasir,
    required String customerName,
    int? tax,
    double? taxRate,
    int? serviceCharge,
    double? serviceChargeRate,
  }) = _Success;
  const factory OrderState.error(String message) = _Error;
  const factory OrderState.syncing() = _Syncing;
  const factory OrderState.discountApplied(
      double discountPercentage, int totalAfterDiscount) = _DiscountApplied;
  const factory OrderState.syncStatusUpdated(int orderId, bool isSynced) =
      _SyncStatusUpdated;
}
