import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/view/home_screen.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'google_login_page.dart';

class IntroScreen extends StatelessWidget {
  final PageController _controller = PageController();

  IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize AuthController early to check for existing login
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
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
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -50.h,
              right: -50.w,
              child: Container(
                width: 200.w,
                height: 200.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceWhite.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -100.h,
              left: -100.w,
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceWhite.withOpacity(0.05),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    // Glass header
                    Container(
                      margin: EdgeInsets.only(bottom: 40.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppTheme.surfaceWhite.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Text(
                        "Easy Mail",
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.surfaceWhite,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),

                    Expanded(
                      child: PageView(
                        controller: _controller,
                        children: [
                          _buildGlassPage("assets/svg_images/1.jpg", "Welcome",
                              "Sign in to send Gmail quickly."),
                          _buildGlassPage("assets/svg_images/2.jpg",
                              "Templates", "Use your own templates."),
                          _buildGlassPage("assets/svg_images/3.jpg",
                              "Send Emails", "Send emails using Gmail API."),
                        ],
                      ),
                    ),

                    // Glass page indicator
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color: AppTheme.surfaceWhite.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: WormEffect(
                          dotHeight: 10.h,
                          dotWidth: 10.w,
                          activeDotColor: AppTheme.surfaceWhite,
                          dotColor: AppTheme.surfaceWhite.withOpacity(0.3),
                          type: WormType.thin,
                        ),
                      ),
                    ),

                    // Glass get started button
                    Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.surfaceWhite.withOpacity(0.25),
                            AppTheme.surfaceWhite.withOpacity(0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: AppTheme.surfaceWhite.withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Get.off(() => GoogleLoginPage()),
                          borderRadius: BorderRadius.circular(16.r),
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.surfaceWhite,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassPage(String imagePath, String title, String desc) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppTheme.surfaceWhite.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Glass image container
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppTheme.surfaceWhite.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.asset(
                imagePath,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 30.h),

          // Glass title container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: AppTheme.surfaceWhite.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: AppTheme.surfaceWhite,
                letterSpacing: 0.5,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Glass description container
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppTheme.surfaceWhite.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Text(
              desc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppTheme.surfaceWhite.withOpacity(0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
