import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/utils/Icon_animation.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController controller = Get.put(AuthController());

  final List<Map<String, String>> personalTemplates = [
    {
      'title': 'Sales follow-up',
      'subtitle': 'Hi [name], Just wanted to follow up on our previous conversation...'
    },
    {
      'title': 'New feature announcement',
      'subtitle': 'We re excited to introduce our latest feature that will...'
    },
  ];

  final List<Map<String, String>> globalTemplates = [
    {
      'title': '🚀 Product Launch Announcement',
      'body': 'Hi [Name],\n\nWe re excited to let you know that our new product is live! Discover the features, explore the possibilities, and let us know what you think.\n\nFor more details, visit: [Product Page Link]',
      'regards': 'Best regards,  Team [Your Company]\n\nCC: product@company.com  Date: [Launch Date]'
    },
    {
      'title': '🎁 Holiday Offer – Limited Time Only!',
      'body': 'Hey [Name],\n\nWe ve got something special just for you — enjoy 40% OFF everything in our store until December 31st!\n\nUse code: HOLIDAY40  Shop now 👉 [Link]',
      'regards': 'Warm wishes,  The [Company] Team\n\nCC: marketing@company.com  Valid until: Dec 31'
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F2),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// App Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          backgroundImage: controller.photoUrl.value.isNotEmpty
                              ? NetworkImage(controller.photoUrl.value)
                              : null,
                          child: controller.photoUrl.value.isEmpty
                              ? Icon(Icons.person, size: 30.r, color: Colors.white)
                              : null,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () async => await controller.signOutGoogle(),
                          icon: const Icon(Icons.logout, color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    /// Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(

                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(

                          hintText: 'Search templates...',
                          prefixIcon: Icon(Icons.search,color: Colors.black,),
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.black),
                          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    /// AI Template Creation Card
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to AI template creation
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(18.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.shade50,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Icon(Icons.auto_awesome, color: Colors.green.shade700, size: 36.r),
                            const AnimatedAutoAwesomeIcon(),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create with AI',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                      color: Colors.green.shade900,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Let AI help you craft the perfect email template!',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, color: Colors.green.shade700, size: 20.r),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    /// Personal Templates
                    Text(
                      'Your Templates',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      height: 120.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: personalTemplates.length,
                        separatorBuilder: (_, __) => SizedBox(width: 12.w),
                        itemBuilder: (context, index) {
                          final template = personalTemplates[index];
                          return GestureDetector(
                            onTap: () {
                              // TODO: Navigate to personal template editor
                            },
                            child: Container(
                              width: 220.w,
                              padding: EdgeInsets.all(14.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    template['title']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    template['subtitle']!,
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Spacer(),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Icon(Icons.edit, color: Colors.green.shade400, size: 18.r),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 28.h),

                    /// Filter Chips
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: filters.length,
                        separatorBuilder: (_, __) => SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          final filter = filters[index];
                          final isSelected = selectedFilter == filter;
                          return ChoiceChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                            selectedColor: Colors.green.shade600,
                            backgroundColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 11.sp,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 18.h),
                  ],
                ),
              ),
            ),
            /// Global Templates Grid
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final template = globalTemplates[index];
                    // Filter by search and selected filter (if implemented)
                    if (searchQuery.isNotEmpty &&
                        !(template['title']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
                          template['body']!.toLowerCase().contains(searchQuery.toLowerCase()))) {
                      return SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => EmailTemplateEditorScreen(selectedTemplate: template));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template['title']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              template['body']!,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.grey[700],
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(Icons.arrow_forward, color: Colors.green.shade400, size: 18.r),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: globalTemplates.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.85,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 32.h)),
          ],
        ),
      ),
    );
  }
}
