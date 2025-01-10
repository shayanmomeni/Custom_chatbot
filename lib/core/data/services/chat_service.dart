import 'package:decent_chatbot/core/data/services/services_helper.dart';
import 'package:decent_chatbot/core/utils/enum.dart';

class ChatService extends ServicesHelper {
  Future<dynamic> sendMessage(String message, String userId) async {
    final url = '$baseURL/send-message';
    final body = {
      "userId": userId,
      "message": message,
    };

    return await request(
      url,
      serviceType: ServiceType.post,
      body: body,
    );
  }
}
