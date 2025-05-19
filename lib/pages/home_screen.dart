
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> userTemplates = ['Welcome', 'Job Offer', 'Invitation'];
  final List<String> allTemplates =
  List.generate(20, (index) => 'Template ${index + 1}');
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredTemplates = allTemplates
        .where((template) =>
        template.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mail Templates'),
        backgroundColor: Colors.grey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search box
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search templates...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
            const SizedBox(height: 16),

            // 👤 User Templates
            const Text("Your Templates",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: userTemplates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) => Card(
                  color: Colors.grey[800],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Center(
                      child: Text(userTemplates[index],
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📄 All Templates (2-row horizontal scroll)
            const Text("All Templates",
                style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              // child: SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       _buildTemplateColumn(filteredTemplates, 0),
              //       const SizedBox(width: 10),
              //       _buildTemplateColumn(filteredTemplates, 1),
              //     ],
              //   ),
              // ),
              child: ListView.builder(itemBuilder:(context, index) {
                return _buildTemplateColumn(filteredTemplates, 0);

              },),
            ),
          ],
        ),
      ),

      // ➕ Add Template FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add your custom template add logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Add template tapped!")),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // 📦 Builds one vertical column from even or odd indexed templates
  Widget _buildTemplateColumn(List<String> templates, int startIndex) {
    List<Widget> columnChildren = [];
    for (int i = startIndex; i < templates.length; i += 2) {
      columnChildren.add(
        Card(
          color: Colors.grey[850],
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              templates[i],
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Column(children: columnChildren);
  }
}