import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import '../models/response/customer_response_model.dart';

class CustomerRemoteDatasource {
  Future<List<CustomerResponseModel>> getCustomers() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/customers'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );
    if (response.statusCode == 200) {
      log('Success to get all customer response: ${response.body}');
      final data = json.decode(response.body);
      if (data is List) {
        return CustomerResponseModel.fromList(data);
      } else if (data['data'] is List) {
        return CustomerResponseModel.fromList(data['data']);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      log('failed to get all customer response: ${response.body}');
      throw Exception('Failed to load customers');
    }
  }
}
