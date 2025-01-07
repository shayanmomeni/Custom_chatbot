import 'package:decent_chatbot/core/components/textfields_widget.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';

class CustomQuestionBox extends StatelessWidget {
  final String question;

  const CustomQuestionBox({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppConfig().dimens.medium,
      children: [
        Text(
          question,
          style: TextStyle(
              fontSize: AppConfig().dimens.medium, fontWeight: FontWeight.w600),
        ),
        CustomTextField(
          labelText: "Enter your answer",
        ),
      ],
    );
  }
}
