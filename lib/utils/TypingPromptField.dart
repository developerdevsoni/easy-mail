import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/controllers/animatedTextWidget.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';

class TypingPromptField extends StatefulWidget {
  final TypingPromptController controller;
  const TypingPromptField({super.key, required this.controller});

  @override
  State<TypingPromptField> createState() => _TypingPromptFieldState();
}

class _TypingPromptFieldState extends State<TypingPromptField> {
  late final TypingPromptController _controller;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_onControllerChange);
    _focusNode.addListener(_onFocusChange);
    _textController.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    _focusNode.removeListener(_onFocusChange);
    _textController.removeListener(_onTextChange);
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isExpanded = _focusNode.hasFocus;
      });
    }
  }

  void _onTextChange() {
    if (mounted) {
      setState(() {
        // Update UI when text changes (for send button state)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input field
        Container(
          constraints: BoxConstraints(
            minHeight: 50.h,
            maxHeight: _isExpanded ? 120.h : 50.h,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppTheme.textPrimary,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppTheme.primaryPurple.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.backgroundDark.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Input field
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.backgroundDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Ask AI to help you write an email...',
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  maxLines: _isExpanded ? 3 : 1,
                  minLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                ),
              ),
              
              // Send button
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: _textController.text.trim().isEmpty
                    ? () {}
                    : () {
                        // Handle send message
                        _textController.clear();
                        _focusNode.unfocus();
                      },
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    gradient: _textController.text.trim().isEmpty
                        ? null
                        : AppTheme.primaryGradient,
                    color: _textController.text.trim().isEmpty
                        ? AppTheme.textSecondary.withOpacity(0.3)
                        : null,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: AppTheme.textPrimary,
                    size: 16.r,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Suggestions (if expanded)
        if (_isExpanded) ...[
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.textPrimary.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick suggestions:',
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.backgroundDark,
                  ),
                ),
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 6.h,
                  children: [
                    _buildSuggestionChip('Write a follow-up email'),
                    _buildSuggestionChip('Create a meeting request'),
                    _buildSuggestionChip('Draft a thank you note'),
                    _buildSuggestionChip('Write a professional inquiry'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        _textController.text = text;
        // Handle text update
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: AppTheme.primaryPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppTheme.primaryPurple.withOpacity(0.2),
            width: 0.5,
          ),
        ),
        child: Text(
          text,
          style: AppTheme.caption.copyWith(
            color: AppTheme.primaryPurple,
            fontWeight: FontWeight.w500,
            fontSize: 10.sp,
          ),
        ),
      ),
    );
  }
}
