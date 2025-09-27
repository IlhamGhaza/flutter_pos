import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/variables.dart';
import '../models/response/product_sales_report.dart';
import '../models/response/summary_response_model.dart';
import 'auth_local_datasource.dart';

class ReportRemoteDatasource {
  Future<Either<String, SummaryResponseModel>> getSummary(
      String startDate, String endDate) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse(
          '${Variables.baseUrl}/api/reports/summary?start_date=$startDate&end_date=$endDate'),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      log('Success to get summary response: ${response.body}', name: 'ReportRemoteDatasource');
      return right(SummaryResponseModel.fromJson(response.body));
    } else {
      log('failed to get summary response: ${response.body}', name: 'ReportRemoteDatasource');
      return left(response.body);
    }
  }

  Future<Either<String, ProductSalesResponseModel>> getProductSales(
      String startDate, String endDate) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse(
          '${Variables.baseUrl}/api/reports/product-sales?start_date=$startDate&end_date=$endDate'),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
      },
    );

    if (response.statusCode == 200) {
      log('Success to get product sales response: ${response.body}', name: 'ReportRemoteDatasource');
      return right(ProductSalesResponseModel.fromJson(response.body));
    } else {
      log('failed to get product sales response: ${response.body}', name: 'ReportRemoteDatasource');
      return left(response.body);
    }
  }

  Future<Either<String, String>> closeCashier() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/reports/close-cashier'),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      log('Success to close cashier response: ${response.body}', name: 'ReportRemoteDatasource');
      return right('Success');
    } else {
      log('failed to close cashier response: ${response.body}', name: 'ReportRemoteDatasource');
      return left(response.body);
    }
  }
}
