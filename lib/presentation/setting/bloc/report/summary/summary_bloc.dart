import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_pos/data/datasources/order_local_datasource.dart';
import '../../../../../data/models/response/summary_response_model.dart';

part 'summary_bloc.freezed.dart';
part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  SummaryBloc() : super(const _Initial()) {
    on<_GetSummary>((event, emit) async {
      emit(const _Loading());
      try {
        final orders = await OrderLocalDatasource.instance.getAllOfflineOrdersWithProductJoin();
        int totalRevenue = 0;
        int totalSoldQuantity = 0;
        for (final order in orders) {
          final orderMap = order['order'] as Map<String, dynamic>;
          totalRevenue += (orderMap['total_price'] as int?) ?? 0;
          final items = (order['items'] as List).cast<Map<String, dynamic>>();
          for (final item in items) {
            totalSoldQuantity += (item['quantity'] as int?) ?? 0;
          }
        }
        final summary = Summary(
          totalRevenue: totalRevenue,
          totalSoldQuantity: totalSoldQuantity,
        );
        emit(_Success(SummaryResponseModel(status: 'success', data: summary)));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
