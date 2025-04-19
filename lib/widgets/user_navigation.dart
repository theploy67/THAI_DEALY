import 'package:flutter/material.dart';
import 'package:thai_dealy/pages/user_page/HomeU_page.dart'; // หน้า Home
import 'package:thai_dealy/pages/user_page/All_NoteU_page.dart'; // หน้า All Note
import 'package:thai_dealy/pages/user_page/SearchU_page.dart'; // หน้า Search
import 'package:thai_dealy/pages/user_page/AboutUs_page.dart'; // หน้า About Us

class UserNavigationPage extends StatefulWidget {
  @override
  _UserNavigationPageState createState() => _UserNavigationPageState();
}

class _UserNavigationPageState extends State<UserNavigationPage> {
  int _selectedIndex = 0;

  // เพิ่มหน้า SearchU_page และ AboutUs_page
  final List<Widget> _pages = [
    const HomeUPage(), // หน้าแรก
    const SearchUPage(), // หน้า Search
    const AllNoteUPage(), // หน้า All Note
    const AboutUsPage(), // หน้า About Us
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _labels = ['Home', 'Search', 'Note', 'About us'];
  final List<IconData> _icons = [
    Icons.home, // ไอคอน Home
    Icons.search, // ไอคอน Search
    Icons.note_add, // ไอคอน Note
    Icons.account_circle, // ไอคอน About Us
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // แสดงหน้าใหม่ตาม index
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Color(0xFFFFD966), // สีเหลืองสำหรับ User
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(_icons.length, (index) {
            final isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () => _onItemTapped(index), // เมื่อกดให้เปลี่ยนหน้า
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
                          isSelected ? FontWeight.bold : FontWeight.normal,
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
