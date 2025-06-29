import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/tax_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';

import 'sync_tax_event.dart';
import 'sync_tax_state.dart';

class SyncTaxBloc extends Bloc<SyncTaxEvent, SyncTaxState> {
  final TaxRemoteDatasource _taxRemoteDatasource;
  
  SyncTaxBloc(this._taxRemoteDatasource) : super(const SyncTaxState.initial()) {
    on<SyncTaxEvent>((event, emit) async {
      await event.when(
        sync: () async {
      emit(const SyncTaxState.loading());
      try {
        final taxes = await _taxRemoteDatasource.getTaxes();
        await ProductLocalDatasource.instance.insertAllTax(taxes);
        emit(const SyncTaxState.success());
      } catch (e) {
        emit(SyncTaxState.error(e.toString()));
      }
    });
  });
  }
}
