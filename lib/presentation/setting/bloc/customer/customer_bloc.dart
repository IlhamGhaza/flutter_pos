import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/customer_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';

import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRemoteDatasource _customerRemoteDatasource;
  
  CustomerBloc(this._customerRemoteDatasource) : super(const CustomerState.initial()) {
    on<CustomerEvent>((event, emit) async {
    await event.when(
      fetch: () async {
      emit(const CustomerState.loading());
      try {
        final customers = await _customerRemoteDatasource.getCustomers();
        await ProductLocalDatasource.instance.insertAllCustomer(customers);
        emit(const CustomerState.success());
      } catch (e) {
        emit(CustomerState.error(e.toString()));
      }
    });
  });
  }
}
