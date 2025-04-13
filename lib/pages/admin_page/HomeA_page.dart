import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gap/gap.dart';

class HomeAPage extends StatefulWidget {
  const HomeAPage({super.key});

  @override
  _HomeAPageState createState() => _HomeAPageState();
}

class _HomeAPageState extends State<HomeAPage> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, String> events = {
    DateTime.utc(2025, 4, 25): 'Meeting with Ploy - Discuss project details',
    DateTime.utc(2025, 4, 26): 'Budget Review Meeting',
    DateTime.utc(2025, 4, 27): 'Office renovation check',
  };

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
              // Calendar Section
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _selectedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                    });
                    _showEventDialog(
                      selectedDay,
                    ); // เรียกแสดง Popup เมื่อเลือกวันที่
                  },
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),

              // Task Section (Do Now)
              const SizedBox(height: 16),
              const Text(
                "Do Now",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._buildTaskCards(Icons.add_box),

              // Work Plan Section
              const SizedBox(height: 16),
              const Text(
                "Work Plan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ..._buildTaskCards(Icons.check_box_outlined),

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

  List<Widget> _buildTaskCards(IconData icon) {
    final List<Map<String, dynamic>> tasks = [
      {'status': 'Done', 'color': Colors.grey},
      {'status': 'Done', 'color': Colors.green},
      {'status': 'Waiting', 'color': Colors.red},
    ];

    return tasks.map((task) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          leading: Icon(icon, size: 40),
          title: const Text("Do Something"),
          subtitle: const Text(
            "913 13 The Muang, Tha Muang\nDistrict,Kanchanaburi 71110",
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
                  color: task['color'],
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

  // ฟังก์ชันแสดง Popup เมื่อเลือกวัน
  void _showEventDialog(DateTime selectedDay) {
    String event =
        events[selectedDay] ??
        'No events for this day'; // ตรวจสอบวันที่มีเหตุการณ์หรือไม่

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
}
