import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import '../models/response/customer_response_model.dart';
import '../models/request/customer_request_model.dart';

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

  // Create customer (POST)
  Future<CustomerResponseModel> createCustomer(
      CustomerRequestModel customer) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final requestBody = json.encode(customer.toJson());
    final url = '${Variables.baseUrl}/api/customers';

    log('CustomerRemoteDatasource: Making POST request to $url');
    log('CustomerRemoteDatasource: Request body: $requestBody');
    log('CustomerRemoteDatasource: Auth token: ${authData.token}');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );
    log('CustomerRemoteDatasource: Response status code: ${response.statusCode}');
    log('CustomerRemoteDatasource: Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      log('CustomerRemoteDatasource: create customer success: \n${response.body}');
      final data = json.decode(response.body);
      if (data is Map<String, dynamic>) {
        return CustomerResponseModel.fromMap(data['data'] ?? data);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      log('CustomerRemoteDatasource: Failed to create customer: \n${response.body}');
      throw Exception(
          'Failed to create customer: ${response.statusCode} - ${response.body}');
    }
  }
}
