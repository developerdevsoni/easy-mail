import 'package:easy_mail/view/mailEditor_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final String userImageUrl =
  //     // "https://via.placeholder.com/150"; // Replace with real image URL or asset
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4YreOWfDX3kK-QLAbAL4ufCPc84ol2MA8Xg&s"; // Replace with real image URL or asset

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurple.shade400,
                    Colors.deepPurple.shade700
                  ],
                ),
              ),
              // child:Text("abc")
            child:   CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(userImageUrl),
              ),
            ),
            ListTile(
              leading: Icon(Icons.inbox),
              title: Text('Inbox'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Mail Sender'),
        backgroundColor: Colors.deepPurple,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon:
            CircleAvatar(
              backgroundImage: NetworkImage(userImageUrl),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Templates",
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 8),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Replace with dynamic data
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(() => const MailEditorScreen());
                    },
                    child: Card(
                      elevation: 3,
                      margin: EdgeInsets.only(right: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.all(12),
                        child: Center(child: Text("Template ${index + 1}")),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search templates...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 20),
            Text("Global Templates",
                style: Theme.of(context).textTheme.headlineMedium),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with dynamic data
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: Icon(Icons.email_outlined),
                      title: Text('Global Template ${index + 1}'),
                      subtitle: Text('Description of template goes here.'),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
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
