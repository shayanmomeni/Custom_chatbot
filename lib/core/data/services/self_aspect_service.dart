import 'package:decent_chatbot/core/data/services/services_helper.dart';
import 'package:decent_chatbot/core/utils/enum.dart';
import 'package:flutter/material.dart';

class SelfAspectService extends ServicesHelper {
  /// Fetch User Assessment
  Future<List<String>> fetchUserAssessment(String userId) async {
    final url = '$baseURL/assessment?userId=$userId';

    debugPrint('Fetching User Assessment for User ID: $userId');

    final response = await request(
      url,
      serviceType: ServiceType.get,
      requiredDefaultHeader: true,
    );

    if (response == null ||
        response['data'] == null ||
        response['data'] is! List) {
      throw Exception('Failed to fetch user assessments: Invalid response');
    }

    return List<String>.from(response['data']);
  }

  /// Save Self-Aspects
  Future<Map<String, dynamic>> saveSelfAspects(
      String userId, List<String> aspects) async {
    final url = '$baseURL/self-aspects';

    final body = {
      'userId': userId,
      'aspects': aspects,
    };

    debugPrint('Saving Self-Aspects: $body');

    final response = await request(
      url,
      serviceType: ServiceType.put,
      body: body,
      requiredDefaultHeader: false,
    );

    if (response == null || response is! Map<String, dynamic>) {
      throw Exception('Failed to save self-aspects: Invalid response');
    }

    return response;
  }
}
