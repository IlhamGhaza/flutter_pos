import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_state.freezed.dart';

@freezed
class CustomerState with _$CustomerState {
  const factory CustomerState.initial() = _Initial;
  const factory CustomerState.loading() = _Loading;
  const factory CustomerState.success() = _Success;
  const factory CustomerState.error(String message) = _Error;
}
