import 'package:flutter/material.dart';
import 'package:thai_dealy/widgets/admin_navigation.dart'; // ✅ ใช้ชื่อไฟล์ที่มีคลาส AdminNavigationPage
import 'package:thai_dealy/widgets/user_navigation.dart';
import 'package:thai_dealy/pages/user_page/All_NoteU_page.dart';

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
       //home: AdminNavigationPage(), // ✅ ใช้ชื่อคลาส Widget ของหน้า Navigation Admin
        home: UserNavigationPage(),  // ✅ ใช้ชื่อคลาส Widget ของหน้า Navigation User
    );
  }
}
