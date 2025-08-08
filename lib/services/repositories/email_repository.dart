import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_routes.dart';
import 'base_repository.dart';

class EmailRepository extends BaseRepository {
  // ==================== EMAIL APIs ====================

  static Future<Map<String, dynamic>> sendEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    final headers = await BaseRepository.getHeaders();
    final requestBody = {
      'to': to,
      'subject': subject,
      'body': body,
    };

    return BaseRepository.handleRequest(
      () => http.post(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.sendEmail}'),
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
    final headers = await BaseRepository.getHeaders();
    final body = {
      'to': to,
      'templateId': templateId,
      'variables': variables,
    };

    return BaseRepository.handleRequest(
      () => http.post(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.sendEmailWithTemplate}'),
        headers: headers,
        body: json.encode(body),
      ),
      'send email with template',
    );
  }

  static Future<Map<String, dynamic>> getMailHistory() async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.mailHistory}'),
        headers: headers,
      ),
      'get mail history',
    );
  }

  static Future<Map<String, dynamic>> getMailStats() async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.mailStats}'),
        headers: headers,
      ),
      'get mail stats',
    );
  }
}
