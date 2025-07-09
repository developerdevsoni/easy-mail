import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:easy_mail/utils/TypingPromptField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/animatedTextWidget.dart';

// Template model for AI suggestions
class EmailTemplate {
  final String id;
  final String title;
  final IconData icon;
  final Gradient gradient;
  final String promptText;

  EmailTemplate({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
    required this.promptText,
  });
}

class AiMailGeneratorScreen extends StatefulWidget {
  const AiMailGeneratorScreen({super.key});

  @override
  State<AiMailGeneratorScreen> createState() => _AiMailGeneratorScreenState();
}

class _AiMailGeneratorScreenState extends State<AiMailGeneratorScreen>
    with TickerProviderStateMixin {
  List<EmailTemplate> templates = [];
  bool isLoading = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadTemplates();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: AppAnimations.gentleCurve,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _showTipsDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: AppTheme.textPrimary.withOpacity(0.5),
      transitionDuration: AppAnimations.standard,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AppAnimations.slideIn(
          child: AppAnimations.scaleIn(
            child: Center(
              child: Material(
                type: MaterialType.transparency,
                child: _buildTipsDialogContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipsDialogContent() {
    return Container(
      margin: AppSpacing.pagePadding,
      padding: AppSpacing.cardPadding,
      decoration: AppTheme.cardElevated.copyWith(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppTheme.surfaceWhite,
                  size: 24.r,
                ),
              ),
              AppSpacing.horizontalSpaceMD,
              Expanded(
                child: Text(
                  'Writing Tips',
                  style: AppTheme.headingLarge.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.close_rounded,
                  color: AppTheme.textSecondary,
                  size: 24.r,
                ),
              ),
            ],
          ),
          
          AppSpacing.verticalSpaceLG,
          
          // Tips
          _buildTipItem('🎯', 'Be specific about the purpose and context'),
          _buildTipItem('🎨', 'Mention the desired tone (formal, casual, friendly)'),
          _buildTipItem('👥', 'Include recipient details and your relationship'),
          _buildTipItem('📞', 'Specify any call-to-action needed'),
          _buildTipItem('📎', 'Mention attachments or links if relevant'),
          _buildTipItem('⏰', 'Include urgency or timeline details'),
          
          AppSpacing.verticalSpaceLG,
          
          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: AppTheme.buttonLarge,
              child: Text('Got it!'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(String emoji, String text) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.cardPadding,
      decoration: AppTheme.cardBasic.copyWith(
        color: AppTheme.backgroundSecondary,
      ),
      child: Row(
        children: [
          Text(
            emoji,
            style: AppTheme.headingMedium,
          ),
          AppSpacing.horizontalSpaceMD,
          Expanded(
            child: Text(
              text,
              style: AppTheme.bodyMedium.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadTemplates() async {
    // Simulate loading
    await Future.delayed(AppAnimations.standard);

    setState(() {
      templates = [
        EmailTemplate(
          id: '1',
          title: 'Sales Email',
          icon: Icons.trending_up_rounded,
          gradient: AppTheme.primaryGradient,
          promptText: 'Write a professional sales follow-up email',
        ),
        EmailTemplate(
          id: '2',
          title: 'Product Launch',
          icon: Icons.rocket_launch_rounded,
          gradient: AppTheme.secondaryGradient,
          promptText: 'Create an exciting product launch announcement',
        ),
        EmailTemplate(
          id: '3',
          title: 'Thank You',
          icon: Icons.favorite_outline_rounded,
          gradient: AppTheme.accentGradient,
          promptText: 'Write a sincere thank you email',
        ),
        EmailTemplate(
          id: '4',
          title: 'Meeting Request',
          icon: Icons.meeting_room_rounded,
          gradient: AppTheme.primaryGradient,
          promptText: 'Schedule a meeting or call with someone',
        ),
        EmailTemplate(
          id: '5',
          title: 'Project Update',
          icon: Icons.update_rounded,
          gradient: AppTheme.secondaryGradient,
          promptText: 'Send a project or status update',
        ),
        EmailTemplate(
          id: '6',
          title: 'Welcome Message',
          icon: Icons.waving_hand_rounded,
          gradient: AppTheme.accentGradient,
          promptText: 'Welcome new clients or team members',
        ),
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TypingPromptController controller = Get.put(TypingPromptController());

    return Scaffold(
      backgroundColor: AppTheme.backgroundPrimary,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced Header
              _buildEnhancedHeader(),
              
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.pagePadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Hero Section
                      AppAnimations.slideIn(
                        child: _buildHeroSection(),
                        duration: AppAnimations.standard,
                      ),
                      
                      AppSpacing.verticalSpaceXL,
                      
                      // Templates Section
                      AppAnimations.slideIn(
                        child: _buildTemplatesSection(),
                        duration: AppAnimations.complex,
                        begin: const Offset(0, 0.3),
                      ),
                      
                      AppSpacing.verticalSpaceXL,
                      
                      // Prompt Input Section
                      AppAnimations.slideIn(
                        child: _buildPromptSection(controller),
                        duration: AppAnimations.complex,
                        begin: const Offset(0, 0.5),
                      ),
                      
                      AppSpacing.verticalSpaceLG,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedHeader() {
    return Container(
      padding: AppSpacing.sectionPadding,
      decoration: BoxDecoration(
        gradient: AppTheme.overlayGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: AppTheme.cardInteractive.copyWith(
                color: AppTheme.surfaceWhite,
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppTheme.textPrimary,
                size: 20.r,
              ),
            ),
          ),
          
          AppSpacing.horizontalSpaceMD,
          
          // Title Section
          Expanded(
            child: Column(
              children: [
                Text(
                  'AI Email Generator',
                  style: AppTheme.headingLarge.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalSpaceXS,
                Text(
                  'Create professional emails with AI assistance',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          AppSpacing.horizontalSpaceMD,
          
          // Tips Button
          GestureDetector(
            onTap: _showTipsDialog,
            child: Container(
              padding: EdgeInsets.all(12.r),
              decoration: AppTheme.cardInteractive.copyWith(
                color: AppTheme.informationBlue.withOpacity(0.1),
                border: Border.all(
                  color: AppTheme.informationBlue.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.help_outline_rounded,
                color: AppTheme.informationBlue,
                size: 20.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: AppTheme.cardFeature.copyWith(
        gradient: AppTheme.overlayGradient,
      ),
      child: Column(
        children: [
          // AI Icon with Animation
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(28.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: AppTheme.surfaceWhite,
                    size: 36.r,
                  ),
                ),
              );
            },
          ),
          
          AppSpacing.verticalSpaceLG,
          
          // Title and Description
          Text(
            'Generate Perfect Emails',
            style: AppTheme.headingXLarge.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.verticalSpaceSM,
          Text(
            'Use AI to craft professional, personalized emails in seconds. Choose a template or describe what you need.',
            style: AppTheme.bodyLarge.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Start Templates',
          style: AppTheme.headingMedium.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        AppSpacing.verticalSpaceSM,
        Text(
          'Choose a template to get started quickly',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        
        AppSpacing.verticalSpaceLG,
        
        // Templates Grid
        isLoading
            ? _buildLoadingGrid()
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.1,
                ),
                itemCount: templates.length,
                itemBuilder: (context, index) {
                  final template = templates[index];
                  return AppAnimations.slideIn(
                    child: _buildTemplateCard(template),
                    duration: Duration(milliseconds: 300 + (index * 100)),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildTemplateCard(EmailTemplate template) {
    return GestureDetector(
      onTap: () {
        final controller = Get.find<TypingPromptController>();
        controller.setText(template.promptText);
      },
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: AppTheme.cardElevated,
        child: Column(
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                gradient: template.gradient,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                template.icon,
                color: AppTheme.surfaceWhite,
                size: 24.r,
              ),
            ),
            
            AppSpacing.verticalSpaceMD,
            
            // Title
            Text(
              template.title,
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const Spacer(),
            
            // Action Arrow
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: AppTheme.backgroundSecondary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: AppTheme.primaryBlue,
                size: 16.r,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.1,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          padding: AppSpacing.cardPadding,
          decoration: AppTheme.cardBasic,
          child: Column(
            children: [
              Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundSecondary,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              AppSpacing.verticalSpaceMD,
              Container(
                height: 16.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundSecondary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromptSection(TypingPromptController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Describe Your Email',
          style: AppTheme.headingMedium.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        AppSpacing.verticalSpaceSM,
        Text(
          'Tell us what kind of email you want to create',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        
        AppSpacing.verticalSpaceLG,
        
        // Enhanced Prompt Input
        Container(
          decoration: AppTheme.cardElevated,
          child: TypingPromptField(
            controller: controller,
            onGenerate: (prompt) => _handleGenerate(prompt),
          ),
        ),
      ],
    );
  }

  void _handleGenerate(String prompt) {
    if (prompt.trim().isEmpty) {
      Get.snackbar(
        'Empty Prompt',
        'Please describe what kind of email you want to create',
        backgroundColor: AppTheme.warningOrange.withOpacity(0.1),
        colorText: AppTheme.warningOrange,
        borderRadius: 12.r,
        margin: AppSpacing.pagePadding,
      );
      return;
    }

    // Navigate to email editor with the generated content
    Get.to(() => EmailTemplateEditorScreen(
      selectedTemplate: {
        'title': 'AI Generated Email',
        'body': 'Generating your email...\n\nPrompt: $prompt',
        'regards': 'Best regards, [Your Name]',
        'category': 'AI Generated',
        'isAI': 'true',
      },
    ));
  }
}
