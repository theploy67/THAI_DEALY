import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeAPage extends StatelessWidget {
  const HomeAPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("THAI DAELY", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("Admin", style: TextStyle(fontSize: 16)),
                ],
              ),
              const Divider(thickness: 1),

              // Calendar
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),

              const SizedBox(height: 16),
              const Text("Do Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildTaskCards(Icons.add_box),

              const SizedBox(height: 16),
              const Text("Work Plan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ..._buildTaskCards(Icons.check_box_outlined),

              const SizedBox(height: 16),
              const Text("Name & Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildLocationCard("โรงพยาบาลสัตว์ PET CASTLE", "assets/images/pet_castle.png"),
                  const SizedBox(width: 8),
                  _buildLocationCard("Andaman International Clinic, Koh Yao Noi", "assets/images/andaman_clinic.png"),
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
          subtitle: const Text("913 13 The Muang, Tha Muang\nDistrict,Kanchanaburi 71110"),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text("Confirmed"),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
            child: Image.asset(imagePath, height: 100, fit: BoxFit.cover),
          ),
          const SizedBox(height: 4),
          Text(name, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
