import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/features/assessment/presentation/controller/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class QuestionBox extends StatelessWidget {
  final AssessmentController controller;
  final String question;
  final String example;
  final int index;

  const QuestionBox({
    Key? key,
    required this.controller,
    required this.question,
    required this.example,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display the question text
        Text(
          question,
          style: TextStyle(
            color: AppConfig().colors.txtHeaderColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Gap(AppConfig().dimens.small),
        // Display the example text with a distinct style
        Text(
          example,
          style: TextStyle(
            color: AppConfig().colors.txtBodyColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(AppConfig().dimens.mediumSmall),
        Container(
          padding: EdgeInsets.symmetric(
            vertical: AppConfig().dimens.mediumSmall,
            horizontal: AppConfig().dimens.medium,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: AppConfig().colors.txtBodyColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textControllers[index],
                      decoration: InputDecoration(
                        hintText: 'Add your answers here',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppConfig().colors.txtTextFielColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      final answerText = controller.textControllers[index].text;
                      if (answerText.isNotEmpty) {
                        controller.addAnswer(index, answerText);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConfig().colors.secondaryColor,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: AppConfig().colors.secondaryColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    label: const Text('Add Answer'),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Gap(AppConfig().dimens.mediumSmall),
              Obx(
                () => Wrap(
                  spacing: 8.0,
                  children: controller.answers[index]
                      .map(
                        (answer) => Chip(
                          key: ValueKey(answer),
                          label: Text(answer),
                          deleteIcon: const Icon(Icons.cancel, size: 18),
                          deleteIconColor: AppConfig().colors.secondaryColor,
                          onDeleted: () =>
                              controller.removeAnswer(index, answer),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
        Gap(20),
      ],
    );
  }
}
