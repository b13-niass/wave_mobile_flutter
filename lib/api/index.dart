import 'package:wave_mobile_flutter/config/global.params.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'token_storage.dart';

class ApiFetch {
  static String? _token;

  static Future<Map<String, dynamic>> findClientByTelephone(
      String telephone) async {
    final response = await http.post(
        Uri.parse('${GlobalParam.apiUrl}/auth/find-by-telephone'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'telephone': telephone,
        }));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> verifyCode(String code) async {
    final response =
        await http.post(Uri.parse('${GlobalParam.apiUrl}/auth/verify-code'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'code': code,
            }));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> login(
      String telephone, String password) async {
    final dynamic response =
        await http.post(Uri.parse('${GlobalParam.apiUrl}/auth/login'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({'telephone': telephone, 'password': password}));

    final jsonData = json.decode(response.body);

    if (jsonData["status"] == "OK") {
      _token = jsonData['data']['token'];
      await TokenStorage.saveToken(_token);
    }

    return jsonData;
  }

  static Future<Map<String, dynamic>> registerClient(
      String email, String telephone, String password) async {
    final response = await http.post(
        Uri.parse('${GlobalParam.apiUrl}/auth/inscription/client'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
            {'email': email, 'telephone': telephone, 'password': password}));
    return json.decode(response.body);
  }
  
}
