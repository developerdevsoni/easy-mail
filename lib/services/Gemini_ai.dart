import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiService {
  final gemini = Gemini.init(apiKey: 'AIzaSyBrf1s23Y41WLPPDXE8vpYPlHSOPUrR3p0'); // Replace with your actual API key

  Future<String> generateEmail(String prompt) async {
    try {
      final response = await gemini.text(prompt);

      if (response?.output != null && response!.output!.isNotEmpty) {
        return response.output!;
      } else {
        return 'No response from Gemini.';
      }
    } catch (e) {
      return 'Error generating email: $e';
    }
  }
}
