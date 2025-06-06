import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_mail/controllers/animatedTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // Make sure this is imported

class TypingPromptField extends StatelessWidget {
  TypingPromptField({super.key});

  final TypingPromptController controller = Get.put(TypingPromptController());

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 10.0.sp,
      color: Colors.grey.shade600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Stack(
            children: [
              Obx(() => controller.showAnimation.value
                  ? Positioned.fill(
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 4),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Write your prompt to generate with AI...',
                          textStyle:
                          textStyle.copyWith(color: Colors.grey),
                          speed: const Duration(milliseconds: 60),
                        ),
                      ],
                      repeatForever: true,
                      isRepeatingAnimation: true,
                      pause: const Duration(milliseconds: 1000),
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink()),
              TextField(
                controller: controller.textController,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                style: textStyle.copyWith(color: Colors.black),
                decoration: const InputDecoration.collapsed(
                  hintText: '',
                ),

                onSubmitted: (value) {
                  controller.submitPrompt(value);
                },
              ),
            ],
          ),
        ),

        /// Show loading or result
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.result.value.isNotEmpty) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.result.value,
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
}
