import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_mail/controllers/animatedTextWidget.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // Make sure this is imported

class TypingPromptField extends StatelessWidget {
  TypingPromptField({super.key});

  final TypingPromptController controller = Get.put(TypingPromptController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 📝 COMPACT INPUT CONTAINER
        ModernCard(
          elevated: false,
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 80.h),
                child: Stack(
                  children: [
                    // Animated Placeholder
                    Obx(
                      () => controller.showAnimation.value
                          ? Positioned.fill(
                              child: IgnorePointer(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 6.h, left: 3.w),
                                  child: AnimatedTextKit(
                                    animatedTexts: [
                                      TypewriterAnimatedText(
                                        'Describe your email... e.g., "Write a follow-up email to a client about our meeting yesterday"',
                                        textStyle: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textTertiary,
                                        ),
                                        speed: const Duration(milliseconds: 80),
                                      ),
                                    ],
                                    repeatForever: true,
                                    isRepeatingAnimation: true,
                                    pause: const Duration(milliseconds: 2000),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    
                    // Text Input
                    TextField(
                      controller: controller.textController,
                      maxLines: null,
                      minLines: 3,
                      textInputAction: TextInputAction.done,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '',
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (value) {
                        controller.submitPrompt(value);
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: AppSpacing.sm),
              
              // Action Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Press Enter to generate',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Obx(() => !controller.showAnimation.value
                        ? ModernButton(
                            text: 'Generate',
                            variant: ButtonVariant.primary,
                            loading: controller.isLoading.value,
                            icon: Icon(
                              Icons.auto_awesome_rounded,
                              size: 12.r,
                              color: AppTheme.surfaceWhite,
                            ),
                            onPressed: () {
                              controller.submitPrompt(controller.textController.text);
                            },
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundGray,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(color: AppTheme.cardGray),
                            ),
                            child: Text(
                              'Generate',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textTertiary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: AppSpacing.md),
        
        /// 🎯 COMPACT RESULT DISPLAY
        Obx(() {
          if (controller.isLoading.value) {
            return ModernCard(
              elevated: true,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: _buildLoadingAnimation(),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'AI is crafting your email...',
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'This usually takes a few seconds',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (controller.result.value.isNotEmpty) {
            final email = controller.result.value;
            return ModernCard(
              elevated: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          gradient: AppTheme.tealGradient,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: AppTheme.surfaceWhite,
                          size: 12.r,
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          'Generated Email',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.secondaryTeal,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Copy to clipboard
                        },
                        icon: Icon(
                          Icons.copy_rounded,
                          color: AppTheme.textSecondary,
                          size: 14.r,
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: AppSpacing.sm),
                  
                  // Subject
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundGray,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Subject',
                          style: AppTheme.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          email['title'] ?? 'No title',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: AppSpacing.xs),

                  // Body
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundGray,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Body',
                          style: AppTheme.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 120.h),
                          child: SingleChildScrollView(
                            child: Text(
                              email['body'] ?? 'No body content',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: AppSpacing.xs),

                  // Regards
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundGray,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Closing',
                          style: AppTheme.caption.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Text(
                          email['regards'] ?? 'No regards',
                          style: AppTheme.bodySmall.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: AppSpacing.sm),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ModernButton(
                          text: 'Regenerate',
                          variant: ButtonVariant.secondary,
                          icon: Icon(
                            Icons.refresh_rounded,
                            size: 12.r,
                            color: AppTheme.textPrimary,
                          ),
                          onPressed: () {
                            controller.submitPrompt(controller.textController.text);
                          },
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Expanded(
                        flex: 2,
                        child: ModernButton(
                          text: 'Use This Email',
                          variant: ButtonVariant.primary,
                          icon: Icon(
                            Icons.check_rounded,
                            size: 12.r,
                            color: AppTheme.surfaceWhite,
                          ),
                          onPressed: () {
                            // This will be handled by the parent screen
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }
  
  Widget _buildLoadingAnimation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLoadingDot(0),
        SizedBox(width: 6.w),
        _buildLoadingDot(1),
        SizedBox(width: 6.w),
        _buildLoadingDot(2),
      ],
    );
  }
  
  Widget _buildLoadingDot(int index) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.5, end: 1.0),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
        );
      },
      onEnd: () {
        // This will create a continuous animation effect
      },
    );
  }
}
