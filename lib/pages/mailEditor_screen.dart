// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:file_picker/file_picker.dart';
// import 'package:http/http.dart' as http;
//
// class EmailEditorScreen extends StatefulWidget {
//   final String templateText; // Pass from previous screen
//
//   const EmailEditorScreen({Key? key, required this.templateText}) : super(key: key);
//
//   @override
//   State<EmailEditorScreen> createState() => _EmailEditorScreenState();
// }
//
// class _EmailEditorScreenState extends State<EmailEditorScreen> {
//
//   quill.QuillController _controller = quill.QuillController.basic();
//   File? selectedFile;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = quill.QuillController(
//       document: quill.Document()..insert(0, widget.templateText),
//       selection: const TextSelection.collapsed(offset: 0),
//     );
//   }
//
//   Future<void> pickDocument() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null) {
//       setState(() {
//         selectedFile = File(result.files.single.path!);
//       });
//
//       final fileContent = await selectedFile!.readAsString();
//
//       // Append to editor
//       _controller.document.insert(_controller.document.length - 1, "\n\n$fileContent");
//     }
//   }
//
//   Future<void> sendEmail() async {
//     final String plainText = _controller.document.toPlainText();
//     final uri = Uri.parse("http://your_backend_api/send-mail");
//
//     var request = http.MultipartRequest('POST', uri)
//       ..fields['to'] = 'test@example.com'
//       ..fields['subject'] = 'Mail from Flutter App'
//       ..fields['text'] = plainText;
//
//     if (selectedFile != null) {
//       request.files.add(await http.MultipartFile.fromPath('attachment', selectedFile!.path));
//     }
//
//     final response = await request.send();
//
//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Email sent successfully")),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to send email")),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Compose Email"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.attach_file),
//             onPressed: pickDocument,
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: sendEmail,
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           quill.QuillToolbar.basic(controller: _controller),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               child: quill.QuillEditor.basic(
//                 controller: _controller,
//                 readOnly: false, // user can edit
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
