import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import '../models/response/service_charge_response_model.dart';

class ServiceChargeRemoteDatasource {
  Future<List<ServiceChargeResponseModel>> getServiceCharges() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/service-charges'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${authData.token}',
      },
    );
    if (response.statusCode == 200) {
      log('Success to get all service charge response: ${response.body}');
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'] ?? jsonData;
      return ServiceChargeResponseModel.fromList(data);
    } else {
      log('failed to get all service charge response: ${response.body}');
      throw Exception('Failed to load service charges');
    }
  }
}
