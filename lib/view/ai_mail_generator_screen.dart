import 'package:easy_mail/view/discoverTemplete_screen.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:easy_mail/utils/TypingPromptField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
// import 'mailEditor_screen.dart';
import '../controllers/animatedTextWidget.dart';

class AiMailGeneratorScreen extends StatelessWidget {
  const AiMailGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TypingPromptController controller = Get.put(TypingPromptController());
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: AppTheme.textPrimary,
              size: 16.r,
            ),
          ),
        ),
        title: Text(
          'AI Email Generator',
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Show help or settings
              },
              icon: Icon(
                Icons.help_outline_rounded,
                color: AppTheme.textSecondary,
                size: 16.r,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🎯 COMPACT HERO SECTION
              ModernCard(
                elevated: true,
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: AppTheme.surfaceWhite,
                        size: 24.r,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Create Professional Emails',
                            style: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            'Describe what you want to write and let AI craft the perfect email',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // 📝 PROMPT SECTION
              Text(
                'What would you like to write about?',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              SizedBox(height: AppSpacing.sm),
              
              // Enhanced Typing Prompt Field
              TypingPromptField(),
              
              SizedBox(height: AppSpacing.md),
              
              // 💡 COMPACT TIPS SECTION
              ModernCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline_rounded,
                          color: AppTheme.accentGold,
                          size: 16.r,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Tips for better results',
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    _buildTipItem('Be specific about the purpose (sales, follow-up, announcement)'),
                    _buildTipItem('Mention the tone you want (formal, casual, friendly)'),
                    _buildTipItem('Include key details like recipient type or context'),
                    _buildTipItem('Specify if you need a call-to-action'),
                  ],
                ),
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // 🎯 QUICK TEMPLATES
              Text(
                'Quick Start Templates',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: AppSpacing.sm),
              
              _buildQuickTemplate(
                'Sales Follow-up',
                'Follow up with a potential client after initial meeting',
                Icons.trending_up_rounded,
                AppTheme.primaryGradient,
                controller,
              ),
              SizedBox(height: AppSpacing.xs),
              
              _buildQuickTemplate(
                'Product Launch',
                'Announce new product or feature to customers',
                Icons.rocket_launch_rounded,
                AppTheme.tealGradient,
                controller,
              ),
              SizedBox(height: AppSpacing.xs),
              
              _buildQuickTemplate(
                'Thank You Note',
                'Express gratitude to clients or partners',
                Icons.favorite_outline_rounded,
                AppTheme.goldGradient,
                controller,
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // 🚀 ACTION BUTTON
              Obx(() {
                final generated = controller.result.value;
                if (generated.isNotEmpty) {
                  return ModernButton(
                    text: 'Use in Email Editor',
                    icon: Icon(
                      Icons.edit_rounded,
                      color: AppTheme.surfaceWhite,
                      size: 14.r,
                    ),
                    minimumSize: Size(double.infinity, 42.h),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailTemplateEditorScreen(
                            selectedTemplate: {
                              'title': generated["title"],
                              'body': generated["body"],
                              'regards': generated["regards"]
                            },
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundGray,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppTheme.cardGray,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppTheme.textSecondary,
                          size: 16.r,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Write your prompt above to generate an email',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTipItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4.r),
            width: 3.r,
            height: 3.r,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(1.5.r),
            ),
          ),
          SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              text,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textPrimary,
              ),
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuickTemplate(
    String title,
    String description,
    IconData icon,
    Gradient gradient,
    TypingPromptController controller,
  ) {
    return ModernCard(
      onTap: () {
        // Pre-fill the text field with template prompt
        String promptText = '';
        switch (title) {
          case 'Sales Follow-up':
            promptText = 'Write a professional follow-up email to a potential client after our initial meeting. Keep it friendly but business-focused.';
            break;
          case 'Product Launch':
            promptText = 'Create an exciting product launch announcement email. Make it engaging and include a clear call-to-action.';
            break;
          case 'Thank You Note':
            promptText = 'Write a sincere thank you email to a client or partner. Express genuine gratitude and maintain the relationship.';
            break;
        }
        controller.textController.text = promptText;
        controller.submitPrompt(promptText);
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              color: AppTheme.surfaceWhite,
              size: 16.r,
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppTheme.textSecondary,
            size: 12.r,
          ),
        ],
      ),
    );
  }
}
