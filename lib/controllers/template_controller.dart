import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_repository.dart';

class TemplateController extends GetxController {
  var isLoading = false.obs;
  var globalTemplates = [].obs;
  var personalTemplates = [].obs;
  var favoriteTemplates = [].obs;
  var popularTemplates = [].obs;

  // ==================== GLOBAL TEMPLATES ====================

  // Get all global templates
  Future<void> getGlobalTemplates() async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.getGlobalTemplates();

      if (result['success']) {
        globalTemplates.value = result['data'] ?? [];
      } else {
        Get.snackbar(
          "Templates Failed",
          result['message'] ?? "Failed to get global templates",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Templates Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get popular templates
  Future<void> getPopularTemplates() async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.getPopularTemplates();

      if (result['success']) {
        popularTemplates.value = result['data'] ?? [];
      } else {
        Get.snackbar(
          "Popular Failed",
          result['message'] ?? "Failed to get popular templates",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Popular Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get templates by category
  Future<void> getTemplatesByCategory(String category) async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.getTemplatesByCategory(category);

      if (result['success']) {
        globalTemplates.value = result['data'] ?? [];
      } else {
        Get.snackbar(
          "Category Failed",
          result['message'] ?? "Failed to get templates by category",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Category Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get global template by ID
  Future<Map<String, dynamic>?> getGlobalTemplateById(String templateId) async {
    try {
      final result = await ApiRepository.getGlobalTemplateById(templateId);

      if (result['success']) {
        return result['data'];
      } else {
        Get.snackbar(
          "Template Failed",
          result['message'] ?? "Failed to get template",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        "Template Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  // Create global template
  Future<bool> createGlobalTemplate(Map<String, dynamic> templateData) async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.createGlobalTemplate(
        templateData: templateData,
      );

      if (result['success']) {
        Get.snackbar(
          "Template Created",
          "Global template created successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          "Create Failed",
          result['message'] ?? "Failed to create global template",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Create Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Increment usage count
  Future<bool> incrementUsageCount(String templateId) async {
    try {
      final result = await ApiRepository.incrementUsageCount(templateId);

      if (result['success']) {
        return true;
      } else {
        print("Failed to increment usage count: ${result['message']}");
        return false;
      }
    } catch (e) {
      print("Error incrementing usage count: $e");
      return false;
    }
  }

  // ==================== PERSONAL TEMPLATES ====================

  // Get personal templates
  Future<void> getPersonalTemplates() async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.getPersonalTemplates();

      if (result['success']) {
        personalTemplates.value = result['data'] ?? [];
      } else {
        Get.snackbar(
          "Personal Failed",
          result['message'] ?? "Failed to get personal templates",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Personal Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Create personal template
  Future<bool> createPersonalTemplate(Map<String, dynamic> templateData) async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.createPersonalTemplate(
        templateData: templateData,
      );

      if (result['success']) {
        Get.snackbar(
          "Template Created",
          "Personal template created successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Refresh personal templates
        await getPersonalTemplates();
        return true;
      } else {
        Get.snackbar(
          "Create Failed",
          result['message'] ?? "Failed to create personal template",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Create Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get favorite templates
  Future<void> getFavoriteTemplates() async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.getFavoriteTemplates();

      if (result['success']) {
        favoriteTemplates.value = result['data'] ?? [];
      } else {
        Get.snackbar(
          "Favorites Failed",
          result['message'] ?? "Failed to get favorite templates",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Favorites Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get personal template by ID
  Future<Map<String, dynamic>?> getPersonalTemplateById(
      String templateId) async {
    try {
      final result = await ApiRepository.getPersonalTemplateById(templateId);

      if (result['success']) {
        return result['data'];
      } else {
        Get.snackbar(
          "Template Failed",
          result['message'] ?? "Failed to get personal template",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        "Template Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  // Update personal template
  Future<bool> updatePersonalTemplate({
    required String templateId,
    required Map<String, dynamic> templateData,
  }) async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.updatePersonalTemplate(
        templateId: templateId,
        templateData: templateData,
      );

      if (result['success']) {
        Get.snackbar(
          "Template Updated",
          "Personal template updated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Refresh personal templates
        await getPersonalTemplates();
        return true;
      } else {
        Get.snackbar(
          "Update Failed",
          result['message'] ?? "Failed to update personal template",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Update Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete personal template
  Future<bool> deletePersonalTemplate(String templateId) async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.deletePersonalTemplate(templateId);

      if (result['success']) {
        Get.snackbar(
          "Template Deleted",
          "Personal template deleted successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Refresh personal templates
        await getPersonalTemplates();
        return true;
      } else {
        Get.snackbar(
          "Delete Failed",
          result['message'] ?? "Failed to delete personal template",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Delete Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle favorite
  Future<bool> toggleFavorite(String templateId) async {
    try {
      final result = await ApiRepository.toggleFavorite(templateId);

      if (result['success']) {
        Get.snackbar(
          "Favorite Updated",
          "Favorite status updated successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Refresh favorite templates
        await getFavoriteTemplates();
        return true;
      } else {
        Get.snackbar(
          "Favorite Failed",
          result['message'] ?? "Failed to update favorite status",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Favorite Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }
}
