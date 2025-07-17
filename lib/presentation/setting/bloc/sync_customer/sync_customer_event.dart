part of 'sync_customer_bloc.dart';

@freezed
class SyncCustomerEvent with _$SyncCustomerEvent {
  const factory SyncCustomerEvent.started() = _Started;
  const factory SyncCustomerEvent.sendCustomer() = _SendCustomer;
  const factory SyncCustomerEvent.sendCustomerForCloseChasier() =
      _SendCustomerForCloseChasier;
  const factory SyncCustomerEvent.fetchFromServer() = _FetchFromServer;
}
