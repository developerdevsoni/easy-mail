import 'package:easy_mail/services/api_service.dart';
import 'package:easy_mail/view/google_login_page.dart';
import 'package:easy_mail/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  // Replace with your actual Web Client ID from Google Cloud Console
  static const String _webClientId =
      '528888226435-qp8r73od0f4tqd20984kgluc16mbvvaj.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/gmail.send'],
    serverClientId: _webClientId, // 👈 Required for serverAuthCode
  );

  var userEmail = ''.obs;
  var userName = ''.obs;
  var accessToken = ''.obs;
  var isLoading = false.obs;
  var photoUrl="".obs;
  Future signOutGoogle() async {
  await _googleSignIn.signOut();
  await Get.to(GoogleLoginPage());
}
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      // Optional: Clear previous session
      await _googleSignIn.signOut();

      // Trigger Google login
      final account = await _googleSignIn.signIn();
      if (account == null) {
        Get.snackbar("Login Cancelled", "User cancelled the login process");
        return;
      }

      final auth = await account.authentication;

      userEmail.value = account.email;
      userName.value = account.displayName ?? '';
      accessToken.value = auth.accessToken ?? '';
      photoUrl.value= account.photoUrl??"";

      final serverAuthCode = account.serverAuthCode;
      print("Server Auth Code: $account  --------------->    ${auth }");

      // ✅ Send auth code to your backend
      if (serverAuthCode != null) {
        final res = await ApiService.saveGoogleUser(
          email: userEmail.value,
          name: userName.value,
          accessToken: accessToken.value,
          serverAuthCode:  account.serverAuthCode.toString(),
          photoUrl: account.photoUrl,
          id: account.id,
        );

        if (res.success == true) {
          Get.snackbar("Login Successful", "Welcome, ${userName.value}");
          isLoading.value = false;
          await Get.to(HomeScreen());
        } else {
          Get.snackbar("Something went wrong", res.success.toString());
          isLoading.value = false;
        }
      }
    } catch (e) {
      print("Login Error: ${e.toString()}");
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendAuthCodeToBackend(String authCode) async {
    const backendUrl =
        'https://your-backend.com/send-email'; // Replace with your backend URL

    final response = await http.post(
      Uri.parse(backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'authCode': authCode,
        'to': 'recipient@example.com',
        'subject': 'Hello from Flutter & Gmail',
        'body': 'This email was sent using Gmail and Google OAuth.',
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar("Email Sent", "Email was sent successfully");
    } else {
      Get.snackbar("Email Error", "Failed to send email: ${response.body}");
    }
  }
}
