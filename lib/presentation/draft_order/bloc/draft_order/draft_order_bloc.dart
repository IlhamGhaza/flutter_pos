import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos/data/datasources/product_local_datasource.dart';

import '../../../order/bloc/qris/models/draft_order_model.dart';

part 'draft_order_bloc.freezed.dart';
part 'draft_order_event.dart';
part 'draft_order_state.dart';

class DraftOrderBloc extends Bloc<DraftOrderEvent, DraftOrderState> {
  final ProductLocalDatasource productLocalDatasource;
  DraftOrderBloc(
    this.productLocalDatasource,
  ) : super(const _Initial()) {
    on<_GetAllDraftOrder>((event, emit) async {
      emit(const _Loading());
      final result = await productLocalDatasource.getAllDraftOrder();
      emit(DraftOrderState.success(result));
    });
  }
}
