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
      backgroundColor: AppTheme.surfaceWhite,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.surfaceWhite,
              AppTheme.backgroundGray.withOpacity(0.2),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                // Top section with logo and branding
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Compact logo
                      Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryBlue,
                              AppTheme.secondaryTeal,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.email_rounded,
                          size: 36.r,
                          color: AppTheme.surfaceWhite,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // App name
                      Text(
                        "EzMail",
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                          letterSpacing: -1.0,
                          height: 1.0,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Tagline
                      Text(
                        "AI-Powered Email Assistant",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Compact feature highlights
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeatureCard(
                              Icons.auto_awesome_rounded,
                              "AI Generated",
                              "Smart composition",
                              AppTheme.primaryBlue,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildFeatureCard(
                              Icons.description_outlined,
                              "Templates",
                              "Professional layouts",
                              AppTheme.secondaryTeal,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildFeatureCard(
                              Icons.security_rounded,
                              "Secure",
                              "Your data protected",
                              AppTheme.accentGold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Middle section - User info or welcome message
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(() {
                        if (controller.userName.isNotEmpty) {
                          return Column(
                            children: [
                              // Compact user avatar
                              Container(
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppTheme.primaryBlue,
                                      AppTheme.secondaryTeal,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: CircleAvatar(
                                  radius: 24.r,
                                  backgroundColor: AppTheme.surfaceWhite,
                                  backgroundImage: controller
                                          .photoUrl.value.isNotEmpty
                                      ? NetworkImage(controller.photoUrl.value)
                                      : null,
                                  child: controller.photoUrl.value.isEmpty
                                      ? Icon(
                                          Icons.person_rounded,
                                          size: 24.r,
                                          color: AppTheme.primaryBlue,
                                        )
                                      : null,
                                ),
                              ),

                              SizedBox(height: 16.h),

                              Text(
                                "Welcome back,",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              SizedBox(height: 4.h),

                              Text(
                                controller.userName.value.split(' ').first,
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            Text(
                              "Get Started",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Sign in to access your AI email assistant",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                // Bottom section - Login button and footer
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Compact login button
                      Obx(() {
                        return Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryBlue,
                                AppTheme.secondaryTeal,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
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
                                            AppTheme.surfaceWhite,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            controller.userName.isNotEmpty
                                                ? Icons.arrow_forward_rounded
                                                : Icons.login_rounded,
                                            color: AppTheme.surfaceWhite,
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
                                              color: AppTheme.surfaceWhite,
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

                      // Compact security note
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            color: AppTheme.textTertiary,
                            size: 14.r,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Secure authentication with Google",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTheme.textTertiary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.h),

                      // Compact terms
                      Text(
                        "By continuing, you agree to our Terms & Privacy Policy",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppTheme.textTertiary,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 16.h),
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

  Widget _buildFeatureCard(
      IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 16.r,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9.sp,
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
