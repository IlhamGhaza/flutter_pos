import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_service_charge_state.freezed.dart';

@freezed
class SyncServiceChargeState with _$SyncServiceChargeState {
  const factory SyncServiceChargeState.initial() = _Initial;
  const factory SyncServiceChargeState.loading() = _Loading;
  const factory SyncServiceChargeState.success() = _Success;
  const factory SyncServiceChargeState.error(String message) = _Error;
}
