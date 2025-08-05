import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:easy_mail/view/ai_mail_generator_screen.dart';
import 'package:easy_mail/view/discoverTemplete_screen.dart';
import 'package:easy_mail/view/my_templates_screen.dart';
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

    // Marketing Templates
    {
      'title': '🎯 New Campaign Launch',
      'body':
          'Hi [Name],\n\nWe\'re excited to introduce our latest campaign! Don\'t miss out on exclusive offers and updates.',
      'regards': 'The Marketing Team',
      'category': 'Marketing'
    },
    {
      'title': '📈 Product Update Newsletter',
      'body':
          'Hello [Name],\n\nHere\'s what\'s new this month: exciting features, improvements, and upcoming releases!',
      'regards': 'Best, [Company] Team',
      'category': 'Marketing'
    },
    {
      'title': '🏆 Customer Success Story',
      'body':
          'Hi [Name],\n\nWe\'re thrilled to share how [Customer] achieved amazing results using our solution. Read their story!',
      'regards': 'The [Company] Team',
      'category': 'Marketing'
    },

    // Sales Templates
    {
      'title': '🎁 Holiday Offer – Limited Time Only!',
      'body':
          'Hey [Name],\n\nWe ve got something special just for you — enjoy 40% OFF everything in our store until December 31st!',
      'regards': 'Warm wishes, The [Company] Team',
      'category': 'Sales'
    },
    {
      'title': '💰 Flash Sale Alert',
      'body':
          'Hi [Name],\n\n24-hour flash sale is live! Get up to 60% off on selected items. Shop now before it\'s gone!',
      'regards': 'Happy Shopping, Sales Team',
      'category': 'Sales'
    },
    {
      'title': '🔥 Exclusive Deal Just for You',
      'body':
          'Dear [Name],\n\nAs a valued customer, you get early access to our biggest sale of the year. Use code EXCLUSIVE20 for 20% off!',
      'regards': 'Best, [Company] Sales Team',
      'category': 'Sales'
    },

    // Events Templates
    {
      'title': '📅 Webinar Reminder – Starts in 1 Hour',
      'body':
          'Dear [Name],\n\nJust a friendly reminder that our webinar "AI Trends in 2025" starts in 1 hour.',
      'regards': 'Regards, Emily from [Company]',
      'category': 'Events'
    },
    {
      'title': '🎪 Conference Invitation',
      'body':
          'Hi [Name],\n\nYou\'re invited to our annual conference on [Date]. Join industry leaders and innovators for insights and networking.',
      'regards': 'Event Team',
      'category': 'Events'
    },
    {
      'title': '🍷 Networking Event Tonight',
      'body':
          'Hello [Name],\n\nDon\'t forget about tonight\'s networking event at [Venue]. Looking forward to seeing you there!',
      'regards': 'Cheers, [Your Name]',
      'category': 'Events'
    },

    // Welcome Templates
    {
      'title': '👋 Welcome Onboard!',
      'body':
          'Hi [Name],\n\nWelcome to [Platform Name] — we\'re so glad to have you! 🎉',
      'regards': 'Cheers, Customer Success Team',
      'category': 'Welcome'
    },
    {
      'title': '🌟 Welcome to Our Community',
      'body':
          'Dear [Name],\n\nWelcome to our amazing community! Here\'s everything you need to get started on your journey with us.',
      'regards': 'Welcome Team',
      'category': 'Welcome'
    },
    {
      'title': '🎊 New Member Welcome Package',
      'body':
          'Hello [Name],\n\nWelcome aboard! We\'ve prepared a special welcome package with exclusive resources just for you.',
      'regards': 'The [Company] Family',
      'category': 'Welcome'
    },

    // Support Templates
    {
      'title': '🛠️ Technical Support Response',
      'body':
          'Hi [Name],\n\nThank you for contacting support. We\'ve received your request and will respond within 24 hours.',
      'regards': 'Support Team',
      'category': 'Support'
    },
    {
      'title': '✅ Issue Resolved',
      'body':
          'Dear [Name],\n\nGreat news! We\'ve successfully resolved the issue you reported. Everything should be working perfectly now.',
      'regards': 'Technical Support',
      'category': 'Support'
    },
    {
      'title': '📞 Schedule Support Call',
      'body':
          'Hello [Name],\n\nTo better assist you, we\'d like to schedule a support call. Please let us know your preferred time.',
      'regards': 'Customer Support',
      'category': 'Support'
    },

    // Personal Templates
    {
      'title': '🎂 Birthday Wishes',
      'body':
          'Hey [Name],\n\nHappy Birthday! Hope your special day is filled with joy, laughter, and all your favorite things! 🎉',
      'regards': 'With love, [Your Name]',
      'category': 'Personal'
    },
    {
      'title': '☕ Coffee Catch-up',
      'body':
          'Hi [Name],\n\nIt\'s been too long! Would you like to grab coffee sometime this week? I\'d love to catch up.',
      'regards': 'Looking forward to it, [Your Name]',
      'category': 'Personal'
    },
    {
      'title': '🏠 Housewarming Invitation',
      'body':
          'Dear [Name],\n\nWe\'re excited to invite you to our housewarming party on [Date]. Can\'t wait to celebrate with you!',
      'regards': 'Warmly, [Your Name]',
      'category': 'Personal'
    },

    // Announcements Templates
    {
      'title': '🚀 Product Launch Announcement',
      'body':
          'Hi [Name],\n\nWe re excited to let you know that our new product is live! Discover the features, explore the possibilities, and let us know what you think.',
      'regards': 'Best regards, Team [Your Company]',
      'category': 'Announcements'
    },
    {
      'title': '📢 Company Update',
      'body':
          'Dear Team,\n\nWe\'re excited to share some important updates about our company\'s growth and new opportunities ahead.',
      'regards': 'Leadership Team',
      'category': 'Announcements'
    },
    {
      'title': '🏢 Office Relocation Notice',
      'body':
          'Hello [Name],\n\nWe\'re moving to a new office! Our new address will be [Address] effective [Date]. All other contact details remain the same.',
      'regards': 'Administration Team',
      'category': 'Announcements'
    },

    // Newsletters Templates
    {
      'title': '📰 Monthly Newsletter',
      'body':
          'Hi [Name],\n\nHere\'s your monthly roundup of news, updates, and insights from our team. Don\'t miss the highlights!',
      'regards': 'The Editorial Team',
      'category': 'Newsletters'
    },
    {
      'title': '📊 Weekly Industry Report',
      'body':
          'Dear [Name],\n\nYour weekly dose of industry insights, trends, and analysis. Stay ahead of the curve!',
      'regards': 'Research Team',
      'category': 'Newsletters'
    },
    {
      'title': '🎨 Creative Inspiration Weekly',
      'body':
          'Hello [Name],\n\nFuel your creativity with this week\'s collection of inspiring designs, tips, and creative resources.',
      'regards': 'Creative Team',
      'category': 'Newsletters'
    },

    // Follow-up Templates
    {
      'title': '📧 Meeting Follow-up',
      'body':
          'Hi [Name],\n\nThank you for the productive meeting today. Here are the action items we discussed and next steps.',
      'regards': 'Best regards, [Your Name]',
      'category': 'Follow-up'
    },
    {
      'title': '📞 Call Follow-up',
      'body':
          'Dear [Name],\n\nThank you for taking the time to speak with me today. As promised, I\'m sending the information we discussed.',
      'regards': 'Talk soon, [Your Name]',
      'category': 'Follow-up'
    },
    {
      'title': '📝 Proposal Follow-up',
      'body':
          'Hello [Name],\n\nI wanted to follow up on the proposal we submitted last week. Do you have any questions or need additional information?',
      'regards': 'Looking forward to your response, [Your Name]',
      'category': 'Follow-up'
    },

    // Invitations Templates
    {
      'title': '🎉 Event Invitation',
      'body':
          'Dear [Name],\n\nYou\'re cordially invited to [Event Name] on [Date] at [Location]. We\'d be honored to have you join us!',
      'regards': 'With excitement, [Your Name]',
      'category': 'Invitations'
    },
    {
      'title': '🍽️ Dinner Invitation',
      'body':
          'Hi [Name],\n\nWe\'d love to have you over for dinner this [Day] at [Time]. Please let us know if you can make it!',
      'regards': 'Hope to see you soon, [Your Name]',
      'category': 'Invitations'
    },
    {
      'title': '🎓 Graduation Ceremony Invitation',
      'body':
          'Dear [Name],\n\nYou\'re invited to celebrate [Graduate Name]\'s graduation ceremony on [Date]. Your presence would make the day extra special!',
      'regards': 'With gratitude, [Your Name]',
      'category': 'Invitations'
    },

    // Reminders Templates
    {
      'title': '⏰ Appointment Reminder',
      'body':
          'Hi [Name],\n\nThis is a friendly reminder about your appointment scheduled for [Date] at [Time]. We look forward to seeing you!',
      'regards': 'See you soon, [Your Name]',
      'category': 'Reminders'
    },
    {
      'title': '📅 Deadline Reminder',
      'body':
          'Dear [Name],\n\nJust a gentle reminder that the deadline for [Task/Project] is approaching on [Date]. Please let us know if you need any assistance.',
      'regards': 'Best regards, [Your Name]',
      'category': 'Reminders'
    },
    {
      'title': '💳 Payment Reminder',
      'body':
          'Hello [Name],\n\nWe wanted to remind you that your payment for [Service/Product] is due on [Date]. Thank you for your prompt attention.',
      'regards': 'Billing Department',
      'category': 'Reminders'
    },

    // Thank You Templates
    {
      'title': '🙏 Thank You for Your Purchase',
      'body':
          'Dear [Name],\n\nThank you for your recent purchase! We appreciate your business and hope you love your new [Product].',
      'regards': 'Gratefully, [Company] Team',
      'category': 'Thank You'
    },
    {
      'title': '💝 Thank You for Your Support',
      'body':
          'Hi [Name],\n\nWe wanted to take a moment to thank you for your continued support. It means the world to us!',
      'regards': 'With appreciation, [Your Name]',
      'category': 'Thank You'
    },
    {
      'title': '🌟 Thank You for the Referral',
      'body':
          'Dear [Name],\n\nThank you so much for referring [Referral Name] to us. We truly appreciate your trust in our services!',
      'regards': 'With gratitude, [Your Name]',
      'category': 'Thank You'
    },

    // Apologies Templates
    {
      'title': '😔 Sincere Apology',
      'body':
          'Dear [Name],\n\nWe sincerely apologize for the inconvenience caused. We are taking immediate steps to resolve this issue.',
      'regards': 'With regret, [Your Name]',
      'category': 'Apologies'
    },
    {
      'title': '⚠️ Service Disruption Apology',
      'body':
          'Hi [Name],\n\nWe apologize for the service disruption you experienced. Our team has resolved the issue and implemented measures to prevent future occurrences.',
      'regards': 'Customer Service Team',
      'category': 'Apologies'
    },
    {
      'title': '🔄 Delivery Delay Apology',
      'body':
          'Dear [Name],\n\nWe apologize for the delay in your order delivery. We\'re working to get your package to you as soon as possible.',
      'regards': 'Shipping Department',
      'category': 'Apologies'
    },

    // Feedback Templates
    {
      'title': '📝 Customer Feedback Request',
      'body':
          'Hi [Name],\n\nWe\'d love to hear about your experience with us! Your feedback helps us improve our services. Could you spare 2 minutes for a quick survey?',
      'regards': 'Thank you, Customer Success Team',
      'category': 'Feedback'
    },
    {
      'title': '⭐ Product Review Request',
      'body':
          'Dear [Name],\n\nWe hope you\'re enjoying your recent purchase! Would you mind leaving a review? Your feedback helps other customers make informed decisions.',
      'regards': 'Thanks in advance, [Company] Team',
      'category': 'Feedback'
    },
    {
      'title': '💬 Service Improvement Survey',
      'body':
          'Hello [Name],\n\nWe\'re always looking to improve! Please take our brief survey about your recent experience with our customer service.',
      'regards': 'Quality Assurance Team',
      'category': 'Feedback'
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

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // Show FAB when scrolled past the AI card (approximately 300 pixels)
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundGrayF6,
              AppTheme.backgroundGrayF6.withOpacity(1),
              AppTheme.backgroundGrayF6.withOpacity(1),
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
                                  AppTheme.primaryBlue,
                                  AppTheme.secondaryTeal,
                                  AppTheme.backgroundGray,
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
                                  backgroundImage: controller
                                          .photoUrl.value.isNotEmpty
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
                                shaderCallback: (bounds) => AppTheme
                                    .primaryGradient
                                    .createShader(bounds),
                                child: Text(
                                  controller.userName.value.isNotEmpty
                                      ? controller.userName.value
                                          .split(' ')
                                          .first
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
                    _buildActionButton(Icons.notifications_none_rounded,
                        AppTheme.textSecondary, () {}),
                    SizedBox(width: AppSpacing.xs),
                    _buildActionButton(Icons.logout_rounded, AppTheme.errorRed,
                        () => _showLogoutDialog()),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // AI Generator Hero Card
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 800),
                        tween: Tween<double>(begin: 0, end: 1),
                        curve: Curves.easeOutBack,
                        builder: (context, double value, child) {
                          final clampedValue = value.clamp(0.0, 1.0);
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - clampedValue)),
                            child: Opacity(
                              opacity: clampedValue,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => const AiMailGeneratorScreen());
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    padding: EdgeInsets.all(AppSpacing.md),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppTheme.primaryBlue,
                                          AppTheme.secondaryTeal,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(18.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.primaryBlue
                                              .withOpacity(0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                        BoxShadow(
                                          color: AppTheme.textTertiary
                                              .withOpacity(0.1),
                                          blurRadius: 30,
                                          offset: const Offset(0, 20),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          padding: EdgeInsets.all(10.r),
                                          decoration: BoxDecoration(
                                            color: AppTheme.surfaceWhite
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          child: Icon(
                                            Icons.auto_awesome_rounded,
                                            color: AppTheme.surfaceWhite,
                                            size: 28.r,
                                          ),
                                        ),
                                        SizedBox(width: AppSpacing.md),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '✨ Create with AI',
                                                style:
                                                    AppTheme.heading2.copyWith(
                                                  color: AppTheme.surfaceWhite,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                              SizedBox(height: 4.h),
                                              Text(
                                                'Generate professional emails in seconds',
                                                style: AppTheme.bodyMedium
                                                    .copyWith(
                                                  color: AppTheme.surfaceWhite
                                                      .withOpacity(0.9),
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          padding: EdgeInsets.all(6.r),
                                          decoration: BoxDecoration(
                                            color: AppTheme.surfaceWhite
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_rounded,
                                            color: AppTheme.surfaceWhite,
                                            size: 16.r,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: AppSpacing.xl),

                      // My Templates Section
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween<double>(begin: 0, end: 1),
                        curve: Curves.easeOutBack,
                        builder: (context, double value, child) {
                          final clampedValue = value.clamp(0.0, 1.0);
                          return Transform.translate(
                            offset: Offset(-20 * (1 - clampedValue), 0),
                            child: Opacity(
                              opacity: clampedValue,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg),
                                child: Row(
                                  children: [
                                    Text(
                                      /*'⭐ */ 'My Templates',
                                      style: AppTheme.heading3.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        FirebaseCrashlytics.instance.crash();
                                        // Get.to(() => MyTemplatesScreen());
                                      },
                                      child: Text(
                                        'View All',
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: AppSpacing.sm),

                      // My Templates Horizontal Scroll
                      Container(
                        height: 120.h,
                        child: myTemplates.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg),
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: myTemplates.length,
                                itemBuilder: (context, index) {
                                  if (index >= myTemplates.length)
                                    return const SizedBox.shrink();
                                  final template = myTemplates[index];
                                  return AnimatedContainer(
                                    duration: Duration(
                                        milliseconds: 300 + (index * 100)),
                                    curve: Curves.easeOutBack,
                                    width: 220.w,
                                    margin: EdgeInsets.only(
                                      right: index == myTemplates.length - 1
                                          ? 0
                                          : AppSpacing.sm,
                                    ),
                                    child:
                                        _buildMyTemplateCard(template, index),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                  'No custom templates yet',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.textTertiary,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: AppSpacing.xl),

                      // Templates Section
                      TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 700),
                        tween: Tween<double>(begin: 0, end: 1),
                        curve: Curves.easeOutBack,
                        builder: (context, double value, child) {
                          final clampedValue = value.clamp(0.0, 1.0);
                          return Transform.translate(
                            offset: Offset(-20 * (1 - clampedValue), 0),
                            child: Opacity(
                              opacity: clampedValue,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSpacing.lg),
                                child: Row(
                                  children: [
                                    Text(
                                      /*'📧*/ ' Email Templates',
                                      style: AppTheme.heading3.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(() => DiscoverTemplatesPage());
                                      },
                                      child: Text(
                                        'View All',
                                        style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      SizedBox(height: AppSpacing.sm),

                      // Templates Grid
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                        child: _getFilteredTemplates().isNotEmpty
                            ? GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: AppSpacing.md,
                                  crossAxisSpacing: AppSpacing.md,
                                  childAspectRatio: 1.0,
                                ),
                                itemCount: _getFilteredTemplates().length,
                                itemBuilder: (context, index) {
                                  final filteredTemplates =
                                      _getFilteredTemplates();
                                  if (index >= filteredTemplates.length)
                                    return const SizedBox.shrink();
                                  final template = filteredTemplates[index];
                                  return AnimatedContainer(
                                    duration: Duration(
                                        milliseconds: 300 + (index * 50)),
                                    curve: Curves.easeOutBack,
                                    child: _buildTemplateCard(
                                      template['title'] ?? '',
                                      template['body'] ?? '',
                                      index,
                                      () {
                                        Get.to(() => EmailTemplateEditorScreen(
                                              selectedTemplate: template,
                                            ));
                                      },
                                    ),
                                  );
                                },
                              )
                            : Container(
                                height: 200.h,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 48.r,
                                        color: AppTheme.textTertiary,
                                      ),
                                      SizedBox(height: AppSpacing.sm),
                                      Text(
                                        'No templates found',
                                        style: AppTheme.bodyMedium.copyWith(
                                          color: AppTheme.textTertiary,
                                        ),
                                      ),
                                      SizedBox(height: AppSpacing.xs),
                                      Text(
                                        'Try selecting a different category',
                                        style: AppTheme.caption.copyWith(
                                          color: AppTheme.textTertiary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),

                      SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: _showFab ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: _showFab ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryBlue,
                  AppTheme.secondaryTeal,
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppTheme.textTertiary.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () {
                Get.to(() => const AiMailGeneratorScreen());
              },
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

  Widget _buildMyTemplateCard(Map<String, String> template, int index) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 30 * (1 - clampedValue)),
          child: Opacity(
            opacity: clampedValue,
            child: GestureDetector(
              onTapDown: (_) => {},
              onTapUp: (_) => {},
              onTap: () {
                if (template.isNotEmpty) {
                  Get.to(() => EmailTemplateEditorScreen(
                        selectedTemplate: template,
                      ));
                }
              },
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 100.h,
                  maxHeight: 120.h,
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.surfaceWhite,
                        AppTheme.backgroundGray.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: AppTheme.textTertiary.withOpacity(0.15),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.textTertiary.withOpacity(0.08),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.03),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            template['createdDate']!,
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.textTertiary,
                              fontSize: 9.sp,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.textTertiary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'Custom',
                              style: AppTheme.caption.copyWith(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w600,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              color: AppTheme.surfaceWhite,
                              size: 12.r,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        template['title'] ?? 'Untitled',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8.h),
                      Expanded(
                        child: Text(
                          _getEmailPreview(template['body'] ?? ''),
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.textSecondary,
                            height: 1.3,
                            fontSize: 11.sp,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getEmailPreview(String body) {
    if (body.isEmpty) return 'No content available';

    // Split by lines and filter out common greetings and empty lines
    List<String> lines = body
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    // Skip common greeting patterns and get meaningful content
    List<String> meaningfulLines = [];
    for (String line in lines) {
      String lowerLine = line.toLowerCase();
      // Skip common greetings
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
      if (meaningfulLines.length >= 2) break; // Get first 2 meaningful lines
    }

    return meaningfulLines.isNotEmpty
        ? meaningfulLines.join(' ')
        : lines.isNotEmpty
            ? lines.first
            : 'No content';
  }

  Widget _buildTemplateCard(
      String title, String body, int index, VoidCallback onTap) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 400 + (index * 50)),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 20 * (1 - clampedValue)),
          child: Opacity(
            opacity: clampedValue,
            child: GestureDetector(
              onTapDown: (_) => {},
              onTapUp: (_) => {},
              onTap: onTap,
              child: Container(
                height: double.infinity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.surfaceWhite,
                        AppTheme.backgroundGray.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppTheme.cardGray.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.03),
                        blurRadius: 12,
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
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(7.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryBlue.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getIconForTemplate(title),
                              color: AppTheme.surfaceWhite,
                              size: 16.r,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundGray,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: AppTheme.primaryBlue,
                              size: 12.r,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        title.isNotEmpty ? title : 'Untitled',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Expanded(
                        child: Text(
                          _getEmailPreview(body),
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.textSecondary,
                            fontSize: 10.sp,
                            height: 1.3,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getIconForTemplate(String title) {
    try {
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
    } catch (e) {
      return Icons.email_rounded;
    }
  }

  List<Map<String, String>> _getFilteredTemplates() {
    // Return only the first 7 templates for home screen
    return globalTemplates.take(7).toList();
  }

  void _showLogoutDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          )),
          child: ScaleTransition(
            scale: Tween<double>(
              begin: 0.7,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
            )),
            child: RotationTransition(
              turns: Tween<double>(
                begin: 0.1,
                end: 0.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut,
              )),
              child: Center(
                child: Material(
                  type: MaterialType.transparency,
                  child: _buildLogoutDialogContent(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogoutDialogContent() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.surfaceWhite,
            AppTheme.backgroundGray,
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppTheme.primaryBlue.withOpacity(0.1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mail Icon with Animation
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.errorRed.withOpacity(0.1),
                  AppTheme.errorRed.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(
                color: AppTheme.errorRed.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.mail_outline_rounded,
              size: 40.r,
              color: AppTheme.errorRed,
            ),
          ),

          SizedBox(height: AppSpacing.md),

          // Title
          Text(
            'Logout Confirmation',
            style: AppTheme.heading2.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),

          SizedBox(height: AppSpacing.sm),

          // Message
          Text(
            'Are you sure you want to logout?\nYour session will be ended.',
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),

          SizedBox(height: AppSpacing.lg),

          // Buttons
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundGray,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppTheme.textTertiary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: AppSpacing.sm),

              // Logout Button
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await controller.signOutGoogle();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.errorRed,
                          AppTheme.errorRed.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.errorRed.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      'Logout',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.surfaceWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
