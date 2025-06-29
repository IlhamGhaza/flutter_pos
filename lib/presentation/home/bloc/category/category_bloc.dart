import 'package:bloc/bloc.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos/data/datasources/product_remote_datasource.dart';

import '../../../../data/models/response/category_response_model.dart';

part 'category_bloc.freezed.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ProductRemoteDatasource productRemoteDatasource;
  List<Category> categories = [];
  CategoryBloc(
    this.productRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetCategories>((event, emit) async {
      emit(const _Loading());
      try {
        // First try to get categories from local database
        final localCategories = await ProductLocalDatasource.instance.getAllCategories();
        if (localCategories.isNotEmpty) {
          categories = localCategories;
          if (!emit.isDone) emit(_LoadedLocal(categories));
          
          // Then try to update from remote in the background
          _fetchFromRemote(emit);
        } else {
          // If no local categories, fetch from remote
          await _fetchFromRemote(emit);
        }
      } catch (e) {
        // If any error occurs with local DB, try to fetch from remote
        await _fetchFromRemote(emit);
      }
    });

    on<_GetCategoriesLocal>((event, emit) async {
      emit(const _Loading());
      try {
        final localCategories = await ProductLocalDatasource.instance.getAllCategories();
        if (localCategories.isNotEmpty) {
          categories = localCategories;
          if (!emit.isDone) emit(_LoadedLocal(categories));
        } else {
          // If no local categories, emit empty list instead of fetching from remote
          categories = [];
          if (!emit.isDone) emit(const _LoadedLocal([]));
        }
      } catch (e) {
        // On error, emit empty list
        if (!emit.isDone) emit(const _LoadedLocal([]));
      }
    });
  }

  // Helper method to fetch categories from remote and update local DB
  Future<void> _fetchFromRemote(Emitter<CategoryState> emit) async {
    try {
      final result = await productRemoteDatasource.getCategories();
      await result.fold(
        (error) async {
          // Only emit error if we don't have any local data
          if (categories.isEmpty && !emit.isDone) {
            emit(_Error(error));
          }
        },
        (response) async {
          if (response.data != null && response.data!.isNotEmpty) {
            // Save to local database
            await ProductLocalDatasource.instance.insertAllCategories(response.data!);
            categories = response.data!;
            if (!emit.isDone) emit(_Loaded(categories));
          }
        },
      );
    } catch (e) {
      // Only emit error if we don't have any local data
      if (categories.isEmpty && !emit.isDone) {
        emit(_Error(e.toString()));
      }
    }
  }
}
