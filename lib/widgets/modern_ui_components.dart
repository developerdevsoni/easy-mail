import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_mail/utils/app_theme.dart';

// 🌌 COSMIC GRADIENT BUTTON
class CosmicGradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final LinearGradient? gradient;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool isLoading;
  final bool isEnabled;

  const CosmicGradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.gradient,
    this.width,
    this.height,
    this.padding,
    this.textStyle,
    this.icon,
    this.isLoading = false,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 56.h,
      decoration: BoxDecoration(
        gradient: gradient ?? AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowPurple,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.textPrimary),
                    ),
                  )
                else if (icon != null) ...[
                  Icon(
                    icon,
                    color: AppTheme.textPrimary,
                    size: 20.r,
                  ),
                  SizedBox(width: 8.w),
                ],
                if (!isLoading)
                  Text(
                    text,
                    style: textStyle ?? AppTheme.buttonTextMedium.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🌟 COSMIC GLASS BUTTON
class CosmicGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool isEnabled;

  const CosmicGlassButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.textStyle,
    this.icon,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 56.h,
      decoration: BoxDecoration(
        gradient: AppTheme.glassGradient,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowPurple,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: AppTheme.textPrimary,
                    size: 20.r,
                  ),
                  SizedBox(width: 8.w),
                ],
                Text(
                  text,
                  style: textStyle ?? AppTheme.buttonTextMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🌌 COSMIC BACKGROUND DECORATION
class CosmicBackgroundDecoration extends StatelessWidget {
  final Widget child;
  final bool showStars;
  final bool showPlanets;

  const CosmicBackgroundDecoration({
    Key? key,
    required this.child,
    this.showStars = true,
    this.showPlanets = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: Stack(
        children: [
          // Stars background
          if (showStars) ...[
            Positioned(
              top: 100.h,
              left: 50.w,
              child: _buildStar(4.r, AppTheme.primaryPurpleLight.withOpacity(0.6)),
            ),
            Positioned(
              top: 200.h,
              right: 80.w,
              child: _buildStar(3.r, AppTheme.secondaryLavenderLight.withOpacity(0.8)),
            ),
            Positioned(
              top: 300.h,
              left: 120.w,
              child: _buildStar(2.r, AppTheme.accentPinkLight.withOpacity(0.7)),
            ),
            Positioned(
              top: 150.h,
              right: 150.w,
              child: _buildStar(3.r, AppTheme.primaryPurpleLight.withOpacity(0.5)),
            ),
            Positioned(
              bottom: 200.h,
              left: 80.w,
              child: _buildStar(4.r, AppTheme.secondaryLavenderLight.withOpacity(0.6)),
            ),
            Positioned(
              bottom: 300.h,
              right: 120.w,
              child: _buildStar(2.r, AppTheme.accentPinkLight.withOpacity(0.8)),
            ),
          ],
          
          // Planets/cosmic elements
          if (showPlanets) ...[
            Positioned(
              top: 50.h,
              right: 30.w,
              child: _buildPlanet(60.r, AppTheme.primaryPurple.withOpacity(0.3)),
            ),
            Positioned(
              bottom: 100.h,
              left: 40.w,
              child: _buildPlanet(40.r, AppTheme.secondaryLavender.withOpacity(0.4)),
            ),
          ],
          
          // Main content
          child,
        ],
      ),
    );
  }

  Widget _buildStar(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: size * 2,
            spreadRadius: size * 0.5,
          ),
        ],
      ),
    );
  }

  Widget _buildPlanet(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.6),
            color.withOpacity(0.1),
          ],
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}

// 🎨 COSMIC CARD WRAPPER
class CosmicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isInteractive;
  final bool isElevated;

  const CosmicCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.isInteractive = false,
    this.isElevated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.all(8.w),
      decoration: isElevated 
          ? AppTheme.cardElevated 
          : (isInteractive ? AppTheme.cardInteractive : AppTheme.cardBasic),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
                     child: Container(
             padding: padding ?? AppSpacing.cardPadding,
             child: child,
           ),
        ),
      ),
    );
  }
}

// 🌟 COSMIC FLOATING ACTION BUTTON
class CosmicFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? heroTag;
  final bool mini;

  const CosmicFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.heroTag,
    this.mini = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(mini ? 16.r : 20.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowPurple,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        heroTag: heroTag,
        backgroundColor: Colors.transparent,
        elevation: 0,
        mini: mini,
        child: Icon(
          icon,
          color: AppTheme.textPrimary,
          size: mini ? 20.r : 28.r,
        ),
      ),
    );
  }
}

// 🌌 COSMIC TEXT FIELD
class CosmicTextField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? minLines;

  const CosmicTextField({
    Key? key,
    required this.hintText,
    this.labelText,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.minLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.glassGradient,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        minLines: minLines,
        style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
        decoration: AppTheme.inputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ).copyWith(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}

// 🎭 COSMIC ANIMATED CONTAINER
class CosmicAnimatedContainer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double initialScale;
  final double finalScale;
  final bool autoPlay;

  const CosmicAnimatedContainer({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.initialScale = 0.95,
    this.finalScale = 1.05,
    this.autoPlay = true,
  }) : super(key: key);

  @override
  State<CosmicAnimatedContainer> createState() => _CosmicAnimatedContainerState();
}

class _CosmicAnimatedContainerState extends State<CosmicAnimatedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.initialScale,
      end: widget.finalScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.autoPlay) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

// Legacy compatibility - AppAnimations and AppSpacing are imported from app_theme.dart 