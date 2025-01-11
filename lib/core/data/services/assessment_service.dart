import 'package:decent_chatbot/core/data/services/services_helper.dart';
import 'package:decent_chatbot/core/utils/enum.dart';
import 'package:flutter/material.dart';
import '../models/assessment_request_model.dart';

class AssessmentService extends ServicesHelper {
  Future<void> saveAssessment(AssessmentRequest request) async {
    final url = '$baseURL/assessment';

    debugPrint('Submitting Assessment: ${request.toJson()}');

    // Correctly using the `request` function
    final response = await super.request(
      url,
      serviceType: ServiceType.put,
      body: request.toJson(),
      requiredDefaultHeader: true, // Use default headers with JWT
    );

    // Validate the response
    if (response == null || response is! Map<String, dynamic>) {
      throw Exception('Failed to save assessment: Invalid response');
    }
  }
}
