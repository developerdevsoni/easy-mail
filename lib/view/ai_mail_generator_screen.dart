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

// Template model for API data
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
  late AnimationController _iconAnimationController;
  late AnimationController _pulseAnimationController;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadTemplates();
  }

  void _initializeAnimations() {
    // Icon rotation animation - more subtle
    _iconAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _iconRotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeInOut,
    ));

    // Pulse animation - very subtle
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _iconAnimationController.repeat();
    _pulseAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }

  void _showTipsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline_rounded,
                        color: AppTheme.surfaceWhite,
                        size: 22.r,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Tips for Better Emails',
                        style: AppTheme.heading3.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: AppTheme.textSecondary,
                        size: 20.r,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                _buildTipItem(
                    '🎯 Be specific about the purpose (sales, follow-up, announcement)'),
                _buildTipItem(
                    '🎨 Mention the tone you want (formal, casual, friendly)'),
                _buildTipItem(
                    '👥 Include key details like recipient type or context'),
                _buildTipItem('📞 Specify if you need a call-to-action'),
                _buildTipItem('📧 Mention any attachments or links needed'),
                _buildTipItem('⏰ Include urgency or timeline if relevant'),
                SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ModernButton(
                    text: 'Got it!',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 4.r),
            width: 4.r,
            height: 4.r,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Simulate API call - replace with actual API call
  Future<void> _loadTemplates() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - replace with actual API response
    setState(() {
      templates = [
        EmailTemplate(
          id: '1',
          title: 'Sales',
          icon: Icons.trending_up_rounded,
          gradient: AppTheme.primaryGradient,
          promptText: 'Write a professional sales follow-up email',
        ),
        EmailTemplate(
          id: '2',
          title: 'Launch',
          icon: Icons.rocket_launch_rounded,
          gradient: AppTheme.tealGradient,
          promptText: 'Create an exciting product launch announcement',
        ),
        EmailTemplate(
          id: '3',
          title: 'Thank You',
          icon: Icons.favorite_outline_rounded,
          gradient: AppTheme.goldGradient,
          promptText: 'Write a sincere thank you email',
        ),
        EmailTemplate(
          id: '4',
          title: 'Meeting',
          icon: Icons.meeting_room_rounded,
          gradient: AppTheme.primaryGradient,
          promptText: 'Schedule a meeting or call',
        ),
        EmailTemplate(
          id: '5',
          title: 'Update',
          icon: Icons.update_rounded,
          gradient: AppTheme.tealGradient,
          promptText: 'Send a project or status update',
        ),
        EmailTemplate(
          id: '6',
          title: 'Welcome',
          icon: Icons.waving_hand_rounded,
          gradient: AppTheme.goldGradient,
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
      backgroundColor: AppTheme.backgroundGray,
      body: SafeArea(
        child: Column(
          children: [
            // 🎯 ENHANCED HEADER
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppTheme.surfaceWhite,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundGray,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: AppTheme.textPrimary,
                        size: 18.r,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'AI Email Generator',
                          style: AppTheme.heading2.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Create professional emails with AI',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundGray,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: _showTipsDialog,
                      icon: Icon(
                        Icons.help_outline_rounded,
                        color: AppTheme.textSecondary,
                        size: 18.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 📝 MAIN CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SizedBox(height: AppSpacing.lg),

                    // 🎯 ENHANCED HERO SECTION
                    // Container(
                    //   padding: EdgeInsets.all(AppSpacing.lg),
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.bottomRight,
                    //       colors: [
                    //         AppTheme.primaryBlue.withOpacity(0.05),
                    //         AppTheme.secondaryTeal.withOpacity(0.05),
                    //       ],
                    //     ),
                    //     borderRadius: BorderRadius.circular(20.r),
                    //     border: Border.all(
                    //       color: AppTheme.primaryBlue.withOpacity(0.1),
                    //       width: 1,
                    //     ),
                    //   ),
                    //   child: Row(
                    //     children: [
                    //       // Enhanced Animated Awesome Icon
                    //       AnimatedBuilder(
                    //         animation: Listenable.merge([
                    //           _iconRotationAnimation,
                    //           _pulseAnimation,
                    //         ]),
                    //         builder: (context, child) {
                    //           return Transform.scale(
                    //             scale: _pulseAnimation.value,
                    //             child: Transform.rotate(
                    //               angle: _iconRotationAnimation.value *
                    //                   2 *
                    //                   3.14159,
                    //               child: Container(
                    //                 padding: EdgeInsets.all(16.r),
                    //                 decoration: BoxDecoration(
                    //                   gradient: LinearGradient(
                    //                     begin: Alignment.topLeft,
                    //                     end: Alignment.bottomRight,
                    //                     colors: [
                    //                       AppTheme.primaryBlue,
                    //                       AppTheme.secondaryTeal,
                    //                     ],
                    //                   ),
                    //                   borderRadius: BorderRadius.circular(16.r),
                    //                   boxShadow: [
                    //                     BoxShadow(
                    //                       color: AppTheme.primaryBlue
                    //                           .withOpacity(0.3),
                    //                       blurRadius: 15,
                    //                       offset: const Offset(0, 6),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 child: Icon(
                    //                   Icons.auto_awesome_rounded,
                    //                   color: AppTheme.surfaceWhite,
                    //                   size: 28.r,
                    //                 ),
                    //               ),
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //       SizedBox(width: AppSpacing.md),
                    //       Expanded(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               'AI-Powered Email Creation',
                    //               style: AppTheme.heading3.copyWith(
                    //                 fontWeight: FontWeight.w700,
                    //                 color: AppTheme.textPrimary,
                    //               ),
                    //             ),
                    //             SizedBox(height: AppSpacing.xs),
                    //             Text(
                    //               'Describe your email and let our AI create a professional, engaging message for you',
                    //               style: AppTheme.bodyMedium.copyWith(
                    //                 fontWeight: FontWeight.w500,
                    //                 color: AppTheme.textSecondary,
                    //                 height: 1.4,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),

                    // ),

                    SizedBox(height: AppSpacing.xl),

                    // Enhanced Typing Prompt Field
                    TypingPromptField(),

                    SizedBox(height: AppSpacing.xl),

                    // 🎯 ENHANCED QUICK TEMPLATES SECTION
                    Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.tealGradient,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  Icons.category_rounded,
                                  color: AppTheme.surfaceWhite,
                                  size: 16.r,
                                ),
                              ),
                              SizedBox(width: AppSpacing.sm),
                              Text(
                                'Quick Start Templates',
                                style: AppTheme.heading3.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              if (isLoading)
                                SizedBox(
                                  width: 18.r,
                                  height: 18.r,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.primaryBlue),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'Choose a template to get started quickly',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: AppSpacing.lg),

                          // Enhanced Grid View
                          isLoading
                              ? _buildLoadingGrid()
                              : _buildTemplatesGrid(controller),
                        ],
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // 🚀 ENHANCED ACTION BUTTON
                    Obx(() {
                      final generated = controller.result.value;
                      if (generated.isNotEmpty) {
                        return Container(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryBlue.withOpacity(0.05),
                                AppTheme.secondaryTeal.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppTheme.primaryBlue.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Ready to Edit?',
                                style: AppTheme.heading3.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: AppSpacing.sm),
                              Text(
                                'Your AI-generated email is ready for customization',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: AppSpacing.lg),
                              ModernButton(
                                text: 'Open in Email Editor',
                                icon: Icon(
                                  Icons.edit_rounded,
                                  color: AppTheme.surfaceWhite,
                                  size: 16.r,
                                ),
                                minimumSize: Size(double.infinity, 56.h),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EmailTemplateEditorScreen(
                                        selectedTemplate: {
                                          'title': generated["title"],
                                          'body': generated["body"],
                                          'regards': generated["regards"]
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.1,
      ),
      itemCount: 6, // Show 6 loading placeholders
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.backgroundGray,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: AppTheme.cardGray.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Container(
                width: 60.r,
                height: 10.r,
                decoration: BoxDecoration(
                  color: AppTheme.cardGray.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTemplatesGrid(TypingPromptController controller) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.1,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        return _buildQuickTemplateGrid(
          template.title,
          template.icon,
          template.gradient,
          controller,
          template.promptText,
        );
      },
    );
  }

  Widget _buildQuickTemplateGrid(
    String title,
    IconData icon,
    Gradient gradient,
    TypingPromptController controller,
    String promptText,
  ) {
    return GestureDetector(
      onTap: () {
        controller.textController.text = promptText;
        controller.submitPrompt(promptText);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: AppTheme.surfaceWhite,
                size: 24.r,
              ),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
