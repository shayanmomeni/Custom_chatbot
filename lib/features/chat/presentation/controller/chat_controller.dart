import 'package:get/get.dart';

import '../../domain/chat_repo.dart';

class ChatController extends GetxController {

  late ChatRepository repo;

  ChatController({
    required this.repo,
  });

}