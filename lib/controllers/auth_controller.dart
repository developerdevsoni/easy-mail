import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/gmail.send'],
  );

  var userEmail = ''.obs;
  var userName = ''.obs;
  var accessToken = ''.obs;
  var isLoading = false.obs;

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      await _googleSignIn.signOut(); // Ensure fresh login
      final account = await _googleSignIn.signIn();

      if (account == null) {
        Get.snackbar("Login Cancelled", "User cancelled the login process");
        return;
      }

      final auth = await account.authentication;

      userEmail.value = account.email;
      userName.value = account.displayName ?? '';
      accessToken.value = auth.accessToken ?? '';

      await ApiService.saveGoogleUser(
        email: account.email,
        name: account.displayName ?? '',
        accessToken: auth.accessToken ?? '',
        idToken: auth.idToken ?? '',
      );

      Get.snackbar("Login Successful", "Welcome, ${userName.value}");
    } catch (e) {
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
