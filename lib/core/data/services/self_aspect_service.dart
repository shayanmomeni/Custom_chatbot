import 'package:decent_chatbot/core/data/services/services_helper.dart';
import 'package:decent_chatbot/core/utils/enum.dart';
import 'package:flutter/material.dart';

class SelfAspectService extends ServicesHelper {
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
