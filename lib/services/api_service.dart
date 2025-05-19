import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://lp4wn4z5-5000.inc1.devtunnels.ms";

  static Future<void> saveGoogleUser({
    required String email,
    required String name,
    required String accessToken,
    required String idToken,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save-google-user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "email": email,
        "name": name,
        "access_token": accessToken,
        "id_token": idToken,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save user: ${response.body}');
    }
  }
}
