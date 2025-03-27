import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/data/models/chat_model.dart';
import 'package:decent_chatbot/core/data/local_cache/local_cache_helper.dart';
import 'package:get/get.dart';
import '../../domain/chat_repo.dart';
import 'package:decent_chatbot/core/utils/excel_helper.dart';

class ChatController extends GetxController {
  late ChatRepository repo;
  final LocalCacheHelper cacheHelper = LocalCacheHelper();

  var messages = <Message>[].obs; // List of messages in the chat
  var isLoading = false.obs; // To track loading state
  var currentStep = 'awaiting_time_response'.obs; // Current chatbot step
  var isEnd = false.obs; // Whether the chat has ended
  var conversationId = ''.obs; // Tracks the conversation ID

  // 2-hour expiration (example)
  static const int conversationExpiryMs = 2 * 60 * 60 * 1000;

  ChatController({required this.repo});

  @override
  void onInit() {
    super.onInit();
    checkConversationExpiry();
    initializeChat();
  }

  /// Checks if the stored conversation timestamp is older than [conversationExpiryMs].
  /// If yes, we reset the conversation.
  void checkConversationExpiry() {
    final lastActive = cacheHelper.read<int>('lastActiveTimestamp');
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    if (lastActive != null &&
        (currentTime - lastActive) > conversationExpiryMs) {
      // It's been more than 2 hours -> reset conversation
      resetConversation();
    }
  }

  /// Initializes a new chat conversation if no messages exist.
  /// Saves a single timestamp to indicate when the conversation started.
  void initializeChat() {
    if (messages.isEmpty) {
      messages.add(Message(
        text:
            "Hi ${AppRepo().user?.fullName}, Would you like to take a moment to reflect on a decision you are facing at the moment? Please answer with 'yes' or 'no'.",
        isSentByUser: false,
      ));
      currentStep.value = 'awaiting_time_response';
      conversationId.value = generateConversationId();

      // Save the conversation ID and timestamp once at the start
      cacheHelper.write('lastConversationId', conversationId.value);
      cacheHelper.write(
          'lastActiveTimestamp', DateTime.now().millisecondsSinceEpoch);
    }
  }

  String generateConversationId() {
    return DateTime.now().millisecondsSinceEpoch.toString(); // Unique ID
  }

  /// Resets the conversation manually (e.g., user taps 'Reset' or we detect expiration).
  void resetConversation() {
    messages.clear();
    conversationId.value = generateConversationId();
    currentStep.value = 'awaiting_time_response';
    isEnd.value = false;

    // Save new start timestamp
    cacheHelper.write('lastConversationId', conversationId.value);
    cacheHelper.write(
        'lastActiveTimestamp', DateTime.now().millisecondsSinceEpoch);

    initializeChat();
  }

  Future<void> sendMessage(String text, String userId) async {
    // 1. Add the user's message to the chat
    messages.add(Message(text: text, isSentByUser: true));
    print("[Frontend] User message: $text");

    isLoading.value = true; // Show loading indicator

    try {
      // 2. Prepare the message history
      final history = messages.map((message) {
        return {
          "role": message.isSentByUser ? "user" : "assistant",
          "content": message.text,
        };
      }).toList();

      // 3. Call the backend
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

        // Next step & conversation
        final nextStepValue = data['nextStep'] ?? currentStep.value;
        currentStep.value = nextStepValue;
        isEnd.value = data['isEnd'] ?? false;

        print("[Frontend] Backend response data: $data");

        final openAIResponses = data['openAIResponses'];
        final singleResponse = data['openAIResponse'];
        final images = List<String>.from(data['images'] ?? []);

        final aspectsList = data['aspects'];
        List<AspectItem> aspectItems = [];
        if (aspectsList != null && aspectsList is List) {
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
            }
          }
        } else {
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
          }
        }

        // If conversation ends, user can press "Start New Chat" or "Reset"
        if (isEnd.value) {
          print("[Frontend] Conversation ended.");
          await ExcelHelper.updateTrigger(
            sheetName: 'Triggers',
            cell: 'A1',
            triggerValue: false,
          );
        }
      } else {
        // Unexpected or null backend response
        messages.add(Message(
          text: "Failed to process your message.",
          isSentByUser: false,
        ));
        print("[Frontend] Unexpected or null backend response.");
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
