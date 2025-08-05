import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_routes.dart';
import '../model/saveGoogleUser_modal.dart';

class ApiRepository {
  static const String baseUrl = ApiRoutes.baseUrl;

  // Helper method to get auth token
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Helper method to create headers
  static Future<Map<String, String>> _getHeaders(
      {bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // Helper method to handle HTTP requests
  static Future<Map<String, dynamic>> _handleRequest(
    Future<http.Response> Function() request,
    String operation,
  ) async {
    try {
      print("🔄 API: Starting $operation...");
      final response = await request();

      print("📡 API Response Status: ${response.statusCode}");
      print("📄 API Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = json.decode(response.body);
        print("✅ API: $operation successful");
        return {
          'success': true,
          'data': jsonResponse,
          'message': 'Success',
        };
      } else {
        print("❌ API: $operation failed with status ${response.statusCode}");
        return {
          'success': false,
          'data': null,
          'message': 'Request failed: ${response.statusCode}',
          'error': response.body,
        };
      }
    } catch (e) {
      print("❌ API Error in $operation: $e");
      return {
        'success': false,
        'data': null,
        'message': 'Network error: $e',
        'error': e.toString(),
      };
    }
  }

  // ==================== AUTHENTICATION APIs ====================

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final headers = await _getHeaders(requiresAuth: false);
    final body = {
      'email': email,
      'password': password,
      'name': name,
    };

    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl${ApiRoutes.register}'),
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
    final headers = await _getHeaders(requiresAuth: false);
    final body = {
      'email': email,
      'password': password,
    };

    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl${ApiRoutes.login}'),
        headers: headers,
        body: json.encode(body),
      ),
      'login',
    );
  }

  static Future<Map<String, dynamic>> loginWithGoogleToken({
    required String idToken,
  }) async {
    final headers = await _getHeaders(requiresAuth: false);
    final body = {
      'idToken': idToken,
    };

    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl${ApiRoutes.googleLogin}'),
        headers: headers,
        body: json.encode(body),
      ),
      'Google login',
    );
  }

  static Future<Map<String, dynamic>> logout() async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl${ApiRoutes.logout}'),
        headers: headers,
      ),
      'logout',
    );
  }

  static Future<Map<String, dynamic>> getProfile() async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.profile}'),
        headers: headers,
      ),
      'get profile',
    );
  }

  static Future<Map<String, dynamic>> updateProfile({
    required Map<String, dynamic> profileData,
  }) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.put(
        Uri.parse('$baseUrl${ApiRoutes.updateProfile}'),
        headers: headers,
        body: json.encode(profileData),
      ),
      'update profile',
    );
  }

  // ==================== USER APIs ====================

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
      final headers = await _getHeaders(requiresAuth: false);

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
        Uri.parse('$baseUrl${ApiRoutes.saveGoogleUser}'),
        headers: headers,
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
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.getUserByEmailUrl(email)}'),
        headers: headers,
      ),
      'get user by email',
    );
  }

  static Future<Map<String, dynamic>> getPrivacyPolicy() async {
    final headers = await _getHeaders(requiresAuth: false);

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.privacyPolicy}'),
        headers: headers,
      ),
      'get privacy policy',
    );
  }

  // ==================== EMAIL APIs ====================

  static Future<Map<String, dynamic>> sendEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    final headers = await _getHeaders();
    final requestBody = {
      'to': to,
      'subject': subject,
      'body': body,
    };

    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl${ApiRoutes.sendEmail}'),
        headers: headers,
        body: json.encode(requestBody),
      ),
      'send email',
    );
  }

  static Future<Map<String, dynamic>> sendEmailWithTemplate({
    required String to,
    required String templateId,
    required Map<String, dynamic> variables,
  }) async {
    final headers = await _getHeaders();
    final body = {
      'to': to,
      'templateId': templateId,
      'variables': variables,
    };

    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl${ApiRoutes.sendEmailWithTemplate}'),
        headers: headers,
        body: json.encode(body),
      ),
      'send email with template',
    );
  }

  static Future<Map<String, dynamic>> getMailHistory() async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.mailHistory}'),
        headers: headers,
      ),
      'get mail history',
    );
  }

  static Future<Map<String, dynamic>> getMailStats() async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.mailStats}'),
        headers: headers,
      ),
      'get mail stats',
    );
  }

  // ==================== GLOBAL TEMPLATES APIs ====================

  static Future<Map<String, dynamic>> getGlobalTemplates() async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.globalTemplates}'),
        headers: headers,
      ),
      'get global templates',
    );
  }

  static Future<Map<String, dynamic>> getPopularTemplates() async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.popularTemplates}'),
        headers: headers,
      ),
      'get popular templates',
    );
  }

  static Future<Map<String, dynamic>> getTemplatesByCategory(
      String category) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.templatesByCategoryUrl(category)}'),
        headers: headers,
      ),
      'get templates by category',
    );
  }

  static Future<Map<String, dynamic>> getGlobalTemplateById(
      String templateId) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.globalTemplateByIdUrl(templateId)}'),
        headers: headers,
      ),
      'get global template by id',
    );
  }

  static Future<Map<String, dynamic>> createGlobalTemplate({
    required Map<String, dynamic> templateData,
  }) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl${ApiRoutes.createGlobalTemplate}'),
        headers: headers,
        body: json.encode(templateData),
      ),
      'create global template',
    );
  }

  static Future<Map<String, dynamic>> incrementUsageCount(
      String templateId) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.patch(
        Uri.parse('$baseUrl${ApiRoutes.incrementUsageCountUrl(templateId)}'),
        headers: headers,
      ),
      'increment usage count',
    );
  }

  // ==================== PERSONAL TEMPLATES APIs ====================

  static Future<Map<String, dynamic>> getPersonalTemplates() async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.personalTemplates}'),
        headers: headers,
      ),
      'get personal templates',
    );
  }

  static Future<Map<String, dynamic>> createPersonalTemplate({
    required Map<String, dynamic> templateData,
  }) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl${ApiRoutes.createPersonalTemplate}'),
        headers: headers,
        body: json.encode(templateData),
      ),
      'create personal template',
    );
  }

  static Future<Map<String, dynamic>> getFavoriteTemplates() async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.favoriteTemplates}'),
        headers: headers,
      ),
      'get favorite templates',
    );
  }

  static Future<Map<String, dynamic>> getPersonalTemplateById(
      String templateId) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.personalTemplateByIdUrl(templateId)}'),
        headers: headers,
      ),
      'get personal template by id',
    );
  }

  static Future<Map<String, dynamic>> updatePersonalTemplate({
    required String templateId,
    required Map<String, dynamic> templateData,
  }) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.put(
        Uri.parse('$baseUrl${ApiRoutes.updatePersonalTemplateUrl(templateId)}'),
        headers: headers,
        body: json.encode(templateData),
      ),
      'update personal template',
    );
  }

  static Future<Map<String, dynamic>> deletePersonalTemplate(
      String templateId) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.delete(
        Uri.parse('$baseUrl${ApiRoutes.deletePersonalTemplateUrl(templateId)}'),
        headers: headers,
      ),
      'delete personal template',
    );
  }

  static Future<Map<String, dynamic>> toggleFavorite(String templateId) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.patch(
        Uri.parse('$baseUrl${ApiRoutes.toggleFavoriteUrl(templateId)}'),
        headers: headers,
      ),
      'toggle favorite',
    );
  }

  // ==================== TEMPLATE MANAGEMENT APIs ====================

  static Future<Map<String, dynamic>> getTemplates() async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.get(
        Uri.parse('$baseUrl${ApiRoutes.templates}'),
        headers: headers,
      ),
      'get templates',
    );
  }

  static Future<Map<String, dynamic>> addTemplate({
    required Map<String, dynamic> templateData,
  }) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.post(
        Uri.parse('$baseUrl${ApiRoutes.addTemplate}'),
        headers: headers,
        body: json.encode(templateData),
      ),
      'add template',
    );
  }

  static Future<Map<String, dynamic>> updateTemplate({
    required String id,
    required Map<String, dynamic> templateData,
  }) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.put(
        Uri.parse('$baseUrl${ApiRoutes.updateTemplateUrl(id)}'),
        headers: headers,
        body: json.encode(templateData),
      ),
      'update template',
    );
  }

  static Future<Map<String, dynamic>> deleteTemplate(String id) async {
    final headers = await _getHeaders();

    return _handleRequest(
      () => http.delete(
        Uri.parse('$baseUrl${ApiRoutes.deleteTemplateUrl(id)}'),
        headers: headers,
      ),
      'delete template',
    );
  }
}
