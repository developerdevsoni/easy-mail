import 'package:easy_mail/view/discoverTemplete_screen.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_mail/utils/TypingPromptField.dart';
import 'package:get/get.dart';
// import 'mailEditor_screen.dart';
import '../controllers/animatedTextWidget.dart';

class AiMailGeneratorScreen extends StatelessWidget {
  const AiMailGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TypingPromptController controller = Get.put(TypingPromptController());
    return Scaffold(
      backgroundColor: MyColor().lightGreen,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Generate Mail with AI',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        backgroundColor: const Color(0xFFF3F8F2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Describe what you want to write:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              TypingPromptField(),
              const SizedBox(height: 24),
              Obx(() {
                final generated = controller.result.value;
                if (generated.isNotEmpty) {
                  return ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Use in Mail Editor'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => EmailTemplateEditorScreen(
                                selectedTemplate: {
                                  'title': generated["title"],
                                  'body':generated["body"],
                                "regrads":generated["regards"]},
                              ),
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
