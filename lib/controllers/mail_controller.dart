import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_repository.dart';

class MailController extends GetxController {
  var isLoading = false.obs;
  var mailHistory = [].obs;
  var mailStats = {}.obs;

  // Send email
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.sendEmail(
        to: to,
        subject: subject,
        body: body,
      );

      if (result['success']) {
        Get.snackbar(
          "Email Sent",
          "Email sent successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          "Send Failed",
          result['message'] ?? "Failed to send email",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Send Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Send email with template
  Future<bool> sendEmailWithTemplate({
    required String to,
    required String templateId,
    required Map<String, dynamic> variables,
  }) async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.sendEmailWithTemplate(
        to: to,
        templateId: templateId,
        variables: variables,
      );

      if (result['success']) {
        Get.snackbar(
          "Email Sent",
          "Email sent with template successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          "Send Failed",
          result['message'] ?? "Failed to send email with template",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Send Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get mail history
  Future<void> getMailHistory() async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.getMailHistory();

      if (result['success']) {
        mailHistory.value = result['data'] ?? [];
      } else {
        Get.snackbar(
          "History Failed",
          result['message'] ?? "Failed to get mail history",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "History Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get mail stats
  Future<void> getMailStats() async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.getMailStats();

      if (result['success']) {
        mailStats.value = result['data'] ?? {};
      } else {
        Get.snackbar(
          "Stats Failed",
          result['message'] ?? "Failed to get mail stats",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Stats Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
