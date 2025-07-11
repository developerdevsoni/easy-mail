import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/view/home_screen.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'google_login_page.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackgroundDecoration(
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
            SafeArea(
              child: Column(
                children: [
                  // Top skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: TextButton(
                        onPressed: () {
                          Get.off(() => const GoogleLoginPage());
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppTheme.textPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppTheme.textPrimary.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Skip',
                            style: TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // PageView
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                      children: [
                        _buildIntroPage(
                          title: 'Welcome to EasyMail',
                          subtitle: 'Your AI-powered email assistant',
                          description: 'Generate professional emails in seconds with our advanced AI technology',
                          imagePath: 'assets/svg_images/1.jpg',
                        ),
                        _buildIntroPage(
                          title: 'Smart Templates',
                          subtitle: 'Pre-made templates for every occasion',
                          description: 'Choose from hundreds of professional email templates or create your own',
                          imagePath: 'assets/svg_images/2.jpg',
                        ),
                        _buildIntroPage(
                          title: 'Get Started',
                          subtitle: 'Ready to revolutionize your emails?',
                          description: 'Sign in with Google and start creating amazing emails today',
                          imagePath: 'assets/svg_images/3.jpg',
                        ),
                      ],
                    ),
                  ),
                  
                  // Bottom navigation
                  Container(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        // Page indicator
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: 3,
                          effect: ExpandingDotsEffect(
                            dotColor: AppTheme.textPrimary.withOpacity(0.3),
                            activeDotColor: AppTheme.primaryPurple,
                            dotHeight: 8.h,
                            dotWidth: 8.w,
                            spacing: 8.w,
                          ),
                        ),
                        
                        SizedBox(height: 32.h),
                        
                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Back button
                            if (currentPage > 0)
                              CosmicGlassButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                text: 'Back',
                                icon: Icons.arrow_back,
                              )
                            else
                              const SizedBox(),
                            
                            // Next/Get Started button
                            CosmicGradientButton(
                              onPressed: () {
                                if (currentPage < 2) {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                } else {
                                  Get.off(() => const GoogleLoginPage());
                                }
                              },
                              text: currentPage < 2 ? 'Next' : 'Get Started',
                              icon: currentPage < 2 ? Icons.arrow_forward : Icons.rocket_launch,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroPage({
    required String title,
    required String subtitle,
    required String description,
    required String imagePath,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Container(
            height: 280.h,
            width: 280.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SizedBox(height: 48.h),
          
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 16.h),
          
          // Subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.secondaryLavender,
            ),
            textAlign: TextAlign.center,
          ),
          
          SizedBox(height: 16.h),
          
          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
