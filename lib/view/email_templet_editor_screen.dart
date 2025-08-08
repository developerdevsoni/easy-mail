import 'package:easy_mail/utils/app_theme.dart';
import 'package:easy_mail/widgets/modern_ui_components.dart';
import 'package:easy_mail/controllers/template_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart'; // 👈 Required for Clipboard
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart'; // URL Launcher

class EmailTemplateEditorScreen extends StatefulWidget {
  final selectedTemplate;

  const EmailTemplateEditorScreen({super.key, this.selectedTemplate});

  @override
  State<EmailTemplateEditorScreen> createState() =>
      _EmailTemplateEditorScreenState();
}

class _EmailTemplateEditorScreenState extends State<EmailTemplateEditorScreen> {
  final TemplateController templateController = Get.put(TemplateController());
  final toController = TextEditingController();
  final ccController = TextEditingController();
  final bccController = TextEditingController();
  final subjectController = TextEditingController();
  final bodyController = TextEditingController();
  final regardsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Handle both null template and empty template cases
    if (widget.selectedTemplate != null) {
      print(
          "🔑 Selected Template: ${widget.selectedTemplate['title'] ?? widget.selectedTemplate['subject'] ?? 'Untitled'}");

      // Handle both 'title' and 'subject' fields for compatibility
      final templateTitle = widget.selectedTemplate['title'] ??
          widget.selectedTemplate['subject'] ??
          '';

      subjectController.text = templateTitle;

      // Combine body and regards if they exist
      final templateBody = widget.selectedTemplate['body'] ?? '';
      final templateRegards = widget.selectedTemplate['regards'] ?? '';

      if (templateBody.isNotEmpty || templateRegards.isNotEmpty) {
        bodyController.text =
            templateBody.isNotEmpty && templateRegards.isNotEmpty
                ? '$templateBody\n\n$templateRegards'
                : templateBody + templateRegards;
      }
    } else {
      print("🔑 No template selected - Starting with empty editor");
    }

