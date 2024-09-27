import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos/data/datasources/report_remote_datasource.dart';

import '../../../../../data/datasources/auth_local_datasource.dart';

part 'close_cashier_bloc.freezed.dart';
part 'close_cashier_event.dart';
part 'close_cashier_state.dart';

class CloseCashierBloc extends Bloc<CloseCashierEvent, CloseCashierState> {
  final ReportRemoteDatasource reportRemoteDatasource;
  CloseCashierBloc(
    this.reportRemoteDatasource,
  ) : super(const _Initial()) {
    on<_CloseCashier>((event, emit) async {
      emit(const CloseCashierState.loading());
      final result = await reportRemoteDatasource.closeCashier();
      result.fold(
        (l) => emit(CloseCashierState.error(l)),
        (r) {
          AuthLocalDatasource().removeAuthData();
          emit(const CloseCashierState.success());
        },
      );
    });
  }
}
