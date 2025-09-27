import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_pos/core/constants/variables.dart';
import 'package:flutter_pos/data/models/request/product_request_model.dart';
import 'package:flutter_pos/data/models/response/add_product_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pos/data/models/response/product_response_model.dart';

import '../models/response/category_response_model.dart';
import 'auth_local_datasource.dart';

class ProductRemoteDatasource {
  Future<Either<String, ProductResponseModel>> getProducts() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/products'),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
      },
    );

    if (response.statusCode == 200) {
      log('Success to get all product response: ${response.body}');
      return right(ProductResponseModel.fromJson(response.body));
    } else {
      log('failed to get all product response: ${response.body}');
      return left(response.body);
    }
  }

  Future<Either<String, AddProductResponseModel>> addProduct(
      ProductRequestModel productRequestModel) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final Map<String, String> headers = {
        'Authorization': 'Bearer ${authData.token}',
      };
      
      var request = http.MultipartRequest(
          'POST', Uri.parse('${Variables.baseUrl}/api/products'));
          
      // Convert all values to String and add to fields
      final fields = productRequestModel.toMap();
      fields.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
      
      // Add image if provided
      if (productRequestModel.image != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'image', productRequestModel.image!.path));
      }
      
      request.headers.addAll(headers);

      final response = await request.send();
      final String body = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        log('Success to add product response: $body');
        return right(AddProductResponseModel.fromJson(body));
      } else {
        log('failed to add product response: $body');
        return left(body);
      }
    } catch (e) {
      log('Failed to add product: $e');
      return left(e.toString());
    }
  }

  //get categories
  Future<Either<String, CategoryResponseModel>> getCategories() async {
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(
      Uri.parse('${Variables.baseUrl}/api/categories'),
      headers: {
        'Authorization': 'Bearer ${authData.token}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      log('Success to get all category response: ${response.body}');
      return right(CategoryResponseModel.fromJson(response.body));
    } else {
      log('failed to get all category response: ${response.body}');
      return left(response.body);
    }
  }

  // add category
  Future<Either<String, int>> addCategory(String name) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.post(
        Uri.parse('${Variables.baseUrl}/api/categories'),
        headers: {
          'Authorization': 'Bearer ${authData.token}',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: '{"name":"$name"}',
      );
      if (response.statusCode == 201) {
        log('Success to add category response: ${response.body}');
        try {
          final jsonBody = json.decode(response.body) as Map<String, dynamic>;
          final data = jsonBody['data'] as Map<String, dynamic>;
          final id = (data['id'] as num).toInt();
          return right(id);
        } catch (e) {
          return left('Invalid response format: ${response.body}');
        }
      } else {
        log('Failed to add category response: ${response.statusCode} - ${response.body}');
        return left(response.body);
      }
    } catch (e) {
      log('Exception when adding category: $e');
      return left(e.toString());
    }
  }

  // delete category
  Future<Either<String, bool>> deleteCategory(int id) async {
    try {
      final authData = await AuthLocalDatasource().getAuthData();
      final response = await http.delete(
        Uri.parse('${Variables.baseUrl}/api/categories/$id'),
        headers: {
          'Authorization': 'Bearer ${authData.token}',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        log('Success to delete category response: ${response.body}');
        return right(true);
      } else {
        log('Failed to delete category response: ${response.statusCode} - ${response.body}');
        return left(response.body);
      }
    } catch (e) {
      log('Exception when deleting category: $e');
      return left(e.toString());
    }
  }
}
