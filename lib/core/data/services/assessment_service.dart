import 'package:decent_chatbot/core/data/services/services_helper.dart';
import 'package:decent_chatbot/core/utils/enum.dart';

class AssessmentService extends ServicesHelper {
  Future<void> saveAssessment(String userId, List<String> answers) async {
    final url = '$baseURL/assessment';
    final body = {
      'userId': userId,
      'answers': answers,
    };

    final response = await request(
      url,
      serviceType: ServiceType.put,
      body: body,
      requiredDefaultHeader: true,
    );

    if (response == null) {
      throw Exception('Failed to save assessment.');
    }
    return response;
  }
}
