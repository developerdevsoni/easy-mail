import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_routes.dart';
import 'base_repository.dart';

class TemplateManagementRepository extends BaseRepository {
  // ==================== TEMPLATE MANAGEMENT APIs ====================

  static Future<Map<String, dynamic>> getTemplates() async {
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.templates}'),
        headers: headers,
      ),
      'get templates',
    );
  }

  static Future<Map<String, dynamic>> addTemplate({
    required Map<String, dynamic> templateData,
  }) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.post(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.addTemplate}'),
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
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.put(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.updateTemplateUrl(id)}'),
        headers: headers,
        body: json.encode(templateData),
      ),
      'update template',
    );
  }

  static Future<Map<String, dynamic>> deleteTemplate(String id) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.delete(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.deleteTemplateUrl(id)}'),
        headers: headers,
      ),
      'delete template',
    );
  }
}
