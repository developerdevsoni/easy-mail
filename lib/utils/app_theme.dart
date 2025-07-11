import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🌌 COSMIC DARK THEME COLOR PALETTE
  
  // Primary Colors (Deep Purple/Lavender)
  static const Color primaryPurple = Color(0xFF8B5CF6);        // Vibrant purple
  static const Color primaryPurpleDark = Color(0xFF7C3AED);    // Darker purple
  static const Color primaryPurpleLight = Color(0xFFA78BFA);   // Light purple
  
  // Secondary Colors (Cosmic Lavender)
  static const Color secondaryLavender = Color(0xFFB794F6);    // Soft lavender
  static const Color secondaryLavenderDark = Color(0xFF9F7AEA); // Darker lavender
  static const Color secondaryLavenderLight = Color(0xFFCFC9E8); // Light lavender
  
  // Accent Colors (Cosmic Pink)
  static const Color accentPink = Color(0xFFF472B6);           // Cosmic pink
  static const Color accentPinkDark = Color(0xFFEC4899);       // Darker pink
  static const Color accentPinkLight = Color(0xFFF9A8D4);      // Light pink
  
  // Dark Background Colors (Space/Cosmic)
  static const Color backgroundDark = Color(0xFF0F0F23);       // Deep space
  static const Color backgroundSecondary = Color(0xFF1A1A2E);  // Secondary dark
  static const Color backgroundTertiary = Color(0xFF16213E);   // Tertiary dark
  
  // Surface Colors (Glass-like)
  static const Color surfaceDark = Color(0xFF1F1F35);         // Dark surface
  static const Color surfaceGlass = Color(0xFF2A2A45);        // Glass surface
  static const Color surfaceElevated = Color(0xFF353553);     // Elevated surface
  
  // Text Colors (Light on Dark)
  static const Color textPrimary = Color(0xFFFFFFFF);         // Pure white
  static const Color textSecondary = Color(0xFFE5E5E5);       // Light gray
  static const Color textTertiary = Color(0xFFB0B0B0);        // Medium gray
  static const Color textMuted = Color(0xFF8A8A8A);           // Muted gray
  
  // Border & Divider Colors (Subtle)
  static const Color borderLight = Color(0xFF3A3A55);         // Light border
  static const Color borderMedium = Color(0xFF2A2A45);        // Medium border
  static const Color borderDark = Color(0xFF1A1A35);          // Dark border
  
  // Semantic Colors (Cosmic versions)
  static const Color successGreen = Color(0xFF10B981);        // Success green
  static const Color warningOrange = Color(0xFFF59E0B);       // Warning orange
  static const Color errorRed = Color(0xFFEF4444);            // Error red
  static const Color infoPurple = Color(0xFF8B5CF6);          // Info purple
  
  // Shadow Colors (Cosmic glows)
  static const Color shadowPurple = Color(0x1A8B5CF6);       // Purple glow
  static const Color shadowPink = Color(0x1AF472B6);         // Pink glow
  static const Color shadowDark = Color(0x40000000);         // Dark shadow
  
  // 🌈 COSMIC GRADIENT SYSTEM
  
  // Primary Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, primaryPurpleLight],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondaryLavender, secondaryLavenderLight],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPink, accentPinkLight],
  );
  
  // Background Gradients (Cosmic)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [backgroundDark, backgroundSecondary, backgroundTertiary],
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceDark, surfaceGlass],
  );
  
  // Cosmic Overlay Gradients
  static const LinearGradient overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x1A8B5CF6),  // Purple overlay
      Color(0x0AF472B6),  // Pink overlay
    ],
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x15FFFFFF),  // White glass
      Color(0x0AFFFFFF),  // Transparent glass
    ],
  );
  
  // Semantic Gradients
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [successGreen, Color(0xFF34D399)],
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warningOrange, Color(0xFFFBBF24)],
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [errorRed, Color(0xFFF87171)],
  );
  
  // 🔤 COSMIC TYPOGRAPHY SYSTEM
  
  // Display Styles (Hero content)
  static TextStyle get displayLarge => GoogleFonts.poppins(
    fontSize: 32.sp,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );
  
  static TextStyle get displayMedium => GoogleFonts.poppins(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.3,
    height: 1.15,
  );
  
  // Heading Styles
  static TextStyle get headingXLarge => GoogleFonts.poppins(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: -0.2,
    height: 1.2,
  );
  
  static TextStyle get headingLarge => GoogleFonts.poppins(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.1,
    height: 1.25,
  );
  
  static TextStyle get headingMedium => GoogleFonts.poppins(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );
  
  static TextStyle get headingSmall => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    height: 1.3,
  );
  
  // Body Styles
  static TextStyle get bodyXLarge => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );
  
  static TextStyle get bodyLarge => GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.5,
  );
  
  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.4,
  );
  
  static TextStyle get bodySmall => GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: textTertiary,
    height: 1.4,
  );
  
  // Label Styles
  static TextStyle get labelLarge => GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: textPrimary,
    letterSpacing: 0.1,
    height: 1.3,
  );
  
  static TextStyle get labelMedium => GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: textSecondary,
    letterSpacing: 0.1,
    height: 1.3,
  );
  
  static TextStyle get labelSmall => GoogleFonts.poppins(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: textTertiary,
    letterSpacing: 0.2,
    height: 1.2,
  );
  
  // Button Text Styles
  static TextStyle get buttonTextLarge => GoogleFonts.poppins(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.2,
  );
  
  static TextStyle get buttonTextMedium => GoogleFonts.poppins(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.2,
  );
  
  static TextStyle get buttonTextSmall => GoogleFonts.poppins(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.2,
  );
  
  // Caption Styles
  static TextStyle get caption => GoogleFonts.poppins(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: textMuted,
    letterSpacing: 0.3,
    height: 1.3,
  );
  
  // Legacy compatibility (keep for gradual migration)
  static TextStyle get heading1 => displayMedium;
  static TextStyle get heading2 => headingLarge;
  static TextStyle get heading3 => headingMedium;
  
  // Legacy button text compatibility
  static TextStyle get buttonText => buttonTextMedium;
  
  // 📦 COSMIC CARD DESIGN SYSTEM
  
  // Glass Card (Main card style) - SVG background cards with white text
  static BoxDecoration get cardBasic => BoxDecoration(
    color: surfaceDark.withOpacity(0.85),
    borderRadius: BorderRadius.circular(16.r),
    border: Border.all(
      color: textPrimary.withOpacity(0.25),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: backgroundDark.withOpacity(0.4),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: primaryPurple.withOpacity(0.1),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );
  
  // Elevated Glass Card - Dark visible cards with white text
  static BoxDecoration get cardElevated => BoxDecoration(
    color: surfaceDark.withOpacity(0.95),
    borderRadius: BorderRadius.circular(20.r),
    border: Border.all(
      color: textPrimary.withOpacity(0.25),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: backgroundDark.withOpacity(0.4),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
      BoxShadow(
        color: primaryPurple.withOpacity(0.1),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ],
  );
  
  // Interactive Card - Dark visible cards with white text
  static BoxDecoration get cardInteractive => BoxDecoration(
    color: surfaceDark.withOpacity(0.9),
    borderRadius: BorderRadius.circular(16.r),
    border: Border.all(
      color: textPrimary.withOpacity(0.2),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: backgroundDark.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  // Glass Card with stronger effect
  static BoxDecoration get cardGlass => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0x20FFFFFF),
        Color(0x10FFFFFF),
      ],
    ),
    borderRadius: BorderRadius.circular(16.r),
    border: Border.all(
      color: Color(0x30FFFFFF),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: shadowPurple,
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );
  
  // Feature Card (Hero cards)
  static BoxDecoration get cardFeature => BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.circular(20.r),
    border: Border.all(
      color: primaryPurpleLight.withOpacity(0.5),
      width: 2,
    ),
    boxShadow: [
      BoxShadow(
        color: shadowPurple,
        blurRadius: 32,
        offset: const Offset(0, 12),
      ),
      BoxShadow(
        color: shadowDark,
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  // Legacy compatibility
  static BoxDecoration get cardDecoration => cardBasic;
  static BoxDecoration get elevatedCardDecoration => cardElevated;
  static BoxDecoration get glassDecoration => cardGlass;
  
  // Legacy color compatibility
  static const Color cardGray = borderLight;
  
  // Legacy gradient compatibility
  static LinearGradient get tealGradient => secondaryGradient;
  static LinearGradient get goldGradient => accentGradient;
  
  // 🔘 COSMIC BUTTON SYSTEM
  
  // Primary Button (Cosmic purple)
  static ButtonStyle get buttonPrimary => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: textPrimary,
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
    minimumSize: Size(120.w, 48.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
    ),
    textStyle: buttonTextMedium,
  ).copyWith(
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    overlayColor: MaterialStateProperty.all(
      textPrimary.withOpacity(0.1),
    ),
  );
  
  // Secondary Button (Glass style)
  static ButtonStyle get buttonSecondary => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: textPrimary,
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
    minimumSize: Size(120.w, 48.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
      side: BorderSide(color: borderLight, width: 1.5),
    ),
    textStyle: buttonTextMedium,
  ).copyWith(
    backgroundColor: MaterialStateProperty.all(Colors.transparent),
    overlayColor: MaterialStateProperty.all(
      textPrimary.withOpacity(0.05),
    ),
  );
  
  // Tertiary Button
  static ButtonStyle get buttonTertiary => TextButton.styleFrom(
    foregroundColor: primaryPurple,
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    minimumSize: Size(80.w, 44.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
    textStyle: buttonTextMedium,
  );
  
  // Large Button
  static ButtonStyle get buttonLarge => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: textPrimary,
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
    minimumSize: Size(200.w, 56.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.r),
    ),
    textStyle: buttonTextLarge,
  );
  
  // Small Button
  static ButtonStyle get buttonSmall => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: textPrimary,
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
    minimumSize: Size(80.w, 36.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
    textStyle: buttonTextSmall,
  );
  
  // Icon Button
  static ButtonStyle get buttonIcon => IconButton.styleFrom(
    backgroundColor: surfaceGlass,
    foregroundColor: textPrimary,
    padding: EdgeInsets.all(12.w),
    minimumSize: Size(44.w, 44.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
    ),
  );
  
  // Legacy compatibility
  static ButtonStyle get primaryButtonStyle => buttonPrimary;
  static ButtonStyle get secondaryButtonStyle => buttonSecondary;
  static ButtonStyle get accentButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: textPrimary,
  );
  
  // 📱 COSMIC INPUT SYSTEM
  
  static InputDecoration inputDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
  }) => InputDecoration(
    labelText: labelText,
    hintText: hintText,
    hintStyle: bodyMedium.copyWith(color: textMuted),
    labelStyle: labelMedium.copyWith(color: textSecondary),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: surfaceGlass.withOpacity(0.3),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: borderLight, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: borderLight, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: primaryPurple, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: errorRed, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: errorRed, width: 2),
    ),
  );
  
  // Search Input
  static InputDecoration get searchInputDecoration => InputDecoration(
    hintText: 'Search...',
    hintStyle: bodyMedium.copyWith(color: textMuted),
    prefixIcon: Icon(
      Icons.search_rounded,
      color: textMuted,
      size: 20.r,
    ),
    filled: true,
    fillColor: surfaceGlass.withOpacity(0.3),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.r),
      borderSide: BorderSide(color: borderLight, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.r),
      borderSide: BorderSide(color: borderLight, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(24.r),
      borderSide: BorderSide(color: primaryPurple, width: 2),
    ),
  );
  
  // 🎨 COSMIC THEME DATA
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPurple,
      brightness: Brightness.dark,
      primary: primaryPurple,
      secondary: secondaryLavender,
      tertiary: accentPink,
      surface: surfaceDark,
      background: backgroundDark,
      error: errorRed,
      onPrimary: textPrimary,
      onSecondary: textPrimary,
      onSurface: textPrimary,
      onBackground: textPrimary,
    ),
    scaffoldBackgroundColor: backgroundDark,
    fontFamily: GoogleFonts.poppins().fontFamily,
    
    // AppBar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: headingMedium,
      iconTheme: IconThemeData(
        color: textPrimary,
        size: 24.r,
      ),
      centerTitle: true,
    ),
    
    // Card Theme
    cardTheme: CardTheme(
      color: Colors.transparent,
      elevation: 0,
      shadowColor: shadowPurple,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.all(8.w),
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(style: buttonPrimary),
    textButtonTheme: TextButtonThemeData(style: buttonTertiary),
    outlinedButtonTheme: OutlinedButtonThemeData(style: buttonSecondary),
    
    // Input Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceGlass.withOpacity(0.3),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: borderLight, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: borderLight, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: primaryPurple, width: 2),
      ),
    ),
    
    // Icon Theme
    iconTheme: IconThemeData(
      color: textSecondary,
      size: 24.r,
    ),
    
    // Divider Theme
    dividerTheme: DividerThemeData(
      color: borderLight,
      thickness: 1,
      space: 1,
    ),
  );
}

