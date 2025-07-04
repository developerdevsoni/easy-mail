import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:easy_mail/view/ai_mail_generator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final AuthController controller = Get.put(AuthController());
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, String>> globalTemplates = [
    {
      'title': '🚀 Product Launch Announcement',
      'body': 'Hi [Name],\n\nWe re excited to let you know that our new product is live! Discover the features, explore the possibilities, and let us know what you think.',
      'regards': 'Best regards,  Team [Your Company]'
    },
    {
      'title': '🎁 Holiday Offer – Limited Time Only!',
      'body': 'Hey [Name],\n\nWe ve got something special just for you — enjoy 40% OFF everything in our store until December 31st!',
      'regards': 'Warm wishes,  The [Company] Team'
    },
    {
      'title': '📅 Webinar Reminder – Starts in 1 Hour',
      'body': 'Dear [Name],\n\nJust a friendly reminder that our webinar "AI Trends in 2025" starts in 1 hour.',
      'regards': 'Regards, Emily from [Company]'
    },
    {
      'title': '👋 Welcome Onboard!',
      'body':"Hi [Name],\n\nWelcome to [Platform Name] — we're so glad to have you! 🎉",
      'regards': 'Cheers, Customer Success Team'
    },
  ];

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundGray,
              AppTheme.backgroundGray.withOpacity(0.8),
              AppTheme.primaryBlue.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    // Profile Section
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            padding: EdgeInsets.all(2.r),
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  AppTheme.accentGold,
                                  AppTheme.primaryBlue,
                                  AppTheme.secondaryTeal,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryBlue.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Obx(() => CircleAvatar(
                              radius: 20.r,
                              backgroundColor: AppTheme.surfaceWhite,
                              backgroundImage: controller.photoUrl.value.isNotEmpty
                                  ? NetworkImage(controller.photoUrl.value)
                                  : null,
                              child: controller.photoUrl.value.isEmpty
                                  ? Icon(
                                      Icons.person_rounded,
                                      size: 20.r,
                                      color: AppTheme.primaryBlue,
                                    )
                                  : null,
                            )),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: AppSpacing.sm),
                    
                    // Welcome Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          Obx(() => ShaderMask(
                            shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                            child: Text(
                              controller.userName.value.isNotEmpty
                                  ? controller.userName.value.split(' ').first
                                  : 'User',
                              style: AppTheme.heading3.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    
                    // Action Buttons
                    _buildActionButton(Icons.notifications_none_rounded, AppTheme.textSecondary, () {}),
                    SizedBox(width: AppSpacing.xs),
                    _buildActionButton(Icons.logout_rounded, AppTheme.errorRed, () async => await controller.signOutGoogle()),
                  ],
                ),
              ),
              
              // AI Generator Hero Card
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryBlue,
                        AppTheme.secondaryTeal,
                        AppTheme.accentGold.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: ModernCard(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    onTap: () {
                      Get.to(() => const AiMailGeneratorScreen());
                    },
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceWhite.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: AppTheme.surfaceWhite,
                            size: 32.r,
                          ),
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '✨ Create with AI',
                                style: AppTheme.heading2.copyWith(
                                  color: AppTheme.surfaceWhite,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: AppSpacing.xs),
                              Text(
                                'Generate professional emails in seconds',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.surfaceWhite.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: AppTheme.surfaceWhite,
                          size: 20.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: AppSpacing.lg),
              
              // Templates Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  children: [
                    Text(
                      '📧 Email Templates',
                      style: AppTheme.heading3.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'View All',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: AppSpacing.md),
              
              // Templates Grid
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppSpacing.sm,
                      crossAxisSpacing: AppSpacing.sm,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: globalTemplates.length,
                    itemBuilder: (context, index) {
                      final template = globalTemplates[index];
                      return _buildTemplateCard(
                        template['title']!,
                        template['body']!,
                        () {
                          Get.to(() => EmailTemplateEditorScreen(
                            selectedTemplate: template,
                          ));
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 18.r,
        ),
      ),
    );
  }

  Widget _buildTemplateCard(String title, String body, VoidCallback onTap) {
    return ModernCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              _getIconForTemplate(title),
              color: AppTheme.surfaceWhite,
              size: 20.r,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            body.split('\n').first,
            style: AppTheme.caption.copyWith(
              color: AppTheme.textSecondary,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: AppTheme.backgroundGray,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: AppTheme.primaryBlue,
              size: 12.r,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTemplate(String title) {
    if (title.contains('🚀')) return Icons.rocket_launch_rounded;
    if (title.contains('🎁')) return Icons.card_giftcard_rounded;
    if (title.contains('📅')) return Icons.event_rounded;
    if (title.contains('👋')) return Icons.waving_hand_rounded;
    return Icons.email_rounded;
  }
}