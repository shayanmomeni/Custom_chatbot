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

    void sendMessage() {
      final text = textController.text.trim();
      if (text.isNotEmpty) {
        controller.sendMessage(
          text,
          AppRepo().user!.userId.toString(), // Pass user ID
        );
        textController.clear();
      }
    }

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
                          // Display images (if any) from imageUrls field
                          if (message.imageUrls != null &&
                              message.imageUrls!.isNotEmpty) ...[
                            const SizedBox(height: 10),
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
                          // Display aspect images (if any) with their names
                          if (message.aspects != null &&
                              message.aspects!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            ...message.aspects!.map((aspect) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    aspect.aspectName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Image.network(
                                    aspect.imageUrl,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Text("Failed to load aspect image"),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            }).toList(),
                          ],
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
                    onSubmitted: (value) => sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ).paddingAll(AppConfig().dimens.medium),
    );
  }
}
