import 'dart:ffi';

import 'package:wave_mobile_flutter/config/global.params.dart';
import 'package:wave_mobile_flutter/dto/transaction_request.dart';
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

  static Future<Map<String, dynamic>> transfertsClient(
      List<TransactionRequest> transferts) async {
    final List<Map<String, dynamic>> transfertsJson =
        transferts.map((transfert) => transfert.toJson()).toList();

    final response = await _clientHttp.post(
        Uri.parse('${GlobalParam.apiUrl}/client/transferts'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'transferts': transfertsJson,
        }));
    return json.decode(response.body);
  }

    static Future<Map<String, dynamic>> annulerTransfertClient(
      int idTransaction) async {

    final response = await _clientHttp.post(
        Uri.parse('${GlobalParam.apiUrl}/client/transfert/annuler'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'idTransaction': idTransaction,
        }));
    return json.decode(response.body);
  }
  
}
