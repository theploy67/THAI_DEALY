import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:thai_dealy/pages/user_page/NoteU_Detail_page.dart';

class HomeUPage extends StatefulWidget {
  const HomeUPage({super.key});
  @override
  State<HomeUPage> createState() => _HomeUPageState();
}

class _HomeUPageState extends State<HomeUPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<dynamic> doNowTasks = []; // งานที่ต้องทำในปัจจุบัน (Do Now)
  List<dynamic> workPlanTasks = []; // งานตามเวลา (Work Plan)
  Map<DateTime, List<dynamic>> _eventsByDate = {};
  List<dynamic> dismissedTasks = []; // เก็บงานที่ถูกปัดออก (แค่หายไปในหน้า Home)

  @override
  void initState() {
    super.initState();
    fetchTasks(); // ดึงข้อมูลงานเมื่อเริ่มต้น
  }

  // ฟังก์ชันในการดึงข้อมูล task จาก API
  Future<void> fetchTasks() async {
    try {
      final response = await http.get(
        Uri.parse('http://172.20.10.6:3000/notes'),
      ); // API ของคุณ

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Fetched Data: $data'); // ตรวจสอบข้อมูลที่ได้รับ

        setState(() {
          doNowTasks =
              data.where((task) => task['status'] == 'Do Now!').toList();
          workPlanTasks =
              data.where((task) => task['status'] == 'Normal').toList();

          _eventsByDate.clear(); // เคลียร์ก่อนโหลดใหม่
          for (var task in data) {
            final DateTime date = DateTime.parse(task['dateline']);
            final DateTime dateOnly = DateTime(
              date.year,
              date.month,
              date.day,
            ); // เอาเฉพาะวัน

            if (_eventsByDate[dateOnly] == null) {
              _eventsByDate[dateOnly] = [task];
            } else {
              _eventsByDate[dateOnly]!.add(task);
            }
          }
        });
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // ฟังก์ชันที่กรอง task ตาม status ที่ให้เลือก (Do Now, Normal)
  List<Widget> _buildTaskCards(IconData icon, List<dynamic> tasks) {
    return tasks.map((task) {
      return Dismissible(
        key: Key(task['id'].toString()), // ใช้ id เป็น key
        onDismissed: (direction) {
          // เมื่อปัดขวา ให้แสดง AlertDialog สำหรับ "Office Check"
          _showOfficeCheckDialog(task);
        },
        background: Container(
          color: Colors.green,
          alignment: Alignment.centerRight,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'งานเสร็จแล้ว',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteUDetailPage(note: task),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(icon, size: 40),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Last Modified: ${DateFormat('dd MMM yyyy').format(DateTime.parse(task['last_modified']))}",
                          ),
                          Text("Sent For: ${task['sent_for']}"),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: task['status'] == 'Do Now!' ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task['status'],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // ฟังก์ชันแสดง Dialog ให้กรอก "Office Check"
  void _showOfficeCheckDialog(dynamic task) {
    TextEditingController officeCheckController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Office Check'),
          content: TextField(
            controller: officeCheckController,
            decoration: const InputDecoration(
              hintText: 'กรุณากรอก Office Check',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                // เมื่อกด Save
                setState(() {
                  dismissedTasks.add(task); // เพิ่มงานที่ปัดไปใน dismissedTasks
                  doNowTasks.remove(task); // ลบงานจากรายการ
                });
                Navigator.of(context).pop(); // ปิด dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD966),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "THAI DAELY",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("USER", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2101, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                eventLoader: (day) {
                  final dateOnly = DateTime(day.year, day.month, day.day);
                  return _eventsByDate[dateOnly] ?? [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        bottom: 1,
                        child: _buildCircleMarker(events),
                      );
                    }
                    return null;
                  },
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),

              // แสดงงานที่ต้องทำตอนนี้ (Do Now)
              const SizedBox(height: 16),
              const Text(
                "Do Now",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._buildTaskCards(Icons.add_box, doNowTasks),

              // แสดงงานตามเวลา (Work Plan)
              const SizedBox(height: 16),
              const Text(
                "Work Plan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._buildTaskCards(Icons.check_box_outlined, workPlanTasks),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleMarker(List<dynamic> events) {
    Color markerColor = Colors.blue;

    if (events.any((e) => e['status'] == 'Do Now!')) {
      markerColor = Colors.red;
    } else if (events.any((e) => e['status'] == 'Normal')) {
      markerColor = Colors.green;
    }

    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(shape: BoxShape.circle, color: markerColor),
    );
  }
}
