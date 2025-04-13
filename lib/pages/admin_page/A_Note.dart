import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thai_dealy/pages/admin_page/NoteA_Detail_page.dart'; // นำเข้า NoteADetailPage


class A_Note extends StatefulWidget {
  const A_Note({super.key});

  @override
  _A_NoteState createState() => _A_NoteState();
}

class _A_NoteState extends State<A_Note> {
  List<dynamic> notes = []; // สร้างตัวแปรเก็บข้อมูลโน้ต
  String searchQuery = ''; // ตัวแปรสำหรับค้นหา

  @override
  void initState() {
    super.initState();
    fetchNotes(); // เรียกใช้งานฟังก์ชันดึงข้อมูลโน้ตเมื่อเริ่มต้น
  }

  // ฟังก์ชันในการดึงข้อมูลโน้ตจาก API
  Future<void> fetchNotes() async {
    final response = await http.get(Uri.parse('https://your-api-url.com/notes'));

    if (response.statusCode == 200) {
      // ถ้าสำเร็จ จะทำการแปลงข้อมูล JSON เป็น List และเก็บไว้ในตัวแปร notes
      setState(() {
        notes = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load notes');
    }
  }

  @override
  Widget build(BuildContext context) {
    // กรองข้อมูลโน้ตที่ตรงกับคำค้น
    final filteredNotes = notes
        .where((note) => note['title']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDE712C),
        title: const Text('All Notes'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ส่วนการค้นหาข้อมูลโน้ต
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

              // แสดงโน้ตทั้งหมด
              ListView.builder(
                shrinkWrap: true,
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    color: Colors.green[100], // เปลี่ยนสีพื้นหลังของโน้ต
                    child: ListTile(
                      title: Text(note['title']), // แสดงชื่อโน้ต
                      subtitle: Text(note['date']), // แสดงวันที่
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          // ไปที่หน้า NoteDetailPage เมื่อกดที่ไอคอนนี้
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => NoteADetailPage(
                                    dateline:
                                        DateTime.now(), // ส่งค่าพารามิเตอร์ที่ต้องการ
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20), // ใช้แทน Gap(20)


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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // ฟังก์ชันสำหรับเพิ่มโน้ตใหม่
      //   },
      //   backgroundColor: const Color(0xFFDE712C),
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ใช้ Navigator เพื่อไปที่หน้า NoteA_Detail_page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => NoteADetailPage(
                    dateline:
                        DateTime.now(), // ส่งค่า dateline ไปยังหน้า NoteADetailPage
                  ),
            ),
          );
        },
        backgroundColor: const Color(0xFFDE712C),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteDetailPage extends StatelessWidget {
  final int noteId;
  const NoteDetailPage({super.key, required this.noteId});

  @override
  Widget build(BuildContext context) {
    // คุณสามารถใช้ noteId เพื่อนำไปดึงข้อมูลรายละเอียดของโน้ตจาก API
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Detail'),
      ),
      body: Center(
        child: Text('Detail of Note ID: $noteId'), // แสดงข้อมูลโน้ต
      ),
    );
  }
}
