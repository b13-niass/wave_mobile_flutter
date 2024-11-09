import 'package:wave_mobile_flutter/config/global.params.dart';
import 'authenticated_http_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClientFetch {
  static final _clientHttp = AuthenticatedHttpClient(http.Client());

  static Future<Map<String, dynamic>> accueilClient() async {
    final response = await _clientHttp
        .get(Uri.parse('${GlobalParam.apiUrl}/client/accueil'), headers: {
      'Content-Type': 'application/json',
    });
    return json.decode(response.body);
  }
}
