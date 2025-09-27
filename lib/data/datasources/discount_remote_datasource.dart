import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/models/response/discount_response_model.dart';

class DiscountRemoteDatasource {
  Future<List<DiscountResponseModel>> getDiscounts() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/discounts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authData.token}',
        },
      );

      if (response.statusCode == 200) {
        log('Success to get all discount response: ${response.body}');
        final dynamic decodedBody = json.decode(response.body);
        
        // The API returns a single response with all discounts in the 'data' array
        if (decodedBody is Map<String, dynamic> && decodedBody['data'] is List) {
          // Create a single DiscountResponseModel with all discounts in the data field
          return [
            DiscountResponseModel(
              message: decodedBody['message'] ?? '',
              data: (decodedBody['data'] as List)
                  .whereType<Map<String, dynamic>>()
                  .map((item) => DiscountModel.fromMap(item))
                  .toList(),
              syncTime: DateTime.now().toUtc(),
              total: (decodedBody['total'] is int) 
                  ? decodedBody['total'] 
                  : int.tryParse(decodedBody['total']?.toString() ?? '0') ?? 0,
            )
          ];
        }
        
        throw Exception('Unexpected response format: ${response.body}');
      } else {
        log('Failed to get all discount response: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load discounts: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in getDiscounts: $e');
      rethrow;
    }
  }

  Future<List<DiscountResponseModel>> getTodayDiscounts() async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/discounts/filter/today'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authData.token}',
        },
      );

      if (response.statusCode == 200) {
        log('Success to get today discount response: ${response.body}');
        final dynamic decodedBody = json.decode(response.body);
        
        // The API returns a single response with all discounts in the 'data' array
        if (decodedBody is Map<String, dynamic> && decodedBody['data'] is List) {
          // Create a single DiscountResponseModel with all discounts in the data field
          return [
            DiscountResponseModel(
              message: decodedBody['message'] ?? '',
              data: (decodedBody['data'] as List)
                  .whereType<Map<String, dynamic>>()
                  .map((item) => DiscountModel.fromMap(item))
                  .toList(),
              syncTime: DateTime.now().toUtc(),
              total: (decodedBody['total'] is int) 
                  ? decodedBody['total'] 
                  : int.tryParse(decodedBody['total']?.toString() ?? '0') ?? 0,
            )
          ];
        }
        
        log('Unexpected response format: $decodedBody');
        return [];
      } else {
        log('Failed to get today\'s discounts: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load today\'s discounts: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in getTodayDiscounts: $e');
      rethrow;
    }
  }

  Future<DiscountResponseModel> getDiscountById(int id) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/discounts/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authData.token}',
        },
      );

      if (response.statusCode == 200) {
        log('Success to get discount by id response: ${response.body}');
        final dynamic jsonData = json.decode(response.body);
        
        // Handle different response formats
        if (jsonData is Map<String, dynamic>) {
          // If response has a 'data' field, use that
          if (jsonData['data'] != null) {
            return DiscountResponseModel.fromMap(
              jsonData['data'] is Map<String, dynamic> 
                ? jsonData['data'] 
                : {'data': jsonData['data']}
            );
          }
          // If no 'data' field, assume the entire response is the discount
          return DiscountResponseModel.fromMap(jsonData);
        } else {
          log('Unexpected response format: $jsonData');
          throw Exception('Invalid discount data format');
        }
      } else {
        log('Failed to get discount by id: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load discount: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in getDiscountById: $e');
      rethrow;
    }
  }

  Future<int?> createDiscount(Map<String, dynamic> discountData) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/discounts'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authData.token}',
          'Content-Type': 'application/json',
        },
        body: json.encode(discountData),
      );

      if (response.statusCode == 201) {
        log('Success to create discount: ${response.body}');
        try {
          final decoded = json.decode(response.body) as Map<String, dynamic>;
          final data = decoded['data'] as Map<String, dynamic>;
          return (data['id'] as num?)?.toInt();
        } catch (e) {
          log('Failed to parse discount create response: $e');
          return null;
        }
      } else {
        log('Failed to create discount: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      log('Error in createDiscount: $e');
      rethrow;
    }
  }

  Future<bool> deleteDiscount(int id) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.delete(
        Uri.parse('${Variables.baseUrl}/api/discounts/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${authData.token}',
        },
      );

      if (response.statusCode == 200) {
        log('Success to delete discount: ${response.body}');
        return true;
      } else {
        log('Failed to delete discount: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      log('Error in deleteDiscount: $e');
      rethrow;
    }
  }
}
