import 'package:easy_mail/view/home_screen.dart';
import 'package:easy_mail/view/intro_screen.dart';
import 'package:easy_mail/view/mailEditor_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'view/google_login_page.dart';

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
          title: 'Gmail Auth App',
          debugShowCheckedModeBanner: false,
          // theme: ThemeData(primarySwatch: Colors.deepPurple),
        theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
        primary: Colors.blueAccent,
        secondary: Colors.tealAccent,
        ),
        ),
          home: child,
        );
      },
      child:    IntroScreen(),
    );
  }
}
