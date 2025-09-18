import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_ap/bindings/initial_binding.dart';
import 'package:todo_ap/routes/app_pages.dart';
import 'package:todo_ap/services/api_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); // Initialize local storage

  final api = ApiService();
  String initialRoute = api.getToken() != null ? Routes.todos : Routes.login;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo App',
      initialBinding: AuthBinding(), // global bindings
      initialRoute: initialRoute, // ✅ use the token-based route here
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
