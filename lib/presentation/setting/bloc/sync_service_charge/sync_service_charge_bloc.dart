import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/service_charge_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';

import 'sync_service_charge_event.dart';
import 'sync_service_charge_state.dart';

class SyncServiceChargeBloc extends Bloc<SyncServiceChargeEvent, SyncServiceChargeState> {
  final ServiceChargeRemoteDatasource _serviceChargeRemoteDatasource;
  
  SyncServiceChargeBloc(this._serviceChargeRemoteDatasource) : super(const SyncServiceChargeState.initial()) {
    on<SyncServiceChargeEvent>((event, emit) async {
      await event.when(
        sync: () async {
      emit(const SyncServiceChargeState.loading());
      try {
        final serviceCharges = await _serviceChargeRemoteDatasource.getServiceCharges();
        await ProductLocalDatasource.instance.insertAllServiceCharge(serviceCharges);
        emit(const SyncServiceChargeState.success());
      } catch (e) {
        emit(SyncServiceChargeState.error(e.toString()));
      }
    });
  });
  }
}
