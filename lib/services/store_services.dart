import 'dart:convert';
import 'dart:developer';

import 'package:flutter_pagination/models/store_model.dart';
import 'package:http/http.dart' as http;

class StoreServices {
  Future<List<StoreModel>> getStoresServices({required int limit}) async {
    List<StoreModel> storeLists = [];
    try {
      final http.Response response = await http
          .get(Uri.parse("https://fakestoreapi.com/products?limit=$limit"));

      if (response.statusCode == 200) {
        log("Fake store api is success");
        List responseBody = jsonDecode(response.body);
        storeLists = responseBody.map((e) => StoreModel.fromJson(e)).toList();
        log(storeLists.first.toJson().toString());
      } else {
        // storeLists = [];
        log("no data found");
        log(response.statusCode.toString());
      }
    } catch (e) {
      rethrow;
    }
    return storeLists;
  }
}
