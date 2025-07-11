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
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';

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

  final List<Map<String, String>> predefinedTemplates = [
    {
      'title': '🔥 New Feature Launch',
      'body':
          'Hey [Name],\n\nWe\'re excited to announce our latest feature - [Feature Name]! This new addition will help you [benefit].',
      'regards': 'Cheers, [Your Name]',
      'category': 'Product Updates'
    },
    {
      'title': '🎁 Special Offer Just for You',
      'body':
          'Hi [Name],\n\nWe have an exclusive offer just for you! Get [discount]% off on [product/service].',
      'regards': 'Best deals, [Your Name]',
      'category': 'Promotions'
    },
    {
      'title': '📊 Monthly Report Summary',
      'body':
          'Dear [Name],\n\nHere\'s your monthly summary:\n\n📈 Key Metrics:\n• [Metric 1]: [Value]\n• [Metric 2]: [Value]\n\n🎯 Goals for next month:\n• [Goal 1]\n• [Goal 2]',
      'regards': 'Best regards, [Your Name]',
      'category': 'Reports'
    },
    {
      'title': '💡 Quick Question',
      'body':
          'Hi [Name],\n\nI hope you\'re doing well! I have a quick question about [topic].',
      'regards': 'Thanks, [Your Name]',
      'category': 'Inquiry'
    },
    {
      'title': '🚀 Project Kickoff',
      'body':
          'Hello [Name],\n\nI\'m excited to start working on [project name] with you!\n\n📅 Timeline: [dates]\n🎯 Key objectives:\n• [Objective 1]\n• [Objective 2]',
      'regards': 'Looking forward, [Your Name]',
      'category': 'Project Management'
    },
    {
      'title': '🤝 Partnership Proposal',
      'body':
          'Dear [Name],\n\nI hope this email finds you well. I\'d like to discuss a potential partnership opportunity between our companies.',
      'regards': 'Best regards, [Your Name]',
      'category': 'Business'
    },
    {
      'title': '🎉 Congratulations!',
      'body':
          'Hi [Name],\n\nCongratulations on [achievement]! This is a fantastic milestone.',
      'regards': 'Cheers, [Your Name]',
      'category': 'Congratulations'
    },
    {
      'title': '📅 Meeting Request',
      'body':
          'Hi [Name],\n\nI\'d like to schedule a meeting to discuss [topic]. Are you available on [date/time]?',
      'regards': 'Best regards, [Your Name]',
      'category': 'Meetings'
    },
    {
      'title': '🔔 Important Update',
      'body':
          'Dear [Name],\n\nI wanted to inform you about an important update regarding [subject].',
      'regards': 'Best regards, [Your Name]',
      'category': 'Updates'
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
      await ForceUpdateService().checkForUpdate();
    } catch (e) {
      print('Force update check failed: $e');
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
      backgroundColor:AppTheme.secondaryLavenderLight,
      body: Stack(
        children: [
          // SVG Background
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/svg_images/home_bg.svg',
              fit: BoxFit.cover,
            ),
          ),
          
          // Blur and overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.backgroundDark.withOpacity(0.1),
                      AppTheme.backgroundDark.withOpacity(0.3),
                      AppTheme.backgroundDark.withOpacity(0.4),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SafeArea(
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
                        
                        AppSpacing.verticalSpaceSM,
                        
                        // My Templates Section
                        AppAnimations.slideIn(
                          child: _buildMyTemplatesSection(),
                          duration: AppAnimations.complex,
                          begin: const Offset(-0.3, 0),
                        ),
                        
                        // AppSpacing.verticalSpaceMD,
                        
                        // Global Templates Section
                        AppAnimations.slideIn(
                          child: _buildGlobalTemplatesSection(),
                          duration: AppAnimations.complex,
                          begin: const Offset(0.3, 0),
                        ),
                        
                        AppSpacing.verticalSpaceXS,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AppAnimations.scaleIn(
        child: _buildAnimatedFAB(),
        duration: AppAnimations.standard,
      ),
    );
  }

  Widget _buildEnhancedHeader() {
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
                          color: AppTheme.textPrimary,
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
            Icons.logout_rounded,
            AppTheme.errorRed,
            () {
              Get.dialog(
                AlertDialog(
                  backgroundColor: AppTheme.backgroundSecondary,
                  title: Text(
                    'Logout',
                    style: AppTheme.headingMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to logout?',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        controller.signOutGoogle();
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: AppTheme.errorRed),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Obx(() => GestureDetector(
          onTap: () {
            Get.snackbar(
              'Profile',
              'Profile settings coming soon!',
              backgroundColor: AppTheme.infoPurple.withOpacity(0.1),
              colorText: AppTheme.infoPurple,
              borderRadius: 12.r,
              margin: AppSpacing.pagePadding,
            );
          },
          child: Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 18.r,
              backgroundColor: AppTheme.textPrimary,
                             child: controller.photoUrl.value.isNotEmpty
                   ? ClipOval(
                       child: Image.network(
                         controller.photoUrl.value,
                         width: 32.r,
                         height: 32.r,
                         fit: BoxFit.cover,
                       ),
                     )
                   : Icon(
                       Icons.person_rounded,
                       color: AppTheme.primaryPurple,
                       size: 20.r,
                     ),
            ),
          ),
        ));
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: AppTheme.cardInteractive.copyWith(
          color: AppTheme.textPrimary,
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
              // AI Icon
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppTheme.textPrimary,
                  size: 24.r,
                ),
              ),
              
              AppSpacing.verticalSpaceMD,
              
              // Title and Description
              Text(
                'AI Email Generator',
                style: AppTheme.headingLarge.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              AppSpacing.verticalSpaceXS,
              Text(
                'Create professional emails in seconds using AI',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              AppSpacing.verticalSpaceMD,
              
              // CTA Button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryPurple,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: AppTheme.textPrimary,
                      size: 14.r,
                    ),
                    AppSpacing.horizontalSpaceXS,
                    Text(
                      'Generate Now',
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
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
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          // padding: AppSpacing.pagePadding,
          child: Row(
            children: [
              Icon(
                Icons.bookmark_rounded,
                color: AppTheme.primaryPurple,
                size: 20.r,
              ),
              AppSpacing.horizontalSpaceSM,
              Expanded(
                child: Text(
                  'My Templates',
                  style: AppTheme.headingMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => MyTemplatesScreen()),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppTheme.textPrimary.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppTheme.textPrimary.withOpacity(0.5),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.backgroundDark.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppTheme.primaryPurple,
                        size: 14.r,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        AppSpacing.verticalSpaceMD,
        
        // Templates Grid
        SizedBox(
          height: 140.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: myTemplates.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200.w,
                margin: EdgeInsets.only(
                  right: 12.w,
                  left: index == 0 ? 24.w : 0,
                ),
                child: _buildTemplateCard(myTemplates[index], index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGlobalTemplatesSection() {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            children: [
              // Icon(
              //   Icons.public_rounded,
              //   color: AppTheme.primaryPurple,
              //   size: 20.r,
              // ),
              // AppSpacing.horizontalSpaceSM,
              Expanded(
                child: Text(
                  'Discover Templates',
                  style: AppTheme.headingMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.to(() => DiscoverTemplatesPage()),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppTheme.textPrimary.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppTheme.textPrimary.withOpacity(0.5),
                      width: 0.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.backgroundDark.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.primaryPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppTheme.primaryPurple,
                        size: 14.r,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          AppSpacing.verticalSpaceMD,
          
          // Templates Grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.75,
            ),
            itemCount: 6, // Show only 6 templates
            itemBuilder: (context, index) {
              return _buildTemplateCard(predefinedTemplates[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, String> template, int index) {
    return GestureDetector(
      onTap: () => Get.to(() => EmailTemplateEditorScreen(selectedTemplate: template)),
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
                // Category Badge at top
                if (template['category'] != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      template['category']!,
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                
                SizedBox(height: 12.h),
                
                // Title (no maxLines limit to show complete title)
                Text(
                  template['title'] ?? 'Untitled',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                    height: 1.2,
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                // Preview
                Expanded(
                  child: Text(
                    _getEmailBodyPreview(template['body'] ?? ''),
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.3,
                    ),
                    maxLines: 6,
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

  Widget _buildAnimatedFAB() {
    return AnimatedScale(
      scale: _showFab ? 1.0 : 0.0,
      duration: AppAnimations.standard,
      curve: AppAnimations.bounceCurve,
      child: AnimatedOpacity(
        opacity: _showFab ? 1.0 : 0.0,
        duration: AppAnimations.standard,
        child: CosmicFloatingActionButton(
          onPressed: () => Get.to(() => const AiMailGeneratorScreen()),
          icon: Icons.auto_awesome_rounded,
        ),
      ),
    );
  }

  Widget _buildAnimatedCategoryText(String category) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if text fits in available space
        final textPainter = TextPainter(
          text: TextSpan(
            text: category,
            style: AppTheme.caption.copyWith(
              color: AppTheme.primaryPurple,
              fontWeight: FontWeight.w600,
              fontSize: 9.sp,
            ),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: double.infinity);

        if (textPainter.size.width <= constraints.maxWidth) {
          // Text fits, show normally
          return Text(
            category,
            style: AppTheme.caption.copyWith(
              color: AppTheme.primaryPurple,
              fontWeight: FontWeight.w600,
              fontSize: 9.sp,
            ),
            maxLines: 1,
          );
        } else {
          // Text doesn't fit, show with ellipsis
          return SizedBox(
            width: constraints.maxWidth,
            height: 16.h,
            child: Text(
              category,
              style: AppTheme.caption.copyWith(
                color: AppTheme.primaryPurple,
                fontWeight: FontWeight.w600,
                fontSize: 9.sp,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }
      },
    );
  }

  String _getEmailBodyPreview(String body) {
    if (body.isEmpty) return 'No content available';
    
    List<String> lines = body.split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    
    List<String> meaningfulLines = [];
    
    for (String line in lines) {
      String lowerLine = line.toLowerCase().trim();
      
      // Skip common greetings, signatures, and placeholders
      if (lowerLine.startsWith('hi [') || 
          lowerLine.startsWith('hello [') || 
          lowerLine.startsWith('dear [') ||
          lowerLine.startsWith('hey [') ||
          lowerLine.startsWith('regards,') ||
          lowerLine.startsWith('best regards,') ||
          lowerLine.startsWith('sincerely,') ||
          lowerLine.startsWith('thanks,') ||
          lowerLine.startsWith('thank you,') ||
          lowerLine.startsWith('cheers,') ||
          lowerLine.startsWith('yours,') ||
          lowerLine.startsWith('with ') ||
          line.trim() == '[Your Name]' ||
          line.trim() == '[Name]' ||
          line.length < 10) { // Skip very short lines
        continue;
      }
      
      meaningfulLines.add(line);
      if (meaningfulLines.length >= 2) break; // Get first 2 meaningful lines
    }
    
    if (meaningfulLines.isEmpty) {
      // Fallback: take lines that aren't just placeholders
      meaningfulLines = lines
          .where((line) => 
              !line.contains('[Name]') && 
              !line.contains('[Your Name]') && 
              line.length > 5)
          .take(2)
          .toList();
    }
    
    String preview = meaningfulLines.join(' ');
    
    // Replace common placeholders with readable text
    preview = preview
        .replaceAll('[Name]', 'recipient')
        .replaceAll('[Your Name]', 'sender')
        .replaceAll('[Topic]', 'the topic')
        .replaceAll('[Project Name]', 'the project')
        .replaceAll('[Date]', 'the date')
        .replaceAll('[Time]', 'the time')
        .replaceAll('[Company]', 'your company')
        .replaceAll('[Product]', 'the product')
        .replaceAll('[Service]', 'the service');
    
    return preview.isNotEmpty ? preview : 'Professional email template content';
  }

  // Helper methods
  IconData _getIconForTemplate(String title) {
    if (title.contains('Meeting') || title.contains('📝')) return Icons.event_note_rounded;
    if (title.contains('Project') || title.contains('🎯')) return Icons.track_changes_rounded;
    if (title.contains('Client') || title.contains('🎉')) return Icons.celebration_rounded;
    if (title.contains('Follow') || title.contains('📞')) return Icons.call_rounded;
    if (title.contains('Feature') || title.contains('🔥')) return Icons.new_releases_rounded;
    if (title.contains('Offer') || title.contains('🎁')) return Icons.local_offer_rounded;
    if (title.contains('Report') || title.contains('📊')) return Icons.assessment_rounded;
    if (title.contains('Question') || title.contains('💡')) return Icons.help_outline_rounded;
    if (title.contains('Kickoff') || title.contains('🚀')) return Icons.rocket_launch_rounded;
    if (title.contains('Partnership') || title.contains('🤝')) return Icons.handshake_rounded;
    if (title.contains('Congratulations') || title.contains('🎉')) return Icons.celebration_rounded;
    if (title.contains('Meeting') || title.contains('📅')) return Icons.schedule_rounded;
    if (title.contains('Update') || title.contains('🔔')) return Icons.notifications_rounded;
    if (title.contains('Webinar') || title.contains('📅')) return Icons.video_call_rounded;
    if (title.contains('Welcome') || title.contains('👋')) return Icons.waving_hand_rounded;
    return Icons.email_rounded;
  }

  String _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'personal': return '0xFF8B5CF6';
      case 'business': return '0xFFB794F6';
      case 'thank you': return '0xFFF472B6';
      case 'follow-up': return '0xFF10B981';
      case 'product updates': return '0xFFF59E0B';
      case 'promotions': return '0xFFEC4899';
      case 'reports': return '0xFF3B82F6';
      case 'inquiry': return '0xFF8B5CF6';
      case 'project management': return '0xFFB794F6';
      case 'congratulations': return '0xFFF472B6';
      case 'meetings': return '0xFF10B981';
      case 'updates': return '0xFFF59E0B';
      case 'events': return '0xFFEC4899';
      case 'welcome': return '0xFF8B5CF6';
      default: return '0xFF8B5CF6';
    }
  }
}
