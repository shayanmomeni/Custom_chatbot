import 'package:decent_chatbot/core/components/buttons_widgets.dart';
import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/features/assessment/presentation/widgets/question_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
            QuestionBox(controller: controller, question: 'Question 1'),
            for (int i = 0; i < 10; i++)
              QuestionBox(
                  controller: controller, question: 'Question ${i + 1}'),
            Gap(AppConfig().dimens.small),
            CustomIconButton(
              title: 'Submit',
              onTap: () => controller.routeToSelfAspectScreen(),
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
