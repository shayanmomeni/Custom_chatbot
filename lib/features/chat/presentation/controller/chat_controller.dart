import 'dart:async';

import 'package:decent_chatbot/core/data/models/chat_model.dart';
import 'package:get/get.dart';

import '../../domain/chat_repo.dart';

class ChatController extends GetxController {
  late ChatRepository repo;

  var timeLeft = (5 * 60 * 60).obs;
  Timer? _timer;

  var messages = <Message>[
    Message(text: "Hello!", isSentByUser: true),
    Message(text: "Hi there!", isSentByUser: false),
    Message(text: "How are you?", isSentByUser: true),
    Message(text: "I'm good, thanks!", isSentByUser: false),
  ].obs;

  ChatController({
    required this.repo,
  });

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    timeLeft.value = 5 * 60 * 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void refreshChat() {
    messages.clear();
    startTimer();
    Get.back();
  }

  void endChat() {
    messages.clear();
    startTimer();
    Get.back();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
