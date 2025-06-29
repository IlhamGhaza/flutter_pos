import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_service_charge_event.freezed.dart';

@freezed
class SyncServiceChargeEvent with _$SyncServiceChargeEvent {
  const factory SyncServiceChargeEvent.sync() = _Sync;
}
