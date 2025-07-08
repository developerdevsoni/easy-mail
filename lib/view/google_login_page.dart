import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GoogleLoginPage extends StatelessWidget {
  const GoogleLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryBlue,
              AppTheme.secondaryTeal,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              children: [
                // Top section with logo and branding
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo container with light background
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceWhite,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background circle
                            Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.primaryBlue,
                                    AppTheme.secondaryTeal,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            // Email icon
                            Icon(
                              Icons.email_outlined,
                              size: 32.r,
                              color: AppTheme.surfaceWhite,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // App name with premium font styling
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.surfaceWhite,
                            AppTheme.surfaceWhite.withOpacity(0.9),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          "EzMail",
                          style: TextStyle(
                            fontSize: 36.sp,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.surfaceWhite,
                            letterSpacing: -1.0,
                            height: 1.0,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Tagline with light text
                      Text(
                        "AI-Powered Email Assistant",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppTheme.surfaceWhite.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Middle section - User info or welcome message
                Expanded(
                  flex: 1,
                  child: Obx(() {
                    if (controller.userName.isNotEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // User avatar with light background
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceWhite,
                              borderRadius: BorderRadius.circular(50.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 28.r,
                              backgroundColor: AppTheme.primaryBlue,
                              backgroundImage:
                                  controller.photoUrl.value.isNotEmpty
                                      ? NetworkImage(controller.photoUrl.value)
                                      : null,
                              child: controller.photoUrl.value.isEmpty
                                  ? Icon(
                                      Icons.person_rounded,
                                      size: 28.r,
                                      color: AppTheme.surfaceWhite,
                                    )
                                  : null,
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Welcome text with light colors
                          Text(
                            "Welcome back,",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: AppTheme.surfaceWhite.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            controller.userName.value.split(' ').first,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.surfaceWhite,
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Feature highlights with light backgrounds
                        Row(
                          children: [
                            Expanded(
                              child: _buildFeatureItem(
                                Icons.auto_awesome_rounded,
                                "AI Generated",
                                "Smart emails",
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _buildFeatureItem(
                                Icons.temple_hindu_sharp,
                                "Templates",
                                "Professional",
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _buildFeatureItem(
                                Icons.security_rounded,
                                "Secure",
                                "Your data safe",
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ),

                // Bottom section - Login button and footer
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Login button with light background
                      Obx(() {
                        return Container(
                          width: double.infinity,
                          height: 56.h,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceWhite,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: controller.isLoading.value
                                  ? null
                                  : () async {
                                      await controller.loginWithGoogle();
                                    },
                              borderRadius: BorderRadius.circular(16.r),
                              child: Container(
                                alignment: Alignment.center,
                                child: controller.isLoading.value
                                    ? SizedBox(
                                        width: 24.w,
                                        height: 24.h,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            AppTheme.primaryBlue,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          controller.userName.isNotEmpty
                                              ? Icon(
                                                  Icons.arrow_forward_rounded,
                                                  color: AppTheme.primaryBlue,
                                                  size: 20.r,
                                                )
                                              : Icon(
                                                  Icons.login_rounded,
                                                  color: AppTheme.primaryBlue,
                                                  size: 20.r,
                                                ),
                                          SizedBox(width: 12.w),
                                          Text(
                                            controller.userName.isNotEmpty
                                                ? "Continue to EzMail"
                                                : "Sign in with Google",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.primaryBlue,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        );
                      }),

                      SizedBox(height: 16.h),

                      // Security note with light text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            color: AppTheme.surfaceWhite.withOpacity(0.7),
                            size: 16.r,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Secure authentication with Google",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppTheme.surfaceWhite.withOpacity(0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),

                      // Terms with light text
                      Text(
                        "By continuing, you agree to our Terms & Privacy Policy",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTheme.surfaceWhite.withOpacity(0.6),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryBlue,
              size: 20.r,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppTheme.textTertiary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
