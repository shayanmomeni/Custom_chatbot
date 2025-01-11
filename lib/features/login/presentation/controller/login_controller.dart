import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decent_chatbot/app_repo.dart'; // Import AppRepo
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
      // Call the repository to log in
      final userDetails = await _repository.login(username, password);

      // Save user details to AppRepo and local cache
      await AppRepo().loginUser({
        'token': userDetails['token'], // Include token in the response
        'userDetails': {
          'userId': userDetails['userId'],
          'username': userDetails['username'],
          'fullName': userDetails['fullName'],
        },
      });

      // Save user details locally for this session
      userId = userDetails['userId'];
      this.username = userDetails['username'];
      fullName = userDetails['fullName'];

      // Show success message
      Get.snackbar('Success', 'Welcome, $fullName');

      // Navigate to the Assessment screen
      Get.offNamed(AppConfig().routes.assessment);
    } catch (e) {
      Get.snackbar('Error', e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
