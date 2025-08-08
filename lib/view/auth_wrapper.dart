import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_theme.dart';
import 'google_login_page.dart';
import 'home_screen.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthController authController = Get.put(AuthController());
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      // Check if user is already logged in
      bool isLoggedIn = await authController.isUserLoggedIn();

      // Add a small delay for smooth UX
      await Future.delayed(const Duration(milliseconds: 1500));

      setState(() {
        _isChecking = false;
      });

      // Navigate based on login status
      if (isLoggedIn) {
        // User is logged in, go to home screen
        Get.offAll(() => HomeScreen());
      } else {
        // User needs to login
        Get.offAll(() => const GoogleLoginPage());
      }
    } catch (e) {
      print('Error checking login status: $e');
      setState(() {
        _isChecking = false;
      });
      // On error, show login screen
      Get.offAll(() => const GoogleLoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen while checking authentication
    return Scaffold(
      backgroundColor: AppTheme.surfaceWhite,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.surfaceWhite,
              AppTheme.backgroundGray.withOpacity(0.1),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryBlue,
                      AppTheme.secondaryTeal,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.email_rounded,
                  color: AppTheme.surfaceWhite,
                  size: 50,
                ),
              ),

              const SizedBox(height: 30),

              // App Title
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppTheme.primaryGradient.createShader(bounds),
                child: Text(
                  'Easy Mail',
                  style: AppTheme.heading1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'AI Email Assistant',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 50),

              // Loading Animation
              if (_isChecking) ...[
                Container(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Checking authentication...',
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
