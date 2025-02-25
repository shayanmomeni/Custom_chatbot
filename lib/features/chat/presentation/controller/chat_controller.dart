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
          "Hi ${AppRepo().user?.fullName}, Would you like to take a moment to reflect on a decision you are facing at the moment? Please answer with 'yes' or 'no'.",
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
    // 1. Add the user's message to the chat
    messages.add(Message(text: text, isSentByUser: true));
    print("[Frontend] User message: $text");

    isLoading.value = true; // Show loading indicator

    try {
      // 2. Prepare the message history for the backend
      final history = messages.map((message) {
        return {
          "role": message.isSentByUser ? "user" : "assistant",
          "content": message.text,
        };
      }).toList();

      // 3. Call the backend API
      final response = await repo.sendMessage(
        text,
        userId,
        currentStep.value,
        history,
        conversationId.value,
      );

      isLoading.value = false; // Hide loading indicator

      if (response != null && response['data'] != null) {
        final data = response['data'];

        // Next step & conversation metadata
        final nextStepValue = data['nextStep'] ?? currentStep.value;
        currentStep.value = nextStepValue;
        isEnd.value = data['isEnd'] ?? false;

        print("[Frontend] Backend response data: $data");

        // 4. Check if we got multiple messages (openAIResponses) or a single message (openAIResponse)
        final openAIResponses = data['openAIResponses'];
        final singleResponse = data['openAIResponse'];

        // Images are still read the old way
        final images = List<String>.from(data['images'] ?? []);

        // NEW: We check if aspects exist
        final aspectsList = data['aspects'];
        List<AspectItem> aspectItems = [];
        if (aspectsList != null && aspectsList is List) {
          // Convert each item in 'aspects' to AspectItem
          for (var aspect in aspectsList) {
            if (aspect is Map) {
              final aspectName = aspect['aspectName'] ?? '';
              final imageUrl = aspect['imageUrl'] ?? '';
              aspectItems
                  .add(AspectItem(aspectName: aspectName, imageUrl: imageUrl));
            }
          }
        }

        if (openAIResponses != null && openAIResponses is List) {
          // 4a. We have multiple messages to display
          for (String partialResponse in openAIResponses) {
            if (partialResponse.isNotEmpty ||
                images.isNotEmpty ||
                aspectItems.isNotEmpty) {
              messages.add(Message(
                text: partialResponse,
                isSentByUser: false,
                imageUrls: images.isNotEmpty ? images : [],
                aspects: aspectItems.isNotEmpty ? aspectItems : null,
              ));
              print("[Frontend] Assistant partial message: $partialResponse");
              if (images.isNotEmpty) {
                print("[Frontend] Assistant sent images: $images");
              }
              if (aspectItems.isNotEmpty) {
                for (var a in aspectItems) {
                  print(
                      "[Frontend] Assistant aspect: ${a.aspectName} => ${a.imageUrl}");
                }
              }
            }
          }
        } else {
          // 4b. Single message scenario
          final nextMessage = singleResponse ?? '';
          if (nextMessage.isNotEmpty ||
              images.isNotEmpty ||
              aspectItems.isNotEmpty) {
            messages.add(Message(
              text: nextMessage,
              isSentByUser: false,
              imageUrls: images,
              aspects: aspectItems.isNotEmpty ? aspectItems : null,
            ));
            print("[Frontend] Assistant message: $nextMessage");
            if (images.isNotEmpty) {
              print("[Frontend] Assistant sent images: $images");
            }
            if (aspectItems.isNotEmpty) {
              for (var a in aspectItems) {
                print(
                    "[Frontend] Assistant aspect: ${a.aspectName} => ${a.imageUrl}");
              }
            }
          }
        }

        // 5. If the chat ends, reset the conversation ID
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
        print("[Frontend] Unexpected or null backend response.");
      }
    } catch (e) {
      // 6. Handle error
      isLoading.value = false;
      print("[Frontend] Error during API call: $e");
      messages.add(Message(
        text: "Failed to connect to the server. Please try again later.",
        isSentByUser: false,
      ));
    }
  }
}
