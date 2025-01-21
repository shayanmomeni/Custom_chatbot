import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/data/models/chat_model.dart';
import 'package:get/get.dart';
import '../../domain/chat_repo.dart';

class ChatController extends GetxController {
  late ChatRepository repo;

  var messages = <Message>[].obs; // List of messages in the chat
  var isLoading = false.obs; // To track loading state
  var currentStep = 'awaiting_time_response'.obs; // Current chatbot step
  var isEnd = false.obs; // Whether the chat has ended
  var conversationId = ''.obs; // Tracks the conversation ID

  ChatController({required this.repo});

  @override
  void onInit() {
    super.onInit();
    initializeChat();
  }

  void initializeChat() {
    // Initial chatbot message
    messages.add(Message(
      text:
          "Hi ${AppRepo().user?.fullName}, do you have time? Please answer with 'yes' or 'no'.",
      isSentByUser: false,
    ));
    currentStep.value = 'awaiting_time_response';
    conversationId.value =
        generateConversationId(); // Generate a new conversation ID
  }

  String generateConversationId() {
    return DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // Generate a unique ID
  }

  Future<void> sendMessage(String text, String userId) async {
    messages
        .add(Message(text: text, isSentByUser: true)); // Add the user's message
    print("[Frontend] User message: $text");

    isLoading.value = true; // Show loading indicator
    try {
      // Prepare the message history
      final history = messages.map((message) {
        return {
          "role": message.isSentByUser ? "user" : "assistant",
          "content": message.text,
        };
      }).toList();

      // Call the backend API
      final response = await repo.sendMessage(
        text,
        userId,
        currentStep.value,
        history, // Pass the correct List<Map<String, String>>
        conversationId.value,
      );

      isLoading.value = false; // Hide loading indicator

      if (response != null && response['data'] != null) {
        final data = response['data'];
        final nextMessage = data['openAIResponse'] ?? '';
        final images = List<String>.from(
            data['images'] ?? []); // Extract multiple image URLs
        final nextStep = data['nextStep'] ?? currentStep.value;

        print("[Frontend] Backend response: $data");
        currentStep.value = nextStep;
        isEnd.value = data['isEnd'] ?? false;

        // Add assistant message with text and images
        if (nextMessage.isNotEmpty || images.isNotEmpty) {
          messages.add(Message(
            text: nextMessage,
            isSentByUser: false,
            imageUrls: images, // Assign the list of images
          ));
          print("[Frontend] Assistant message: $nextMessage");
          if (images.isNotEmpty) {
            print("[Frontend] Assistant sent images: $images");
          }
        }

        // If the chat ends, reset the conversation ID
        if (isEnd.value) {
          print("[Frontend] Conversation has ended.");
          conversationId.value = '';
        }
      } else {
        // Handle unexpected backend response
        messages.add(Message(
          text: "Failed to process your message.",
          isSentByUser: false,
        ));
        print("[Frontend] Unexpected backend response.");
      }
    } catch (e) {
      // Handle error
      isLoading.value = false;
      print("[Frontend] Error during API call: $e");
      messages.add(Message(
        text: "Failed to connect to the server. Please try again later.",
        isSentByUser: false,
      ));
    }
  }
}
