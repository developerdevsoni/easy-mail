import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_mail/controllers/animatedTextWidget.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:async';

class TypingPromptField extends StatefulWidget {
  const TypingPromptField({super.key});

  @override
  State<TypingPromptField> createState() => _TypingPromptFieldState();
}

class _TypingPromptFieldState extends State<TypingPromptField> {
  final TypingPromptController controller = Get.put(TypingPromptController());
  final RxBool isAutoTyping = true.obs; // Reactive state for auto-typing
  final RxBool hasUserInput = false.obs; // Reactive state for user input
  final RxString currentPlaceholder = "".obs; // Reactive placeholder text
  Timer? _typingTimer;

  final List<String> _placeholderExamples = [
    "write your upskelled mail with ai"
  ];

  @override
  void initState() {
    super.initState();
    _startAutoTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  void _startAutoTyping() {
    if (isAutoTyping.value && !hasUserInput.value) {
      _typeNextExample();
    }
  }

  void _typeNextExample() {
    if (isAutoTyping.value) {
      String example = _placeholderExamples[0];
      int currentLength = 0;

      _typingTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
        if (!isAutoTyping.value) {
          timer.cancel();
          return;
        }

        if (currentLength < example.length) {
          currentPlaceholder.value = example.substring(0, currentLength + 1);
          currentLength++;
        } else {
          timer.cancel();
          Future.delayed(const Duration(seconds: 2), () {
            if (isAutoTyping.value) {
              currentPlaceholder.value = "";
              Future.delayed(const Duration(milliseconds: 500), () {
                _typeNextExample();
              });
            }
          });
        }
      });
    }
  }

  void _stopAutoTyping() {
    isAutoTyping.value = false;
    _typingTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 14.0.sp,
      color: AppTheme.textPrimary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppTheme.primaryBlue.withOpacity(0.15),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: 120.h),
                child: Stack(
                  children: [
                    // Animated placeholder overlay
                    Obx(() => isAutoTyping.value &&
                            currentPlaceholder.value.isNotEmpty
                        ? Positioned.fill(
                            child: Container(
                              padding: EdgeInsets.all(20.r),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  currentPlaceholder.value,
                                  style: textStyle.copyWith(
                                    color:
                                        AppTheme.textTertiary.withOpacity(0.4),
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()),
                    TextField(
                      controller: controller.textController,
                      maxLines: null,
                      minLines: 5,
                      textInputAction: TextInputAction.done,
                      style: textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        fontSize: 15.sp,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Start typing your email prompt...",
                        hintStyle: textStyle.copyWith(
                          color: AppTheme.textTertiary.withOpacity(0.6),
                          fontStyle: FontStyle.italic,
                          fontSize: 15.sp,
                        ),
                        contentPadding: EdgeInsets.all(20.r),
                      ),
                      onTap: () {
                        _stopAutoTyping();
                        currentPlaceholder.value = "";
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          _stopAutoTyping();
                          currentPlaceholder.value = "";
                          hasUserInput.value = true;
                        } else {
                          hasUserInput.value = false;
                          isAutoTyping.value = true;
                          _startAutoTyping();
                        }
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundGray.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Spacer(),
                    SizedBox(width: AppSpacing.md),
                    Flexible(
                      child: Obx(() => !controller.showAnimation.value
                          ? Container(
                              height: 52.h,
                              decoration: BoxDecoration(
                                gradient: hasUserInput.value
                                    ? LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppTheme.primaryBlue,
                                          AppTheme.secondaryTeal,
                                        ],
                                      )
                                    : null,
                                color: hasUserInput.value
                                    ? null
                                    : AppTheme.cardGray.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: hasUserInput.value
                                    ? [
                                        BoxShadow(
                                          color: AppTheme.primaryBlue
                                              .withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16.r),
                                  onTap: hasUserInput.value
                                      ? () {
                                          _stopAutoTyping();
                                          controller.submitPrompt(
                                              controller.textController.text);
                                        }
                                      : null,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.auto_awesome_rounded,
                                        size: 20.r,
                                        color: hasUserInput.value
                                            ? AppTheme.surfaceWhite
                                            : AppTheme.textSecondary,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        'Generate',
                                        style: AppTheme.bodyMedium.copyWith(
                                          color: hasUserInput.value
                                              ? AppTheme.surfaceWhite
                                              : AppTheme.textSecondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 52.h,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                color: AppTheme.cardGray.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_awesome_rounded,
                                    size: 20.r,
                                    color: AppTheme.textSecondary,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Generate',
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                    ),
                  ],
                ),
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
                        SingleChildScrollView(
                          child: Text(
                            email['body'] ?? 'No body content',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.visible,
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
                          backgroundColor: AppTheme.secondaryTeal,
                          text: 'Regenerate',
                          variant: ButtonVariant.secondary,
                          icon: Icon(
                            Icons.refresh_rounded,
                            size: 12.r,
                            color: AppTheme.textPrimary,
                          ),
                          onPressed: () {
                            controller
                                .submitPrompt(controller.textController.text);
                          },
                        ),
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Expanded(
                        flex: 2,
                        child: ModernButton(
                          backgroundColor: AppTheme.secondaryTeal,
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
