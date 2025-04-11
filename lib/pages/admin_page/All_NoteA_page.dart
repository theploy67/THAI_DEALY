import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:thai_dealy/widgets/admin_navigation.dart'; // นำเข้า admin_navigation.dart
import 'package:thai_dealy/pages/admin_page/NoteA_Detail_page.dart'; // นำเข้า NoteA_DetailPage

class AllNoteAPage extends StatefulWidget {
  const AllNoteAPage({super.key});

  @override
  _AllNoteAPageState createState() => _AllNoteAPageState();
}

class _AllNoteAPageState extends State<AllNoteAPage> {
  String searchQuery = ''; // ตัวแปรสำหรับการค้นหา
  final List<Map<String, String>> notes = [
    {'title': 'Meeting with Ploy next week', 'date': '23 Jan 2025'},
    {'title': 'Discuss budget', 'date': '23 Jan 2025'},
    {'title': 'Ploy proposed moving to the new office', 'date': '23 Jan 2025'},
    // ข้อมูลโน้ตเพิ่มเติม
  ];

  @override
  Widget build(BuildContext context) {
    // กรองข้อมูลโน้ตที่ตรงกับคำค้น
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
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("All Notes"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // กลับไปหน้าก่อนหน้า
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ช่องค้นหาข้อมูล
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Note....',
                  border: OutlineInputBorder(),
                ),
              ),
              const Gap(20),

              // รายการโน้ต
              ListView.builder(
                shrinkWrap: true,
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
                          // เมื่อคลิกไอคอน arrow_forward, ให้ไปหน้า NoteADetailPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NoteADetailPage(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),

              const Gap(20),

              // ปุ่ม "See All"
              TextButton(
                onPressed: () {
                  // เพิ่มการนำทางไปยังหน้าทั้งหมด
                  // สามารถเปิดหน้าอื่นๆ เช่น หน้า All Notes ที่เต็มได้
                },
                child: const Text("See All"),
              ),
            ],
          ),
        ),
      ),

      // BottomNavigationBar สำหรับการนำทาง
      bottomNavigationBar:
          AdminNavigationPage(), // ใช้ AdminNavigationPage สำหรับการนำทาง
    );
  }
}
