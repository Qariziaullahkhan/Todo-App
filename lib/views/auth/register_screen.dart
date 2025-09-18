import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_ap/constants/app_colors.dart';
import 'package:todo_ap/constants/resposnive.dart';
import 'package:todo_ap/controllers/auth_controller.dart';
import 'package:todo_ap/views/auth/login_screen.dart';
import 'package:todo_ap/widgets/custom_button.dart';
import 'package:todo_ap/widgets/custom_socialbutton.dart';
import 'package:todo_ap/widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmC = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final AuthController authC = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 44.h, left: 24.w, right: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create an account",
                style: TextStyle(
                  fontSize: 24.fS,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lato",
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 30.h),

              CustomTextField(
                controller: nameC,
                hintText: "Name",
                prefixIcon: const Icon(Icons.person),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),

              CustomTextField(
                controller: emailC,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),

              CustomTextField(
                controller: passC,
                hintText: "Password",
                obscureText: true,
                suffixIcon: const Icon(Icons.visibility_off_outlined),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),

              CustomTextField(
                controller: confirmC,
                hintText: "Confirm Password",
                obscureText: true,
                suffixIcon: const Icon(Icons.visibility_off_outlined),
                validator: (value) {
                  if (value != passC.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20.h),

              CustomSocialButton(
                label: "Continue with Google",
                assetIcon: "assets/icons/google.png",
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onPressed: () {},
              ),
              SizedBox(height: 12.h),

              CustomSocialButton(
                label: "Continue with Apple",
                iconData: Icons.apple,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () {},
              ),
              SizedBox(height: 24.h),

              /// ✅ Register Button with API
              Obx(
                () => CustomButton(
                  text: authC.isLoading.value ? "Please wait..." : "Sign Up",
                  onPressed: authC.isLoading.value
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            authC.register(
                              nameC.text.trim(),
                              emailC.text.trim(),
                              passC.text.trim(),
                              confirmC.text.trim(),
                            );
                          }
                        },
                ),
              ),
              SizedBox(height: 20.h),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: "Lato",
                        fontSize: 16.fS,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => LoginScreen());
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: "Lato",
                          fontSize: 16.fS,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
