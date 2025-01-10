import 'package:decent_chatbot/core/data/services/chat_service.dart';

import '../../domain/chat_repo.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatService _chatService;

  ChatRepositoryImpl(this._chatService);

  @override
  Future<dynamic> sendMessage(String message, String userId) async {
    return await _chatService.sendMessage(message, userId);
  }
}
