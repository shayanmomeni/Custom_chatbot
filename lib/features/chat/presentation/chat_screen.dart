import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/chat_controller.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          // Chat Messages List
          Expanded(
            child: Obx(
              () => ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final alignment = message.isSentByUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft;
                  final color = message.isSentByUser
                      ? Colors.green[100]
                      : Colors.grey[300];

                  // Display message with text and/or images
                  return Align(
                    alignment: alignment,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Message Text
                          if (message.text.isNotEmpty)
                            Text(
                              message.text,
                              style: const TextStyle(fontSize: 16),
                            ),
                          // Space between text and images
                          if (message.text.isNotEmpty &&
                              message.imageUrls != null &&
                              message.imageUrls!.isNotEmpty)
                            const SizedBox(height: 10),
                          // Display multiple images
                          if (message.imageUrls != null &&
                              message.imageUrls!.isNotEmpty)
                            ...message.imageUrls!.map(
                              (imageUrl) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Image.network(
                                  imageUrl,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Text("Failed to load image"),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Loading Indicator
          Obx(
            () => controller.isLoading.value
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),
          ),
          // Message Input Field
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = textController.text.trim();
                    if (text.isNotEmpty) {
                      controller.sendMessage(
                        text,
                        AppRepo().user!.userId.toString(), // Pass user ID
                      );
                      textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ).paddingAll(AppConfig().dimens.medium),
    );
  }
}
