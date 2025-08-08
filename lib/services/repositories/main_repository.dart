import 'auth_repository.dart';
import 'email_repository.dart';
import 'global_template_repository.dart';
import 'personal_template_repository.dart';
import 'template_management_repository.dart';
import '../../model/saveGoogleUser_modal.dart';

/// Main repository that coordinates all service repositories
/// Provides a unified interface for all API operations
class MainRepository {
  // ==================== AUTHENTICATION APIs ====================

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    return AuthRepository.register(
      email: email,
      password: password,
      name: name,
    );
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return AuthRepository.login(
      email: email,
      password: password,
    );
  }

  static Future<Map<String, dynamic>> loginWithGoogleToken({
    required String idToken,
  }) async {
    return AuthRepository.loginWithGoogleToken(idToken: idToken);
  }

  static Future<Map<String, dynamic>> storeGoogleUser({
    required String googleId,
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    return AuthRepository.storeGoogleUser(
      googleId: googleId,
      email: email,
      name: name,
      photoUrl: photoUrl,
    );
  }

  static Future<Map<String, dynamic>> logout() async {
    return AuthRepository.logout();
  }

  static Future<Map<String, dynamic>> getProfile() async {
    return AuthRepository.getProfile();
  }

  static Future<Map<String, dynamic>> updateProfile({
    required Map<String, dynamic> profileData,
  }) async {
    return AuthRepository.updateProfile(profileData: profileData);
  }

  static Future<saveGoogleUser_modal> saveGoogleUser({
    required String email,
    required String name,
    required String accessToken,
    required String serverAuthCode,
    String? photoUrl,
    String? id,
  }) async {
    return AuthRepository.saveGoogleUser(
      email: email,
      name: name,
      accessToken: accessToken,
      serverAuthCode: serverAuthCode,
      photoUrl: photoUrl,
      id: id,
    );
  }

  static Future<Map<String, dynamic>> getUserByEmail(String email) async {
    return AuthRepository.getUserByEmail(email);
  }

  static Future<Map<String, dynamic>> getPrivacyPolicy() async {
    return AuthRepository.getPrivacyPolicy();
  }

  // ==================== EMAIL APIs ====================

  static Future<Map<String, dynamic>> sendEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    return EmailRepository.sendEmail(
      to: to,
      subject: subject,
      body: body,
    );
  }

  static Future<Map<String, dynamic>> sendEmailWithTemplate({
    required String to,
    required String templateId,
    required Map<String, dynamic> variables,
  }) async {
    return EmailRepository.sendEmailWithTemplate(
      to: to,
      templateId: templateId,
      variables: variables,
    );
  }

  static Future<Map<String, dynamic>> getMailHistory() async {
    return EmailRepository.getMailHistory();
  }

  static Future<Map<String, dynamic>> getMailStats() async {
    return EmailRepository.getMailStats();
  }

  // ==================== GLOBAL TEMPLATES APIs ====================

  static Future<Map<String, dynamic>> getGlobalTemplates() async {
    return GlobalTemplateRepository.getGlobalTemplates();
  }

  static Future<Map<String, dynamic>> getPopularTemplates() async {
    return GlobalTemplateRepository.getPopularTemplates();
  }

  static Future<Map<String, dynamic>> getTemplatesByCategory(
      String category) async {
    return GlobalTemplateRepository.getTemplatesByCategory(category);
  }

  static Future<Map<String, dynamic>> getGlobalTemplateById(
      String templateId) async {
    return GlobalTemplateRepository.getGlobalTemplateById(templateId);
  }

  static Future<Map<String, dynamic>> createGlobalTemplate({
    required Map<String, dynamic> templateData,
  }) async {
    return GlobalTemplateRepository.createGlobalTemplate(
        templateData: templateData);
  }

  static Future<Map<String, dynamic>> incrementUsageCount(
      String templateId) async {
    return GlobalTemplateRepository.incrementUsageCount(templateId);
  }

  // ==================== PERSONAL TEMPLATES APIs ====================

  static Future<Map<String, dynamic>> getPersonalTemplates() async {
    return PersonalTemplateRepository.getPersonalTemplates();
  }

  static Future<Map<String, dynamic>> createPersonalTemplate({
    required Map<String, dynamic> templateData,
  }) async {
    return PersonalTemplateRepository.createPersonalTemplate(
        templateData: templateData);
  }

  static Future<Map<String, dynamic>> getFavoriteTemplates() async {
    return PersonalTemplateRepository.getFavoriteTemplates();
  }

  static Future<Map<String, dynamic>> getPersonalTemplateById(
      String templateId) async {
    return PersonalTemplateRepository.getPersonalTemplateById(templateId);
  }

  static Future<Map<String, dynamic>> updatePersonalTemplate({
    required String templateId,
    required Map<String, dynamic> templateData,
  }) async {
    return PersonalTemplateRepository.updatePersonalTemplate(
      templateId: templateId,
      templateData: templateData,
    );
  }

  static Future<Map<String, dynamic>> deletePersonalTemplate(
      String templateId) async {
    return PersonalTemplateRepository.deletePersonalTemplate(templateId);
  }

  static Future<Map<String, dynamic>> toggleFavorite(String templateId) async {
    return PersonalTemplateRepository.toggleFavorite(templateId);
  }

  // ==================== TEMPLATE MANAGEMENT APIs ====================

  static Future<Map<String, dynamic>> getTemplates() async {
    return TemplateManagementRepository.getTemplates();
  }

  static Future<Map<String, dynamic>> addTemplate({
    required Map<String, dynamic> templateData,
  }) async {
    return TemplateManagementRepository.addTemplate(templateData: templateData);
  }

  static Future<Map<String, dynamic>> updateTemplate({
    required String id,
    required Map<String, dynamic> templateData,
  }) async {
    return TemplateManagementRepository.updateTemplate(
      id: id,
      templateData: templateData,
    );
  }

  static Future<Map<String, dynamic>> deleteTemplate(String id) async {
    return TemplateManagementRepository.deleteTemplate(id);
  }
}
