import 'package:easy_mail/services/Gemini_ai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypingPromptController extends GetxController {
  final textController = TextEditingController();
  var showAnimation = true.obs;
  var result = <String, String>{}.obs;
  var isLoading = false.obs;

  final geminiService = GeminiService();

  @override
  void onInit() {
    super.onInit();
    textController.addListener(() {
      showAnimation.value = textController.text.isEmpty;
    });
  }

Future<void> submitPrompt(String prompt) async {
  print(prompt);
  if (prompt.trim().isEmpty) return;

  isLoading.value = true;
  result.value = {}; // ✅ Clear the previous result

  try {
    final response = await geminiService.generateEmail(prompt);
    result.value = response; // ✅ This is a Map<String, String>
  } catch (e) {
    print(e);
    result.value = {
      'title': '',
      'body': '',
      'regards': 'Error: $e',
    };
  } finally {
    isLoading.value = false;
  }
}
  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
