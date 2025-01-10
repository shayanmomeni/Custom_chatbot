import 'dart:async';
import 'package:decent_chatbot/core/data/models/chat_model.dart';
import 'package:get/get.dart';
import '../../domain/chat_repo.dart';

class ChatController extends GetxController {
  late ChatRepository repo;

  var messages = <Message>[].obs;
  var isLoading = false.obs;

  ChatController({required this.repo});

  @override
  void onInit() {
    super.onInit();
    initializeChat();
  }

  void initializeChat() {
    // Add the system's first message
    messages.add(Message(text: "Hi, do you have time?", isSentByUser: false));
  }

  Future<void> sendMessage(String text, String userId) async {
    messages.add(Message(text: text, isSentByUser: true));

    // Send user message to the backend
    isLoading.value = true;
    final response = await repo.sendMessage(text, userId);
    isLoading.value = false;

    if (response != null && response['data'] != null) {
      final reply = response['data']['openAIResponse'];
      messages.add(Message(text: reply, isSentByUser: false));
    } else {
      messages.add(Message(
          text: "Failed to process your message.", isSentByUser: false));
    }
  }
}
