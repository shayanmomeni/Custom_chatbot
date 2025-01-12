import 'package:decent_chatbot/core/components/buttons_widgets.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:decent_chatbot/features/self_aspect/data/repo/self_aspect_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/self_aspect_controller.dart';

class SelfAspectScreen extends StatelessWidget {
  SelfAspectScreen({super.key});

  final controller = Get.put(SelfAspectController(repo: SelfAspectRepositoryImpl()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Aspect'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select 10 self aspects",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.aspects.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: controller.aspects.length,
                  itemBuilder: (context, index) {
                    final aspect = controller.aspects[index];
                    // Wrap each item with Obx
                    return Obx(() => AspectItem(
                          aspect: aspect,
                          isSelected: controller.selectedAspects.contains(aspect),
                          onTap: () => controller.toggleSelection(aspect),
                        ));
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
                  "Selected: ${controller.selectedAspects.length}/10",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        final isSubmitEnabled = controller.isSubmitEnabled;
        return GestureDetector(
          onTap: () {
            if (isSubmitEnabled) {
              controller.handleSubmit();
            } else {
              Get.snackbar(
                "Incomplete Selection",
                "Please select exactly 10 aspects before submitting.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppConfig().colors.snackbarColor,
              );
            }
          },
          child: CustomIconButton(
            title: "Submit",
            color: isSubmitEnabled ? AppConfig().colors.primaryColor : Colors.grey,
            onTap: isSubmitEnabled ? () => controller.handleSubmit() : null,
          ).paddingOnly(
            bottom: 40,
            left: 16,
            right: 16,
          ),
        );
      }),
    );
  }
}

// Separate widget for aspect item
class AspectItem extends StatelessWidget {
  final String aspect;
  final bool isSelected;
  final VoidCallback onTap;

  const AspectItem({
    Key? key,
    required this.aspect,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppConfig().colors.primaryColor 
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected 
                ? AppConfig().colors.primaryColor 
                : Colors.grey,
            width: 1.5,
          ),
        ),
        child: Text(
          aspect,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}