import 'package:decent_chatbot/core/components/buttons_widgets.dart';
import 'package:decent_chatbot/core/constants/color.dart';
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
        title: const Text('Assessment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.generate(10, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: QuestionBox(
                  controller: controller,
                  question: "Question ${index + 1}",
                  index: index,
                ),
              );
            }),
            const SizedBox(height: 20),
            Obx(() {
              return CustomIconButton(
                title: "Submit",
                color: controller.isSubmitEnabled
                    ? AppColors().primaryColor
                    : Colors.grey,
                onTap: controller.isSubmitEnabled
                    ? () => controller.submitAssessment()
                    : null,
              );
            }),
          ],
        ).paddingAll(16),
      ),
    );
  }
}
