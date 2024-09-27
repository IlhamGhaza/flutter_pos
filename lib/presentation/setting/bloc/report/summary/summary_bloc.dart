import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos/data/datasources/report_remote_datasource.dart';

import '../../../../../data/models/response/summary_response_model.dart';

part 'summary_bloc.freezed.dart';
part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  final ReportRemoteDatasource reportRemoteDatasource;
  SummaryBloc(
    this.reportRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetSummary>((event, emit) async {
      emit(const _Loading());
      final result = await reportRemoteDatasource.getSummary(
          event.startDate, event.endDate);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
