import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_theme.dart';

// 🎨 MODERN CARD COMPONENT
class ModernCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool elevated;
  final bool glassMorphism;

  const ModernCard({
    Key? key,
    required this.child,
    this.padding,
    this.onTap,
    this.elevated = false,
    this.glassMorphism = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = glassMorphism 
        ? AppTheme.glassDecoration 
        : elevated 
            ? AppTheme.elevatedCardDecoration 
            : AppTheme.cardDecoration;

    Widget cardContent = Container(
      padding: padding ?? EdgeInsets.all(AppSpacing.md),
      decoration: decoration,
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

// 🔘 MODERN BUTTON COMPONENT
class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final Size? minimumSize;
  final Widget? icon;
  final bool loading;

  const ModernButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.minimumSize,
    this.icon,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ButtonStyle style;
    switch (variant) {
      case ButtonVariant.primary:
        style = AppTheme.primaryButtonStyle;
        break;
      case ButtonVariant.secondary:
        style = AppTheme.secondaryButtonStyle;
        break;
      case ButtonVariant.accent:
        style = AppTheme.accentButtonStyle;
        break;
    }

    if (minimumSize != null) {
      style = style.copyWith(
        minimumSize: MaterialStateProperty.all(minimumSize),
      );
    }

    Widget buttonChild = loading
        ? SizedBox(
            width: 16.w,
            height: 16.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == ButtonVariant.secondary 
                    ? AppTheme.textPrimary 
                    : AppTheme.surfaceWhite,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          );

    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: style,
      child: buttonChild,
    );
  }
}

enum ButtonVariant { primary, secondary, accent }

// ✨ GRADIENT CONTAINER
class GradientContainer extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const GradientContainer({
    Key? key,
    required this.child,
    required this.gradient,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius ?? BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }
}

// 🔍 MODERN SEARCH BAR
class ModernSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final TextEditingController? controller;

  const ModernSearchBar({
    Key? key,
    this.hintText = 'Search...',
    this.onChanged,
    this.onFilterTap,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: AppTheme.cardDecoration,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
        decoration: AppTheme.inputDecoration(
          hintText: hintText,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppTheme.textSecondary,
            size: 16.r,
          ),
          suffixIcon: onFilterTap != null
              ? IconButton(
                  onPressed: onFilterTap,
                  icon: Icon(
                    Icons.tune_rounded,
                    color: AppTheme.textSecondary,
                    size: 16.r,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

// 🎯 FEATURE CARD COMPONENT
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Gradient? gradient;
  final bool isPremium;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.onTap,
    this.iconColor,
    this.gradient,
    this.isPremium = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      elevated: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  gradient: gradient ?? AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.surfaceWhite,
                  size: 14.r,
                ),
              ),
              const Spacer(),
              if (isPremium)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    gradient: AppTheme.goldGradient,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'PRO',
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.surfaceWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: 8.sp,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Flexible(
            child: Text(
              title,
              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: Text(
              description,
              style: AppTheme.caption,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.arrow_forward_rounded,
                color: AppTheme.textSecondary,
                size: 10.r,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 📊 STATS CARD COMPONENT
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const StatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(5.r),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 12.r,
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  subtitle,
                  style: AppTheme.caption,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Flexible(
            child: Text(
              value,
              style: AppTheme.bodyLarge.copyWith(color: color),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(height: 2.h),
          Flexible(
            child: Text(
              title,
              style: AppTheme.caption,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

// 🏷️ MODERN CHIP COMPONENT
class ModernChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Color? selectedColor;

  const ModernChip({
    Key? key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fastDuration,
        curve: AppAnimations.defaultCurve,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: selected 
              ? (selectedColor ?? AppTheme.primaryBlue) 
              : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected 
                ? (selectedColor ?? AppTheme.primaryBlue) 
                : AppTheme.cardGray,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: selected 
                ? AppTheme.surfaceWhite 
                : AppTheme.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}

// 🌟 PREMIUM BADGE
class PremiumBadge extends StatelessWidget {
  final String text;
  final bool small;

  const PremiumBadge({
    Key? key,
    this.text = 'PRO',
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 4.w : 6.w,
        vertical: small ? 1.h : 2.h,
      ),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(small ? 4.r : 6.r),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGold.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: (small ? AppTheme.caption : AppTheme.bodySmall).copyWith(
          color: AppTheme.surfaceWhite,
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
} 