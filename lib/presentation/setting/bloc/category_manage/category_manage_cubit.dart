import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';

class CategoryManageState {
  final bool loading;
  final bool success;
  final String? error;
  CategoryManageState({this.loading = false, this.success = false, this.error});
  CategoryManageState copyWith({bool? loading, bool? success, String? error}) =>
      CategoryManageState(
          loading: loading ?? this.loading,
          success: success ?? this.success,
          error: error);
}

class CategoryManageCubit extends Cubit<CategoryManageState> {
  final ProductLocalDatasource _local;
  CategoryManageCubit({ProductLocalDatasource? local})
      : _local = local ?? ProductLocalDatasource.instance,
        super(CategoryManageState());

  Future<void> addLocal(String name) async {
    emit(state.copyWith(loading: true, success: false, error: null));
    try {
      await _local.saveCategoryWithSyncFlag(name);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, success: false, error: e.toString()));
    }
  }

  Future<void> renameLocal(int localId, String newName) async {
    emit(state.copyWith(loading: true, success: false, error: null));
    try {
      await _local.updateCategoryNameLocal(localId: localId, newName: newName);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, success: false, error: e.toString()));
    }
  }

  Future<void> softDeleteLocal(int localId) async {
    emit(state.copyWith(loading: true, success: false, error: null));
    try {
      await _local.softDeleteCategoryLocal(localId);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, success: false, error: e.toString()));
    }
  }
}
