import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:comparify_cross/pages/helpers/constants.dart';
import 'package:comparify_cross/models/products_dto_v3.dart';
import 'package:http/http.dart' as http;

class ApiService {
  List<ProductsDTOV3> parseProducts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ProductsDTOV3>((json) => ProductsDTOV3.fromJson(json))
        .toList();
  }

  Future<List<ProductsDTOV3>> searchByCategory(int category) async {
    try {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.findByCategoryPageEndpoint}/$category");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return parseProducts(response.body);
      }
    } catch (e) {
      log("exception");
      log(e.toString());
    }
    return List.empty();
  }

  Future<List<ProductsDTOV3>> searchByCode(String code) async {
    try {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.findByCodePageEndpoint}/$code");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        log(response.body);
        return parseProducts(response.body);
      }
    } catch (e) {
      log("exception");
      log(e.toString());
    }
    return List.empty();
  }

  Future<List<ProductsDTOV3>> searchByName(String name) async {
    try {
      var url = Uri.parse(
          "${ApiConstants.baseUrl}${ApiConstants.findByNamePageEndpoint}/$name");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        log(response.body);
        return parseProducts(response.body);
      }
    } catch (e) {
      log("exception");
      log(e.toString());
    }
    return List.empty();
  }
}
