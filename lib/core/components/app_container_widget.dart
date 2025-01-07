
import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/core/constants/dimens.dart';
import 'package:flutter/material.dart';

class AppContainerWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double? width;
  final double? height;
  final Color? bacjgroundColor;

  const AppContainerWidget({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.width,
    this.height,
    this.bacjgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: bacjgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(Dimens().medium),
        border: Border.all(
          color: AppColors().txtBodyColor,
          width: 0.3,
        ),
      ),
      child: child,
    );
  }
}
