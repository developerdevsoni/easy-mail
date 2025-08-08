import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_repository.dart';
import '../view/google_login_page.dart';
import '../view/home_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  var userEmail = ''.obs;
  var userName = ''.obs;
  var photoUrl = ''.obs;
  var isLoggedIn = false.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize the controller but don't auto-check login
    // Login check will be called manually by AuthWrapper
  }

  // Check if user is already logged in (called manually when needed)
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail') ?? '';
    final name = prefs.getString('userName') ?? '';
    final photo = prefs.getString('photoUrl') ?? '';
    final token = prefs.getString('accessToken') ?? '';

    if (email.isNotEmpty && name.isNotEmpty && token.isNotEmpty) {
      userEmail.value = email;
      userName.value = name;
      photoUrl.value = photo;
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
      // Clear any incomplete data
      await clearUserData();
    }
  }

  // Manual login check - call this when you want to check login status
  Future<bool> isUserLoggedIn() async {
    await checkLoginStatus();
    return isLoggedIn.value;
  }

  // Email/Password Registration
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.register(
        email: email,
        password: password,
        name: name,
      );

      if (result['success']) {
        Get.snackbar(
          "Registration Successful",
          "Account created successfully!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Navigate to login or home screen
      } else {
        Get.snackbar(
          "Registration Failed",
          result['message'] ?? "Failed to register",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Registration Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Email/Password Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.login(
        email: email,
        password: password,
      );

      if (result['success']) {
        // Save user data and token locally
        await _saveUserDataLocally(result['data']);

        // Save access token if available
        if (result['data']['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', result['data']['token']);
        }

        Get.snackbar(
          "Login Successful",
          "Welcome back!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar(
          "Login Failed",
          result['message'] ?? "Invalid credentials",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Login Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign-In with Firebase
  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        isLoading.value = false;
        Get.snackbar("Login Cancelled", "User cancelled the login");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google [UserCredential]
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        // Try to save user to backend first
        try {
          final res = await ApiRepository.storeGoogleUser(
            googleId: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? '',
            photoUrl: user.photoURL,
          );
          print("token------->: ${res['data']['data']['token']}");
          await prefs.setString('accessToken', res['data']['data']['token']);
          if (res['success'] == true) {
            // Save user data from backend response
            if (res['data'] != null && res['data']['user'] != null) {
              final userData = res['data']['user'];
              userEmail.value = userData['email'] ?? user.email ?? '';
              userName.value = userData['name'] ?? user.displayName ?? '';
              photoUrl.value = userData['photoUrl'] ?? user.photoURL ?? '';
            } else {
              // Fallback to Firebase user data
              userEmail.value = user.email ?? '';
              userName.value = user.displayName ?? '';
              photoUrl.value = user.photoURL ?? '';
            }

            isLoggedIn.value = true;
            await saveUserData();

            Get.snackbar(
              "Login Success",
              "Welcome ${userName.value}",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            // Navigate to home screen only on successful login
            Get.offAll(() => HomeScreen());
          } else {
            // Backend sync failed - don't save user data locally
            await _handleFailedLogin();

            Get.snackbar(
              "Login Failed",
              "Server authentication failed. Please try again.",
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } catch (e) {
          // Backend sync failed - don't save user data locally
          await _handleFailedLogin();

          Get.snackbar(
            "Login Failed",
            "Server connection failed. Please check your internet connection and try again.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        await _handleFailedLogin();

        Get.snackbar(
          "Login Failed",
          "Could not retrieve user data from Google",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Handle Firebase authentication errors
      await _handleFailedLogin();

      Get.snackbar(
        "Login Error",
        "Authentication failed: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign-In with Token (Alternative method)
  Future<void> loginWithGoogleToken(String idToken) async {
    try {
      isLoading.value = true;

      final result = await ApiRepository.loginWithGoogleToken(
        idToken: idToken,
      );

      if (result['success']) {
        await _saveUserDataLocally(result['data']);
        Get.snackbar(
          "Login Successful",
          "Welcome back!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar(
          "Login Failed",
          result['message'] ?? "Google login failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Login Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Call backend logout
      await ApiRepository.logout();

      // Sign out from Firebase and Google
      await _googleSignIn.signOut();
      await _auth.signOut();

      // Clear local data
      await clearUserData();

      Get.snackbar(
        "Logout Successful",
        "You have been logged out",
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );

      // Navigate back to auth wrapper for proper routing
      Get.offAll(() => const GoogleLoginPage());
    } catch (e) {
      Get.snackbar(
        "Logout Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final result = await ApiRepository.getProfile();
      return result['success'] ? result['data'] : null;
    } catch (e) {
      return null;
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final result = await ApiRepository.updateProfile(
        profileData: profileData,
      );

      if (result['success']) {
        Get.snackbar(
          "Profile Updated",
          "Profile updated successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          "Update Failed",
          result['message'] ?? "Failed to update profile",
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
    }
  }

  // Helper method to save user data locally
  Future<void> _saveUserDataLocally(Map<String, dynamic> userData) async {
    userEmail.value = userData['email'] ?? '';
    userName.value = userData['name'] ?? '';
    photoUrl.value = userData['photoUrl'] ?? '';
    isLoggedIn.value = true;
    await saveUserData();
  }

  // Helper method to handle failed login cleanup
  Future<void> _handleFailedLogin() async {
    // Ensure Firebase and Google are signed out
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {}

    // Clear any partial user data
    userEmail.value = '';
    userName.value = '';
    photoUrl.value = '';
    isLoggedIn.value = false;
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', userEmail.value);
    await prefs.setString('userName', userName.value);
    await prefs.setString('photoUrl', photoUrl.value);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    // Clear specific keys instead of all data
    await prefs.remove('userEmail');
    await prefs.remove('userName');
    await prefs.remove('photoUrl');
    await prefs.remove('accessToken');

    userEmail.value = '';
    userName.value = '';
    photoUrl.value = '';
    isLoggedIn.value = false;
  }
}
