import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedTabIndex = 0; // 0: Waiting, 1: Remind, 2: Done
  double checklistProgress = 0.0;
  List<dynamic> tasks = []; // รายการงานที่ดึงจาก API
  Map<String, dynamic> weatherData = {}; // ตัวแปรเก็บข้อมูลอากาศ

  @override
  void initState() {
    super.initState();
    fetchTasks(); // ดึงข้อมูลเมื่อเริ่มต้น
    fetchWeather(); // ดึงข้อมูลพยากรณ์อากาศ
  }

  // ฟังก์ชันดึงข้อมูลงานจาก API
  Future<void> fetchTasks() async {
    try {
      final response = await http.get(
        Uri.parse('http://172.20.10.6:3000/notes'), 
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          tasks = data;

          // คำนวณเปอร์เซ็นต์การทำงาน
          final totalTasks = tasks.length;
          final completedTasks = tasks.where((task) => task['checklist'] == true).length;
          checklistProgress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
        });
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // ฟังก์ชันดึงข้อมูลพยากรณ์อากาศจาก WAQI API
Future<void> fetchWeather() async {
  try {
    const String token = '60a27dbd75ae5dcb682f949461d3808e70678e3e'; // ใส่ token ของคุณ
    final city = 'bangkok'; // เมืองที่ต้องการดึงข้อมูล (เช่น กรุงเทพฯ)

    // เพิ่ม timeout ในการร้องขอ API
    final response = await http.get(
      Uri.parse('https://api.waqi.info/feed/$city/?token=$token'),
    ).timeout(const Duration(seconds: 30));  // กำหนดเวลา timeout ให้เป็น 10 วินาที

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        weatherData = data['data']; // เก็บข้อมูลอากาศในตัวแปร
      });
      print('Weather data loaded successfully');
    } else {
      print('Error: ${response.statusCode}');
      print('Error Response: ${response.body}');
      throw Exception('Failed to load weather data');
    }
  } catch (e) {
    // การจัดการข้อผิดพลาด
    if (e is TimeoutException) {
      print('Request Timeout! Please check your internet connection.');
    } else {
      print('Error: $e');
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(
                  "${(checklistProgress * 100).toStringAsFixed(0)}%", // แสดงเปอร์เซ็นต์
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: checklistProgress,
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ),

          // Weather Card (แสดงข้อมูลอากาศ)
          buildWeatherCard(),

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

  // Widget สำหรับแสดงข้อมูลสภาพอากาศ
  Widget buildWeatherCard() {
    return Container(
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
            "Weather Information",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          weatherData.isNotEmpty && weatherData.containsKey('aqi')
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // แสดง AQI
                    Text(
                      'Air Quality Index (AQI): ${weatherData['aqi']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    // แสดงสถานะของอากาศ
                    Text(
                      'Dominant Pollution: ${weatherData['dominentpol'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    // PM2.5 Forecast สำหรับ 3 วันถัดไป
                    if (weatherData['forecast'] != null && weatherData['forecast']['daily'] != null)
                      ...[
                        const Text("PM2.5 Forecast for Next 3 Days:", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("2025-03-23: avg=${weatherData['forecast']['daily']['pm25'][0]['avg']}, min=${weatherData['forecast']['daily']['pm25'][0]['min']}, max=${weatherData['forecast']['daily']['pm25'][0]['max']}"),
                        Text("2025-03-24: avg=${weatherData['forecast']['daily']['pm25'][1]['avg']}, min=${weatherData['forecast']['daily']['pm25'][1]['min']}, max=${weatherData['forecast']['daily']['pm25'][1]['max']}"),
                        Text("2025-03-25: avg=${weatherData['forecast']['daily']['pm25'][2]['avg']}, min=${weatherData['forecast']['daily']['pm25'][2]['min']}, max=${weatherData['forecast']['daily']['pm25'][2]['max']}"),
                      ],
                  ],
                )
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }

  // ฟังก์ชันแสดงแท็บ
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

  // ฟังก์ชันแสดงงานตามสถานะที่เลือก
  Widget _buildTaskList() {
    List<dynamic> filteredTasks = [];
    if (selectedTabIndex == 0) {
      filteredTasks = tasks.where((task) => task['status'] == 'Do Now!').toList();
    } else if (selectedTabIndex == 1) {
      filteredTasks = tasks.where((task) => task['status'] == 'Normal').toList();
    } else if (selectedTabIndex == 2) {
      filteredTasks = tasks.where((task) => task['checklist'] == true).toList();
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              task['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(task['dateline']),
            trailing: _buildTrailingIcon(task),
          ),
        );
      },
    );
  }

  // ฟังก์ชันแสดงไอคอนสำหรับแต่ละสถานะ
  Widget _buildTrailingIcon(Map<String, dynamic> task) {
    if (task['status'] == 'Do Now!') {
      return const Icon(Icons.emergency, color: Colors.red, size: 28);
    } else if (task['status'] == 'Normal') {
      return const Icon(Icons.mail, color: Colors.yellow, size: 28);
    } else {
      return const Icon(Icons.check, color: Colors.green, size: 28);
    }
  }
}
