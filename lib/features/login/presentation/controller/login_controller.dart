import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/login_repo.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final LoginRepository _repository;

  LoginController({required LoginRepository repository})
      : _repository = repository;

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Username and password cannot be empty');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _repository.login(username, password);

      if (response['message'] == 'Login successful') {
        Get.snackbar(
            'Success', 'Welcome, ${response['userDetails']['fullName']}',
            backgroundColor: AppConfig().colors.snackbarColor);
        Get.offNamed(AppConfig().routes.assessment);
      } else {
        Get.snackbar('Login Failed', response['message'] ?? 'Unknown error',
            backgroundColor: AppConfig().colors.snackbarColor);
      }
    } catch (e) {
      Get.snackbar(
          'Error',
          e.toString().replaceAll(
                'Exception: ',
                '',
              ),
          backgroundColor: AppConfig().colors.snackbarColor);
    } finally {
      isLoading.value = false;
    }
  }
}
