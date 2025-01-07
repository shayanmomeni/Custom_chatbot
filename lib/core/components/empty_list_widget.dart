import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String title;
  const EmptyListWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          AppConfig().dimens.large,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: AppConfig().colors.txtHeaderColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
