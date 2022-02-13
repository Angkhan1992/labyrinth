import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:labyrinth/utils/constants.dart';

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

  Future<Map<String, dynamic>?> uploadFile({
    required String filePath,
    required String header,
    String type = 'image',
  }) async {
    String url = kSetting + 'upload_media';
    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.fields['header'] = header;
    request.fields['type'] = type;
    if (kDebugMode) {
      print('[REQUEST] ===> ${request.fields}');
    }

    var pic = await http.MultipartFile.fromPath("data", filePath);
    request.files.add(pic);

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    if (kDebugMode) {
      print('[Upload File] ===> $responseString');
    }
    try {
      var jsonData = json.decode(responseString);
      return jsonData;
    } catch (e) {
      if (kDebugMode) {
        print('[Upload File] ===> ${e.toString()}');
      }
      return null;
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
