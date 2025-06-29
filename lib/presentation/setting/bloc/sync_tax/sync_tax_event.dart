import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_tax_event.freezed.dart';

@freezed
class SyncTaxEvent with _$SyncTaxEvent {
  const factory SyncTaxEvent.sync() = _Sync;
}
