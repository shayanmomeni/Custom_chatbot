import 'package:decent_chatbot/app_repo.dart';
import 'package:decent_chatbot/core/components/buttons_widgets.dart';
import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
        leadingWidth: 120,
        leading: GestureDetector(
          onTap: () {
            controller.resetConversation();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(7),
              const Icon(
                Icons.refresh,
                color: Colors.black,
              ),
              Gap(5),
              const Text(
                'Reset',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        title: Text(
          'Reflecto Chatbot',
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColors().primaryColor,
      ),
      body: Column(
        children: [
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
                      ? AppColors().primaryColor
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Text(
                                                "Failed to load aspect image"),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              );
                            }),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // If conversation has ended, display "Start New Chat" button
          Obx(() {
            if (controller.isEnd.value) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: CustomIconButton(
                  color: AppColors().primaryColor,
                  title: "Start New Chat",
                  onTap: () {
                    controller.resetConversation();
                  },
                ),
              );
            } else {
              // Show the message input field only if conversation is active
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: AppColors().primaryColor,
                              width: 2.5,
                            ),
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
              );
            }
          }),
          // Loading Indicator
          Obx(
            () => controller.isLoading.value
                ? const CircularProgressIndicator()
                : const SizedBox.shrink(),
          ),
        ],
      ).paddingAll(AppConfig().dimens.medium),
    );
  }
}
