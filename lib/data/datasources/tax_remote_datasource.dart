import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import '../models/response/tax_response_model.dart';

class TaxRemoteDatasource {
  Future<List<TaxResponseModel>> getTaxes() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/taxes'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );
    if (response.statusCode == 200) {
      log('Success to get all tax response: ${response.body}', name: 'TaxRemoteDatasource');
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'] ?? jsonData;
      return TaxResponseModel.fromList(data);
    } else {
      log('failed to get all tax response: ${response.body}', name: 'TaxRemoteDatasource');
      throw Exception('Failed to load taxes');
    }
  }
}
