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
    // Removed automatic login check - users must explicitly login
    print("🚀 AuthController initialized - No automatic login");
  }

  // Check if user is already logged in (called manually when needed)
  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userEmail') ?? '';
    final name = prefs.getString('userName') ?? '';
    final photo = prefs.getString('photoUrl') ?? '';

    if (email.isNotEmpty && name.isNotEmpty) {
      userEmail.value = email;
      userName.value = name;
      photoUrl.value = photo;
      isLoggedIn.value = true;
      print("✅ User found in local storage: $name ($email)");
    } else {
      print("❌ No user data found in local storage");
      isLoggedIn.value = false;
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
        // Save user data locally
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
        // Save user data locally
        userEmail.value = user.email ?? '';
        userName.value = user.displayName ?? '';
        photoUrl.value = user.photoURL ?? '';
        isLoggedIn.value = true;
        await saveUserData();

        // Try to save user to backend
        try {
          final res = await ApiRepository.saveGoogleUser(
            email: userEmail.value,
            name: userName.value,
            accessToken: googleAuth.accessToken ?? '',
            serverAuthCode: googleUser.serverAuthCode ?? '',
            photoUrl: user.photoURL,
            id: user.uid,
          );

          if (res.success == true) {
            Get.snackbar(
              "Login Success",
              "Welcome ${userName.value}",
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } else {
            Get.snackbar(
              "Login Success",
              "Welcome ${userName.value} (Offline mode)",
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
          }
        } catch (e) {
          print("Backend sync failed: $e");
          Get.snackbar(
            "Login Success",
            "Welcome ${userName.value} (Offline mode)",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }

        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar(
          "Login Failed",
          "Could not retrieve user data",
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

      Get.offAll(() => GoogleLoginPage());
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
      print("Error getting profile: $e");
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

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', userEmail.value);
    await prefs.setString('userName', userName.value);
    await prefs.setString('photoUrl', photoUrl.value);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    userEmail.value = '';
    userName.value = '';
    photoUrl.value = '';
    isLoggedIn.value = false;
  }
}
