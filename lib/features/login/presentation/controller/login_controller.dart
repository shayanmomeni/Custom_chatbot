import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/login_repo.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final LoginRepository _repository;

  String? userId; // Store userId
  String? username; // Store username
  String? fullName; // Store fullName

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
      final userDetails = await _repository.login(username, password);

      // Save user details
      userId = userDetails['userId'];
      this.username = userDetails['username'];
      fullName = userDetails['fullName'];

      Get.snackbar('Success', 'Welcome, $fullName');
      Get.offNamed(AppConfig().routes.assessment);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}
