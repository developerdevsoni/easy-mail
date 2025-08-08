import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_routes.dart';
import 'base_repository.dart';

class GlobalTemplateRepository extends BaseRepository {
  // ==================== GLOBAL TEMPLATES APIs ====================

  static Future<Map<String, dynamic>> getGlobalTemplates(
      {int page = 1, int limit = 10}) async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.globalTemplates}?page=$page&limit=$limit'),
        headers: headers,
      ),
      'get global templates',
    );
  }

  static Future<Map<String, dynamic>> getPopularTemplates() async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.popularTemplates}'),
        headers: headers,
      ),
      'get popular templates',
    );
  }

  static Future<Map<String, dynamic>> getTemplatesByCategory(
      String category) async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.get(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.templatesByCategoryUrl(category)}'),
        headers: headers,
      ),
      'get templates by category',
    );
  }

  static Future<Map<String, dynamic>> getGlobalTemplateById(
      String templateId) async {
    final headers = await BaseRepository.getHeaders();

    final response = await BaseRepository.handleRequest(
      () => http.get(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.globalTemplateByIdUrl(templateId)}'),
        headers: headers,
      ),
      'get global template by id',
    );
    return response;
  }

  static Future<Map<String, dynamic>> createGlobalTemplate({
    required Map<String, dynamic> templateData,
  }) async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.post(
        Uri.parse('${BaseRepository.baseUrl}${ApiRoutes.createGlobalTemplate}'),
        headers: headers,
        body: json.encode(templateData),
      ),
      'create global template',
    );
  }

  static Future<Map<String, dynamic>> incrementUsageCount(
      String templateId) async {
    final headers = await BaseRepository.getHeaders();

    return BaseRepository.handleRequest(
      () => http.patch(
        Uri.parse(
            '${BaseRepository.baseUrl}${ApiRoutes.incrementUsageCountUrl(templateId)}'),
        headers: headers,
      ),
      'increment usage count',
    );
  }
}
