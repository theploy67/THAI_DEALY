import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HomeAPage extends StatefulWidget {
  const HomeAPage({super.key});

  @override
  _HomeAPageState createState() => _HomeAPageState();
}

class _HomeAPageState extends State<HomeAPage> {
  DateTime _selectedDay = DateTime.now();
  List<dynamic> doNowTasks = []; // งานที่ต้องทำในปัจจุบัน (Do Now)
  List<dynamic> workPlanTasks = []; // งานตามเวลา (Work Plan)

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
          // กรองข้อมูลตาม status
          doNowTasks =
              data
                  .where((task) => task['status'] == 'Do Now!')
                  .toList(); // ใช้ 'Do Now!' แทน 'Do Now'
          workPlanTasks =
              data
                  .where((task) => task['status'] == 'Normal')
                  .toList(); // ใช้ 'Normal'
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
    String event = 'No events for this day'; // ตรวจสอบวันที่มีเหตุการณ์หรือไม่

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Event on ${selectedDay.toLocal()}'),
          content: Text(event),
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
              // แสดงปฏิทินและให้เลือกวันที่
              ListTile(
                title: Text(
                  "Selected Date: ${DateFormat('dd MMM yyyy').format(_selectedDay)}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
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

              // Location Section (Showing images)
              const SizedBox(height: 16),
              const Text(
                "Name & Location",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildLocationCard(
                    "โรงพยาบาลสัตว์ PET CASTLE",
                    "assets/images/loca1.png",
                  ),
                  const SizedBox(width: 8),
                  _buildLocationCard(
                    "Andaman International Clinic, Koh Yao Noi",
                    "assets/images/loca2.png",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ฟังก์ชันที่กรอง task ตาม status ที่ให้เลือก (Do Now, Normal)
  List<Widget> _buildTaskCards(IconData icon, List<dynamic> tasks) {
    return tasks.map((task) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: Icon(icon, size: 40),
          title: Text(task['title']), // แสดง title จากข้อมูล
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Last Modified: ${DateFormat('dd MMM yyyy').format(DateTime.parse(task['last_modified']))}",
              ), // แสดง last_modified
              Text("Sent For: ${task['sent_for']}"), // แสดง sent_for
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text("Confirmed"),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      task['status'] == 'Do Now!'
                          ? Colors
                              .red // กำหนดสีแดงถ้าสถานะเป็น Do Now
                          : task['status'] == 'Waiting'
                          ? Colors
                              .orange // สีส้มถ้าสถานะเป็น Waiting
                          : Colors.green, // สีเขียวถ้าสถานะอื่นๆ
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task['status'],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildLocationCard(String name, String imagePath) {
    return Expanded(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath, // ใช้ Image.asset เพื่อแสดงภาพ
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 4),
          Text(name, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
