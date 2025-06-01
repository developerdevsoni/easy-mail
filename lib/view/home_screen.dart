import 'package:easy_mail/controllers/auth_controller.dart';
import 'package:easy_mail/utils/animatedTextWidget.dart';
import 'package:easy_mail/view/discoverTemplete_screen.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:easy_mail/view/mailEditor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController controller = Get.put(AuthController());
  final List<Map<String, String>> yourTemplates = [
    {
      'title': 'Sales follow-up',
      'subtitle':
          'Hi [name], Just wanted to follow up on our previous conversation...',
    },
    {
      'title': 'New feature announcement',
      'subtitle': 'We’re excited to introduce our latest feature that will...',
    },
  ];

  final List<Map<String, String>> globalTemplates = [
    {
      'title': '🚀 Product Launch Announcement',
      'body': '''
Hi [Name],

We’re excited to let you know that our new product is live! Discover the features, explore the possibilities, and let us know what you think.

For more details, visit: [Product Page Link]
''',
      'regards': '''
Best regards,  
Team [Your Company]

CC: product@company.com  
Date: [Launch Date]
''',
    },
    {
      'title': '🎁 Holiday Offer – Limited Time Only!',
      'body': '''
Hey [Name],

We’ve got something special just for you — enjoy 40% OFF everything in our store until December 31st!

Use code: HOLIDAY40  
Shop now 👉 [Link]
''',
      'regards': '''
Warm wishes,  
The [Company] Team

CC: marketing@company.com  
Valid until: Dec 31
''',
    },
    {
      'title': '📅 Webinar Reminder – Starts in 1 Hour',
      'body': '''
Dear [Name],

Just a friendly reminder that our webinar “AI Trends in 2025” starts in 1 hour.

🕐 Time: [Start Time]  
📍 Join here: [Webinar Link]

We’ll be taking questions live too — don’t miss it!
''',
      'regards': '''
Regards,  
Emily from [Company]

CC: webinars@company.com  
Sent: [Today’s Date]
''',
    },
    {
      'title': '👋 Welcome Onboard!',
      'body': '''
Hi [Name],

Welcome to [Platform Name] — we’re so glad to have you! 🎉

Here’s a quick start guide to help you: [Guide Link]  
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
      'title': '💬 We’d Love Your Feedback',
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
      'title': '✅ Confirmation – You’re Registered',
      'body': '''
Hi [Name],

You’re all set! We’ve registered you for “[Event Name]” happening on [Event Date].

📍 View event details: [Event Link]  
Questions? Reach out anytime.
''',
      'regards': '''
Warm regards,  
Events Team

CC: events@company.com  
Registered: [Today’s Date]
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [CircleAvatar(
                  // radius: 30.r,
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
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                    onTap: () async => await controller.signOutGoogle(),
                    child: const Icon(Icons.logout, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              TypingPromptField(),
              SizedBox(height: 20.h),

              /// Your Templates
              Text(
                'Your templates',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Container(
                height: 330.h,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: globalTemplates.length,
                  // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 2,
                  //   mainAxisSpacing: 12,
                  //   crossAxisSpacing: 12,
                  //   childAspectRatio: 0.75,
                  // ),
                  itemBuilder: (context, index) {
                    final template = globalTemplates[index];

                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10.h),
                        width: 250.w,
                        // margin: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),

                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => EmailTemplateEditorScreen(selectedTemplate: template));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template['title']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    template['body']!,
                                    softWrap: true,
                                    maxLines: 7,
                                    // 👈 limit to 4 lines
                                    overflow: TextOverflow.ellipsis,
                                    // 👈 show ellipsis when overflow
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      height: 1.4.h,
                                      color: Colors.black,
                                    ),
                                  ),

                                  SizedBox(height: 6.h),
                                  Text(
                                    template['regards']!,
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      height: 1.3,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                  },
                ),
              ),

              SizedBox(height: 20),

              /// Discover Global Templates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover global templates',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.to(DiscoverTemplatesPage()),
                    child: Text(
                      'Discover more',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),

              /// Filter Bar
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = selectedFilter == filter;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.green.shade600 : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Center(
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 12.h),

              /// Horizontal Scroll Templates
              Container(
                height: 330.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: globalTemplates.length,
                  // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 2,
                  //   mainAxisSpacing: 12,
                  //   crossAxisSpacing: 12,
                  //   childAspectRatio: 0.75,
                  // ),
                  itemBuilder: (context, index) {
                    final template = globalTemplates[index];

                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 6.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(10.h),
                        width: 250.w,
                        // margin: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),

                        ),
                        child: GestureDetector(
                          onTap: () {
                            Get.to(() => EmailTemplateEditorScreen(selectedTemplate: template));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template['title']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp,
                                  color: Colors.black,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    template['body']!,
                                    softWrap: true,
                                    maxLines: 7,
                                    // 👈 limit to 4 lines
                                    overflow: TextOverflow.ellipsis,
                                    // 👈 show ellipsis when overflow
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      height: 1.4.h,
                                      color: Colors.black,
                                    ),
                                  ),

                                  SizedBox(height: 6.h),
                                  Text(
                                    template['regards']!,
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      height: 1.3,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                  },
                ),
              ),
              SizedBox(height: 26.h),
              // const Spacer(),
              /// Create with AI Button
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: Size(double.infinity, 48.h),
                ),
                icon: Icon(Icons.auto_awesome, color: Colors.white),
                label: Text(
                  'Create with AI',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
