import 'package:easy_mail/services/api_service.dart';
import 'package:easy_mail/view/google_login_page.dart';
import 'package:easy_mail/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  var photoUrl = "".obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    print("🚀 AuthController initialized");
    
    // 🚧 DEVELOPMENT BYPASS: Skip authentication check and set test data
    // TODO: Remove this bypass for production
    print("🚧 DEVELOPMENT MODE: Bypassing authentication");
    setTestUserData();
    
    // checkLoginStatus(); // 👈 ORIGINAL CODE - UNCOMMENT FOR PRODUCTION
  }

  Future<void> checkLoginStatus() async {
    try {
      print("Checking login status...");
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('userEmail') ?? '';
      final name = prefs.getString('userName') ?? '';
      final photo = prefs.getString('photoUrl') ?? '';
      final token = prefs.getString('accessToken') ?? '';
      
      print("Loaded from SharedPreferences:");
      print("  Email: '$email' (${email.isEmpty ? 'EMPTY' : 'OK'})");
      print("  Name: '$name' (${name.isEmpty ? 'EMPTY' : 'OK'})");
      print("  Photo: '$photo' (${photo.isEmpty ? 'EMPTY' : 'OK'})");
      print("  Token: '$token' (${token.isEmpty ? 'EMPTY' : 'OK'})");
      
      if (email.isNotEmpty && name.isNotEmpty) {
        userEmail.value = email;
        userName.value = name;
        photoUrl.value = photo;
        accessToken.value = token;
        isLoggedIn.value = true;
        
        print("✅ User already logged in: $name ($email)");
        print("Navigating to HomeScreen...");
        // Get.off(() => HomeScreen()); // 👈 COMMENTED FOR DEVELOPMENT BYPASS
      } else {
        print("❌ No valid user data found - staying on login page");
        isLoggedIn.value = false;
      }
    } catch (e) {
      print("❌ Error checking login status: $e");
      isLoggedIn.value = false;
    }
  }

  Future<void> saveUserData() async {
    try {
      print("💾 Saving user data to SharedPreferences...");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', userEmail.value);
      await prefs.setString('userName', userName.value);
      await prefs.setString('photoUrl', photoUrl.value);
      await prefs.setString('accessToken', accessToken.value);
      
      print("✅ User data saved successfully:");
      print("  - Email: '${userEmail.value}'");
      print("  - Name: '${userName.value}'");
      print("  - Photo: '${photoUrl.value}'");
      print("  - Token: '${accessToken.value.length > 10 ? '${accessToken.value.substring(0, 10)}...' : accessToken.value}'");
    } catch (e) {
      print("❌ Error saving user data: $e");
    }
  }

  Future<void> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      userEmail.value = '';
      userName.value = '';
      photoUrl.value = '';
      accessToken.value = '';
      isLoggedIn.value = false;
      print("User data cleared successfully");
    } catch (e) {
      print("Error clearing user data: $e");
    }
  }

  Future signOutGoogle() async {
    await _googleSignIn.signOut();
    await clearUserData();
    Get.offAll(() => GoogleLoginPage());
  }

  // Debug method to test with sample data
  void setTestUserData() {
    userEmail.value = "test@example.com";
    userName.value = "Test User";
    photoUrl.value = "";
    accessToken.value = "test_token";
    isLoggedIn.value = true;
    
    print("🧪 Test user data set:");
    print("  - Email: ${userEmail.value}");
    print("  - Name: ${userName.value}");
    print("  - Photo: ${photoUrl.value}");
    print("  - Is logged in: ${isLoggedIn.value}");
    
    // Also save test data to SharedPreferences
    saveUserData();
  }

  // Method to manually refresh user data from SharedPreferences
  Future<void> refreshUserData() async {
    print("🔄 Manually refreshing user data...");
    await checkLoginStatus();
  }

  // Method to check if user data is valid
  bool isUserDataValid() {
    final isValid = userEmail.value.isNotEmpty && 
                   userName.value.isNotEmpty && 
                   isLoggedIn.value;
    
    print("🔍 User data validation:");
    print("  - Email valid: ${userEmail.value.isNotEmpty} ('${userEmail.value}')");
    print("  - Name valid: ${userName.value.isNotEmpty} ('${userName.value}')");
    print("  - Logged in: ${isLoggedIn.value}");
    print("  - Overall valid: $isValid");
    
    return isValid;
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
      photoUrl.value = account.photoUrl ?? "";

      final serverAuthCode = account.serverAuthCode;
      print("Login successful - User: ${userName.value} (${userEmail.value})");
      print("Server Auth Code: $serverAuthCode");

      // Save user data locally first
      await saveUserData();
      isLoggedIn.value = true;

      // ✅ Send auth code to your backend
      if (serverAuthCode != null) {
        try {
          final res = await ApiService.saveGoogleUser(
            email: userEmail.value,
            name: userName.value,
            accessToken: accessToken.value,
            serverAuthCode: serverAuthCode,
            photoUrl: account.photoUrl,
            id: account.id,
          );

          if (res.success == true) {
            Get.snackbar(
              "Login Successful", 
              "Welcome back, ${userName.value}!",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            isLoading.value = false;
            Get.offAll(() => HomeScreen());
          } else {
            Get.snackbar(
              "Backend Error", 
              "Login successful but server sync failed: ${res.message ?? 'Unknown error'}",
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            isLoading.value = false;
            // Still navigate to home since local login was successful
            Get.offAll(() => HomeScreen());
          }
        } catch (e) {
          print("Backend API Error: $e");
          Get.snackbar(
            "Backend Connection Error", 
            "Login successful but couldn't sync with server. You can still use the app.",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          isLoading.value = false;
          // Still navigate to home since local login was successful
          Get.offAll(() => HomeScreen());
        }
      } else {
        // No server auth code, but still proceed with local login
        Get.snackbar(
          "Login Successful", 
          "Welcome, ${userName.value}!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        isLoading.value = false;
        Get.offAll(() => HomeScreen());
      }
    } catch (e) {
      print("Login Error: ${e.toString()}");
      Get.snackbar(
        "Login Error", 
        "Failed to login: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.offAll(() => HomeScreen());
      // Don't navigate to HomeScreen on error - stay on login page
    } finally {
      Get.offAll(() => HomeScreen());
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
