import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_ap/constants/resposnive.dart';
import 'package:todo_ap/controllers/auth_controller.dart';
import 'package:todo_ap/controllers/todo_controller.dart';
import 'package:todo_ap/views/todos/create_todo_screen.dart';
import 'package:todo_ap/views/todos/todo_edit_screen.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoC = Get.put(TodoController());
    final authC = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authC.logout();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (todoC.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (todoC.todos.isEmpty) {
          return const Center(
            child: Text(
              'No todos found.',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: todoC.todos.length,
          itemBuilder: (_, i) {
            final t = todoC.todos[i];

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${t.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     SizedBox(height: 8.h),
                    Text(
                      'Value: ${t.value}',
                      style: const TextStyle(
                       fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                     SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.to(
                              () => UpdateTodoScreen(
                                todoId: t.id,
                                currentValue: t.value,
                                currentName: t.name,
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Update'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                  'Are you sure you want to delete this todo?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                      todoC.deleteTodo(t.id);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Get.to(() => const CreateTodoScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
