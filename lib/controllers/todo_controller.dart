import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:todo_ap/models/todo_model.dart';
import 'package:todo_ap/services/api_services.dart';

class TodoController extends GetxController {
  final ApiService _api = ApiService();

  var todos = <TodoModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodos();
  }

  Map<String, dynamic> _safeDecode(String? body) {
    if (body == null || body.trim().isEmpty) return {};
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'data': decoded};
    } catch (e) {
      log('Failed to decode JSON: $e');
      return {};
    }
  }

  Future<void> fetchTodos() async {
    try {
      isLoading(true);
      final res = await _api.get('/todo');
      log('Todos response: ${res.body}'); // This should show the updated data

      if (res.statusCode == 200) {
        final body = _safeDecode(res.body);

        // Extract todos from the 'data' array in the response
        if (body.containsKey('data') && body['data'] is List) {
          final list = body['data'] as List;
          todos.value = list.map((e) => TodoModel.fromJson(e)).toList();
          log('Fetched ${todos.length} todos');

          // Log the first todo to verify it has the updated data
          if (todos.isNotEmpty) {
            log('First todo: ${todos.first.name} - ${todos.first.value}');
          }
        } else {
          Get.snackbar('Error', 'Invalid response format from server');
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch todos - Status: ${res.statusCode}',
        );
      }
    } catch (e) {
      log('Fetch todos error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> createTodo(String name, String value) async {
    try {
      // Ensure we have an auth token before sending a protected request
      final token = _api.getToken();
      if (token == null || token.trim().isEmpty) {
        log('createTodo aborted: no auth token present');
        Get.snackbar('Authentication required', 'Please login to create todos');
        Get.offAllNamed('/login');
        return;
      }

      isLoading(true);
      log('Creating todo: name=$name, value=$value');

      final res = await _api.post('/todo', {'name': name, 'value': value});
      log('CreateTodo status: ${res.statusCode}; body: ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 201) {
        final body = _safeDecode(res.body);
        final newId = body['id'];

        if (newId != null) {
          // Add the new todo to the local list immediately
          final newTodo = TodoModel(
            id: newId is int ? newId : int.tryParse(newId.toString()) ?? 0,
            name: name, // Use the name we sent
            value: value, // Use the value we sent
            status: 'open', // Default status
            user: 'current_user', // You might need to get this from auth
            createdAt: DateTime.now().toString(),
            updatedAt: DateTime.now().toString(),
          );
          todos.insert(0, newTodo);
        } else {
          // Fallback: refresh from server if we can't parse the ID
          await fetchTodos();
        }

        Get.snackbar('Success', 'Todo created successfully');
        Get.back();
      } else {
        // Try to surface server error message or validation errors
        final errorBody = _safeDecode(res.body);
        String message = 'Failed to create todo (status ${res.statusCode})';
        if (errorBody.isNotEmpty) {
          if (errorBody.containsKey('message')) {
            message = errorBody['message'].toString();
          } else if (errorBody.containsKey('errors')) {
            final errs = errorBody['errors'];
            if (errs is List) {
              message = errs.join(', ');
            } else if (errs is Map) {
              // flatten map of field->messages
              final parts = <String>[];
              errs.forEach((k, v) {
                if (v is List) {
                  parts.addAll(v.map((e) => e.toString()));
                } else {
                  parts.add(v.toString());
                }
              });
              message = parts.join(', ');
            }
          }
        }
        log('CreateTodo error: $message');
        Get.snackbar('Error', message);
      }
    } catch (e) {
      log('Create todo error: $e');
      Get.snackbar('Error', 'Failed to create todo: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<bool> updateTodo(
    int id, {
    String? name,
    String? value,
    String? status,
  }) async {
    try {
      isLoading(true);
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (value != null) body['value'] = value;
      if (status != null) body['status'] = status;

      final res = await _api.put('/todo/$id', body);

      if (res.statusCode == 200) {
        // Update the local list directly
        final index = todos.indexWhere((t) => t.id == id);
        if (index != -1) {
          todos[index] = TodoModel(
            id: id,
            name: name ?? todos[index].name,
            value: value ?? todos[index].value,
            status: status ?? todos[index].status,
            user: todos[index].user,
            createdAt: todos[index].createdAt,
            updatedAt: DateTime.now().toString(),
          );
          todos.refresh(); // Notify UI about the change
        }

        Get.snackbar('Success', 'Todo updated successfully');
        return true;
      } else {
        final errorBody = _safeDecode(res.body);
        final errorMessage = errorBody['message'] ?? 'Failed to update todo';
        Get.snackbar('Error', errorMessage.toString());
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update todo: ${e.toString()}');
      return false;
    } finally {
      isLoading(false);
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      isLoading(true);
      log('Deleting todo $id');
      final res = await _api.delete('/todo/$id');
      log('Delete response: ${res.statusCode} - ${res.body}');

      if (res.statusCode == 200 || res.statusCode == 204) {
        // Remove from local list and refresh
        todos.removeWhere((t) => t.id == id);
        Get.snackbar('Success', 'Todo deleted successfully');
      } else {
        final errorBody = _safeDecode(res.body);
        final errorMessage = errorBody['message'] ?? 'Failed to delete todo';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      log('Delete todo error: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
