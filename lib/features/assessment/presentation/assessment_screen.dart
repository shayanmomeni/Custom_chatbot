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
        title: const Text('Assessment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamically generate 10 QuestionBox widgets
            ...List.generate(10, (index) {
              return Column(
                children: [
                  QuestionBox(
                    controller: controller,
                    question: 'Question ${index + 1}',
                    index: index,
                  ),
                  Gap(AppConfig().dimens.medium),
                ],
              );
            }),
            // Add spacing and the Submit button
            Gap(AppConfig().dimens.medium),
            Center(
              child: Obx(
                () {
                  // Enable button only if all questions have at least one answer
                  final isButtonEnabled = controller.selectedTagsList.every(
                    (tags) => tags.isNotEmpty,
                  );
                  return CustomIconButton(
                    title: 'Submit',
                    onTap: isButtonEnabled
                        ? () => controller.submitAssessment(
                            '6781295d825a2db485975ffc') // Pass userId dynamically
                        : null,
                    color: isButtonEnabled
                        ? AppColors().primaryColor
                        : Colors.grey, // Disable color
                  );
                },
              ),
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
