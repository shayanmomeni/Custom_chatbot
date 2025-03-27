import 'package:decent_chatbot/core/data/services/services_helper.dart';
import 'package:decent_chatbot/core/utils/enum.dart';
import 'package:flutter/material.dart';

class UserService extends ServicesHelper {
  /// Fetch the user data from backend using userId.
  Future<Map<String, dynamic>> fetchUser(String userId) async {
    final url = '$baseURL/user/$userId'; // Adjust endpoint if necessary

    debugPrint('Fetching user data for User ID: $userId');

    final response = await request(
      url,
      serviceType: ServiceType.get,
      requiredDefaultHeader: true,
    );

    if (response == null || response['data'] == null) {
      throw Exception('Failed to fetch user data: Invalid response');
    }

    return Map<String, dynamic>.from(response['data']);
  }
}
