import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NetworkProvider {
  NetworkProvider();

  factory NetworkProvider.of() {
    return NetworkProvider();
  }

  Future<Map<String, dynamic>?> post(
    String link,
    Map<String, String>? param,
  ) async {
    var url = Uri.parse(link);
    final response = await http.post(
      url,
      body: param,
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      try {
        var json = jsonDecode(response.body);
        if (json['ret'] == 9999) {
          _httpLog(url, param, "Your token was expired");
          return null;
        }
        _httpLog(url, param, json.toString());
        return json;
      } catch (e) {
        _httpLog(url, param, "Json Error");
        if (kDebugMode) {
          print('[Network] error : ${e.toString()}');
        }
        return null;
      }
    } else {
      _httpLog(url, param, response.statusCode);
      return {
        'msg': 'Network Error! - Status Code ${response.statusCode}',
        'ret': 9998,
        'result': response.statusCode,
      };
    }
  }

  void _httpLog(Uri url, dynamic parameter, dynamic response) {
    if (kDebugMode) {
      print("""
|------------------------------------------------------------------------------------------------------------------------------------ 
|   link : ${url.toString()}
|  param : ${parameter.toString()}
|   resp : ${response.toString()}
|------------------------------------------------------------------------------------------------------------------------------------
    """);
    }
  }
}
