import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_mail/utils/TypingPromptField.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  bool isGenerating = false;
  String generatedEmail = '';
  String generatedSubject = '';
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
                  color: AppTheme.textPrimary,
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
      backgroundColor: AppTheme.backgroundDark,
      body: CosmicBackgroundDecoration(
        showStars: true,
        showPlanets: true,
        child: SafeArea(
          child: Column(
            children: [
              // Compact Header
              _buildCompactHeader(),
              
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppSpacing.verticalSpaceSM,
                      
                      // Compact Hero Section
                      // AppAnimations.slideIn(
                      //   child: _buildCompactHeroSection(),
                      //   duration: AppAnimations.standard,
                      // ),
                      
                      AppSpacing.verticalSpaceMD,
                      
                      // Prompt Input Section
                      AppAnimations.slideIn(
                        child: _buildImprovedPromptSection(controller),
                        duration: AppAnimations.complex,
                        begin: const Offset(0, 0.3),
                      ),
                      
                      AppSpacing.verticalSpaceMD,
                      
                      // Generated Email Section
                      if (isGenerating || generatedEmail.isNotEmpty)
                        AppAnimations.slideIn(
                          child: _buildGeneratedEmailSection(),
                          duration: AppAnimations.standard,
                        ),
                      
                      if (generatedEmail.isNotEmpty) AppSpacing.verticalSpaceMD,
                      
                      // Templates Section
                      AppAnimations.slideIn(
                        child: _buildTemplatesSection(),
                        duration: AppAnimations.complex,
                        begin: const Offset(0, 0.5),
                      ),
                      
                      AppSpacing.verticalSpaceMD,
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

  Widget _buildCompactHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: AppTheme.overlayGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppTheme.textPrimary,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.backgroundDark.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppTheme.backgroundDark,
                size: 18.r,
              ),
            ),
          ),
          
          AppSpacing.horizontalSpaceSM,
          
          // Title Section
          Expanded(
            child: Column(
              children: [
                Text(
                  'AI Email Generator',
                  style: AppTheme.headingMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Create professional emails with AI',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 11.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          AppSpacing.horizontalSpaceSM,
          
          // Tips Button
          GestureDetector(
            onTap: _showTipsDialog,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Icon(
                Icons.help_outline_rounded,
                color: AppTheme.primaryPurple,
                size: 18.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeroSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.secondaryLavenderLight.withOpacity(1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.textPrimary.withOpacity(.9),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.backgroundDark.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // AI Icon with Animation
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryPurple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: AppTheme.textPrimary,
                    size: 24.r,
                  ),
                ),
              );
            },
          ),
          
          AppSpacing.horizontalSpaceMD,
          
          // Title and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Generate Perfect Emails',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.backgroundDark,
                  ),
                ),
                AppSpacing.verticalSpaceXS,
                Text(
                  'Choose a template or describe your needs. AI will craft professional emails in seconds.',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.backgroundDark.withOpacity(0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
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
            color: AppTheme.textPrimary,
          ),
        ),
        // AppSpacing.verticalSpaceXS,
        // Text(
        //   'Choose a template to get started quickly',
        //   style: AppTheme.bodySmall.copyWith(
        //     color: AppTheme.textSecondary,
        //     fontSize: 11.sp,
        //   ),
        // ),
        
        AppSpacing.verticalSpaceMD,
        
        // Templates Grid
        isLoading
            ? _buildLoadingGrid()
            : GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 1.0,
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
        // Set template text and navigate
        Get.to(() => EmailTemplateEditorScreen(
          selectedTemplate: {
            'title': template.title,
            'body': template.promptText,
            'category': 'AI Generated',
          },
        ));
      },
      child: Stack(
        children: [
          // Card SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/svg_images/card.svg',
              fit: BoxFit.fill,
            ),
          ),
          
          // Content
          Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Category
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        gradient: template.gradient,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        template.icon,
                        color: AppTheme.textPrimary,
                        size: 18.r,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'AI',
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.primaryPurple,
                          fontWeight: FontWeight.w600,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                
                AppSpacing.verticalSpaceSM,
                
                // Title
                Text(
                  template.title,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                AppSpacing.verticalSpaceXS,
                
                // Description
                Expanded(
                  child: Text(
                    template.promptText,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.3,
                      fontSize: 10.sp,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildImprovedPromptSection(TypingPromptController controller) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.textPrimary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.backgroundDark.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryPurple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppTheme.textPrimary,
                  size: 20.r,
                ),
              ),
              AppSpacing.horizontalSpaceMD,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Describe Your Email',
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    AppSpacing.verticalSpaceXS,
                    Text(
                      'Tell AI what kind of email you want to create',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          AppSpacing.verticalSpaceMD,
          
          // Improved Text Input Field with Generate Button
          _buildPromptInputField(controller),
          
          AppSpacing.verticalSpaceSM,
          
          // Helper text with examples
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppTheme.primaryPurple,
                  size: 16.r,
                ),
                AppSpacing.horizontalSpaceXS,
                Expanded(
                  child: Text(
                    'Examples: "Professional follow-up email to client", "Thank you note for interview", "Meeting request with team"',
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.textSecondary,
                      fontSize: 10.sp,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptInputField(TypingPromptController controller) {
    final TextEditingController textController = TextEditingController();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Proper Text Input Field
        Container(
          width: double.infinity,
          // padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceGlass,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppTheme.primaryPurple.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: TextField(
          
            controller: textController,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.backgroundDark,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16.w),
              hintText: 'Describe the email you want to create...'/*\n\nExample: "Write a professional follow-up email to a client about project updates"'*/,
              hintStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textMuted,
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
              
              isDense: true,
            ),
            maxLines: 4,
            minLines: 4,
            textAlignVertical: TextAlignVertical.top,
          ),
        ),
        
        AppSpacing.verticalSpaceMD,
        
        // Generate Button Below
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () => _handleGenerate(textController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: AppTheme.textPrimary,
                    size: 20.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Generate Email',
                    style: AppTheme.bodyLarge.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneratedEmailSection() {
    if (isGenerating) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppTheme.textPrimary.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.backgroundDark.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(AppTheme.primaryPurple),
            ),
            AppSpacing.verticalSpaceMD,
            Text(
              'Generating your email...',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppTheme.textPrimary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.backgroundDark.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.email_rounded,
                  color: AppTheme.textPrimary,
                  size: 16.r,
                ),
              ),
              AppSpacing.horizontalSpaceSM,
              Expanded(
                child: Text(
                  'Generated Email',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    generatedEmail = '';
                    generatedSubject = '';
                  });
                },
                icon: Icon(
                  Icons.close_rounded,
                  color: AppTheme.textSecondary,
                  size: 20.r,
                ),
              ),
            ],
          ),
          
          AppSpacing.verticalSpaceMD,
          
          // Subject
          if (generatedSubject.isNotEmpty) ...[
            Text(
              'Subject:',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppSpacing.verticalSpaceXS,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundDark.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                generatedSubject,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AppSpacing.verticalSpaceMD,
          ],
          
          // Email Content
          Text(
            'Email Content:',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.verticalSpaceXS,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppTheme.backgroundDark.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              generatedEmail,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
                height: 1.5,
              ),
            ),
          ),
          
          AppSpacing.verticalSpaceMD,
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Copy to clipboard functionality
                    final fullEmail = '''Subject: $generatedSubject

$generatedEmail''';
                    Clipboard.setData(ClipboardData(text: fullEmail));
                    Get.snackbar(
                      'Copied!',
                      'Email copied to clipboard',
                      backgroundColor: AppTheme.successGreen.withOpacity(0.1),
                      colorText: AppTheme.successGreen,
                    );
                  },
                  icon: Icon(Icons.copy_rounded, size: 16.r),
                  label: Text('Copy'),
                  style: AppTheme.buttonSecondary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to email editor
                    Get.to(() => EmailTemplateEditorScreen(
                      selectedTemplate: {
                        'title': generatedSubject.isNotEmpty ? generatedSubject : 'AI Generated Email',
                        'body': generatedEmail,
                        'regards': 'Best regards, [Your Name]',
                        'category': 'AI Generated',
                      },
                    ));
                  },
                  icon: Icon(Icons.edit_rounded, size: 16.r),
                  label: Text('Edit'),
                  style: AppTheme.buttonPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
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

    // Start generating
    setState(() {
      isGenerating = true;
      generatedEmail = '';
      generatedSubject = '';
    });

    // Simulate AI generation with delay
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isGenerating = false;
          generatedSubject = _generateSubject(prompt);
          generatedEmail = _generateEmailContent(prompt);
        });
      }
    });
  }

  String _generateSubject(String prompt) {
    // Enhanced subject generation based on prompt analysis
    final lowerPrompt = prompt.toLowerCase();
    
    // Follow-up subjects
    if (lowerPrompt.contains('follow up') || lowerPrompt.contains('follow-up')) {
      if (lowerPrompt.contains('client') || lowerPrompt.contains('customer')) {
        return 'Following up on our discussion - Next steps';
      } else if (lowerPrompt.contains('meeting') || lowerPrompt.contains('interview')) {
        return 'Thank you for the meeting - Follow-up information';
      } else {
        return 'Following up on our conversation';
      }
    }
    // Meeting/scheduling subjects
    else if (lowerPrompt.contains('meeting') || lowerPrompt.contains('schedule') || lowerPrompt.contains('call')) {
      if (lowerPrompt.contains('team') || lowerPrompt.contains('project')) {
        return 'Team Meeting Request - Project Coordination';
      } else {
        return 'Meeting Request - Let\'s Connect';
      }
    }
    // Thank you subjects  
    else if (lowerPrompt.contains('thank') || lowerPrompt.contains('appreciation')) {
      if (lowerPrompt.contains('interview')) {
        return 'Thank you for the interview - [Position Title]';
      } else if (lowerPrompt.contains('client') || lowerPrompt.contains('customer')) {
        return 'Thank you for your partnership';
      } else {
        return 'Thank you for your support';
      }
    }
    // Introduction subjects
    else if (lowerPrompt.contains('introduction') || lowerPrompt.contains('introduce') || lowerPrompt.contains('inquiry')) {
      return 'Introduction and Collaboration Opportunity';
    }
    // Application/proposal subjects
    else if (lowerPrompt.contains('application') || lowerPrompt.contains('proposal') || lowerPrompt.contains('opportunity')) {
      return 'Application for [Position/Opportunity]';
    }
    // Default subject
    else {
      return 'Professional Communication - ' + (prompt.length > 30 ? prompt.substring(0, 30) + '...' : prompt);
    }
  }

  String _generateEmailContent(String prompt) {
    // Enhanced email generation based on prompt analysis
    final lowerPrompt = prompt.toLowerCase();
    
    // More specific follow-up scenarios
    if (lowerPrompt.contains('follow up') || lowerPrompt.contains('follow-up')) {
      if (lowerPrompt.contains('client') || lowerPrompt.contains('customer')) {
        return '''Dear [Client Name],

I hope this email finds you well. I wanted to follow up on our recent discussion regarding [project/service] and check on the status of your decision.

Since our last conversation, I've been thinking about the points you raised, and I believe we can address your concerns effectively. Our team is ready to move forward and deliver the results you're looking for.

Would you be available for a brief call this week to discuss next steps? I'm confident we can create a solution that meets your needs and exceeds your expectations.

Thank you for your time and consideration.

Best regards,
[Your Name]''';
      } else if (lowerPrompt.contains('meeting') || lowerPrompt.contains('interview')) {
        return '''Dear [Name],

Thank you for taking the time to meet with me yesterday. I wanted to follow up on our discussion and provide the additional information we talked about.

As mentioned, I'm very excited about the opportunity and believe my experience in [relevant field] would be valuable to your team. I've attached [documents/portfolio] for your review.

Please let me know if you need any additional information or if there are next steps in the process.

I look forward to hearing from you.

Best regards,
[Your Name]''';
      } else {
        return '''Dear [Name],

I hope you're doing well. I wanted to follow up on our previous conversation about [topic] and see if you've had a chance to consider what we discussed.

I'm still very interested in moving forward and would love to continue our dialogue. Please let me know if you have any questions or if there's additional information I can provide.

Looking forward to your response.

Best regards,
[Your Name]''';
      }
    } 
    // Meeting request scenarios
    else if (lowerPrompt.contains('meeting') || lowerPrompt.contains('schedule') || lowerPrompt.contains('call')) {
      if (lowerPrompt.contains('team') || lowerPrompt.contains('project')) {
        return '''Dear Team,

I hope everyone is doing well. I'd like to schedule a team meeting to discuss our upcoming project milestones and coordinate our efforts for the next quarter.

Here are the topics I'd like to cover:
• Project progress review
• Upcoming deadlines and deliverables
• Resource allocation and team responsibilities
• Q&A and open discussion

Would everyone be available for a 1-hour meeting next week? Please reply with your availability, and I'll send out a calendar invite with the final details.

Thank you for your time.

Best regards,
[Your Name]''';
      } else {
        return '''Dear [Name],

I hope this email finds you well. I would like to schedule a meeting with you to discuss [specific topic/project] and explore potential collaboration opportunities.

I believe there's great value in connecting to share insights and discuss how we might work together. Would you be available for a 30-45 minute meeting in the coming weeks?

I'm flexible with timing and can accommodate your schedule. Please let me know what works best for you.

Looking forward to our conversation.

Best regards,
[Your Name]''';
      }
    }
    // Thank you scenarios
    else if (lowerPrompt.contains('thank') || lowerPrompt.contains('appreciation')) {
      if (lowerPrompt.contains('interview')) {
        return '''Dear [Interviewer Name],

Thank you for taking the time to interview me for the [Position Title] role at [Company Name]. I thoroughly enjoyed our conversation and learning more about the team's goals and challenges.

Our discussion reinforced my enthusiasm for this opportunity. I'm particularly excited about [specific aspect discussed] and how my experience in [relevant area] could contribute to your team's success.

Please don't hesitate to reach out if you need any additional information or references. I look forward to the next steps in the process.

Thank you again for your time and consideration.

Best regards,
[Your Name]''';
      } else if (lowerPrompt.contains('client') || lowerPrompt.contains('customer')) {
        return '''Dear [Client Name],

I wanted to take a moment to express my sincere gratitude for choosing [Company/Service] and for the trust you've placed in our team.

Working with you on [project/service] has been a pleasure, and we're proud of the results we've achieved together. Your feedback and collaboration have been instrumental in making this project a success.

We look forward to continuing our partnership and supporting your future needs. Please don't hesitate to reach out if there's anything more we can do for you.

Thank you once again for your business and partnership.

Best regards,
[Your Name]''';
      } else {
        return '''Dear [Name],

I wanted to reach out and express my heartfelt gratitude for [specific reason]. Your [support/guidance/assistance] has made a significant impact, and I truly appreciate the time and effort you've invested.

Thanks to your help, I was able to [specific achievement or outcome]. This wouldn't have been possible without your expertise and generosity.

I hope to have the opportunity to return the favor in the future. Please don't hesitate to reach out if there's ever anything I can do for you.

With sincere appreciation,
[Your Name]''';
      }
    }
    // Professional inquiry/introduction
    else if (lowerPrompt.contains('introduction') || lowerPrompt.contains('introduce') || lowerPrompt.contains('inquiry')) {
      return '''Dear [Name],

I hope this email finds you well. My name is [Your Name], and I'm reaching out to introduce myself and explore potential opportunities for collaboration.

I came across your work in [field/industry] and was impressed by [specific achievement or project]. Given my background in [your expertise], I believe there might be synergies between our work.

I would love the opportunity to learn more about your current projects and discuss how we might work together. Would you be available for a brief call or coffee meeting in the coming weeks?

Thank you for your time, and I look forward to hearing from you.

Best regards,
[Your Name]''';
    }
    // Job application or proposal
    else if (lowerPrompt.contains('application') || lowerPrompt.contains('proposal') || lowerPrompt.contains('opportunity')) {
      return '''Dear [Hiring Manager/Name],

I am writing to express my strong interest in the [Position/Opportunity] at [Company Name]. With my background in [relevant field] and [X years] of experience, I am confident I would be a valuable addition to your team.

In my previous role at [Previous Company], I successfully [key achievement]. This experience has prepared me well for the challenges and opportunities this position presents.

I have attached my resume and portfolio for your review. I would welcome the opportunity to discuss my qualifications further and learn more about how I can contribute to your team's success.

Thank you for considering my application. I look forward to hearing from you.

Sincerely,
[Your Name]''';
    }
    // Default professional email
    else {
      return '''Dear [Name],

I hope this email finds you well. I'm reaching out regarding [specific topic mentioned in your request].

Based on your requirements: "${prompt}"

I believe this is an excellent opportunity for us to [collaborate/discuss/move forward]. I would appreciate the chance to [next steps based on context].

Please let me know your thoughts, and I'm happy to provide any additional information you might need.

Thank you for your time and consideration.

Best regards,
[Your Name]''';
    }
  }
}
