import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_discount_state.freezed.dart';

@freezed
class SyncDiscountState with _$SyncDiscountState {
  const factory SyncDiscountState.initial() = _Initial;
  const factory SyncDiscountState.loading() = _Loading;
  const factory SyncDiscountState.success() = _Success;
  const factory SyncDiscountState.error(String message) = _Error;
}
