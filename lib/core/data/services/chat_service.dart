import 'package:decent_chatbot/core/data/services/services_helper.dart';
import 'package:decent_chatbot/core/utils/enum.dart';

class ChatService extends ServicesHelper {
  Future<dynamic> sendMessage(
    String message,
    String userId,
    String currentStep,
    List<Map<String, String>> history,
  ) async {
    final url = '$baseURL/send-message'; // Backend endpoint
    final body = {
      "userId": userId,
      "message": message,
      "currentStep": currentStep,
      "history": history, // Include the conversation history
    };

    return await request(
      url,
      serviceType: ServiceType.post,
      body: body,
    );
  }
}
