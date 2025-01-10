import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/features/assessment/presentation/controller/assessment_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class QuestionBox extends StatelessWidget {
  final AssessmentController controller;
  final String question;
  final int index;

  const QuestionBox({
    super.key,
    required this.controller,
    required this.question,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(
            color: AppConfig().colors.txtHeaderColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Gap(AppConfig().dimens.mediumSmall),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: AppConfig().dimens.mediumSmall,
              horizontal: AppConfig().dimens.medium),
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
                      controller: controller.tagTextControllers[index],
                      decoration: InputDecoration(
                        hintText: 'Add your answers',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppColors().txtTextFielColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      final tagText = controller.tagTextControllers[index].text;
                      if (tagText.isNotEmpty) {
                        controller.addTag(index, tagText);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppConfig().colors.primaryColor,
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: AppConfig().colors.primaryColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    label: const Text(
                      'Add Answer',
                    ),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              Gap(AppConfig().dimens.mediumSmall),
              Obx(
                () => Wrap(
                  spacing: 8.0,
                  children: controller.selectedTagsList[index]
                      .map((tag) => Chip(
                            label: Text(tag),
                            onDeleted: () => controller.removeTag(index, tag),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
