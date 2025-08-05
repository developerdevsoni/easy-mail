import 'dart:convert';
import 'package:easy_mail/model/saveGoogleUser_modal.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://lp4wn4z5-3000.inc1.devtunnels.ms";

  static Future<saveGoogleUser_modal> saveGoogleUser({
    required String email,
    required String name,
    required String accessToken,
    required String serverAuthCode,
    String? photoUrl,
    String? id,
  }) async {
    try {
      print("🔄 API Service: Preparing request to save Google user");
      print("📧 Email: $email");
      print("👤 Name: $name");
      print("🔑 Access Token: ${accessToken.isNotEmpty ? 'Present' : 'Empty'}");
      print(
          "🔐 Server Auth Code: ${serverAuthCode.isNotEmpty ? 'Present' : 'Empty'}");

      final requestBody = {
        "email": email,
        "name": name,
        "access_token": accessToken,
        "serverAuthToken": serverAuthCode,
        "photoUrl": photoUrl ?? "",
      };

      print("📦 Request Body: ${json.encode(requestBody)}");

      final response = await http
          .post(
        Uri.parse('$baseUrl/api/users/save-google-user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print("⏰ API request timed out");
          throw Exception('Request timed out');
        },
      );

      print("📡 API Response Status: ${response.statusCode}");
      print("📄 API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("✅ API call successful");
        return saveGoogleUser_modal.fromJson(jsonResponse);
      } else {
        print("❌ API call failed with status: ${response.statusCode}");
        print("❌ Error response: ${response.body}");
        throw Exception(
            'Failed to save user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("❌ API Service Error: $e");
      // Return a default response to allow the app to continue
      return saveGoogleUser_modal(
        success: false,
        message: "Network error: $e",
        data: null,
      );
    }
  }
}
