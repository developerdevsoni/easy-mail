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
    final textStyle = TextStyle(fontSize: 10.0.sp, color: Colors.black);

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
              Obx(
                () =>
                    controller.showAnimation.value
                        ? Positioned.fill(
                          child: IgnorePointer(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 4),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                    'Write your prompt to generate with AI...',
                                    textStyle: textStyle.copyWith(
                                      color: Colors.grey,
                                    ),
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
                        : const SizedBox.shrink(),
              ),
              TextField(
                controller: controller.textController,
                maxLines: 4,
                textInputAction: TextInputAction.done,
                style: textStyle.copyWith(color: Colors.black),
                decoration: const InputDecoration.collapsed(hintText: ''),
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
            final email = controller.result.value;
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (Subject)
                  Text(
                    'Subject: ${email['title'] ?? 'No title'}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Body (Main content)
                  Text(
                    email['body'] ?? 'No body content',
                    style: TextStyle(fontSize: 12.sp,
                      color: Colors.black,),
                  ),
                  const SizedBox(height: 12),

                  // Regards (Closing)
                  Text(
                    email['regards'] ?? 'No regards',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
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
