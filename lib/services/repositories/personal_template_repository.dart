import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_routes.dart';
import 'base_repository.dart';

class PersonalTemplateRepository extends BaseRepository {
  // ==================== PERSONAL TEMPLATES APIs ====================

  static Future<Map<String, dynamic>> getPersonalTemplates() async {
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.personalTemplates}'),
        headers: headers,
      ),
      'get personal templates',
    );
  }

  static Future<Map<String, dynamic>> createPersonalTemplate({
    required Map<String, dynamic> templateData,
  }) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.post(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.createPersonalTemplate}'),
        headers: headers,
        body: json.encode(templateData),
      ),
      'create personal template',
    );
  }

  static Future<Map<String, dynamic>> getFavoriteTemplates() async {
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.favoriteTemplates}'),
        headers: headers,
      ),
      'get favorite templates',
    );
  }

  static Future<Map<String, dynamic>> getPersonalTemplateById(
      String templateId) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.personalTemplateByIdUrl(templateId)}'),
        headers: headers,
      ),
      'get personal template by id',
    );
  }

  static Future<Map<String, dynamic>> updatePersonalTemplate({
    required String templateId,
    required Map<String, dynamic> templateData,
  }) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.put(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.updatePersonalTemplateUrl(templateId)}'),
        headers: headers,
        body: json.encode(templateData),
      ),
      'update personal template',
    );
  }

  static Future<Map<String, dynamic>> deletePersonalTemplate(
      String templateId) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.delete(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.deletePersonalTemplateUrl(templateId)}'),
        headers: headers,
      ),
      'delete personal template',
    );
  }

  static Future<Map<String, dynamic>> toggleFavorite(String templateId) async {
    final headers = await BaseRepository.getHeaders(requiresAuth: true);

    return BaseRepository.handleRequest(
      () => http.patch(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.toggleFavoriteUrl(templateId)}'),
        headers: headers,
      ),
      'toggle favorite',
    );
  }
}
