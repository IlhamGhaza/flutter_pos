part of 'sync_customer_bloc.dart';

@freezed
class SyncCustomerState with _$SyncCustomerState {
  const factory SyncCustomerState.initial() = _Initial;
  const factory SyncCustomerState.loading() = _Loading;
  const factory SyncCustomerState.success({@Default(0) int syncedCount}) =
      _Success;
  const factory SyncCustomerState.successCloseChasier(
      {@Default(0) int syncedCount}) = _SuccessCloseChasier;
  const factory SyncCustomerState.readyToFetch({@Default(0) int syncedCount}) =
      _ReadyToFetch;
  const factory SyncCustomerState.error(
    String message, {
    String? stackTrace,
  }) = _Error;
}
