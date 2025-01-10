import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback? onPressed;
  final Color buttonColor;
  final TextStyle buttonTextStyle;
  final String? outlinedButtonText;
  final VoidCallback? outlinedButtonOnPressed;
  final Color outlinedButtonColor;
  final Color outlinedButtonBorderColor;
  final TextStyle outlinedButtonTextStyle;

  const CustomAlertDialogWidget({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    this.onPressed,
    required this.buttonColor,
    required this.buttonTextStyle,
    this.outlinedButtonText,
    this.outlinedButtonOnPressed,
    required this.outlinedButtonColor,
    required this.outlinedButtonBorderColor,
    required this.outlinedButtonTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (outlinedButtonText != null)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: outlinedButtonBorderColor),
                  backgroundColor: outlinedButtonColor,
                ),
                onPressed: outlinedButtonOnPressed,
                child: Text(
                  outlinedButtonText!,
                  style: outlinedButtonTextStyle,
                ),
              ),
            const Gap(12),
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                backgroundColor: buttonColor,
              ),
              child: Text(buttonText, style: buttonTextStyle),
            ),
          ],
        ),
      ],
    );
  }
}
