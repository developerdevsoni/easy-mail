import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/view/home_screen.dart';
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
      backgroundColor: Colors.white,
      body: Padding(

        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            Expanded(
              child: PageView(

                controller: _controller,
                children: [
                  buildPage("assets/svg_images/1.jpg", "Welcome", "Sign in to send Gmail quickly."),
                  buildPage("assets/svg_images/2.jpg", "Templates", "Use your own templates."),
                  buildPage("assets/svg_images/3.jpg", "Send Emails", "Send emails using Gmail API."),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: WormEffect(
                dotHeight: 12.h,
                dotWidth: 12.w,
                activeDotColor: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => Get.off(() => GoogleLoginPage()),
              child: Text("Get Started", style: TextStyle(fontSize: 16.sp,color: Colors.white)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48.h),
                backgroundColor: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget buildPage(String imagePath, String title, String desc) {
    return Column(

      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 250.h),
        // SizedBox(height: 30.h),
        Text(title, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Text(desc, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp)),
      ],
    );
  }
}
