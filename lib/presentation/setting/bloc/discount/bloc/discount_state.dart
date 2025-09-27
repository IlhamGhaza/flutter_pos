part of 'discount_bloc.dart';

@freezed
class DiscountState with _$DiscountState {
  const factory DiscountState.initial() = _Initial;
  const factory DiscountState.loading() = _Loading;
  const factory DiscountState.loaded(List<DiscountResponseModel> discounts) =
      _Loaded;
  const factory DiscountState.loadedDetail(DiscountResponseModel discount) =
      _LoadedDetail;
  const factory DiscountState.success(String message) = _Success;
  const factory DiscountState.error(String message) = _Error;
}
