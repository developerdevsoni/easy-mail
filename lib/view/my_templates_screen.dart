import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:get/get.dart';

class MyTemplatesScreen extends StatefulWidget {
  @override
  State<MyTemplatesScreen> createState() => _MyTemplatesScreenState();
}

class _MyTemplatesScreenState extends State<MyTemplatesScreen> {
  String searchQuery = '';

  final List<Map<String, String>> myTemplates = [
    {
      'title': '📝 My Meeting Notes',
      'body': 'Hi [Name],\n\nHere are the key points from our meeting today:\n\n• [Point 1]\n• [Point 2]\n• [Point 3]\n\nNext steps: [Action Items]',
      'regards': 'Best regards, [Your Name]',
      'category': 'Personal',
      'isCustom': 'true',
      'createdDate': '2024-01-15'
    },
    {
      'title': '🎯 Project Update Template',
      'body': 'Hello Team,\n\nProject Status Update:\n\n✅ Completed:\n• [Task 1]\n• [Task 2]\n\n🔄 In Progress:\n• [Task 3]\n\n📅 Upcoming:\n• [Task 4]',
      'regards': 'Thanks, [Your Name]',
      'category': 'Business',
      'isCustom': 'true',
      'createdDate': '2024-01-12'
    },
    {
      'title': '🎉 Client Appreciation',
      'body': 'Dear [Client Name],\n\nI wanted to personally thank you for choosing our services. Your trust and collaboration have been instrumental in achieving these fantastic results.\n\nLooking forward to continuing our partnership!',
      'regards': 'With gratitude, [Your Name]',
      'category': 'Thank You',
      'isCustom': 'true',
      'createdDate': '2024-01-10'
    },
    {
      'title': '📞 Follow-up Call Summary',
      'body': 'Hi [Name],\n\nThank you for the call today. Here\'s a summary of what we discussed:\n\n🎯 Key Points:\n• [Point 1]\n• [Point 2]\n\n📋 Action Items:\n• [Action 1] - Due: [Date]\n• [Action 2] - Due: [Date]',
      'regards': 'Talk soon, [Your Name]',
      'category': 'Follow-up',
      'isCustom': 'true',
      'createdDate': '2024-01-08'
    },
    {
      'title': '💼 Weekly Team Check-in',
      'body': 'Hello Team,\n\nTime for our weekly check-in! Please share:\n\n1. What you accomplished this week\n2. Current challenges\n3. Goals for next week\n\nLet\'s keep the momentum going!',
      'regards': 'Cheers, [Your Name]',
      'category': 'Business',
      'isCustom': 'true',
      'createdDate': '2024-01-05'
    },
    {
      'title': '📊 Weekly Report Template',
      'body': 'Hi Team,\n\nHere\'s this week\'s summary:\n\n📈 Achievements:\n• [Achievement 1]\n• [Achievement 2]\n\n🎯 Objectives for next week:\n• [Objective 1]\n• [Objective 2]\n\n❓ Questions/Blockers:\n• [Any issues]',
      'regards': 'Best, [Your Name]',
      'category': 'Business',
      'isCustom': 'true',
      'createdDate': '2024-01-03'
    },
    {
      'title': '🎂 Birthday Reminder Template',
      'body': 'Hey [Name]! 🎉\n\nJust wanted to wish you the happiest of birthdays! Hope your special day is filled with joy, laughter, and all your favorite things.\n\nHave an amazing celebration!',
      'regards': 'With love and best wishes, [Your Name]',
      'category': 'Personal',
      'isCustom': 'true',
      'createdDate': '2024-01-01'
    },
    {
      'title': '✈️ Travel Itinerary Share',
      'body': 'Hi [Name],\n\nHere\'s my travel itinerary for the upcoming trip:\n\n🛫 Departure: [Date & Time]\n🏨 Hotel: [Hotel Name & Address]\n🛬 Return: [Date & Time]\n\nFeel free to reach out if you need anything!',
      'regards': 'Safe travels, [Your Name]',
      'category': 'Personal',
      'isCustom': 'true',
      'createdDate': '2023-12-28'
    },
  ];

  List<Map<String, String>> _getFilteredTemplates() {
    if (searchQuery.isEmpty) {
      return myTemplates;
    }
    
    return myTemplates.where((template) => 
      template['title']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
      template['body']!.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
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
              AppTheme.backgroundGray.withOpacity(0.9),
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
                        'My Templates',
                        style: AppTheme.heading2.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: Add create new template functionality
                      },
                      icon: Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(8.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: AppTheme.surfaceWhite,
                          size: 18.r,
                        ),
                      ),
                    ),
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
                        color: AppTheme.textTertiary.withOpacity(0.1),
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
                      hintText: 'Search your templates...',
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
              
              SizedBox(height: 20.h),
              
              // Templates Count
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.textTertiary.withOpacity(0.1),
                            AppTheme.textTertiary.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: AppTheme.textTertiary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${_getFilteredTemplates().length} Templates',
                        style: AppTheme.caption.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            searchQuery = '';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.textTertiary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            'Clear',
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              SizedBox(height: 16.h),
              
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
                            childAspectRatio: 0.75,
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
                                    color: AppTheme.surfaceWhite.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: AppTheme.surfaceWhite.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.r),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.1),
                                            Colors.white.withOpacity(0.05),
                                          ],
                                        ),
                                      ),
                                      padding: EdgeInsets.all(14.w),
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
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.all(24.r),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.textTertiary.withOpacity(0.1),
                                      AppTheme.textTertiary.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Icon(
                                  Icons.create_new_folder_outlined,
                                  size: 48.r,
                                  color: AppTheme.textTertiary,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                searchQuery.isNotEmpty 
                                    ? 'No templates found'
                                    : 'No custom templates yet',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textTertiary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                searchQuery.isNotEmpty
                                    ? 'Try adjusting your search'
                                    : 'Create your first custom template',
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.textTertiary,
                                ),
                                textAlign: TextAlign.center,
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