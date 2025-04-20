import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:thai_dealy/pages/admin_page/NoteAddPage.dart';
import 'package:thai_dealy/pages/user_page/NoteU_Detail_page.dart'; // เชื่อมหน้าแสดงรายละเอียดโน้ตสำหรับผู้ใช้
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class AllNoteUPage extends StatefulWidget {
  const AllNoteUPage({super.key});

  @override
  _AllNoteUPageState createState() => _AllNoteUPageState();
}

class _AllNoteUPageState extends State<AllNoteUPage> {
  List<dynamic> notes = []; // ตัวแปรเก็บข้อมูลโน้ตทั้งหมด
  String searchQuery = ''; // ตัวแปรสำหรับการค้นหาชื่อโน้ต
  String selectedFilter = 'ทั้งหมด'; // ตัวเลือกเริ่มต้นสำหรับการกรอง

  @override
  void initState() {
    super.initState();
    fetchNotes(); // เรียกใช้งานฟังก์ชันดึงข้อมูลโน้ตเมื่อเริ่มต้น
  }

  // ฟังก์ชันในการดึงข้อมูลโน้ตจาก API
  Future<void> fetchNotes() async {
    final response = await http.get(
      Uri.parse('http://172.20.10.6:3000/notes'), // ✅ ใช้ IP Yolp
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Notes Fetched: $data'); // ✅ log ข้อมูล

      setState(() {
        notes = data;
      });
    } else {
      print('❌ Failed to load notes: ${response.statusCode}');
      throw Exception('Failed to load notes');
    }
  }

@override
Widget build(BuildContext context) {
  final now = DateTime.now();

  // เริ่มต้นสัปดาห์จากวันอาทิตย์ (วันอาทิตย์ = 0, จันทร์ = 1, ...)
  final startOfWeek = now.subtract(Duration(days: now.weekday % 7)); // วันอาทิตย์ของสัปดาห์นี้
  final endOfWeek = startOfWeek.add(Duration(days: 6)); // วันเสาร์ของสัปดาห์นี้

  final startOfMonth = DateTime(now.year, now.month, 1); // วันที่ 1 ของเดือนนี้
  final endOfMonth = DateTime(now.year, now.month + 1, 0); // วันสุดท้ายของเดือนนี้
  final startOfYear = DateTime(now.year, 1, 1); // วันที่ 1 มกราคมของปีนี้
  final endOfYear = DateTime(now.year + 1, 1, 0); // วันที่ 31 ธันวาคมของปีนี้

  // กรองโน้ตตามเงื่อนไข title และ date
  final filteredNotes = notes.where((note) {
    final titleMatch =
        note['title']?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;

    final date = DateTime.tryParse(note['dateline'] ?? '') ?? DateTime(2000);

    bool dateMatch = false;
    switch (selectedFilter) {
      case 'สัปดาห์นี้':
        // สัปดาห์นี้เริ่มจากวันอาทิตย์ถึงวันเสาร์
        dateMatch = date.isAfter(startOfWeek) && date.isBefore(endOfWeek.add(Duration(days: 1))); // เพิ่มวันเสาร์ให้เต็ม
        break;
      case 'เดือนนี้':
        dateMatch = date.isAfter(startOfMonth) && date.isBefore(endOfMonth);
        break;
      case 'ปีนี้':
        dateMatch = date.isAfter(startOfYear) && date.isBefore(endOfYear);
        break;
      default:
        dateMatch = true;
    }

    return titleMatch && dateMatch;
  }).toList();

  filteredNotes.sort((a, b) {
    final dateA = DateTime.parse(a['dateline'] ?? '2000-01-01');
    final dateB = DateTime.parse(b['dateline'] ?? '2000-01-01');
    return dateA.compareTo(dateB); // เปรียบเทียบวันที่ A และ B
  });

  return Scaffold(
    appBar: AppBar(
      backgroundColor: const Color(0xFFFFD966),
      title: const Text('All Notes'),
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown filter
            DropdownButton<String>(
              value: selectedFilter,
              items: ['ทั้งหมด', 'สัปดาห์นี้', 'เดือนนี้', 'ปีนี้']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
              },
            ),

            // Search field
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Notes....',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Display filtered notes
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                final dateline =
                    DateTime.tryParse(note['dateline'] ?? '') ?? DateTime.now();
                final lastModified =
                    DateTime.tryParse(note['last_modified'] ?? '') ?? DateTime.now();

                Color cardColor;
                if (dateline.isBefore(now.add(Duration(days: 1)))) {
                  cardColor = Colors.red[100]!; // สีแดงถ้างานต้องทำภายในวันหรือสองวัน
                } else if (dateline.isBefore(now.add(Duration(days: 7)))) {
                  cardColor = Colors.yellow[100]!; // สีเหลืองถ้าภายในหนึ่งสัปดาห์
                } else {
                  cardColor = Colors.green[100]!; // สีเขียวถ้าไม่เร่งด่วน
                }

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: cardColor,
                  child: ListTile(
                    title: Text(note['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Last Modified: ${DateFormat('dd MMM yyyy').format(lastModified)}"),
                        Text("Sent For: ${note['sent_for']}"),
                        Text("Status: ${note['status']}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteUDetailPage(note: note),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
    // floatingActionButton: FloatingActionButton(
    //   onPressed: () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => NoteAddPage(dateline: DateTime.now()),
    //       ),
    //     );
    //   },
    //   backgroundColor: const Color(0xFFDE712C),
    //   child: const Icon(Icons.add),
    // ),
  );
}

}
