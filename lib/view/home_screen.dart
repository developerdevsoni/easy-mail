import 'package:easy_mail/utils/animatedTextWidget.dart';
import 'package:easy_mail/view/discoverTemplete_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> yourTemplates = [
    {
      'title': 'Sales follow-up',
      'subtitle': 'Hi [name], Just wanted to follow up on our previous conversation...',
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

  final List<String> filters = ['All', 'Marketing', 'Ecommerce', 'Events', 'Newsletters'];

  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(radius: 20, backgroundColor: Colors.grey[400]),
                  const Text('Home', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  const Icon(Icons.settings, color: Colors.black54),
                ],
              ),
              const SizedBox(height: 20),

              /// AI Prompt TextField
              // Container(
              //   padding: const EdgeInsets.all(12),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              //   ),
              //   child: TextField(
              //     maxLines: 4,
              //     style: const TextStyle(color: Colors.black),
              //     decoration: const InputDecoration.collapsed(
              //       hintText: 'Write your prompt to generate with AI...',
              //     ),
              //   ),
              // ),
              TypingPromptField(),
              const SizedBox(height: 20),

              /// Search Bar
              // TextField(
              //   style: const TextStyle(color: Colors.black),
              //   decoration: InputDecoration(
              //     hintText: 'Search templates...',
              //     prefixIcon: const Icon(Icons.search),
              //     filled: true,
              //     fillColor: Colors.white,
              //     contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide.none,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 24),

              /// Your Templates
              const Text('Your templates',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
              const SizedBox(height: 12),
              Column(
                children: yourTemplates.map((template) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(template['title']!,
                        style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.black)),
                    subtitle: Text(template['subtitle']!,
                        style: const TextStyle(color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    trailing: CircleAvatar(radius: 20, backgroundColor: Colors.grey[400]),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              /// Discover Global Templates
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Discover global templates',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                  TextButton(
                    onPressed: () => Get.to(DiscoverTemplatesPage()),
                    child:  Text('Discover more',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

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
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green.shade600 : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Text(filter,
                            style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontSize: 13)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              /// Horizontal Scroll Templates
              SizedBox(
                 height: 250,
                child: Expanded(
                  child: GridView.builder(
                     scrollDirection: Axis.horizontal,
                    itemCount: globalTemplates.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemBuilder: (context, index) {
                      final template = globalTemplates[index];
                      return Container(
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
                      );
                    },
                  ),
                ),
              ),

              const Spacer(),
              //
              /// Create with AI Button
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 48),
                ),
                icon: const Icon(Icons.auto_awesome, color: Colors.white),
                label: const Text('Create with AI', style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
