// 📁 lib/widgets/user_navigation.dart
import 'package:flutter/material.dart';
import 'package:thai_dealy/pages/user_page/HomeU_page.dart';
// import other user pages if available

class UserNavigationPage extends StatefulWidget {
  @override
  _UserNavigationPageState createState() => _UserNavigationPageState();
}

class _UserNavigationPageState extends State<UserNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeUPage(),
    // const UserSearchPage(),
    // const UserNotePage(),
    // const UserDashboardPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _labels = ['Home', 'Search', 'Note', 'Dashboard'];
  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.note_add,
    Icons.dashboard_customize
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
              onTap: () => _onItemTapped(index),
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
                      _icons[index],
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