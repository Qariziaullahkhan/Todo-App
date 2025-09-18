import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_ap/constants/app_colors.dart';
import 'package:todo_ap/constants/resposnive.dart';
import 'package:todo_ap/controllers/auth_controller.dart';
import 'package:todo_ap/views/auth/register_screen.dart';
import 'package:todo_ap/widgets/custom_button.dart';
import 'package:todo_ap/widgets/custom_socialbutton.dart';
import 'package:todo_ap/widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final emailC = TextEditingController();
    final passC = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 44.h, left: 24.w, right: 24.w),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                "Welcome Back",
                style: TextStyle(
                  fontSize: 24.fS,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Lato",
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Login to continue",
                style: TextStyle(
                  fontSize: 16.fS,
                  fontFamily: "Lato",
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 30.h),

              /// Email Field
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

              /// Password Field
              Obx(
                () => CustomTextField(
                  controller: passC,
                  hintText: "Password",
                  obscureText:
                      authC.isPasswordHidden.value, // bind to GetX state
                  suffixIcon: IconButton(
                    icon: Icon(
                      authC.isPasswordHidden.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed:
                        authC.togglePasswordVisibility, // toggle visibility
                  ),
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(height: 8.h),

              /// Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => RegisterScreen()));
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: "Lato",
                      fontSize: 14.fS,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              /// Login Button
              Obx(
                () => CustomButton(
                  text: "Sign In",
                  onPressed: authC.isLoading.value
                      ? null
                      : () {
                          if (formKey.currentState!.validate()) {
                            authC.login(emailC.text.trim(), passC.text.trim());
                          }
                        },
                  child: authC.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ),
              SizedBox(height: 20.h),

              /// OR Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.grey[300]),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 14.fS,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1, color: Colors.grey[300]),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              /// Social Login Buttons
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

              /// Don't have an account
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: "Lato",
                        fontSize: 16.fS,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => RegisterScreen());
                      },
                      child: Text(
                        "Sign Up",
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
