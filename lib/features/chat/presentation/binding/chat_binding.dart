import 'package:decent_chatbot/core/data/services/chat_service.dart';
import 'package:get/get.dart';
import '../../data/repo/chat_repo_impl.dart';
import '../controller/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize the ChatService
    final chatService = ChatService();

    // Initialize the ChatRepositoryImpl with the ChatService
    final chatRepository = ChatRepositoryImpl(chatService);

    // Initialize the ChatController with the ChatRepository
    Get.lazyPut<ChatController>(
      () => ChatController(repo: chatRepository),
    );
  }
}