// ✨ ANIMATION SYSTEM
class AppAnimations {
  // Duration Standards
  static const Duration micro = Duration(milliseconds: 150);
  static const Duration quick = Duration(milliseconds: 250);
  static const Duration standard = Duration(milliseconds: 350);
  static const Duration complex = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 750);
  
  // Legacy compatibility
  static const Duration fastDuration = quick;
  static const Duration mediumDuration = standard;
  static const Duration slowDuration = slow;
  
  // Easing Curves
  static const Curve standardCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve sharpCurve = Curves.easeOutExpo;
  static const Curve gentleCurve = Curves.easeOutQuart;
  
  // Legacy compatibility
  static const Curve defaultCurve = standardCurve;
  
  // Animation Builders
  static Widget slideIn({
    required Widget child,
    Duration duration = standard,
    Curve curve = standardCurve,
    Offset begin = const Offset(0, 0.3),
  }) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: begin, end: Offset.zero),
      builder: (context, offset, child) {
        return Transform.translate(
          offset: Offset(offset.dx * 100, offset.dy * 100),
          child: child,
        );
      },
      child: child,
    );
  }
  
  static Widget fadeIn({
    required Widget child,
    Duration duration = standard,
    Curve curve = standardCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, opacity, child) {
        return Opacity(opacity: opacity, child: child);
      },
      child: child,
    );
  }
  
  static Widget scaleIn({
    required Widget child,
    Duration duration = standard,
    Curve curve = bounceCurve,
  }) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: 0.8, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: child,
    );
  }
}

