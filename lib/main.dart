import 'package:flutter/material.dart';
import 'package:thai_dealy/widgets/admin_navigation.dart'; // ใช้ชื่อไฟล์ที่มีคลาส AdminNavigationPage
import 'package:thai_dealy/widgets/user_navigation.dart';
import 'package:thai_dealy/pages/user_page/All_NoteU_page.dart';
import 'package:thai_dealy/pages/welcome_page.dart';
import 'package:thai_dealy/pages/homesreen_page.dart';
import 'package:thai_dealy/pages/login_page.dart';
import 'package:thai_dealy/pages/signup_page.dart';

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
      // กำหนดหน้าเริ่มต้นเป็น AdminNavigationPage
      //home: AdminNavigationPage(), // หากต้องการให้เริ่มที่หน้า Admin
      // หรือหากต้องการให้เป็น UserNavigationPage ให้ใช้:
      //home: const UserNavigationPage(),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomeScreen(),
        '/homeU': (context) => UserNavigationPage(),
      },
    );
  }
}
