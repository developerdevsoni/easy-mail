import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:get/get.dart';

class DiscoverTemplatesPage extends StatefulWidget {
  @override
  State<DiscoverTemplatesPage> createState() => _DiscoverTemplatesPageState();
}

class _DiscoverTemplatesPageState extends State<DiscoverTemplatesPage> {
  String selectedCategory = 'All';
  String searchQuery = '';

  final List<String> emailCategories = [
    'All',
    'Business',
    'Marketing',
    'Sales', 
    'Events',
    'Welcome',
    'Support',
    'Personal',
    'Announcements',
    'Newsletters',
    'Follow-up',
    'Invitations',
    'Reminders',
    'Thank You',
    'Apologies',
    'Feedback'
  ];

  final List<Map<String, String>> globalTemplates = [
    // Business Templates
    {
      'title': '📋 Meeting Request',
      'body': 'Dear [Name],\n\nI would like to schedule a meeting to discuss [Topic]. Please let me know your availability for next week.',
      'regards': 'Best regards, [Your Name]',
      'category': 'Business'
    },
    {
      'title': '📄 Proposal Submission',
      'body': 'Dear [Name],\n\nPlease find attached our proposal for [Project Name]. We look forward to your feedback and next steps.',
      'regards': 'Sincerely, [Your Name]',
      'category': 'Business'
    },
    {
      'title': '🤝 Partnership Inquiry',
      'body': 'Hello [Name],\n\nWe are interested in exploring potential partnership opportunities between our companies. Could we schedule a call to discuss?',
      'regards': 'Best regards, [Your Name]',
      'category': 'Business'
    },
    
    // Marketing Templates
    {
      'title': '🎯 New Campaign Launch',
      'body': 'Hi [Name],\n\nWe\'re excited to introduce our latest campaign! Don\'t miss out on exclusive offers and updates.',
      'regards': 'The Marketing Team',
      'category': 'Marketing'
    },
    {
      'title': '📈 Product Update Newsletter',
      'body': 'Hello [Name],\n\nHere\'s what\'s new this month: exciting features, improvements, and upcoming releases!',
      'regards': 'Best, [Company] Team',
      'category': 'Marketing'
    },
    {
      'title': '🏆 Customer Success Story',
      'body': 'Hi [Name],\n\nWe\'re thrilled to share how [Customer] achieved amazing results using our solution. Read their story!',
      'regards': 'The [Company] Team',
      'category': 'Marketing'
    },
    
    // Sales Templates
    {
      'title': '🎁 Holiday Offer – Limited Time Only!',
      'body': 'Hey [Name],\n\nWe ve got something special just for you — enjoy 40% OFF everything in our store until December 31st!',
      'regards': 'Warm wishes, The [Company] Team',
      'category': 'Sales'
    },
    {
      'title': '💰 Flash Sale Alert',
      'body': 'Hi [Name],\n\n24-hour flash sale is live! Get up to 60% off on selected items. Shop now before it\'s gone!',
      'regards': 'Happy Shopping, Sales Team',
      'category': 'Sales'
    },
    {
      'title': '🔥 Exclusive Deal Just for You',
      'body': 'Dear [Name],\n\nAs a valued customer, you get early access to our biggest sale of the year. Use code EXCLUSIVE20 for 20% off!',
      'regards': 'Best, [Company] Sales Team',
      'category': 'Sales'
    },
    
    // Events Templates
    {
      'title': '📅 Webinar Reminder – Starts in 1 Hour',
      'body': 'Dear [Name],\n\nJust a friendly reminder that our webinar "AI Trends in 2025" starts in 1 hour.',
      'regards': 'Regards, Emily from [Company]',
      'category': 'Events'
    },
    {
      'title': '🎪 Conference Invitation',
      'body': 'Hi [Name],\n\nYou\'re invited to our annual conference on [Date]. Join industry leaders and innovators for insights and networking.',
      'regards': 'Event Team',
      'category': 'Events'
    },
    {
      'title': '🍷 Networking Event Tonight',
      'body': 'Hello [Name],\n\nDon\'t forget about tonight\'s networking event at [Venue]. Looking forward to seeing you there!',
      'regards': 'Cheers, [Your Name]',
      'category': 'Events'
    },
    
    // Welcome Templates
    {
      'title': '👋 Welcome Onboard!',
      'body': 'Hi [Name],\n\nWelcome to [Platform Name] — we\'re so glad to have you! 🎉',
      'regards': 'Cheers, Customer Success Team',
      'category': 'Welcome'
    },
    {
      'title': '🌟 Welcome to Our Community',
      'body': 'Dear [Name],\n\nWelcome to our amazing community! Here\'s everything you need to get started on your journey with us.',
      'regards': 'Welcome Team',
      'category': 'Welcome'
    },
    {
      'title': '🎊 New Member Welcome Package',
      'body': 'Hello [Name],\n\nWelcome aboard! We\'ve prepared a special welcome package with exclusive resources just for you.',
      'regards': 'The [Company] Family',
      'category': 'Welcome'
    },
    
    // Support Templates
    {
      'title': '🛠️ Technical Support Response',
      'body': 'Hi [Name],\n\nThank you for contacting support. We\'ve received your request and will respond within 24 hours.',
      'regards': 'Support Team',
      'category': 'Support'
    },
    {
      'title': '✅ Issue Resolved',
      'body': 'Dear [Name],\n\nGreat news! We\'ve successfully resolved the issue you reported. Everything should be working perfectly now.',
      'regards': 'Technical Support',
      'category': 'Support'
    },
    {
      'title': '📞 Schedule Support Call',
      'body': 'Hello [Name],\n\nTo better assist you, we\'d like to schedule a support call. Please let us know your preferred time.',
      'regards': 'Customer Support',
      'category': 'Support'
    },
    
    // Personal Templates
    {
      'title': '🎂 Birthday Wishes',
      'body': 'Dear [Name],\n\nHappy Birthday! Hope your special day is filled with joy, laughter, and all your favorite things.',
      'regards': 'With love, [Your Name]',
      'category': 'Personal'
    },
    {
      'title': '🎉 Congratulations',
      'body': 'Hi [Name],\n\nCongratulations on your amazing achievement! You\'ve worked so hard for this moment and truly deserve it.',
      'regards': 'Proud of you, [Your Name]',
      'category': 'Personal'
    },
    {
      'title': '💌 Catch Up Message',
      'body': 'Hey [Name],\n\nIt\'s been way too long since we last caught up! How have you been? I\'d love to hear what\'s new in your life.',
      'regards': 'Miss you, [Your Name]',
      'category': 'Personal'
    },
    
    // Additional templates to reach 45+ total
    {
      'title': '📢 Important Company Update',
      'body': 'Dear Team,\n\nWe have some important updates to share about our company direction and upcoming changes.',
      'regards': 'Management Team',
      'category': 'Announcements'
    },
    {
      'title': '📰 Monthly Newsletter',
      'body': 'Hello [Name],\n\nWelcome to our monthly newsletter! Here are the highlights from this month and what\'s coming next.',
      'regards': 'Newsletter Team',
      'category': 'Newsletters'
    },
    {
      'title': '📧 Meeting Follow-up',
      'body': 'Hi [Name],\n\nThank you for the productive meeting today. Here are the action items we discussed and next steps.',
      'regards': 'Best regards, [Your Name]',
      'category': 'Follow-up'
    },
    {
      'title': '🎉 Event Invitation',
      'body': 'Dear [Name],\n\nYou\'re cordially invited to [Event Name] on [Date] at [Location]. We\'d be honored to have you join us!',
      'regards': 'With excitement, [Your Name]',
      'category': 'Invitations'
    },
    {
      'title': '⏰ Appointment Reminder',
      'body': 'Hi [Name],\n\nJust a friendly reminder about your appointment tomorrow at [Time]. Please let us know if you need to reschedule.',
      'regards': 'See you soon, [Your Name]',
      'category': 'Reminders'
    },
    {
      'title': '🙏 Thank You for Your Business',
      'body': 'Dear [Name],\n\nThank you for choosing us for your [Service/Product] needs. We truly appreciate your trust and business.',
      'regards': 'With gratitude, [Your Name]',
      'category': 'Thank You'
    },
    {
      'title': '😔 Sincere Apology',
      'body': 'Dear [Name],\n\nI want to sincerely apologize for [Issue]. This was not the experience we want for our valued customers.',
      'regards': 'Sincerely, [Your Name]',
      'category': 'Apologies'
    },
    {
      'title': '📝 Customer Feedback Request',
      'body': 'Hi [Name],\n\nWe\'d love to hear about your experience with us! Your feedback helps us improve our services. Could you spare 2 minutes for a quick survey?',
      'regards': 'Thank you, Customer Success Team',
      'category': 'Feedback'
    },
  ];

