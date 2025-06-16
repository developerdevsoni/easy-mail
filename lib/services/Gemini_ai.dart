import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  final gemini = Gemini.init(
    apiKey: 'AIzaSyBrf1s23Y41WLPPDXE8vpYPlHSOPUrR3p0', // ⚠️ Store securely
  );

  Future<Map<String, String>> generateEmail(String userPrompt) async {
    try {
      final prompt = '''
You are an email writing assistant.

Based on the following user input, generate an email and return it **strictly** as a valid JSON object with these exact keys:
- "title": the subject line of the email
- "body": the main content of the email
- "regards": the closing line or sign-off

Do not include any explanation, markdown, or text outside of the JSON response.

User input:
"$userPrompt"
''';

      if (kDebugMode) print("🟡 Prompt sent to Gemini:\n$prompt");

      final response = await gemini.text(prompt);

      if (response?.output != null && response!.output!.isNotEmpty) {
        final output = response.output!.trim();

        if (kDebugMode) print("🟢 Gemini raw response:\n$output");

        // 🔍 Remove backtick code blocks (```json ... ```)
        final cleanedOutput =
            output
                .replaceAll(RegExp(r'^```json', multiLine: true), '')
                .replaceAll(RegExp(r'^```', multiLine: true), '')
                .replaceAll(RegExp(r'```$'), '')
                .trim();

        if (kDebugMode) print("🧼 Cleaned JSON:\n$cleanedOutput");

        // ✅ Attempt to decode JSON
        final decoded = jsonDecode(cleanedOutput);

        if (kDebugMode) print("✅ Parsed JSON: $decoded");

        return {
          'title': decoded['title'] ?? '',
          'body': decoded['body'] ?? '',
          'regards': decoded['regards'] ?? '',
        };
      } else {
        throw Exception('No output from Gemini.');
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error parsing Gemini output: $e");
      }

      return {'title': '', 'body': '', 'regards': 'Error generating email: $e'};
    }
  }
}
