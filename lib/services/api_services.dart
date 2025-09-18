import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://test.innovabe.com/api/v1';
  final GetStorage _storage = GetStorage();

  // Getter for token
  String? getToken() => _storage.read<String>('token');

  /// Return true when token is expired or invalid.
  bool _isTokenExpired(String? token) {
    if (token == null || token.trim().isEmpty) return true;
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded) as Map<String, dynamic>;
      final exp = map['exp'];
      if (exp is int) {
        final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
        return exp < now;
      }
      return true;
    } catch (e) {
      log('Failed to parse token for expiry: $e');
      return true;
    }
  }

  // Save token
  void saveToken(String token) => _storage.write('token', token);

  // Remove token
  void removeToken() => _storage.remove('token');

  // Headers with optional Authorization
  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};
    final token = getToken();
    if (token != null) {
      if (_isTokenExpired(token)) {
        log('Stored token is expired; removing it.');
        removeToken();
      } else {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // HTTP POST
  Future<http.Response> post(String path, Map body) async {
    final uri = Uri.parse('$baseUrl$path');
    log('POST $uri headers: $_headers body: ${jsonEncode(body)}');
    final res = await http.post(uri, headers: _headers, body: jsonEncode(body));
    if (res.statusCode == 401) {
      log('POST $uri returned 401 Unauthorized; clearing token.');
      removeToken();
    }
    return res;
  }

  // HTTP GET
  Future<http.Response> get(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    log('GET $uri headers: $_headers');
    final res = await http.get(uri, headers: _headers);
    if (res.statusCode == 401) {
      log('GET $uri returned 401 Unauthorized; clearing token.');
      removeToken();
    }
    return res;
  }

  // HTTP PUT
  Future<http.Response> put(String path, Map body) async {
    final uri = Uri.parse('$baseUrl$path');
    log('PUT $uri headers: $_headers body: ${jsonEncode(body)}');
    final res = await http.put(uri, headers: _headers, body: jsonEncode(body));
    if (res.statusCode == 401) {
      log('PUT $uri returned 401 Unauthorized; clearing token.');
      removeToken();
    }
    return res;
  }

  // HTTP DELETE
  Future<http.Response> delete(String path) async {
    final uri = Uri.parse('$baseUrl$path');
    log('DELETE $uri headers: $_headers');
    final res = await http.delete(uri, headers: _headers);
    if (res.statusCode == 401) {
      log('DELETE $uri returned 401 Unauthorized; clearing token.');
      removeToken();
    }
    return res;
  }
}
