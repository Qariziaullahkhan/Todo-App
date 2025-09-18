import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_ap/controllers/todo_controller.dart';
import 'package:todo_ap/widgets/custom_button.dart';
import 'package:todo_ap/widgets/custom_textfield.dart';

class CreateTodoScreen extends StatelessWidget {
  const CreateTodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todoC = Get.find<TodoController>();
    final nameC = TextEditingController();
    final valueC = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Todo')),
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
                  text: todoC.isLoading.value ? 'Creating...' : 'Create Todo',
                  onPressed: todoC.isLoading.value
                      ? null
                      : () {
                          todoC.createTodo(nameC.text.trim(), valueC.text.trim());
                        },
                )),
          ],
        ),
      ),
    );
  }
}
