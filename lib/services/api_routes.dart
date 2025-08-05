class ApiRoutes {
  // Base URL
  static const String baseUrl = "https://lp4wn4z5-3000.inc1.devtunnels.ms";

  // Auth Routes
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String googleLogin = "/auth/google";
  static const String googleCallback = "/auth/google/callback";
  static const String logout = "/auth/logout";
  static const String profile = "/auth/profile";
  static const String updateProfile = "/auth/profile";

  // User Routes
  static const String saveGoogleUser = "/api/users/save-google-user";
  static const String getUserByEmail = "/api/users/me";
  static const String privacyPolicy = "/api/users/privacy-Policy";

  // Email Routes
  static const String sendEmail = "/api/mail/send";
  static const String sendEmailWithTemplate = "/api/mail/send-with-template";
  static const String mailHistory = "/api/mail/history";
  static const String mailStats = "/api/mail/stats";

  // Global Templates Routes
  static const String globalTemplates = "/api/templates";
  static const String popularTemplates = "/api/templates/popular";
  static const String templatesByCategory = "/api/templates/category";
  static const String globalTemplateById = "/api/templates";
  static const String createGlobalTemplate = "/api/templates";
  static const String incrementUsageCount = "/api/templates";

  // Personal Templates Routes
  static const String personalTemplates = "/api/personal-templates";
  static const String createPersonalTemplate = "/api/personal-templates";
  static const String favoriteTemplates = "/api/personal-templates/favorites";
  static const String personalTemplateById = "/api/personal-templates";
  static const String updatePersonalTemplate = "/api/personal-templates";
  static const String deletePersonalTemplate = "/api/personal-templates";
  static const String toggleFavorite = "/api/personal-templates";

  // Template Management Routes
  static const String templates = "/api/template-management";
  static const String addTemplate = "/api/template-management";
  static const String updateTemplate = "/api/template-management";
  static const String deleteTemplate = "/api/template-management";

  // Helper methods to build URLs with parameters
  static String getUserByEmailUrl(String email) => "$getUserByEmail/$email";
  static String templatesByCategoryUrl(String category) =>
      "$templatesByCategory/$category";
  static String globalTemplateByIdUrl(String templateId) =>
      "$globalTemplateById/$templateId";
  static String incrementUsageCountUrl(String templateId) =>
      "$incrementUsageCount/$templateId/usage";
  static String personalTemplateByIdUrl(String templateId) =>
      "$personalTemplateById/$templateId";
  static String updatePersonalTemplateUrl(String templateId) =>
      "$updatePersonalTemplate/$templateId";
  static String deletePersonalTemplateUrl(String templateId) =>
      "$deletePersonalTemplate/$templateId";
  static String toggleFavoriteUrl(String templateId) =>
      "$toggleFavorite/$templateId/favorite";
  static String updateTemplateUrl(String id) => "$updateTemplate/$id";
  static String deleteTemplateUrl(String id) => "$deleteTemplate/$id";
}
