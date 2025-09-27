import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';

class DiscountManageState {
  final bool loading;
  final bool success;
  final String? error;
  DiscountManageState({this.loading = false, this.success = false, this.error});
  DiscountManageState copyWith({bool? loading, bool? success, String? error}) =>
      DiscountManageState(
        loading: loading ?? this.loading,
        success: success ?? this.success,
        error: error,
      );
}

class DiscountManageCubit extends Cubit<DiscountManageState> {
  final ProductLocalDatasource _local;
  DiscountManageCubit({ProductLocalDatasource? local})
      : _local = local ?? ProductLocalDatasource.instance,
        super(DiscountManageState());

  Future<void> addLocal(Map<String, dynamic> payload) async {
    emit(state.copyWith(loading: true, success: false, error: null));
    try {
      await _local.saveDiscountWithSyncFlag(payload);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, success: false, error: e.toString()));
    }
  }

  Future<void> softDeleteLocal(int anyId) async {
    emit(state.copyWith(loading: true, success: false, error: null));
    try {
      await _local.softDeleteDiscountLocal(anyId);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, success: false, error: e.toString()));
    }
  }
}
