import 'package:flutter/material.dart';
import 'package:thai_dealy/pages/admin_page/HomeA_page.dart'; // หน้า Home
import 'package:thai_dealy/pages/admin_page/SearchA_page.dart'; // หน้า Search
import 'package:thai_dealy/pages/admin_page/All_NoteA_page.dart'; // หน้า All Note
import 'package:thai_dealy/pages/admin_page/Dashboard_Page.dart'; // หน้า Dashboard
import 'package:thai_dealy/pages/admin_page/NoteA_Detail_page.dart'; // หน้า NoteA_Detail_page

class AdminNavigationPage extends StatefulWidget {
  @override
  _AdminNavigationPageState createState() => _AdminNavigationPageState();
}

class _AdminNavigationPageState extends State<AdminNavigationPage> {
  int _selectedIndex = 0; // ค่าเริ่มต้นให้เลือกหน้าแรก (Home)

  // เพิ่มหน้าใหม่เข้าไปใน _pages[] ทั้ง Search, Dashboard และ NoteA_Detail
  final List<Widget> _pages = [
    const HomeAPage(), // หน้า Home
    const SearchAPage(), // หน้า Search
    const AllNoteAPage(), // หน้า All Note
    // const DashboardPage(),   // หน้า Dashboard
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // เปลี่ยนหน้าตามที่เลือกใน BottomNavigationBar
    });
  }

  final List<String> _labels = ['Home', 'Search', 'Note', 'Dashboard'];
  final List<IconData> _icons = [
    Icons.home, // ไอคอน Home
    Icons.search, // ไอคอน Search
    Icons.note_add, // ไอคอน Note
    Icons.dashboard_customize, // ไอคอน Dashboard
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // แสดงหน้าใหม่ตาม index ที่เลือก
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0xFFDE712C), // สีส้มสำหรับ Admin
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_icons.length, (index) {
            final isSelected =
                _selectedIndex == index; // เช็คว่าไอคอนถูกเลือกหรือไม่
            return GestureDetector(
              onTap: () {
                if (index == 2) {
                  // ถ้ากดไอคอน Note
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              const AllNoteAPage(), // ไปยังหน้า AllNoteAPage
                    ),
                  );
                } else {
                  _onItemTapped(
                    index,
                  ); // เปลี่ยนหน้าตามที่เลือกใน BottomNavigationBar
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _icons[index], // ไอคอนที่เลือก
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _labels[index],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight:
                          isSelected
                              ? FontWeight.bold
                              : FontWeight
                                  .normal, // เปลี่ยนความเข้มของฟอนต์เมื่อเลือก
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
