import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_tax_state.freezed.dart';

@freezed
class SyncTaxState with _$SyncTaxState {
  const factory SyncTaxState.initial() = _Initial;
  const factory SyncTaxState.loading() = _Loading;
  const factory SyncTaxState.success() = _Success;
  const factory SyncTaxState.error(String message) = _Error;
}
