import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/view/email_templet_editor_screen.dart';
import 'package:easy_mail/controllers/template_controller.dart';
import 'package:get/get.dart';

class MyTemplatesScreen extends StatefulWidget {
  @override
  State<MyTemplatesScreen> createState() => _MyTemplatesScreenState();
}

class _MyTemplatesScreenState extends State<MyTemplatesScreen> {
  final TemplateController templateController = Get.put(TemplateController());
  String searchQuery = '';

  List<dynamic> _getFilteredTemplates() {
    final templates = templateController.personalTemplates;
    if (searchQuery.isEmpty) {
      return templates;
    }

    return templates
        .where((template) =>
            (template['title'] ?? '')
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            (template['body'] ?? '')
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();
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
  void initState() {
    super.initState();
    // Fetch user's personal templates when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      templateController.getPersonalTemplates();
    });
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
                        Get.to(() => EmailTemplateEditorScreen());
                        // Navigate to template creation screen
                        // TODO: Implement template creation navigation
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
                  child: Obx(() {
                    if (templateController.isLoading.value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppTheme.primaryBlue,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Loading your templates...',
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
                              childAspectRatio: 0.75,
                            ),
                            itemCount: _getFilteredTemplates().length,
                            itemBuilder: (context, index) {
                              final template = _getFilteredTemplates()[index];
                              return AnimatedContainer(
                                duration:
                                    Duration(milliseconds: 300 + (index * 50)),
                                curve: Curves.easeOutBack,
                                child: GestureDetector(
                                  onTap: () {
                                    // Convert dynamic template to Map<String, String> format expected by editor
                                    final templateData = {
                                      'title':
                                          template['subject']?.toString() ??
                                              'Untitled',
                                      'body':
                                          template['body']?.toString() ?? '',
                                      'regards':
                                          template['regards']?.toString() ?? '',
                                      'category':
                                          template['category']?.toString() ??
                                              'Personal',
                                      'isCustom': 'true',
                                      'createdDate': template['createdAt']
                                              ?.toString() ??
                                          template['createdDate']?.toString() ??
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
                                      color: AppTheme.surfaceWhite
                                          .withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(16.r),
                                      border: Border.all(
                                        color: AppTheme.surfaceWhite
                                            .withOpacity(0.3),
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
                                        // padding: EdgeInsets.all(14.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  template['createdAt']
                                                          ?.toString()
                                                          .substring(0, 10) ??
                                                      template['createdDate']
                                                          ?.toString() ??
                                                      DateTime.now()
                                                          .toString()
                                                          .substring(0, 10),
                                                  style:
                                                      AppTheme.caption.copyWith(
                                                    color:
                                                        AppTheme.textTertiary,
                                                    fontSize: 9.sp,
                                                  ),
                                                ),
                                                const Spacer(),
                                                // Container(
                                                //   padding: EdgeInsets.symmetric(
                                                //     horizontal: 8.w,
                                                //     vertical: 3.h,
                                                //   ),
                                                //   decoration: BoxDecoration(
                                                //     color: AppTheme.textTertiary
                                                //         .withOpacity(0.1),
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             6.r),
                                                //   ),
                                                //   child: Text(
                                                //     'Custom',
                                                //     style:
                                                //         AppTheme.caption.copyWith(
                                                //       color:
                                                //           AppTheme.textSecondary,
                                                //       fontWeight: FontWeight.w600,
                                                //       fontSize: 10.sp,
                                                //     ),
                                                //   ),
                                                // ),

                                                SizedBox(width: 8.w),
                                                Container(
                                                  padding: EdgeInsets.all(4.r),
                                                  decoration: BoxDecoration(
                                                    gradient: AppTheme
                                                        .primaryGradient,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4.r),
                                                  ),
                                                  child: Icon(
                                                    Icons.edit_rounded,
                                                    color:
                                                        AppTheme.surfaceWhite,
                                                    size: 12.r,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 12.h),
                                            Text(
                                              template['subject']?.toString() ??
                                                  'Untitled',
                                              style:
                                                  AppTheme.bodyMedium.copyWith(
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
                                                _getEmailPreview(
                                                    template['body']
                                                            ?.toString() ??
                                                        ''),
                                                style:
                                                    AppTheme.caption.copyWith(
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
                                      : 'No personal templates yet',
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textTertiary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  searchQuery.isNotEmpty
                                      ? 'Try adjusting your search'
                                      : 'Create your first personal template',
                                  style: AppTheme.caption.copyWith(
                                    color: AppTheme.textTertiary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (searchQuery.isEmpty) ...[
                                  SizedBox(height: 16.h),
                                  GestureDetector(
                                    onTap: () {
                                      // Refresh templates
                                      templateController.getPersonalTemplates();
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
    );
  }
}
