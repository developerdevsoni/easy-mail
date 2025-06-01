import 'package:easy_mail/view/discoverTemplete_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart'; // 👈 Required for Clipboard

import 'package:url_launcher/url_launcher.dart'; // URL Launcher
class EmailTemplateEditorScreen extends StatefulWidget {
  final Map<String, String>? selectedTemplate;

  const EmailTemplateEditorScreen({super.key, this.selectedTemplate});

  @override
  State<EmailTemplateEditorScreen> createState() =>
      _EmailTemplateEditorScreenState();
}

class _EmailTemplateEditorScreenState
    extends State<EmailTemplateEditorScreen> {
  final toController = TextEditingController();
  final ccController = TextEditingController();
  final bccController = TextEditingController();
  final subjectController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.selectedTemplate != null) {
      subjectController.text = widget.selectedTemplate!['title'] ?? '';
      bodyController.text =
      '${widget.selectedTemplate!['body'] ?? ''}\n\n${widget.selectedTemplate!['regards'] ?? ''}';
    }

    _pasteEmailFromClipboard(); // 👈 Automatically fetch clipboard Gmail
  }

  Future<void> _pasteEmailFromClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    print(clipboardData!.text);
    if (clipboardData != null) {
      final text = clipboardData.text ?? '';
      final emailRegex = RegExp(r'\b[\w._%+-]+@[\w.-]+\.\w{2,}\b');
      final match = emailRegex.firstMatch(text);

      if (match != null) {
        setState(() {
          toController.text = match.group(0)!;
        });
      }
    }
  }

  Future<void> _launchMailClient() async {
    final to = Uri.encodeComponent(toController.text.trim());
    final cc = Uri.encodeComponent(ccController.text.trim());
    final bcc = Uri.encodeComponent(bccController.text.trim());
    final subject = Uri.encodeComponent(subjectController.text.trim());
    final body = Uri.encodeComponent(bodyController.text.trim());

    final mailtoLink = Uri.parse(
        'mailto:$to?cc=$cc&bcc=$bcc&subject=$subject&body=$body');

    if (await canLaunchUrl(mailtoLink)) {
      await launchUrl(mailtoLink);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open mail client')),
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
    final lightGreen = const Color(0xFFB2DFDB);

    return Scaffold(
      backgroundColor: MyColor().lightGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title:  Text(
          'Discover Templates',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              _buildInlineField("To", toController),
              const Divider(height: 1),
              _buildInlineField("CC", ccController),
              _buildInlineField("BCC", bccController),
              _buildInlineField("Subject", subjectController),
              const Divider(height: 1),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: TextField(
                  controller: bodyController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: null,
                  style: TextStyle(fontSize: 9.sp, color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: "Compose email",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w, bottom: 10.h),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightGreen,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),

                    onPressed: _launchMailClient,

                    icon: const Icon(Icons.send, color: Colors.black),
                    label: const Text("Send",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInlineField(
      String label, TextEditingController controller) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 50.w,
                child: Text(
                  label,
                  style: TextStyle(fontSize: 10.sp, color: Colors.black),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: TextStyle(fontSize: 11.sp, color: Colors.black),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    border: InputBorder.none,
                    hintText: '',
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
