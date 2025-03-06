import 'package:decent_chatbot/core/constants/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decent_chatbot/features/assessment/presentation/controller/assessment_controller.dart';
import 'package:decent_chatbot/features/assessment/presentation/widgets/question_box_widget.dart';
import 'package:decent_chatbot/core/components/buttons_widgets.dart';
import 'package:gap/gap.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  _AssessmentScreenState createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  final PageController _pageController = PageController();
  final AssessmentController controller = Get.find<AssessmentController>();
  int currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Build a page displaying 6 questions (with their examples)
  Widget buildPage(int pageIndex) {
    final startIndex = pageIndex * 6;
    final endIndex = startIndex + 6;
    final pageQuestions = controller.questions.sublist(startIndex, endIndex);
    final pageExamples = controller.examples.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(pageQuestions.length, (index) {
          final actualIndex = startIndex + index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: QuestionBox(
              controller: controller,
              question: pageQuestions[index],
              example: pageExamples[index],
              index: actualIndex,
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors().backGroundColor,
        title: Text('Assessment Test',
            style: TextStyle(color: AppColors().secondaryColor)),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              children: [
                buildPage(0),
                buildPage(1),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 36.0, top: 16),
            child: currentPageIndex == 0
                ? CustomIconButton(
                    title: "Next",
                    color: AppColors().primaryColor,
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                : Column(
                    children: [
                      CustomOutlineIconButton(
                        title: "Back",
                        color: AppColors().primaryColor,
                        borderColor: AppColors().secondaryColor,
                        txtColor: AppColors().secondaryColor,
                        onTap: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      const Gap(16.0),
                      Obx(
                        () => CustomIconButton(
                          title: "Submit",
                          color: AppColors().primaryColor,
                          onTap: controller.isSubmitEnabled
                              ? () {
                                  controller.submitAssessment();
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
