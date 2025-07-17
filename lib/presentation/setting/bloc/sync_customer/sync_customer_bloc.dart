import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/datasources/customer_remote_datasource.dart';
import 'package:flutter_pos/data/models/request/customer_request_model.dart';
import 'dart:developer';

part 'sync_customer_event.dart';
part 'sync_customer_state.dart';
part 'sync_customer_bloc.freezed.dart';

class SyncCustomerBloc extends Bloc<SyncCustomerEvent, SyncCustomerState> {
  final CustomerRemoteDatasource _remoteDatasource;
  final ProductLocalDatasource _localDatasource;

  SyncCustomerBloc(
    this._remoteDatasource, {
    ProductLocalDatasource? localDatasource,
  })  : _localDatasource = localDatasource ?? ProductLocalDatasource.instance,
        super(const _Initial()) {
    on<_Started>(_onStarted);
    on<_SendCustomer>(_onSendCustomer);
    on<_SendCustomerForCloseChasier>(_onSendCustomerForCloseChasier);
    on<_FetchFromServer>(_onFetchFromServer);
  }

  Future<void> _onStarted(
      _Started event, Emitter<SyncCustomerState> emit) async {
    // Trigger the sendCustomer event when started is called
    add(const SyncCustomerEvent.sendCustomer());
  }

  Future<void> _onSendCustomer(
      _SendCustomer event, Emitter<SyncCustomerState> emit) async {
    try {
      log('SyncCustomerBloc: Starting customer sync...');
      emit(const SyncCustomerState.loading());
      await _localDatasource.removeInvalidUnsyncedCustomers();
      final unsyncedCustomers = await _localDatasource.getUnsyncedCustomers();
      log('SyncCustomerBloc: Found ${unsyncedCustomers.length} unsynced customers');
      if (unsyncedCustomers.isEmpty) {
        log('SyncCustomerBloc: No unsynced customers found');
        emit(const SyncCustomerState.success(syncedCount: 0));
        return;
      }
      int successCount = 0;
      for (final customer in unsyncedCustomers) {
        final requestJson = customer.requestJson;
        log('SyncCustomerBloc: Processing customer ${customer.id} with requestJson: $requestJson');
        if (requestJson != null) {
          final reqMap = json.decode(requestJson) as Map<String, dynamic>;
          final customerRequest = CustomerRequestModel(
            name: reqMap['name'] ?? '',
            phoneNumber: reqMap['phone_number'] ?? '',
            email: reqMap['email'] ?? '',
            address: reqMap['address'] ?? '',
            city: reqMap['city'] ?? '',
            state: reqMap['state'] ?? '',
            postalCode: reqMap['postal_code'] ?? '',
            customerType: reqMap['customer_type'] ?? '',
          );
          try {
            log('SyncCustomerBloc: Sending customer request to server: ${customerRequest.toJson()}');
            final response =
                await _remoteDatasource.createCustomer(customerRequest);
            log('SyncCustomerBloc: Server response: ${response.toJson()}');
            if (response.id != null) {
              // Update semua order offline yang menggunakan customer lokal ke id server
              await _localDatasource.updateOfflineOrdersCustomerId(
                oldCustomerId: customer.id,
                newCustomerId: response.id!,
              );
              await _localDatasource.updateCustomerSyncStatus(
                  customer.id, true);
              successCount++;
              log('SyncCustomerBloc: Successfully synced customer ${customer.id}');
            }
          } catch (e) {
            log('SyncCustomerBloc: Error syncing customer ${customer.id}: $e');
            // Continue to next customer
          }
        } else {
          log('SyncCustomerBloc: Customer ${customer.id} has no requestJson, skipping');
        }
      }
      log('SyncCustomerBloc: Sync completed. Successfully synced $successCount customers');
      // Emit readyToFetch state instead of success to indicate we should fetch from server
      emit(SyncCustomerState.readyToFetch(syncedCount: successCount));
    } catch (e, stackTrace) {
      emit(SyncCustomerState.error(e.toString(),
          stackTrace: stackTrace.toString()));
    }
  }

  Future<void> _onFetchFromServer(
      _FetchFromServer event, Emitter<SyncCustomerState> emit) async {
    try {
      log('SyncCustomerBloc: Fetching customers from server...');
      emit(const SyncCustomerState.loading());
      final customers = await _remoteDatasource.getCustomers();
      await _localDatasource.insertAllCustomer(customers);
      log('SyncCustomerBloc: Successfully fetched ${customers.length} customers from server');
      emit(const SyncCustomerState.success(syncedCount: 0));
    } catch (e, stackTrace) {
      log('SyncCustomerBloc: Error fetching customers from server: $e');
      emit(SyncCustomerState.error(e.toString(),
          stackTrace: stackTrace.toString()));
    }
  }

  Future<void> _onSendCustomerForCloseChasier(
      _SendCustomerForCloseChasier event,
      Emitter<SyncCustomerState> emit) async {
    try {
      emit(const SyncCustomerState.loading());
      await _localDatasource.removeInvalidUnsyncedCustomers();
      final unsyncedCustomers = await _localDatasource.getUnsyncedCustomers();
      if (unsyncedCustomers.isEmpty) {
        emit(const SyncCustomerState.successCloseChasier(syncedCount: 0));
        return;
      }
      int successCount = 0;
      for (final customer in unsyncedCustomers) {
        final requestJson = customer.requestJson;
        if (requestJson != null) {
          final reqMap = json.decode(requestJson) as Map<String, dynamic>;
          final customerRequest = CustomerRequestModel(
            name: reqMap['name'] ?? '',
            phoneNumber: reqMap['phone_number'] ?? '',
            email: reqMap['email'] ?? '',
            address: reqMap['address'] ?? '',
            city: reqMap['city'] ?? '',
            state: reqMap['state'] ?? '',
            postalCode: reqMap['postal_code'] ?? '',
            customerType: reqMap['customer_type'] ?? '',
          );
          try {
            final response =
                await _remoteDatasource.createCustomer(customerRequest);
            if (response.id != null) {
              // Update semua order offline yang menggunakan customer lokal ke id server
              await _localDatasource.updateOfflineOrdersCustomerId(
                oldCustomerId: customer.id,
                newCustomerId: response.id!,
              );
              await _localDatasource.updateCustomerSyncStatus(
                  customer.id, true);
              successCount++;
            }
          } catch (_) {
            // Continue to next customer
          }
        }
      }
      emit(SyncCustomerState.successCloseChasier(syncedCount: successCount));
    } catch (e, stackTrace) {
      emit(SyncCustomerState.error(e.toString(),
          stackTrace: stackTrace.toString()));
    }
  }
}
