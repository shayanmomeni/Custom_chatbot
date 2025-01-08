import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'controller/chat_controller.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'End Chat',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              )).paddingOnly(right: AppConfig().dimens.medium),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () {
              final hours = (controller.timeLeft.value ~/ 3600)
                  .toString()
                  .padLeft(2, '0');
              final minutes = ((controller.timeLeft.value % 3600) ~/ 60)
                  .toString()
                  .padLeft(2, '0');
              final seconds =
                  (controller.timeLeft.value % 60).toString().padLeft(2, '0');
              return Text(
                'Time left: $hours:$minutes:$seconds',
                style: TextStyle(
                  color: AppConfig().colors.txtBodyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              );
            },
          ),
          Gap(AppConfig().dimens.medium),
          Expanded(
            child: Obx(
              () => ListView.separated(
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  final isSentByUser = message.isSentByUser;
                  return Align(
                    alignment: isSentByUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSentByUser
                            ? AppConfig().colors.primaryColor.withAlpha(50)
                            : Colors.grey.withAlpha(50),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(message.text)
                          .paddingAll(AppConfig().dimens.medium),
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    Gap(AppConfig().dimens.small),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  // controller: controller.messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.grey, // Default border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: AppConfig().colors.primaryColor,
                        width: 1.7,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  // controller.sendMessage();
                },
              ),
            ],
          ),
          Gap(AppConfig().dimens.medium),
        ],
      ).paddingAll(AppConfig().dimens.medium),
    );
  }
}
