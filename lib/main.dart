import 'package:easy_mail/view/home_screen.dart';
import 'package:easy_mail/view/intro_screen.dart';
// import 'package:easy_mail/view/mailEditor_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'view/google_login_page.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Easy Mail - AI Email Assistant',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: child,
        );
      },
      // 🚧 DEVELOPMENT BYPASS: Skip authentication and go directly to HomeScreen
      // TODO: Remove this bypass for production
      child: HomeScreen(), // 👈 BYPASSING AUTHENTICATION FOR DEVELOPMENT
      // child: IntroScreen(), // 👈 ORIGINAL CODE - UNCOMMENT FOR PRODUCTION
    );
  }
}
