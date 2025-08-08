import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:easy_mail/controllers/template_controller.dart';
import 'package:get/get.dart';

class DiscoverTemplatesPage extends StatefulWidget {
  @override
  State<DiscoverTemplatesPage> createState() => _DiscoverTemplatesPageState();
}

class _DiscoverTemplatesPageState extends State<DiscoverTemplatesPage> {
  final TemplateController templateController = Get.put(TemplateController());
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load global templates when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      templateController.getGlobalTemplates();
    });
  }

  Future<void> _onRefresh() async {
    await templateController.getGlobalTemplates();
  }

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

  // Global templates will be loaded from API

  List<dynamic> _getFilteredTemplates() {
    List<dynamic> filtered = templateController.globalTemplates;

    // Filter by category
    if (selectedCategory != 'All') {
      filtered = filtered
          .where((template) =>
              (template['category']?.toString() ?? '') == selectedCategory)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((template) =>
              (template['title']?.toString() ?? '')
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              (template['subject']?.toString() ?? '')
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              (template['body']?.toString() ?? '')
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

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
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppTheme.primaryBlue,
            backgroundColor: AppTheme.surfaceWhite,
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                                            color: AppTheme.textTertiary
                                                .withOpacity(0.2),
                                            width: 1,
                                          ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? AppTheme.primaryBlue
                                                .withOpacity(0.25)
                                            : AppTheme.textTertiary
                                                .withOpacity(0.05),
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
                    child: Obx(() {
                      if (templateController.isLoading.value &&
                          templateController.globalTemplates.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: AppTheme.primaryBlue,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Loading templates...',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return _getFilteredTemplates().isNotEmpty
                          ? GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12.h,
                                crossAxisSpacing: 12.w,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: _getFilteredTemplates().length,
                              itemBuilder: (context, index) {
                                final template = _getFilteredTemplates()[index];
                                return AnimatedContainer(
                                  duration: Duration(
                                      milliseconds: 300 + (index * 50)),
                                  curve: Curves.easeOutBack,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Convert dynamic template to format expected by editor
                                      final templateData = {
                                        'title': template['title']
                                                ?.toString() ??
                                            template['subject']?.toString() ??
                                            'Untitled',
                                        'body':
                                            template['body']?.toString() ?? '',
                                        'regards':
                                            template['regards']?.toString() ??
                                                '',
                                        'category':
                                            template['category']?.toString() ??
                                                'General',
                                        'isCustom': 'false',
                                        'createdDate': template['createdAt']
                                                ?.toString()
                                                .substring(0, 10) ??
                                            DateTime.now()
                                                .toString()
                                                .substring(0, 10),
                                      };
                                      Get.to(() => EmailTemplateEditorScreen(
                                            selectedTemplate: templateData,
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppTheme.surfaceWhite,
                                            AppTheme.backgroundGray
                                                .withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        border: Border.all(
                                          color: AppTheme.cardGray
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.primaryBlue
                                                .withOpacity(0.06),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(12.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(6.r),
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      AppTheme.primaryGradient,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.r),
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
                                                  color:
                                                      AppTheme.backgroundGray,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.r),
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
                                            template['title']?.toString() ??
                                                template['subject']
                                                    ?.toString() ??
                                                'Untitled',
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
                                              _getEmailPreview(template['body']
                                                      ?.toString() ??
                                                  ''),
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
                                  SizedBox(height: 16.h),
                                  GestureDetector(
                                    onTap: () {
                                      templateController.getGlobalTemplates();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.w,
                                        vertical: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: AppTheme.primaryGradient,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.primaryBlue
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.refresh_rounded,
                                            color: AppTheme.surfaceWhite,
                                            size: 16.r,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            'Refresh',
                                            style: AppTheme.bodyMedium.copyWith(
                                              color: AppTheme.surfaceWhite,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
