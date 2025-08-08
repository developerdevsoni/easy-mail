import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_routes.dart';
import '../../model/saveGoogleUser_modal.dart';
import 'base_repository.dart';

class AuthRepository extends BaseRepository {
  // ==================== AUTHENTICATION APIs ====================

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: false);
    final body = {
      'email': email,
      'password': password,
      'name': name,
    };

    return BaseRepository.handleRequest(
      () => http.post(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.register}'),
        headers: headers,
        body: json.encode(body),
      ),
      'register',
    );
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: false);
    final body = {
      'email': email,
      'password': password,
    };

    return BaseRepository.handleRequest(
      () => http.post(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.login}'),
        headers: headers,
        body: json.encode(body),
      ),
      'login',
    );
  }

  static Future<Map<String, dynamic>> loginWithGoogleToken({
    required String idToken,
  }) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: false);
    final body = {
      'idToken': idToken,
    };

    final res = await BaseRepository.handleRequest(
      () => http.post(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.googleLogin}'),
        headers: headers,
        body: body,
      ),
      'Google login',
    );
    return res;
  }

  static Future<Map<String, dynamic>> storeGoogleUser({
    required String googleId,
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: false);
    final body = {
      'googleId': googleId,
      'email': email,
      'name': name,
      'photoUrl': photoUrl ?? '',
    };

    return BaseRepository.handleRequest(
      () => http.post(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.googleLogin}'),
        headers: headers,
        body: json.encode(body),
      ),
      'store Google user',
    );
  }

  static Future<Map<String, dynamic>> logout() async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.post(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.logout}'),
        headers: headers,
      ),
      'logout',
    );
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.profile}'),
        headers: headers,
      ),
      'get profile',
    );
  }

  static Future<Map<String, dynamic>> updateProfile({
    required Map<String, dynamic> profileData,
  }) async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.put(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.updateProfile}'),
        headers: headers,
        body: json.encode(profileData),
      ),
      'update profile',
    );
  }

  static Future<saveGoogleUser_modal> saveGoogleUser({
    required String email,
    required String name,
    required String accessToken,
    required String serverAuthCode,
    String? photoUrl,
    String? id,
  }) async {
    try {
      print("🔄 API: Saving Google user...");
      final headers = await BaseRepository.getHeaders(requiresAuth: false);

      final requestBody = {
        "email": email,
        "name": name,
        "access_token": accessToken,
        "serverAuthToken": serverAuthCode,
        "photoUrl": photoUrl ?? "",
      };

      print("📦 Request Body: ${json.encode(requestBody)}");

      final response = await http.post(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.saveGoogleUser}'),
        headers: headers,
        body: json.encode(requestBody),
      );
      //     .timeout(
      //   const Duration(seconds: 10),
      //   onTimeout: () {
      //     print("⏰ API request timed out");
      //     throw Exception('Request timed out');
      //   },
      // );

      print("📡 API Response Status: ${response.statusCode}");
      print("📄 API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("✅ API: Save Google user successful");
        return saveGoogleUser_modal.fromJson(jsonResponse);
      } else {
        print(
            "❌ API: Save Google user failed with status: ${response.statusCode}");
        throw Exception(
            'Failed to save user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print("❌ API Error in saveGoogleUser: $e");
      return saveGoogleUser_modal(
        success: false,
        message: "Network error: $e",
        data: null,
      );
    }
  }

  static Future<Map<String, dynamic>> getUserByEmail(String email) async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.getUserByEmailUrl(email)}'),
        headers: headers,
      ),
      'get user by email',
    );
  }

  static Future<Map<String, dynamic>> getPrivacyPolicy() async {
    final headers = await BaseRepository.getHeaders(requiresAuth: false);

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.privacyPolicy}'),
        headers: headers,
      ),
      'get privacy policy',
    );
  }
}
