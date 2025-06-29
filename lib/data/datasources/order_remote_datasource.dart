import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/models/request/order_request_model.dart';

class OrderRemoteDatasource {
  Future<Map<String, dynamic>> createOrder(OrderRequestModel order) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/orders'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
      body: json.encode(order.toMap()),
    );

    if (response.statusCode == 201) {
      log('Success to create order response: ${response.body}');
      return json.decode(response.body);
    } else {
      log('failed to create order response: ${response.body}');
      throw Exception('Failed to create order: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/orders'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );

    if (response.statusCode == 200) {
      log('Success to get all order response: ${response.body}');
      final jsonData = json.decode(response.body);
      return List<Map<String, dynamic>>.from(jsonData['data']);
    } else {
      log('failed to get all order response: ${response.body}');
      throw Exception('Failed to load orders');
    }
  }

  Future<Map<String, dynamic>> getOrderById(int id) async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/orders/$id'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );

    if (response.statusCode == 200) {
      log('Success to get order by id response: ${response.body}');
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      log('failed to get order by id response: ${response.body}');
      throw Exception('Failed to load order');
    }
  }
}
