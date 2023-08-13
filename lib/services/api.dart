import 'dart:convert';

import 'package:http/http.dart' as http;

import '../services/storage.dart';
import '../shared/constants/constants.dart';

class ApiService {
  static Future<dynamic> send(
    String serviceName,
    Map<String, dynamic> options,
  ) async {
    var service = endPoints[serviceName];
    var payload = {...options};

    if (service == null) throw Exception('end point not exists');
    final endPoint = {...service};
    var url = endPoint['url'] ?? '';
    final type = endPoint['type'] ?? '';

    var afterReplace = '';
    dynamic v;
    for (final key in options.keys) {
      v = payload[key];
      afterReplace = url.replaceFirst(RegExp('{$key}'), v.toString());
      if (url != afterReplace) {
        payload.remove(key);
        url = afterReplace;
      }
    }

    String getUrl = '$baseUrl/$url';
    if (type == 'GET' && payload.isNotEmpty) {
      getUrl = '$getUrl?';
      payload.forEach((key, value) => getUrl = '$getUrl$key=$value&');
    }

    final finalUrl = Uri.parse(getUrl);
    final lang =
        (await StorageService.getStringValue(LAGUAGE_CODE, ARABIC)) ?? ARABIC;

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'x-api-key': 'rtM70zfMQe7niYTOptz0w5zAuIgwmNjbaJf9rfJh',
      'Accept-Language': lang,
      'accept': 'application/json; charset=utf-8'
    };

    final token = await StorageService.getStringValue(TOKEN, '');
    if (token != '') {
      headers['Authorization'] = 'Bearer $token';
    }

    final httpRequest = type == 'GET'
        ? http.get(finalUrl, headers: headers)
        : http.post(finalUrl, body: json.encode(payload), headers: headers);

    try {
      final response = await httpRequest;
      final data = utf8.decode(response.bodyBytes);
      // TODO remove print in production
      print('$serviceName ==> $data');
      return json.decode(data);
    } catch (e) {
      print('error[$serviceName] ==> $e');
      throw Exception('Http Request Failed ==> ${e.toString()}');
    }
  }
}
