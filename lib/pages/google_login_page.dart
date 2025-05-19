import 'package:easy_mail/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/auth_controller.dart';

class GoogleLoginPage extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  GoogleLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Login", style: TextStyle(fontSize: 18.sp))),
      body: Obx(() {
        return Center(
          child: controller.isLoading.value
              ? const CircularProgressIndicator()
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (controller.userName.isNotEmpty)
                  Column(
                    children: [
                      Text(
                        "Welcome, ${controller.userName}",
                        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.h),
                      Text("Email: ${controller.userEmail}", style: TextStyle(fontSize: 14.sp)),
                      SizedBox(height: 20.h),
                    ],
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    // onPressed: controller.loginWithGoogle,
                    onPressed: () =>  Get.off(() => homeScreen()),
                    icon: const Icon(Icons.login,color: Colors.white,),
                    label: Text("api check", style: TextStyle(fontSize: 16.sp,color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
