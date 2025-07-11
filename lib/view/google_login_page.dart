import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:easy_mail/view/home_screen.dart';

class GoogleLoginPage extends StatelessWidget {
  const GoogleLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: CosmicBackgroundDecoration(
        showStars: true,
        showPlanets: true,
        child: Stack(
          children: [
            // Cosmic gradient overlays
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  colors: [
                    AppTheme.textPrimary.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
                  colors: [
                    AppTheme.textPrimary.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 32.h),
                      
                      // Combined Login Card
                      CosmicCard(
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            children: [
                              // App Logo/Title
                              Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppTheme.primaryGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryPurple.withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.email_outlined,
                                  size: 32.sp,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'Easy Mail',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Your AI-powered email assistant',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              SizedBox(height: 24.h),
                              
                              // Login Form
                              Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Sign in to continue using Easy Mail',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              
                              SizedBox(height: 20.h),
                              
                              // Google Sign In Button
                              GetX<AuthController>(
                                builder: (controller) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: CosmicGradientButton(
                                      onPressed: controller.isLoading.value
                                          ? () {}
                                          : () => controller.loginWithGoogle(),
                                      text: controller.isLoading.value
                                          ? 'Signing in...'
                                          : 'Continue with Google',
                                      icon: controller.isLoading.value
                                          ? null
                                          : Icons.login,
                                    ),
                                  );
                                },
                              ),
                              
                              SizedBox(height: 20.h),
                              
                              // Features Preview
                              Divider(
                                color: AppTheme.textSecondary.withOpacity(0.2),
                                thickness: 1,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'What you get with Easy Mail:',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              _buildFeatureItem(
                                Icons.auto_awesome,
                                'AI-powered email generation',
                                'Create professional emails in seconds',
                              ),
                              _buildFeatureItem(
                                Icons.description,
                                'Smart templates',
                                'Choose from hundreds of pre-made templates',
                              ),
                              _buildFeatureItem(
                                Icons.sync,
                                'Gmail integration',
                                'Seamlessly sync with your Gmail account',
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      // Privacy Notice
                      Text(
                        'By continuing, you agree to our Terms of Service and Privacy Policy.',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppTheme.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSocialButton(IconData icon, String label) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        child: CosmicGlassButton(
          onPressed: () {
            // Handle social login
          },
          text: label,
          icon: icon,
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryPurple,
              size: 16.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
