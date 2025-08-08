import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../api_routes.dart';

abstract class BaseRepository {
  static const String baseUrl = ApiRoutes.baseUrl;

  // Helper method to get auth token
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    print("🔑 Auth Token: ${prefs.getString('accessToken')}");
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

  // Protected getters for subclasses to use
  static Future<Map<String, String>> getHeaders({bool requiresAuth = true}) {
    return _getHeaders(requiresAuth: requiresAuth);
  }

  static Future<Map<String, dynamic>> handleRequest(
    Future<http.Response> Function() request,
    String operation,
  ) {
    return _handleRequest(request, operation);
  }
}
