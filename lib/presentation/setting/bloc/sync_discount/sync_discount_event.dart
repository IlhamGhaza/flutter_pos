import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_discount_event.freezed.dart';

@freezed
class SyncDiscountEvent with _$SyncDiscountEvent {
  const factory SyncDiscountEvent.sync() = _Sync;
}
