part of 'discount_bloc.dart';

@freezed
class DiscountEvent with _$DiscountEvent {
  const factory DiscountEvent.getDiscounts() = _GetDiscounts;
  const factory DiscountEvent.getTodayDiscounts() = _GetTodayDiscounts;
  const factory DiscountEvent.getDiscountById(int id) = _GetDiscountById;
  const factory DiscountEvent.createDiscount(DiscountRequestModel request) = _CreateDiscount;
  const factory DiscountEvent.deleteDiscount(int id) = _DeleteDiscount;
}
