import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GoogleLoginPage extends StatelessWidget {
  const GoogleLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.put(AuthController());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                // const Spacer(),

                // 🎨 LOGO AND BRANDING
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: AppTheme.surfaceWhite.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.email_rounded,
                        size: 48.r,
                        color: AppTheme.surfaceWhite,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xl),
                    
                    Text(
                      "Easy Mail",
                      style: AppTheme.heading1.copyWith(
                        color: AppTheme.surfaceWhite,
                        fontSize: 36.sp,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    
                    Text(
                      "AI-Powered Email Assistant",
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.surfaceWhite.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                
                // const Spacer(),
                
                // 🌟 FEATURES HIGHLIGHT
                ModernCard(
                  glassMorphism: true,
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      Text(
                        "Get Started Today",
                        style: AppTheme.heading2.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppSpacing.md),
                      
                      Text(
                        "Create professional emails with AI, use powerful templates, and boost your productivity.",
                        style: AppTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: AppSpacing.xl),
                      
                      // Feature highlights
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeatureItem(
                              Icons.auto_awesome_rounded,
                              "AI Generated",
                              "Smart emails in seconds",
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _buildFeatureItem(
                              Icons.temple_hindu_sharp,
                              "Templates",
                              "Professional designs",
                            ),
                          ),
                          SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: _buildFeatureItem(
                              Icons.security_rounded,
                              "Secure",
                              "Your data is safe",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: AppSpacing.xl),
                
                // 🔐 LOGIN SECTION
                Obx(() {
                  if (controller.userName.isNotEmpty) {
                    return ModernCard(
                      glassMorphism: true,
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 32.r,
                            backgroundColor: AppTheme.primaryBlue,
                            backgroundImage: controller.photoUrl.value.isNotEmpty
                                ? NetworkImage(controller.photoUrl.value)
                                : null,
                            child: controller.photoUrl.value.isEmpty
                                ? Icon(
                                    Icons.person_rounded,
                                    size: 32.r,
                                    color: AppTheme.surfaceWhite,
                                  )
                                : null,
                          ),
                          SizedBox(height: AppSpacing.md),
                          
                          Text(
                            "Welcome back,",
                            style: AppTheme.bodyMedium,
                          ),
                          Text(
                            controller.userName.value,
                            style: AppTheme.heading3,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: AppSpacing.sm),
                          
                          Text(
                            controller.userEmail.value,
                            style: AppTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return const SizedBox.shrink();
                }),
                
                SizedBox(height: AppSpacing.lg),
                
                // 🚀 LOGIN BUTTON
                Obx(() {
                  return ModernButton(
                    text: controller.userName.isNotEmpty 
                        ? "Continue to Easy Mail" 
                        : "Sign in with Google",
                    icon: controller.userName.isNotEmpty 
                        ? Icon(
                            Icons.arrow_forward_rounded,
                            color: AppTheme.surfaceWhite,
                            size: 18.r,
                          )
                        : Image.asset(
                            'assets/google_logo.png', // You'll need to add this
                            width: 18.w,
                            height: 18.h,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.login_rounded,
                                color: AppTheme.surfaceWhite,
                                size: 18.r,
                              );
                            },
                          ),
                    loading: controller.isLoading.value,
                    minimumSize: Size(double.infinity, 56.h),
                    variant: ButtonVariant.accent,
                    onPressed: controller.isLoading.value 
                        ? null 
                        : () async {
                            await controller.loginWithGoogle();
                          },
                  );
                }),
                
                SizedBox(height: AppSpacing.md),
                
                // 🔒 SECURITY NOTE
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      color: AppTheme.surfaceWhite.withOpacity(0.7),
                      size: 14.r,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      "Secure authentication with Google",
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.surfaceWhite.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                
                // const Spacer(),
                
                // 📄 TERMS
                Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Column(
                    children: [
                      Text(
                        "By continuing, you agree to our Terms of Service\nand Privacy Policy",
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.surfaceWhite.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              // TODO: Show terms
                            },
                            child: Text(
                              "Terms",
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.surfaceWhite,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            " • ",
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.surfaceWhite.withOpacity(0.6),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Show privacy policy
                            },
                            child: Text(
                              "Privacy",
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.surfaceWhite,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryBlue,
            size: 20.r,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        
        Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.xs),
        
        Text(
          subtitle,
          style: AppTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
