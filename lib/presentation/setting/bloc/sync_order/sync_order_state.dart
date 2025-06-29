part of 'sync_order_bloc.dart';

@freezed
class SyncOrderState with _$SyncOrderState {
  const factory SyncOrderState.initial() = _Initial;
  const factory SyncOrderState.loading() = _Loading;
  const factory SyncOrderState.success({
    @Default(0) int syncedCount,
  }) = _Success;
  const factory SyncOrderState.successCloseChasier({
    @Default(0) int syncedCount,
  }) = _SuccessCloseChasier;
  const factory SyncOrderState.error(
    String message, {
    String? stackTrace,
  }) = _Error;
}
