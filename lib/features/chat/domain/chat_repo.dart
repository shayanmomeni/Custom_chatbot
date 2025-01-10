abstract class ChatRepository {
  Future<dynamic> sendMessage(String message, String userId);
}
