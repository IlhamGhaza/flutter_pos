import 'dart:developer';
import 'dart:convert';

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
      log('Success to get all product response: ${response.body}',
          name: 'ProductRemoteDatasource');
      return right(ProductResponseModel.fromJson(response.body));
    } else {
      log('failed to get all product response: ${response.body}',
          name: 'ProductRemoteDatasource');
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
        log('Success to add product response: $body',
            name: 'ProductRemoteDatasource');
        return right(AddProductResponseModel.fromJson(body));
      } else {
        log('failed to add product response: $body',
            name: 'ProductRemoteDatasource');
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
      log('Success to get all category response: ${response.body}',
          name: 'ProductRemoteDatasource');
      return right(CategoryResponseModel.fromJson(response.body));
    } else {
      log('failed to get all category response: ${response.body}',
          name: 'ProductRemoteDatasource');
      return left(response.body);
    }
  }

  // create category
  Future<Either<String, Category>> createCategory(String name) async {
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
        log('Success to create category response: ${response.body}',
            name: 'ProductRemoteDatasource');
        final parsed = CategoryResponseModel.fromJson(response.body);
        if (parsed.data != null && parsed.data!.isNotEmpty) {
          return right(parsed.data!.first);
        }
        // Some APIs return single object; try parse map directly
        final single = CategoryResponseModel.fromMap({
          'data': [Category.fromMap(jsonDecode(response.body)['data'])]
        });
        return right(single.data!.first);
      } else {
        log('failed to create category response: ${response.body}',
            name: 'ProductRemoteDatasource');
        return left(response.body);
      }
    } catch (e) {
      log('Failed to create category: $e', name: 'ProductRemoteDatasource');
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
        log('Success to delete category response: ${response.body}',
            name: 'ProductRemoteDatasource');
        return right(true);
      } else {
        log('failed to delete category response: ${response.body}',
            name: 'ProductRemoteDatasource');
        return left(response.body);
      }
    } catch (e) {
      log('Failed to delete category: $e',
          name: 'ProductRemoteDatasource',
          error: e,
          stackTrace: StackTrace.current);
      return left(e.toString());
    }
  }
}
