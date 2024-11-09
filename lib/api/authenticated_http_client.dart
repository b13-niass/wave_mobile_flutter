import 'dart:async';
import 'package:http/http.dart' as http;
import 'token_storage.dart';

class AuthenticatedHttpClient extends http.BaseClient {
  final http.Client _inner;
  
  AuthenticatedHttpClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return _inner.send(request);
  }
}
