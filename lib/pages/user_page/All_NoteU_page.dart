import 'package:flutter/material.dart';
import 'package:gap/gap.dart'; // ใช้สำหรับจัดระเบียบ layout

class AllNoteUPage extends StatefulWidget {
  const AllNoteUPage({super.key});

  @override
  _AllNoteUPageState createState() => _AllNoteUPageState();
}

class _AllNoteUPageState extends State<AllNoteUPage> {
  // ตัวแปรสำหรับเก็บข้อมูลโน้ต
  final List<Map<String, String>> notes = [
    {'title': 'Meeting with Ploy next week', 'date': '23 Jan 2025'},
    {'title': 'Discuss budget', 'date': '23 Jan 2025'},
    {'title': 'Ploy proposed moving to the....', 'date': '23 Jan 2025'},
    {'title': 'Ploy proposed moving to the....', 'date': '23 Jan 2025'},
    {'title': 'Ploy proposed moving to the....', 'date': '23 Jan 2025'},
    {'title': 'Ploy proposed moving to the....', 'date': '23 Jan 2025'},
    {'title': 'Ploy proposed moving to the....', 'date': '23 Jan 2025'},
    {'title': 'Ploy proposed moving to the....', 'date': '23 Jan 2025'},
  ];

  String searchQuery = ''; // ตัวแปรสำหรับการค้นหาโน้ต

  @override
  Widget build(BuildContext context) {
    final filteredNotes =
        notes
            .where(
              (note) => note['title']!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Note'),
        backgroundColor: const Color(0xFFFFD966),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ช่องค้นหาข้อมูล
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 213, 213, 213),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.black54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search Note....',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(20),

            // รายการโน้ต
            Expanded(
              child: ListView.builder(
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(note['title']!),
                      subtitle: Text(note['date']!),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          // สามารถเพิ่มการนำทางไปยังรายละเอียดของโน้ตที่เลือกได้
                        },
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
