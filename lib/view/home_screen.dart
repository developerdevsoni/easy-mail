import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:easy_mail/view/ai_mail_generator_screen.dart';
import 'package:easy_mail/view/discoverTemplete_screen.dart';
import 'package:easy_mail/view/my_templates_screen.dart';
import 'package:easy_mail/services/force_update_service.dart';
import 'package:easy_mail/widgets/update_dialog.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
  late ScrollController _scrollController;

  bool _showFab = false;

  final List<Map<String, String>> myTemplates = [
    {
      'title': '📝 My Meeting Notes',
      'body':
          'Hi [Name],\n\nHere are the key points from our meeting today:\n\n• [Point 1]\n• [Point 2]\n• [Point 3]\n\nNext steps: [Action Items]',
      'regards': 'Best regards, [Your Name]',
      'category': 'Personal',
      'isCustom': 'true',
      'createdDate': '2024-01-15'
    },
    {
      'title': '🎯 Project Update Template',
      'body':
          'Hello Team,\n\nProject Status Update:\n\n✅ Completed:\n• [Task 1]\n• [Task 2]\n\n🔄 In Progress:\n• [Task 3]\n\n📅 Upcoming:\n• [Task 4]',
      'regards': 'Thanks, [Your Name]',
      'category': 'Business',
      'isCustom': 'true',
      'createdDate': '2024-01-12'
    },
    {
      'title': '🎉 Client Appreciation',
      'body':
          'Dear [Client Name],\n\nI wanted to personally thank you for choosing our services. Your trust and collaboration have been instrumental in achieving these fantastic results.\n\nLooking forward to continuing our partnership!',
      'regards': 'With gratitude, [Your Name]',
      'category': 'Thank You',
      'isCustom': 'true',
      'createdDate': '2024-01-10'
    },
    {
      'title': '📞 Follow-up Call Summary',
      'body':
          'Hi [Name],\n\nThank you for the call today. Here\'s a summary of what we discussed:\n\n🎯 Key Points:\n• [Point 1]\n• [Point 2]\n\n📋 Action Items:\n• [Action 1] - Due: [Date]\n• [Action 2] - Due: [Date]',
      'regards': 'Talk soon, [Your Name]',
      'category': 'Follow-up',
      'isCustom': 'true',
      'createdDate': '2024-01-08'
    },
    {
      'title': '💼 Weekly Team Check-in',
      'body':
          'Hello Team,\n\nTime for our weekly check-in! Please share:\n\n1. What you accomplished this week\n2. Current challenges\n3. Goals for next week\n\nLet\'s keep the momentum going!',
      'regards': 'Cheers, [Your Name]',
      'category': 'Business',
      'isCustom': 'true',
      'createdDate': '2024-01-05'
    },
  ];

  final List<Map<String, String>> globalTemplates = [
    // Business Templates
    {
      'title': '📋 Meeting Request',
      'body':
          'Dear [Name],\n\nI would like to schedule a meeting to discuss [Topic]. Please let me know your availability for next week.',
      'regards': 'Best regards, [Your Name]',
      'category': 'Business'
    },
    {
      'title': '📄 Proposal Submission',
      'body':
          'Dear [Name],\n\nPlease find attached our proposal for [Project Name]. We look forward to your feedback and next steps.',
      'regards': 'Sincerely, [Your Name]',
      'category': 'Business'
    },
    {
      'title': '🤝 Partnership Inquiry',
      'body':
          'Hello [Name],\n\nWe are interested in exploring potential partnership opportunities between our companies. Could we schedule a call to discuss?',
      'regards': 'Best regards, [Your Name]',
      'category': 'Business'
    },
    {
      'title': '🎯 New Campaign Launch',
      'body':
          'Hi [Name],\n\nWe\'re excited to introduce our latest campaign! Don\'t miss out on exclusive offers and updates.',
      'regards': 'The Marketing Team',
      'category': 'Marketing'
    },
    {
      'title': '🎁 Holiday Offer – Limited Time Only!',
      'body':
          'Hey [Name],\n\nWe ve got something special just for you — enjoy 40% OFF everything in our store until December 31st!',
      'regards': 'Warm wishes, The [Company] Team',
      'category': 'Sales'
    },
    {
      'title': '📅 Webinar Reminder – Starts in 1 Hour',
      'body':
          'Dear [Name],\n\nJust a friendly reminder that our webinar "AI Trends in 2025" starts in 1 hour.',
      'regards': 'Regards, Emily from [Company]',
      'category': 'Events'
    },
    {
      'title': '👋 Welcome Onboard!',
      'body':
          'Hi [Name],\n\nWelcome to [Platform Name] — we\'re so glad to have you! 🎉',
      'regards': 'Cheers, Customer Success Team',
      'category': 'Welcome'
    },
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: AppAnimations.slow,
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.96,
      end: 1.04,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: AppAnimations.gentleCurve,
    ));

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showFab) {
        setState(() {
          _showFab = true;
        });
      } else if (_scrollController.offset <= 300 && _showFab) {
        setState(() {
          _showFab = false;
        });
      }
    });

    _initializeForceUpdate();
  }

  void _initializeForceUpdate() async {
    try {
      await ForceUpdateService().initialize();
      await Future.delayed(AppAnimations.standard);
      await _checkForUpdate();
    } catch (e) {
      print('Force update initialization failed: $e');
    }
  }

  Future<void> _checkForUpdate() async {
    try {
      final updateStatus = await ForceUpdateService().checkForUpdate();
      
      if (updateStatus != UpdateStatus.noUpdate) {
        final updateConfig = ForceUpdateService().getUpdateConfig();
        
        if (updateConfig != null) {
          UpdateDialog.show(
            updateStatus: updateStatus,
            updateConfig: updateConfig,
          );
        }
      }
    } catch (e) {
      print('Update check failed: $e');
    }
  }

  Future<void> _testForceUpdate() async {
    try {
      print('🔍 DEBUG: Manual force update test triggered');
      await ForceUpdateService().forceRefreshConfig();
      await _checkForUpdate();
      print('🔍 DEBUG: Manual force update test completed');
    } catch (e) {
      print('❌ ERROR: Manual force update test failed: $e');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Hero AI Generator Card
                      AppAnimations.slideIn(
                        child: _buildHeroAICard(),
                        duration: AppAnimations.standard,
                      ),
                      
                      AppSpacing.verticalSpaceXL,
                      
                      // My Templates Section
                      AppAnimations.slideIn(
                        child: _buildMyTemplatesSection(),
                        duration: AppAnimations.complex,
                        begin: const Offset(-0.3, 0),
                      ),
                      
                      AppSpacing.verticalSpaceXL,
                      
                      // Global Templates Section
                      AppAnimations.slideIn(
                        child: _buildGlobalTemplatesSection(),
                        duration: AppAnimations.complex,
                        begin: const Offset(0.3, 0),
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
      floatingActionButton: AppAnimations.scaleIn(
        child: _buildAnimatedFAB(),
        duration: AppAnimations.standard,
      ),
    );
  }

  Widget _buildEnhancedHeader() {
    return Container(
      padding: AppSpacing.pagePadding,
      decoration: BoxDecoration(
        gradient: AppTheme.overlayGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        children: [
          // Enhanced Profile Section
          _buildProfileSection(),
          
          AppSpacing.horizontalSpaceSM,
          
          // Welcome Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: AppTheme.labelMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                AppSpacing.verticalSpaceXS,
                Obx(() => ShaderMask(
                      shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                      child: Text(
                        controller.userName.value.isNotEmpty
                            ? controller.userName.value.split(' ').first
                            : 'User',
                        style: AppTheme.headingLarge.copyWith(
                          color: AppTheme.surfaceWhite,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    )),
              ],
            ),
          ),
          
          // Action Buttons
          _buildActionButton(
            Icons.notifications_none_rounded,
            AppTheme.textSecondary,
            () {},
          ),
          AppSpacing.horizontalSpaceXS,
          _buildActionButton(
            Icons.refresh_rounded,
            AppTheme.informationBlue,
            () => _testForceUpdate(),
          ),
          AppSpacing.horizontalSpaceXS,
          _buildActionButton(
            Icons.logout_rounded,
            AppTheme.errorRed,
            () => _showLogoutDialog(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            padding: EdgeInsets.all(3.r),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Obx(() => CircleAvatar(
                  radius: 22.r,
                  backgroundColor: AppTheme.surfaceWhite,
                  backgroundImage: controller.photoUrl.value.isNotEmpty
                      ? NetworkImage(controller.photoUrl.value)
                      : null,
                  child: controller.photoUrl.value.isEmpty
                      ? Icon(
                          Icons.person_rounded,
                          size: 24.r,
                          color: AppTheme.primaryBlue,
                        )
                      : null,
                )),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: AppTheme.cardInteractive.copyWith(
          color: AppTheme.surfaceWhite,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 20.r,
        ),
      ),
    );
  }

  Widget _buildHeroAICard() {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: GestureDetector(
        onTap: () => Get.to(() => const AiMailGeneratorScreen()),
        child: Container(
          padding: AppSpacing.cardPadding,
          decoration: AppTheme.cardFeature.copyWith(
            gradient: AppTheme.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
              BoxShadow(
                color: AppTheme.shadowMedium,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // AI Icon
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppTheme.surfaceWhite,
                  size: 32.r,
                ),
              ),
              
              AppSpacing.horizontalSpaceMD,
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✨ Create with AI',
                      style: AppTheme.headingLarge.copyWith(
                        color: AppTheme.surfaceWhite,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    AppSpacing.verticalSpaceXS,
                    Text(
                      'Generate professional emails instantly using advanced AI',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.surfaceWhite.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppTheme.surfaceWhite,
                  size: 20.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyTemplatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: AppSpacing.sectionPadding,
          child: Row(
            children: [
              Text(
                'My Templates',
                style: AppTheme.headingMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.to(() => MyTemplatesScreen()),
                child: Text(
                  'View All',
                  style: AppTheme.labelMedium.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        AppSpacing.verticalSpaceSM,
        
        // Templates Horizontal List
        Container(
          height: 140.h,
          child: myTemplates.isNotEmpty
              ? ListView.builder(
                  padding: AppSpacing.sectionPadding,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: myTemplates.length,
                  itemBuilder: (context, index) {
                    final template = myTemplates[index];
                    return Container(
                      width: 260.w,
                      margin: EdgeInsets.only(
                        right: index == myTemplates.length - 1 ? 0 : AppSpacing.md,
                      ),
                      child: AppAnimations.slideIn(
                        child: _buildMyTemplateCard(template),
                        duration: Duration(milliseconds: 400 + (index * 100)),
                      ),
                    );
                  },
                )
              : _buildEmptyState('No custom templates yet', Icons.bookmark_border_rounded),
        ),
      ],
    );
  }

  Widget _buildMyTemplateCard(Map<String, String> template) {
    return GestureDetector(
      onTap: () => Get.to(() => EmailTemplateEditorScreen(selectedTemplate: template)),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: AppTheme.cardElevated,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.informationBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Custom',
                    style: AppTheme.labelSmall.copyWith(
                      color: AppTheme.informationBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  template['createdDate'] ?? '',
                  style: AppTheme.caption.copyWith(
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
            
            AppSpacing.verticalSpaceMD,
            
            // Title
            Text(
              template['title'] ?? 'Untitled',
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            AppSpacing.verticalSpaceSM,
            
            // Preview
            Expanded(
              child: Text(
                _getEmailPreview(template['body'] ?? ''),
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalTemplatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: AppSpacing.sectionPadding,
          child: Row(
            children: [
              Text(
                'Email Templates',
                style: AppTheme.headingMedium.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.to(() => DiscoverTemplatesPage()),
                child: Text(
                  'View All',
                  style: AppTheme.labelMedium.copyWith(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        AppSpacing.verticalSpaceSM,
        
        // Templates Grid
        Padding(
          padding: AppSpacing.sectionPadding,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
            ),
            itemCount: _getFilteredTemplates().length,
            itemBuilder: (context, index) {
              final template = _getFilteredTemplates()[index];
              return AppAnimations.slideIn(
                child: _buildTemplateCard(template, index),
                duration: Duration(milliseconds: 300 + (index * 50)),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateCard(Map<String, String> template, int index) {
    return GestureDetector(
      onTap: () => Get.to(() => EmailTemplateEditorScreen(selectedTemplate: template)),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: AppTheme.cardBasic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and Category
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    _getIconForTemplate(template['title'] ?? ''),
                    color: AppTheme.surfaceWhite,
                    size: 16.r,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundSecondary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppTheme.primaryBlue,
                    size: 12.r,
                  ),
                ),
              ],
            ),
            
            AppSpacing.verticalSpaceMD,
            
            // Title
            Text(
              template['title'] ?? 'Untitled',
              style: AppTheme.bodyLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            AppSpacing.verticalSpaceSM,
            
            // Preview
            Expanded(
              child: Text(
                _getEmailPreview(template['body'] ?? ''),
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      height: 140.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.r,
              color: AppTheme.textMuted,
            ),
            AppSpacing.verticalSpaceSM,
            Text(
              message,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedFAB() {
    return AnimatedScale(
      scale: _showFab ? 1.0 : 0.0,
      duration: AppAnimations.standard,
      curve: AppAnimations.bounceCurve,
      child: AnimatedOpacity(
        opacity: _showFab ? 1.0 : 0.0,
        duration: AppAnimations.standard,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () => Get.to(() => const AiMailGeneratorScreen()),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Icon(
              Icons.auto_awesome_rounded,
              color: AppTheme.surfaceWhite,
              size: 28.r,
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
  String _getEmailPreview(String body) {
    if (body.isEmpty) return 'No content available';

    List<String> lines = body
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    List<String> meaningfulLines = [];
    for (String line in lines) {
      String lowerLine = line.toLowerCase();
      if (lowerLine.startsWith('hi ') ||
          lowerLine.startsWith('hello ') ||
          lowerLine.startsWith('dear ') ||
          lowerLine.startsWith('hey ') ||
          line.contains('[name]') ||
          line.contains('[client name]') ||
          line.length < 10) {
        continue;
      }
      meaningfulLines.add(line);
      if (meaningfulLines.length >= 2) break;
    }

    return meaningfulLines.isNotEmpty
        ? meaningfulLines.join(' ')
        : lines.isNotEmpty
            ? lines.first
            : 'No content';
  }

  IconData _getIconForTemplate(String title) {
    if (title.isEmpty) return Icons.email_rounded;
    if (title.contains('🚀')) return Icons.rocket_launch_rounded;
    if (title.contains('🎁')) return Icons.card_giftcard_rounded;
    if (title.contains('📅')) return Icons.event_rounded;
    if (title.contains('👋')) return Icons.waving_hand_rounded;
    if (title.contains('📧')) return Icons.email_rounded;
    if (title.contains('📝')) return Icons.edit_rounded;
    if (title.contains('🎯')) return Icons.flag_rounded;
    if (title.contains('🎉')) return Icons.celebration_rounded;
    if (title.contains('📞')) return Icons.phone_rounded;
    if (title.contains('💼')) return Icons.business_rounded;
    return Icons.email_rounded;
  }

  List<Map<String, String>> _getFilteredTemplates() {
    return globalTemplates.take(6).toList();
  }

  void _showLogoutDialog() {
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
                child: _buildLogoutDialogContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutDialogContent() {
    return Container(
      margin: AppSpacing.pagePadding,
      padding: AppSpacing.cardPadding,
      decoration: AppTheme.cardElevated.copyWith(
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppTheme.errorRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Icon(
              Icons.logout_rounded,
              color: AppTheme.errorRed,
              size: 32.r,
            ),
          ),
          
          AppSpacing.verticalSpaceMD,
          
          // Title
          Text(
            'Sign Out',
            style: AppTheme.headingLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          
          AppSpacing.verticalSpaceSM,
          
          // Message
          Text(
            'Are you sure you want to sign out of your account?',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          
          AppSpacing.verticalSpaceLG,
          
          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: AppTheme.buttonSecondary,
                  child: Text('Cancel'),
                ),
              ),
              AppSpacing.horizontalSpaceMD,
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    controller.signOutGoogle();
                  },
                  style: AppTheme.buttonPrimary.copyWith(
                    backgroundColor: MaterialStateProperty.all(AppTheme.errorRed),
                  ),
                  child: Text('Sign Out'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
