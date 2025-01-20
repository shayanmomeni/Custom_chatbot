abstract class ChatRepository {
  Future<dynamic> sendMessage(
    String message,
    String userId,
    String currentStep,
    List<Map<String, String>> history,
  );
}
