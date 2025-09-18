import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_ap/controllers/todo_controller.dart';
import 'package:todo_ap/widgets/custom_button.dart';
import 'package:todo_ap/widgets/custom_textfield.dart';

class UpdateTodoScreen extends StatelessWidget {
  final int todoId;
  final String currentName;
  final String currentValue;

  const UpdateTodoScreen({
    super.key,
    required this.todoId,
    required this.currentName,
    required this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    final todoC = Get.find<TodoController>();
    final nameC = TextEditingController(text: currentName);
    final valueC = TextEditingController(text: currentValue);

    return Scaffold(
      appBar: AppBar(title: const Text('Update Todo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              controller: nameC,
              hintText: 'Name',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: valueC,
              hintText: 'Value',
            ),
            const SizedBox(height: 20),
            Obx(() => CustomButton(
                  text: todoC.isLoading.value ? 'Updating...' : 'Update Todo',
                  onPressed: todoC.isLoading.value
                      ? null
                      : () async {
                          await todoC.updateTodo(
                            todoId,
                            name: nameC.text.trim(),
                            value: valueC.text.trim(),
                          );
                          Get.back(); // go back after update
                        },
                )),
          ],
        ),
      ),
    );
  }
}
