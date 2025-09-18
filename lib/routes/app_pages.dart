import 'package:get/get.dart';
import 'package:todo_ap/bindings/initial_binding.dart';
import 'package:todo_ap/bindings/todo_binding.dart';
import 'package:todo_ap/views/auth/login_screen.dart';
import 'package:todo_ap/views/auth/register_screen.dart';
import 'package:todo_ap/views/todos/todo_list_screen.dart';
part 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.login, page: () =>  LoginScreen(), binding: AuthBinding()),
    GetPage(name: Routes.login, page: () => RegisterScreen(), binding: AuthBinding()),
    GetPage(name: Routes.todos, page: () =>  TodoListScreen(), binding: TodoBinding()),
  ];
}
