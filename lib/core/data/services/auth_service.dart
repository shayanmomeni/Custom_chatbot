import 'package:decent_chatbot/core/data/services/services_helper.dart';
import 'package:decent_chatbot/core/utils/enum.dart';
import 'package:flutter/material.dart';

class LoginService extends ServicesHelper {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = '$baseURL/login'; // Backend login endpoint
    final body = {
      'username': username,
      'password': password,
    };

    debugPrint('Login Request URL: $url');
    debugPrint('Login Request Body: $body');

    // Send POST request with no token requirement
    final response = await request(
      url,
      serviceType: ServiceType.post,
      body: body,
      requiredDefaultHeader: false, // No token for login
    );

    if (response == null || response is! Map<String, dynamic>) {
      throw Exception('Login failed: Invalid response from server');
    }

    return response;
  }
}
