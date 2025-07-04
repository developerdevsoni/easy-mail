import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // 🎨 PROFESSIONAL COLOR PALETTE
  static const Color primaryBlue = Color(0xFF0B2A4E);      // Deep Ocean Blue - trust, reliability
  static const Color secondaryTeal = Color(0xFF148A8A);     // Professional Teal - innovation
  static const Color accentGold = Color(0xFFF59E0B);        // Success Gold - premium
  static const Color surfaceWhite = Color(0xFFFFFFFF);      // Pure White - clean
  static const Color backgroundGray = Color(0xFFF8FAFC);    // Light Gray - modern background
  static const Color cardGray = Color(0xFFE2E8F0);          // Card borders
  static const Color textPrimary = Color(0xFF1E293B);       // Dark text
  static const Color textSecondary = Color(0xFF64748B);     // Secondary text
  static const Color textTertiary = Color(0xFF94A3B8);      // Tertiary text
  static const Color successGreen = Color(0xFF10B981);      // Success states
  static const Color warningOrange = Color(0xFFF59E0B);     // Warning states
  static const Color errorRed = Color(0xFFEF4444);          // Error states
  
  // 🎨 GRADIENT DEFINITIONS
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, Color(0xFF1E3A8A)],
  );
  
  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryTeal, Color(0xFF0F766E)],
  );
  
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGold, Color(0xFFD97706)],
  );
  
  // 📝 COMPACT TYPOGRAPHY SYSTEM
  static TextStyle get heading1 => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    letterSpacing: -0.3,
    height: 1.2,
  );
  
  static TextStyle get heading2 => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.2,
    height: 1.3,
  );
  
  static TextStyle get heading3 => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.1,
    height: 1.3,
  );
  
  static TextStyle get bodyLarge => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.4,
  );
  
  static TextStyle get bodyMedium => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );
  
  static TextStyle get bodySmall => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: textTertiary,
    height: 1.3,
  );
  
  static TextStyle get buttonText => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );
  
  static TextStyle get caption => TextStyle(
    fontSize: 9.sp,
    fontWeight: FontWeight.w500,
    color: textTertiary,
    letterSpacing: 0.3,
  );
  
  // 🎯 COMPACT COMPONENT STYLES
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: surfaceWhite,
    borderRadius: BorderRadius.circular(12.r),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withOpacity(0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: primaryBlue.withOpacity(0.03),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ],
  );
  
  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
    color: surfaceWhite,
    borderRadius: BorderRadius.circular(14.r),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withOpacity(0.08),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: primaryBlue.withOpacity(0.04),
        blurRadius: 6,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration get glassDecoration => BoxDecoration(
    color: surfaceWhite.withOpacity(0.9),
    borderRadius: BorderRadius.circular(14.r),
    border: Border.all(
      color: cardGray.withOpacity(0.2),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: primaryBlue.withOpacity(0.04),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  );
  
  // 🔘 COMPACT BUTTON STYLES
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: surfaceWhite,
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.r),
    ),
    textStyle: buttonText,
  );
  
  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: backgroundGray,
    foregroundColor: textPrimary,
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.r),
      side: BorderSide(color: cardGray, width: 1),
    ),
    textStyle: buttonText,
  );
  
  static ButtonStyle get accentButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: accentGold,
    foregroundColor: surfaceWhite,
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.r),
    ),
    textStyle: buttonText,
  );
  
  // 📱 COMPACT INPUT STYLES
  static InputDecoration inputDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    hintText: hintText,
    hintStyle: bodyMedium.copyWith(color: textTertiary),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: backgroundGray,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: cardGray, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: primaryBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: errorRed, width: 1),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
  );
  
  // 🎨 THEME DATA
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      secondary: secondaryTeal,
      tertiary: accentGold,
      surface: surfaceWhite,
      background: backgroundGray,
    ),
    scaffoldBackgroundColor: backgroundGray,
    fontFamily: 'Inter', // You may want to add this font to pubspec.yaml
    elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButtonStyle),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide.none,
      ),
    ),
    cardTheme: CardTheme(
      color: surfaceWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: heading3,
      iconTheme: IconThemeData(color: textPrimary),
    ),
  );
}

// 🎭 ANIMATION CONSTANTS
class AppAnimations {
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration slowDuration = Duration(milliseconds: 500);
  
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
}

// 📏 COMPACT SPACING CONSTANTS
class AppSpacing {
  static double get xs => 3.w;
  static double get sm => 6.w;
  static double get md => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 28.w;
} 