// 📐 SPACING SYSTEM
class AppSpacing {
  // Core spacing values
  static double get xxs => 2.w;   // Borders, dividers
  static double get xs => 4.w;    // Small gaps
  static double get sm => 8.w;    // Text spacing
  static double get md => 16.w;   // Component spacing
  static double get lg => 24.w;   // Section spacing
  static double get xl => 32.w;   // Page spacing
  static double get xxl => 48.w;  // Major sections
  
  // Component-specific spacing
  static EdgeInsets get cardPadding => EdgeInsets.all(md);
  static EdgeInsets get cardMargin => EdgeInsets.all(sm);
  static EdgeInsets get buttonPadding => EdgeInsets.symmetric(
    horizontal: md + 4.w, 
    vertical: sm + 4.h,
  );
  static EdgeInsets get inputPadding => EdgeInsets.symmetric(
    horizontal: md, 
    vertical: sm + 6.h,
  );
  static EdgeInsets get pagePadding => EdgeInsets.all(lg);
  static EdgeInsets get sectionPadding => EdgeInsets.symmetric(
    horizontal: lg, 
    vertical: md,
  );
  
  // Vertical spacing helpers
  static Widget get verticalSpaceXS => SizedBox(height: xs);
  static Widget get verticalSpaceSM => SizedBox(height: sm);
  static Widget get verticalSpaceMD => SizedBox(height: md);
  static Widget get verticalSpaceLG => SizedBox(height: lg);
  static Widget get verticalSpaceXL => SizedBox(height: xl);
  
  // Horizontal spacing helpers
  static Widget get horizontalSpaceXS => SizedBox(width: xs);
  static Widget get horizontalSpaceSM => SizedBox(width: sm);
  static Widget get horizontalSpaceMD => SizedBox(width: md);
  static Widget get horizontalSpaceLG => SizedBox(width: lg);
  static Widget get horizontalSpaceXL => SizedBox(width: xl);
}

// 🎯 UTILITY CLASSES
class AppUtils {
  // Safe area helpers
  static EdgeInsets safeAreaPadding(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return EdgeInsets.only(
      top: mediaQuery.padding.top,
      bottom: mediaQuery.padding.bottom,
    );
  }
  
  // Responsive breakpoints
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < 768;
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 768 && width < 1024;
  }
  
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= 1024;
  
  // Color helpers
  static Color withOpacity(Color color, double opacity) =>
      color.withOpacity(opacity);
      
  static Color lighten(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
  
  static Color darken(Color color, double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
} 