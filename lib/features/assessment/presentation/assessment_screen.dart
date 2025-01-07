import 'package:decent_chatbot/core/components/buttons_widgets.dart';
import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/features/assessment/presentation/widgets/question_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/assessment_controller.dart';

class AssessmentScreen extends GetView<AssessmentController> {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: AppConfig().dimens.medium,
          children: [
            CustomQuestionBox(
              question: 'Q1',
            ),
            CustomQuestionBox(
              question: 'Q1',
            ),
            CustomQuestionBox(
              question: 'Q1',
            ),
            CustomQuestionBox(
              question: 'Q1',
            ),
            CustomQuestionBox(
              question: 'Q1',
            ),
            CustomQuestionBox(
              question: 'Q1',
            ),
            CustomQuestionBox(
              question: 'Q1',
            ),
            SizedBox(
              height: AppConfig().dimens.small,
            ),
            CustomIconButton(
              title: 'Submit',
              onTap: () => controller.routeToChatScreen(),
              color: AppColors().primaryColor,
            ),
            SizedBox(
              height: AppConfig().dimens.medium,
            ),
          ],
        ).paddingAll(AppConfig().dimens.medium),
      ),
    );
  }
}