  List<Map<String, String>> _getFilteredTemplates() {
    List<Map<String, String>> filtered = globalTemplates;
    
    // Filter by category
    if (selectedCategory != 'All') {
      filtered = filtered.where((template) => 
        template['category'] == selectedCategory
      ).toList();
    }
    
    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((template) => 
        template['title']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
        template['body']!.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  String _getEmailPreview(String body) {
    if (body.isEmpty) return 'No content available';
    
    List<String> lines = body.split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
    
    List<String> meaningfulLines = [];
    for (String line in lines) {
      String lowerLine = line.toLowerCase();
      if (lowerLine.startsWith('hi ') || 
          lowerLine.startsWith('hello ') || 
          lowerLine.startsWith('dear ') ||
          lowerLine.startsWith('regards') ||
          lowerLine.startsWith('best regards') ||
          lowerLine.startsWith('sincerely') ||
          lowerLine.startsWith('thanks') ||
          lowerLine.startsWith('thank you') ||
          lowerLine.startsWith('cheers') ||
          lowerLine.startsWith('yours') ||
          lowerLine.contains('[name]') ||
          lowerLine.contains('[your name]')) {
        continue;
      }
      meaningfulLines.add(line);
      if (meaningfulLines.length >= 2) break;
    }
    
    if (meaningfulLines.isEmpty) {
      return lines.take(2).join(' ');
    }
    
    return meaningfulLines.join(' ');
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
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppTheme.textPrimary,
                        size: 20.r,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'All Templates',
                        style: AppTheme.heading2.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 40.w), // Balance the back button
                  ],
                ),
              ),
              
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceWhite,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    style: AppTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Search templates...',
                      hintStyle: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textTertiary,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: AppTheme.textSecondary,
                        size: 20.r,
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 16.h),
              
              // Categories
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   '🏷️ Categories',
                    //   style: AppTheme.heading3.copyWith(
                    //     fontWeight: FontWeight.w800,
                    //   ),
                    // ),
                    // SizedBox(height: 12.h),
                    Container(
                      height: 36.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: emailCategories.length,
                        itemBuilder: (context, index) {
                          final category = emailCategories[index];
                          final isSelected = selectedCategory == category;
                          
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? AppTheme.primaryGradient
                                      : null,
                                  color: isSelected
                                      ? null
                                      : AppTheme.surfaceWhite,
                                  borderRadius: BorderRadius.circular(18.r),
                                  border: isSelected
                                      ? null
                                      : Border.all(
                                          color: AppTheme.textTertiary.withOpacity(0.2),
                                          width: 1,
                                        ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected
                                          ? AppTheme.primaryBlue.withOpacity(0.25)
                                          : AppTheme.textTertiary.withOpacity(0.05),
                                      blurRadius: isSelected ? 10 : 4,
                                      offset: Offset(0, isSelected ? 3 : 1),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: AppTheme.bodySmall.copyWith(
                                      color: isSelected
                                          ? AppTheme.surfaceWhite
                                          : AppTheme.textPrimary,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20.h),
              
              // Templates Grid
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: _getFilteredTemplates().isNotEmpty
                      ? GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12.h,
                            crossAxisSpacing: 12.w,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: _getFilteredTemplates().length,
                          itemBuilder: (context, index) {
                            final template = _getFilteredTemplates()[index];
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300 + (index * 50)),
                              curve: Curves.easeOutBack,
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(() => EmailTemplateEditorScreen(
                                    selectedTemplate: template,
                                  ));
                                },
                                child: Container(
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
                                    ],
                                  ),
                                  padding: EdgeInsets.all(12.w),
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
                                            ),
                                            child: Icon(
                                              Icons.email_rounded,
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
                                        template['title'] ?? 'Untitled',
                                        style: AppTheme.bodyMedium.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                          height: 1.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8.h),
                                      Expanded(
                                        child: Text(
                                          _getEmailPreview(template['body'] ?? ''),
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
                            );
                          },
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 48.r,
                                color: AppTheme.textTertiary,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No templates found',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Try adjusting your search or category',
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
