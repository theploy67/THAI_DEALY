import 'package:flutter/material.dart'; 
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:thai_dealy/pages/admin_page/NoteA_Detail_page.dart';

class HomeAPage extends StatefulWidget {
  const HomeAPage({super.key});

  @override
  _HomeAPageState createState() => _HomeAPageState();
}

class _HomeAPageState extends State<HomeAPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<dynamic> doNowTasks = []; // งานที่ต้องทำในปัจจุบัน (Do Now)
  List<dynamic> workPlanTasks = []; // งานตามเวลา (Work Plan)
  Map<DateTime, List<dynamic>> _eventsByDate = {};
  List<dynamic> dismissedTasks = []; // เก็บงานที่ถูกปัดออก (แค่หายไปในหน้า Home)

  @override
  void initState() {
    super.initState();
    dismissedTasks.clear(); // เคลียร์ dismissedTasks เมื่อหน้า Home ถูกโหลดใหม่
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
          // กรองงานที่ถูกปัดออกจาก UI
          doNowTasks = data
              .where((task) =>
                  task['status'] == 'Do Now!' && !dismissedTasks.contains(task))
              .toList();
          workPlanTasks = data
              .where((task) =>
                  task['status'] == 'Normal' && !dismissedTasks.contains(task))
              .toList();

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

  // ฟังก์ชันแสดง Popup เมื่อเลือกวัน
  void _showEventDialog(DateTime selectedDay) {
    final dateOnly = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );
    final events = _eventsByDate[dateOnly] ?? []; // ดึงเหตุการณ์จากวันที่เลือก

    // เรียงงานตามวันที่ที่มีลำดับจากแรกสุด
    events.sort((a, b) {
      final dateA = DateTime.parse(a['dateline'] ?? '2000-01-01');
      final dateB = DateTime.parse(b['dateline'] ?? '2000-01-01');
      return dateA.compareTo(dateB); // เรียงงานจากวันที่น้อยไปหามาก
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Tasks on ${DateFormat('dd MMM yyyy').format(selectedDay)}', // แสดงหัวข้อเป็นวันที่
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
          ),
          content:
              events.isEmpty
                  ? const Text('No tasks found for this day')
                  : SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          events.map<Widget>((task) {
                            final taskDate = DateTime.parse(
                              task['dateline'] ?? '2000-01-01',
                            );
                            final taskTitle = task['title'] ?? 'No Title';
                            final taskSendFor = task['send_for'] ?? 'everyone';
                            final taskDescription =
                                task['description'] ?? 'No work';
                            final taskStatus = task['status'] ?? 'Normal';
                            final taskCategory =
                                task['category'] ?? 'ติดตั้งเครื่อง';

                            // กำหนดสีหรือเงื่อนไขของงานในแต่ละงาน เช่น งานด่วน
                            Color cardColor;
                            if (taskDate.isBefore(
                              DateTime.now().add(Duration(days: 1)),
                            )) {
                              cardColor =
                                  Colors.red[100]!; // งานที่ต้องทำภายใน 1 วัน
                            } else if (taskDate.isBefore(
                              DateTime.now().add(Duration(days: 7)),
                            )) {
                              cardColor =
                                  Colors.yellow[100]!; // งานภายใน 1 สัปดาห์
                            } else {
                              cardColor =
                                  Colors.green[100]!; // งานที่ไม่เร่งด่วน
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Card(
                                color: cardColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Title: $taskTitle',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Dateline: ${DateFormat('dd MMM yyyy').format(taskDate)}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Send For: $taskSendFor',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Description: $taskDescription',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Status: $taskStatus',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      'Category: $taskCategory',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
          actions: <Widget>[ 
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันเลือกวันที่จากปฏิทิน
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = picked;
        fetchTasks(); // ดึงข้อมูลใหม่ที่ตรงกับวันที่เลือก
      });
    }
  }

  // ฟังก์ชันที่กรอง task ตาม status ที่ให้เลือก (Do Now, Normal)
  List<Widget> _buildTaskCards(IconData icon, List<dynamic> tasks) {
    return tasks.map((task) {
      return Dismissible(
        key: Key(task['id'].toString()), // ใช้ id เป็น key
        onDismissed: (direction) {
          setState(() {
            dismissedTasks.add(task); // เพิ่มงานที่ถูกปัดออกใน dismissedTasks
            doNowTasks.remove(task); // ลบงานจากรายการในหน้า Home
          });
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
                        builder: (context) => NoteADetailPage(note: task),
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDE712C),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "THAI DAELY",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("Admin", style: TextStyle(fontSize: 16)),
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
                  _showEventDialog(selectedDay);
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
              const SizedBox(height: 16),
              const Text(
                "Do Now",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._buildTaskCards(Icons.add_box, doNowTasks),
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
