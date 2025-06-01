import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TypingPromptController extends GetxController {
  final textController = TextEditingController();
  var showAnimation = true.obs;

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      showAnimation.value = textController.text.isEmpty;
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}

class TypingPromptField extends StatelessWidget {
  TypingPromptField({super.key});

  final TypingPromptController controller = Get.put(TypingPromptController());

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 10.0.sp,
      color: Colors.grey.shade600,
    );

    return Container(
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
                      textStyle: textStyle.copyWith(color: Colors.grey),
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
            style: textStyle.copyWith(color: Colors.black),
            decoration: const InputDecoration.collapsed(
              hintText: '',
            ),
          ),
        ],
      ),
    );
  }
}
