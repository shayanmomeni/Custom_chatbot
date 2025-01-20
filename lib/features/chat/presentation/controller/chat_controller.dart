import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/data/models/chat_model.dart';
import 'package:get/get.dart';
import '../../domain/chat_repo.dart';

class ChatController extends GetxController {
  late ChatRepository repo;

  var messages = <Message>[].obs;
  var isLoading = false.obs;
  var currentStep = 'awaiting_time_response'.obs;
  var isEnd = false.obs;

  ChatController({required this.repo});

  @override
  void onInit() {
    super.onInit();
    initializeChat();
  }

  void initializeChat() {
    messages.add(Message(
      text:
          "Hi ${AppRepo().user?.fullName}, do you have time? Please answer with 'yes' or 'no'.",
      isSentByUser: false,
    ));
    currentStep.value = 'awaiting_time_response';
  }

  Future<void> sendMessage(String text, String userId) async {
    messages.add(Message(text: text, isSentByUser: true));
    print("[Frontend] User message: $text");

    isLoading.value = true;
    try {
      final history = messages.map((message) {
        return {
          "role": message.isSentByUser ? "user" : "assistant",
          "content": message.text,
          "step": currentStep.value,
        };
      }).toList();

      final response = await repo.sendMessage(
        text,
        userId,
        currentStep.value,
        history,
      );

      isLoading.value = false;

      if (response != null && response['data'] != null) {
        final data = response['data'];
        final nextMessage = data['openAIResponse'] ?? '';
        final nextStep = data['nextStep'] ?? currentStep.value;

        print("[Frontend] Backend response: $data");
        currentStep.value = nextStep;
        isEnd.value = data['isEnd'] ?? false;

        if (nextMessage.isNotEmpty) {
          messages.add(Message(text: nextMessage, isSentByUser: false));
          print("[Frontend] Assistant message: $nextMessage");
        }

        if (isEnd.value) {
          print("[Frontend] Conversation has ended.");
        }
      } else {
        messages.add(Message(
          text: "Failed to process your message.",
          isSentByUser: false,
        ));
        print("[Frontend] Unexpected backend response.");
      }
    } catch (e) {
      isLoading.value = false;
      print("[Frontend] Error during API call: $e");
      messages.add(Message(
        text: "Failed to connect to the server. Please try again later.",
        isSentByUser: false,
      ));
    }
  }
}
