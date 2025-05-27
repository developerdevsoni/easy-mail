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
     String?  photoUrl,
    String?  id,

  }) async {
    var Body=json.encode({
      "email": email,
      "name": name,
      "access_token": accessToken,
      "serverAuthToken": serverAuthCode,
      "photoUrl":photoUrl
    });
    print("body ------ ${Body}");
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/save-google-user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "email": email,
        "name": name,
        "access_token": accessToken,
        "serverAuthToken": serverAuthCode,
        "photoUrl":photoUrl
      }),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return saveGoogleUser_modal.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to save user: ${response.body}');
    }
  }

}
