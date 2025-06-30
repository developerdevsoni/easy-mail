import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/utils/Icon_animation.dart';
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
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, String>> personalTemplates = [
    {
      'title': 'Sales follow-up',
      'subtitle':
          'Hi [name], Just wanted to follow up on our previous conversation...'
    },
    {
      'title': 'New feature announcement',
      'subtitle': 'We re excited to introduce our latest feature that will...'
    },
  ];

  final List<Map<String, String>> globalTemplates = [
    {
      'title': '🚀 Product Launch Announcement',
      'body':
          'Hi [Name],\n\nWe re excited to let you know that our new product is live! Discover the features, explore the possibilities, and let us know what you think.\n\nFor more details, visit: [Product Page Link]',
      'regards':
          'Best regards,  Team [Your Company]\n\nCC: product@company.com  Date: [Launch Date]'
    },
    {
      'title': '🎁 Holiday Offer – Limited Time Only!',
      'body':
          'Hey [Name],\n\nWe ve got something special just for you — enjoy 40% OFF everything in our store until December 31st!\n\nUse code: HOLIDAY40  Shop now 👉 [Link]',
      'regards':
          'Warm wishes,  The [Company] Team\n\nCC: marketing@company.com  Valid until: Dec 31'
    },
    {
      'title': '📅 Webinar Reminder – Starts in 1 Hour',
      'body': '''
  Dear [Name],
  
  Just a friendly reminder that our webinar "AI Trends in 2025" starts in 1 hour.
  
  🕐 Time: [Start Time]  
  📍 Join here: [Webinar Link]
  
  We'll be taking questions live too — don't miss it!
  ''',
      'regards': '''
  Regards,  
  Emily from [Company]
  
  CC: webinars@company.com  
  Sent: [Today's Date]
  ''',
    },
    {
      'title': '👋 Welcome Onboard!',
      'body': '''
  Hi [Name],
  
  Welcome to [Platform Name] — we're so glad to have you! 🎉
  
  Here's a quick start guide to help you: [Guide Link]  
  Need help? Just reply to this email.
  ''',
      'regards': '''
  Cheers,  
  Customer Success Team
  
  CC: support@company.com  
  Joined on: [Date]
  ''',
    },
    {
      'title': '💬 We d Love Your Feedback',
      'body': '''
  Hi [Name],
  
  Thanks for using [Product]! Could you spare 2 minutes to share your feedback?
  
  📝 Submit here: [Feedback Form Link]  
  Your input helps us improve!
  ''',
      'regards': '''
  Best,  
  [Product Team]
  
  CC: feedback@company.com  
  Sent on: [Date]
  ''',
    },
    {
      'title': '📦 Shipping Update – Order #[OrderID]',
      'body': '''
  Hello [Name],
  
  Good news — your order #[OrderID] has shipped and is on its way. 🛍️
  
  Track your shipment: [Tracking Link]  
  Estimated Delivery: [ETA]
  ''',
      'regards': '''
  Regards,  
  Shipping Department
  
  CC: logistics@company.com  
  Shipped: [Date]
  ''',
    },
    {
      'title': '✅ Confirmation – You re Registered',
      'body': '''
  Hi [Name],
  
  You're all set! We've registered you for "[Event Name]" happening on [Event Date].
  
  📍 View event details: [Event Link]  
  Questions? Reach out anytime.
  ''',
      'regards': '''
  Warm regards,  
  Events Team
  
  CC: events@company.com  
  Registered: [Today's Date]
  ''',
    },
  ];

  final List<String> filters = [
    'All',
    'Marketing',
    'Ecommerce',
    'Events',
    'Newsletters',
  ];

  String selectedFilter = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
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
          child: CustomScrollView(
            slivers: [
              // 🎨 CREATIVE ANIMATED HEADER
              SliverToBoxAdapter(
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    width: double.infinity,
                    child: Column(
                      children: [
                        // Header with Profile and Actions
                        Row(
                          children: [
                            // 🌟 ANIMATED PROFILE SECTION
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigate to profile
                              },
                              child: AnimatedBuilder(
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
                                      child: CircleAvatar(
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
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            
                            // ✨ ENHANCED WELCOME SECTION
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Welcome back,',
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(width: AppSpacing.xs),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          gradient: AppTheme.goldGradient,
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Text(
                                          '✨ PRO',
                                          style: AppTheme.caption.copyWith(
                                            color: AppTheme.surfaceWhite,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ShaderMask(
                                    shaderCallback: (bounds) => AppTheme.primaryGradient.createShader(bounds),
                                    child: Text(
                                      controller.userName.value.isNotEmpty
                                          ? controller.userName.value.split(' ').first
                                          : 'User',
                                      style: AppTheme.heading3.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // 🎯 STYLISH ACTION BUTTONS
                            _buildActionButton(Icons.notifications_none_rounded, AppTheme.textSecondary, () {}),
                            SizedBox(width: AppSpacing.xs),
                            _buildActionButton(Icons.logout_rounded, AppTheme.errorRed, () async => await controller.signOutGoogle()),
                          ],
                        ),
                        SizedBox(height: AppSpacing.lg),
                        
                        // 🎯 CREATIVE STATS ROW WITH ANIMATIONS
                        Row(
                          children: [
                            Expanded(
                              child: _buildAnimatedStatsCard(
                                'Emails Created',
                                '24',
                                'This month',
                                Icons.email_outlined,
                                AppTheme.primaryBlue,
                                0,
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _buildAnimatedStatsCard(
                                'Templates Used',
                                '8',
                                'This week',
                                Icons.temple_hindu_outlined,
                                AppTheme.secondaryTeal,
                                200,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ),
              ),

              // 🔍 ENHANCED SEARCH SECTION
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ModernSearchBar(
                      hintText: '🔍 Search templates, emails...',
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      onFilterTap: () {
                        // TODO: Show filter modal
                      },
                    ),
                  ),
                ),
              ),
              
              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

              // 🤖 SPECTACULAR AI GENERATOR HERO CARD
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 0.98 + (_pulseAnimation.value - 1) * 0.02,
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
                                    border: Border.all(
                                      color: AppTheme.surfaceWhite.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: const EnhancedAnimatedIcon(),
                                ),
                                SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '✨ Create with AI',
                                            style: AppTheme.heading2.copyWith(
                                              color: AppTheme.surfaceWhite,
                                              fontWeight: FontWeight.w800,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          SizedBox(width: AppSpacing.xs),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                            decoration: BoxDecoration(
                                              color: AppTheme.accentGold,
                                              borderRadius: BorderRadius.circular(6.r),
                                            ),
                                            child: Text(
                                              'NEW',
                                              style: AppTheme.caption.copyWith(
                                                color: AppTheme.surfaceWhite,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: AppSpacing.xs),
                                      Text(
                                        'Generate professional emails in seconds using advanced AI technology',
                                        style: AppTheme.bodyMedium.copyWith(
                                          color: AppTheme.surfaceWhite.withOpacity(0.9),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                      SizedBox(height: AppSpacing.sm),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.trending_up_rounded,
                                            color: AppTheme.accentGold,
                                            size: 14.r,
                                          ),
                                          SizedBox(width: AppSpacing.xs),
                                          Text(
                                            '95% faster email creation',
                                            style: AppTheme.bodySmall.copyWith(
                                              color: AppTheme.accentGold,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
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
                      );
                    },
                  ),
                ),
              ),
              
              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

              // 📝 CREATIVE YOUR TEMPLATES SECTION
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          gradient: AppTheme.tealGradient,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.folder_special_rounded,
                          color: AppTheme.surfaceWhite,
                          size: 16.r,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Your Templates',
                          style: AppTheme.heading3.copyWith(fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          'See all',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.surfaceWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              SliverToBoxAdapter(
                child: SizedBox(
                  height: 130.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    scrollDirection: Axis.horizontal,
                    itemCount: personalTemplates.length,
                    separatorBuilder: (_, __) => SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final template = personalTemplates[index];
                      return Container(
                        width: 220.w,
                        constraints: BoxConstraints(maxWidth: 220.w),
                        child: _buildCreativeFeatureCard(
                          template['title']!,
                          template['subtitle']!,
                          Icons.description_outlined,
                          AppTheme.tealGradient,
                          () {
                            Get.to(() => EmailTemplateEditorScreen(
                              selectedTemplate: template,
                            ));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

              // 🏷️ STYLISH FILTER CHIPS
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 35.h,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    separatorBuilder: (_, __) => SizedBox(width: AppSpacing.xs),
                    itemBuilder: (context, index) {
                      final filter = filters[index];
                      final isSelected = selectedFilter == filter;
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 120.w),
                        child: _buildCreativeChip(filter, isSelected, () {
                          setState(() {
                            selectedFilter = filter;
                          });
                        }),
                      );
                    },
                  ),
                ),
              ),
              
              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

              // 🌟 ENHANCED TEMPLATES GRID
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final template = globalTemplates[index];
                      // Filter by search and selected filter (if implemented)
                      if (searchQuery.isNotEmpty &&
                          !(template['title']!
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()) ||
                              template['body']!
                                  .toLowerCase()
                                  .contains(searchQuery.toLowerCase()))) {
                        return const SizedBox.shrink();
                      }
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: (1.sw - AppSpacing.lg * 2 - AppSpacing.sm) / 2,
                        ),
                        child: _buildCreativeTemplateCard(
                          template['title']!,
                          _getDescriptionFromBody(template['body']!),
                          _getIconForTemplate(template['title']!),
                          _getGradientForIndex(index),
                          index % 3 == 0,
                          () {
                            Get.to(() => EmailTemplateEditorScreen(
                              selectedTemplate: template,
                            ));
                          },
                        ),
                      );
                    },
                    childCount: globalTemplates.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSpacing.sm,
                    crossAxisSpacing: AppSpacing.sm,
                    childAspectRatio: 0.85, // Slightly taller cards
                  ),
                ),
              ),
              
              SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
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

  Widget _buildAnimatedStatsCard(String title, String value, String subtitle, IconData icon, Color color, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 800 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, animation, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animation)),
          child: Opacity(
            opacity: animation,
            child: ModernCard(
              elevated: true,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: AppTheme.surfaceWhite,
                          size: 16.r,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          subtitle,
                          style: AppTheme.caption.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ).createShader(bounds),
                    child: Text(
                      value,
                      style: AppTheme.heading2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    title,
                    style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreativeFeatureCard(String title, String description, IconData icon, Gradient gradient, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppTheme.secondaryTeal.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ModernCard(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceWhite.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      icon,
                      color: AppTheme.surfaceWhite,
                      size: 16.r,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.star_rounded,
                    color: AppTheme.accentGold,
                    size: 16.r,
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.surfaceWhite,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.surfaceWhite.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreativeChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.fastDuration,
        curve: AppAnimations.defaultCurve,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : AppTheme.surfaceWhite,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.cardGray,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                Icons.check_circle_rounded,
                color: AppTheme.surfaceWhite,
                size: 14.r,
              ),
              SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTheme.bodySmall.copyWith(
                color: isSelected ? AppTheme.surfaceWhite : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreativeTemplateCard(String title, String description, IconData icon, Gradient gradient, bool isPremium, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ModernCard(
          elevated: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 6.h,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            gradient: gradient,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            icon,
                            color: AppTheme.surfaceWhite,
                            size: 14.r,
                          ),
                        ),
                        const Spacer(),
                        if (isPremium)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              gradient: AppTheme.goldGradient,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.diamond_rounded,
                                  color: AppTheme.surfaceWhite,
                                  size: 8.r,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'PRO',
                                  style: AppTheme.caption.copyWith(
                                    color: AppTheme.surfaceWhite,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        title,
                        style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Expanded(
                      child: Text(
                        description,
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite_border_rounded,
                              color: AppTheme.textTertiary,
                              size: 12.r,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '${(title.hashCode % 50) + 10}',
                              style: AppTheme.caption.copyWith(
                                color: AppTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundGray,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: AppTheme.textSecondary,
                            size: 10.r,
                          ),
                        ),
                      ],
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

  IconData _getIconForTemplate(String title) {
    if (title.contains('🚀')) return Icons.rocket_launch_rounded;
    if (title.contains('🎁')) return Icons.card_giftcard_rounded;
    if (title.contains('📅')) return Icons.event_rounded;
    if (title.contains('👋')) return Icons.waving_hand_rounded;
    if (title.contains('💬')) return Icons.feedback_rounded;
    if (title.contains('📦')) return Icons.local_shipping_rounded;
    if (title.contains('✅')) return Icons.check_circle_outline_rounded;
    return Icons.email_rounded;
  }

  String _getDescriptionFromBody(String body) {
    // Extract first meaningful line from body
    final lines = body.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.length > 1) {
      String description = lines[1].trim();
      return description.length > 60 ? '${description.substring(0, 60)}...' : description;
    }
    return body.length > 60 ? '${body.substring(0, 60)}...' : body;
  }

  Gradient _getGradientForIndex(int index) {
    final gradients = [
      AppTheme.primaryGradient,
      AppTheme.tealGradient,
      AppTheme.goldGradient,
    ];
    return gradients[index % gradients.length];
  }
}

// 🌟 ENHANCED ANIMATED ICON
class EnhancedAnimatedIcon extends StatefulWidget {
  const EnhancedAnimatedIcon({Key? key}) : super(key: key);

  @override
  _EnhancedAnimatedIconState createState() => _EnhancedAnimatedIconState();
}

class _EnhancedAnimatedIconState extends State<EnhancedAnimatedIcon>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  
  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _pulseController]),
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * 3.14159,
          child: Transform.scale(
            scale: 1.0 + (_pulseController.value * 0.1),
            child: Icon(
              Icons.auto_awesome_rounded,
              color: AppTheme.surfaceWhite,
              size: 32.r,
            ),
          ),
        );
      },
    );
  }
}
