import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedTabIndex = 0; // 0: Waiting, 1: Remind, 2: Done

  final List<Map<String, dynamic>> tasks = [
    {'title': 'Discuss budget', 'date': '23 Jan 2025'},
    {'title': 'Ploy proposed moving to the.....', 'date': '23 Jan 2025'},
    {'title': 'Meeting with Ploy next week', 'date': '23 Jan 2025'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6E9),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {},
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        backgroundColor: const Color(0xFFE37222),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.note_add), label: 'Note'),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFFE37222),
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text("All Work", style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),

          // Progress Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Over All",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Text("Work"),
                const SizedBox(height: 10),
                const Text(
                  "80%",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.8,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),

          // Tab Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTabIcon(Icons.warning, 'Waiting', 0),
              _buildTabIcon(Icons.mail, 'Remind', 1),
              _buildTabIcon(Icons.check_box, 'Done', 2),
            ],
          ),

          const SizedBox(height: 10),

          // Task List
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

  Widget _buildTabIcon(IconData icon, String label, int index) {
    final isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Column(
        children: [
          Icon(icon, color: Colors.black),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Container(
              height: 2,
              width: 30,
              margin: const EdgeInsets.only(top: 4),
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              task['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(task['date']),
            trailing: _buildTrailingIcon(),
          ),
        );
      },
    );
  }

  Widget _buildTrailingIcon() {
    switch (selectedTabIndex) {
      case 0:
        return const Icon(Icons.emergency, color: Colors.red, size: 28);
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("Confirmed", style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text("Done", style: TextStyle(fontSize: 12)),
            ),
          ],
        );
      case 2:
        return const Icon(Icons.check, color: Colors.green, size: 28);
      default:
        return const SizedBox();
    }
  }
}
