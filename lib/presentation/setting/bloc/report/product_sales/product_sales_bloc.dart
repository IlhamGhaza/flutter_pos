import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_pos/data/datasources/report_remote_datasource.dart';

import '../../../../../data/models/response/product_sales_report.dart';

part 'product_sales_bloc.freezed.dart';
part 'product_sales_event.dart';
part 'product_sales_state.dart';

class ProductSalesBloc extends Bloc<ProductSalesEvent, ProductSalesState> {
  final ReportRemoteDatasource reportRemoteDatasource;
  ProductSalesBloc(
    this.reportRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetProductSales>((event, emit) async {
      emit(const _Loading());
      final result = await reportRemoteDatasource.getProductSales(
          event.startDate, event.endDate);
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Success(r)),
      );
    });
  }
}
