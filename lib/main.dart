import 'package:flutter/material.dart';
import 'package:thai_dealy/widgets/admin_navigation.dart'; // ✅ ใช้ชื่อไฟล์ที่มีคลาส AdminNavigationPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'THAI DAELY',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: AdminNavigationPage(), // ✅ ใช้ชื่อคลาส Widget ของหน้า Navigation
    );
  }
}
