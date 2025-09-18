import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:todo_ap/services/api_services.dart';

class AuthController extends GetxController {
  final ApiService _api = ApiService();

  Map<String, dynamic> _safeDecode(String? body) {
    if (body == null || body.trim().isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    } catch (e) {
      log('Failed to decode JSON body: $e');
      return <String, dynamic>{};
    }
  }

  var isLoading = false.obs;

  Future<void> register(String name, String email, String password, String passwordConfirmation) async {
    try {
      isLoading(true);
      final res = await _api.post('/auth/register', {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      log('Register status: ${res.statusCode}; headers: ${res.headers}');
      log('Register response raw body: "${res.body}"');
      // Success responses
      if (res.statusCode == 200 || res.statusCode == 201 || res.statusCode == 204) {
        // 204 No Content: treat as success but no body
        if (res.statusCode == 204 || (res.body.trim().isEmpty)) {
          log('Registration returned no body (status ${res.statusCode}).');
          // If registration succeeded but server doesn't return token, redirect to login
          Get.snackbar('Success', 'Registration succeeded. Please login.');
          Get.offAllNamed('/login');
        } else {
          final body = _safeDecode(res.body);
          final token = body['token'] ?? body['access_token'] ?? body['data']?['token'];
          if (token != null) {
            _api.saveToken(token.toString());
            log("Token saved: $token");
            Get.offAllNamed('/todos');
          } else {
            log("Token not found in response (status ${res.statusCode})");
            // If registered but token is not returned, ask user to login
            Get.snackbar('Success', 'Registration succeeded. Please login.');
            Get.offAllNamed('/login');
          }
        }
      } else {
        final err = _safeDecode(res.body);
        final message = err['message'] ?? err['error'] ?? 'Registration failed (status ${res.statusCode})';
        log('Registration error: $message');
        Get.snackbar('Error', message);
      }
    } catch (e) {
      log("Error: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);
      final res = await _api.post('/auth/login', {
        'email': email,
        'password': password,
      });

      log('Login status: ${res.statusCode}; headers: ${res.headers}');
      log('Login response raw body: "${res.body}"');
      if (res.statusCode == 200) {
        if (res.body.trim().isEmpty) {
          log('Login returned empty body despite 200 status');
          Get.snackbar('Error', 'Login failed: empty response from server');
        } else {
          final body = _safeDecode(res.body);
          final token = body['token'] ?? body['access_token'] ?? body['data']?['token'];
          if (token != null) {
            _api.saveToken(token.toString());
            log("Token saved: $token");
            Get.offAllNamed('/todos');
          } else {
            log("Token not found in response (login)");
            Get.snackbar('Error', 'Token not found in response');
          }
        }
      } else if (res.statusCode == 204) {
        // unlikely for login, but handle defensively
        _api.removeToken();
        Get.snackbar('Success', 'Logged out / no content');
      } else {
        final err = _safeDecode(res.body);
        final message = err['message'] ?? err['error'] ?? 'Login failed (status ${res.statusCode})';
        log('Login error: $message');
        Get.snackbar('Error', message);
      }
    } catch (e) {
      log("Error: $e");
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      isLoading(true);
  await _api.post('/auth/logout', {});
  // even if logout fails, remove token locally
      _api.removeToken();
      Get.offAllNamed('/login');
    } catch (e) {
      _api.removeToken();
      Get.offAllNamed('/login');
    } finally {
      isLoading(false);
    }
  }
  // AuthController
void saveLoginToken(String token) {
  Get.find<ApiService>().saveToken(token);
}

}