    _pasteEmailFromClipboard(); // 👈 Automatically fetch clipboard Gmail
  }

  Future<void> _pasteEmailFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData('text/plain');

      if (clipboardData != null && clipboardData.text != null) {
        final text = clipboardData.text!;
        final emailRegex = RegExp(r'\b[\w._%+-]+@[\w.-]+\.\w{2,}\b');
        final match = emailRegex.firstMatch(text);

        if (match != null && toController.text.isEmpty) {
          setState(() {
            toController.text = match.group(0)!;
          });
        }
      }
    } catch (e) {
      // Clipboard access may fail, ignore silently
      print('Clipboard access failed: $e');
    }
  }

  Future<void> _saveCurrentTemplate() async {
    try {
      // Extract body and regards from the body text
      final fullBody = bodyController.text.trim();
      String body = fullBody;
      String regards = '';

      // Try to separate body and regards (assuming regards is at the end)
      final regardsPattern = RegExp(r'\n\n([A-Za-z\s,]+)$');
      final match = regardsPattern.firstMatch(fullBody);

      if (match != null) {
        regards = match.group(1) ?? '';
        body = fullBody.substring(0, fullBody.length - regards.length).trim();
      }

      // Prepare template data according to API requirements
      final templateData = {
        'name': subjectController.text.trim().isEmpty
            ? 'Untitled Template'
            : subjectController.text.trim(), // API expects 'name' field
        'subject': subjectController.text.trim().isEmpty
            ? 'No Subject'
            : subjectController.text.trim(), // API expects 'subject' field
        'body': body.isEmpty ? 'Empty content' : body,
        'regards': regards.trim().isEmpty ? 'Best regards' : regards.trim(),
        'tags': widget.selectedTemplate != null
            ? ['edited']
            : ['new'], // Tag appropriately
        'isFavorite': false, // Optional favorite flag
      };

      final success =
          await templateController.createPersonalTemplate(templateData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Template saved successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      print('Error saving template: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save template'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _saveAsDraft() async {
    try {
      // Extract body and regards from the body text
      final fullBody = bodyController.text.trim();
      String body = fullBody;
      String regards = '';

      // Try to separate body and regards (assuming regards is at the end)
      final regardsPattern = RegExp(r'\n\n([A-Za-z\s,]+)$');
      final match = regardsPattern.firstMatch(fullBody);

      if (match != null) {
        regards = match.group(1) ?? '';
        body = fullBody.substring(0, fullBody.length - regards.length).trim();
      }

      // Prepare template data according to API requirements for draft
      final templateData = {
        'name': subjectController.text.trim().isEmpty
            ? 'Draft Template'
            : '${subjectController.text.trim()} (Draft)', // API expects 'name' field
        'subject': subjectController.text.trim().isEmpty
            ? 'Draft Subject'
            : subjectController.text.trim(), // API expects 'subject' field
        'body': body.isEmpty ? 'Draft content...' : body,
        'regards': regards.isEmpty ? 'Best regards' : regards,
        'tags': widget.selectedTemplate != null
            ? ['draft', 'edited']
            : ['draft', 'new'], // Tag as draft
        'isFavorite': false, // Optional favorite flag
      };

      final success =
          await templateController.createPersonalTemplate(templateData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Draft saved successfully!'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
    } catch (e) {
      print('Error saving draft: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save draft'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _launchMailClient() async {
    // First save the current template as a regular template
    // await _saveCurrentTemplate();

    final to = Uri.encodeComponent(toController.text.trim());
    final cc = Uri.encodeComponent(ccController.text.trim());
    final bcc = Uri.encodeComponent(bccController.text.trim());
    final subject = Uri.encodeComponent(subjectController.text.trim());
    final body = Uri.encodeComponent(bodyController.text.trim());

    final mailtoLink = Uri.parse(
      'mailto:$to?cc=$cc&bcc=$bcc&subject=$subject&body=$body',
    );

    if (await canLaunchUrl(mailtoLink)) {
      await launchUrl(mailtoLink);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open mail client'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  @override
  void dispose() {
    toController.dispose();
    ccController.dispose();
    bccController.dispose();
    subjectController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: AppTheme.surfaceWhite,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_rounded,
              color: AppTheme.textPrimary,
              size: 16.r,
            ),
          ),
        ),
        title: Text(
          widget.selectedTemplate != null ? 'Edit Template' : 'New Email',
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {
                // TODO: Show email options
              },
              icon: Icon(
                Icons.more_vert_rounded,
                color: AppTheme.textSecondary,
                size: 16.r,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 📧 COMPACT EMAIL HEADER SECTION
                  ModernCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: AppTheme.primaryBlue,
                              size: 16.r,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                'Email Details',
                                style: AppTheme.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.sm),
                        _buildEmailField(
                            "To", toController, Icons.person_outline_rounded),
                        _buildEmailField(
                            "CC", ccController, Icons.people_outline_rounded),
                        _buildEmailField("BCC", bccController,
                            Icons.visibility_off_outlined),
                        _buildEmailField(
                            "Subject", subjectController, Icons.subject_rounded,
                            isLastField: true),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.sm),

                  // 📝 COMPACT EMAIL BODY SECTION
                  ModernCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.edit_note_rounded,
                              color: AppTheme.secondaryTeal,
                              size: 16.r,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                'Email Content',
                                style: AppTheme.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundGray,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                '${bodyController.text.length} chars',
                                style: AppTheme.caption.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(minHeight: 200.h),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundGray,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppTheme.cardGray,
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: bodyController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: 8,
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                              hintText: widget.selectedTemplate != null
                                  ? "Edit your email content..."
                                  : "Compose your email...",
                              hintStyle: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textTertiary,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(AppSpacing.sm),
                            ),
                            onChanged: (value) {
                              setState(() {}); // Update character count
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSpacing.sm),

                  // 🛠️ COMPACT QUICK ACTIONS
                  ModernCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Quick Actions',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickAction(
                                'Save Draft',
                                Icons.save_outlined,
                                AppTheme.textSecondary,
                                () async {
                                  await _saveAsDraft();
                                },
                              ),
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: _buildQuickAction(
                                'Copy Text',
                                Icons.copy_rounded,
                                AppTheme.textSecondary,
                                () {
                                  final fullEmail = '''
Subject: ${subjectController.text}

${bodyController.text}
                                  ''';
                                  Clipboard.setData(
                                      ClipboardData(text: fullEmail));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Copied to clipboard'),
                                      backgroundColor: AppTheme.successGreen,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: _buildQuickAction(
                                'Clear All',
                                Icons.clear_rounded,
                                AppTheme.errorRed,
                                () {
                                  _showClearConfirmation();
                                },
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

          // 🚀 COMPACT SEND SECTION
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppTheme.textSecondary,
                        size: 12.r,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          _canSendEmail()
                              ? 'This will open your default email client'
                              : 'Fill in To, Subject, and Body to send email',
                          style: AppTheme.bodySmall.copyWith(
                            color: _canSendEmail()
                                ? AppTheme.textSecondary
                                : AppTheme.errorRed,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs),

                  // Save Template Button
                  ModernButton(
                    backgroundColor: AppTheme.secondaryTeal,
                    text: widget.selectedTemplate != null
                        ? 'Update Template'
                        : 'Save as Template',
                    icon: Icon(
                      widget.selectedTemplate != null
                          ? Icons.update_rounded
                          : Icons.save_rounded,
                      color: AppTheme.surfaceWhite,
                      size: 14.r,
                    ),
                    minimumSize: Size(double.infinity, 42.h),
                    onPressed: () async {
                      _canSendEmail() ? await _saveCurrentTemplate() : null;
                    },
                  ),

                  SizedBox(height: AppSpacing.xs),

                  ModernButton(
                    backgroundColor: AppTheme.primaryBlue,
                    text: 'Send Email',
                    icon: Icon(
                      Icons.send_rounded,
                      color: AppTheme.surfaceWhite,
                      size: 14.r,
                    ),
                    minimumSize: Size(double.infinity, 42.h),
                    onPressed: _canSendEmail() ? _launchMailClient : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(
      String label, TextEditingController controller, IconData icon,
      {bool isLastField = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    color: AppTheme.textSecondary,
                    size: 12.r,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      label,
                      style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(color: AppTheme.cardGray),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: BorderSide(color: AppTheme.cardGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide:
                        BorderSide(color: AppTheme.primaryBlue, width: 2),
                  ),
                  hintText: label == "Subject"
                      ? "Enter email subject"
                      : "Enter email address",
                  hintStyle:
                      AppTheme.bodySmall.copyWith(color: AppTheme.textTertiary),
                  filled: true,
                  fillColor: AppTheme.backgroundGray,
                ),
              ),
            ),
          ],
        ),
        if (!isLastField) SizedBox(height: AppSpacing.xs),
      ],
    );
  }

  Widget _buildQuickAction(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
        decoration: BoxDecoration(
          color: AppTheme.backgroundGray,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppTheme.cardGray),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 16.r,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTheme.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  bool _canSendEmail() {
    return toController.text.trim().isNotEmpty &&
        subjectController.text.trim().isNotEmpty &&
        bodyController.text.trim().isNotEmpty;
  }

  void _showClearConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          title: Text(
            'Clear All Fields',
            style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          content: Text(
            'Are you sure you want to clear all email fields? This action cannot be undone.',
            style: AppTheme.bodySmall,
            overflow: TextOverflow.visible,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            ModernButton(
              backgroundColor: AppTheme.secondaryTeal,
              text: 'Clear All',
              variant: ButtonVariant.secondary,
              onPressed: () {
                setState(() {
                  toController.clear();
                  ccController.clear();
                  bccController.clear();
                  subjectController.clear();
                  bodyController.clear();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All fields cleared'),
                    backgroundColor: AppTheme.successGreen,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
