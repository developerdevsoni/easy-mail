import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyColor {
  final lightGreen = const Color(0xFFF3F8F2);
}

class DiscoverTemplatesPage extends StatelessWidget {
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
'''
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
'''
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
'''
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
'''
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
'''
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
'''
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
'''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Discover Templates',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Trigger AI template generator
        },
        backgroundColor: Colors.green.shade600,
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text("Generate with AI", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.white,
              ),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Search templates...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.black),
                    onPressed: () {
                      // Handle filter
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                itemCount: globalTemplates.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.6,
                ),
                itemBuilder: (context, index) {
                  final template = globalTemplates[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      // height: 200.h,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 4),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  template['body']!,
                                  softWrap: true,
                                  maxLines: 7, // 👈 limit to 4 lines
                                  overflow: TextOverflow.ellipsis, // 👈 show ellipsis when overflow
                                  style: const TextStyle(fontSize: 12, height: 1.4, color: Colors.black),
                                ),
                    
                                const SizedBox(height: 6),
                                Text(
                                  template['regards']!,
                                  style: const TextStyle(fontSize: 11, height: 1.3, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
