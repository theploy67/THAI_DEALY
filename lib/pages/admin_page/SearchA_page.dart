// By Fluke page1
// หน้านี้มี Tab bar ด้านบนไว้้หมดแล้ว (สำหรับ Top, Accounts, Tags)
// สิ่งที่ต้องแก้ : ตอนนี้ยังบัคอยู่ ยังไม่ได้แก้

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchAPage extends StatefulWidget {
  const SearchAPage({super.key});

  @override
  _SearchAPageState createState() => _SearchAPageState();
}

class _SearchAPageState extends State<SearchAPage> {
  String searchQuery = ''; // ตัวแปรสำหรับการค้นหา

  // รายการของสถานที่ (สำหรับ Top, Accounts, Tags)
  final List<Map<String, String>> topPlaces = [
    {
      'name': 'Andaman International Clinic',
      'address': '51 18, Ko Yao Noi, Ko Yao District, Phang Nga 82160',
      'image': 'andaman_clinic.jpg',
    },
    {
      'name': 'คลินิกแพทย์ศุภฤกษ์',
      'address': '913 13 The Muang, Tha Muang District, Kanchanaburi 71110',
      'image': 'clinic.jpg',
    },
    {
      'name': 'คลินิกสามพัฒนาชุมชน 2 (หมอศศินา)',
      'address': '179/45 ถนน เสรีพัฒนา 1 ตำบล ตลาดกระทุ่มแบน',
      'image': 'clinic_2.jpg',
    },
    // เพิ่มรายการที่ต้องการ
  ];

  final List<Map<String, String>> accountsPlaces = [
    {
      'name': 'Andaman International Clinic',
      'address': '51 18, Ko Yao Noi, Ko Yao District, Phang Nga 82160',
      'image': 'andaman_clinic.jpg',
    },
    {
      'name': 'คลินิกแพทย์ศุภฤกษ์',
      'address': '913 13 The Muang, Tha Muang District, Kanchanaburi 71110',
      'image': 'clinic.jpg',
    },
    {
      'name': 'โรงพยาบาลสัตว์ PET CASTLE',
      'address': 'ถนนราชวิถี (ตรงข้ามเซ็นทรัลรัตนาธิเบศร์)',
      'image': 'pet_castle.jpg',
    },
    // เพิ่มรายการที่ต้องการ
  ];

  final List<Map<String, String>> tagsPlaces = [
    {
      'name': 'คลินิกสัตวแพทย์',
      'address': '111/12 ซอยสามัคคี 8 หมู่ 10 ถนนสุขสวัสดิ์',
      'image': 'clinic_tags.jpg',
    },
    {
      'name': 'โรงพยาบาลสัตว์จุฬา',
      'address': '26 ถนนจุฬา, แขวงวังใหม่, กรุงเทพ',
      'image': 'chula_hospital.jpg',
    },
    {
      'name': 'คลินิกสัตว์เจริญวัฒนา',
      'address': '29/4 ถนนจรัญสนิทวงศ์, กรุงเทพ',
      'image': 'clinic_wattana.jpg',
    },
    // เพิ่มรายการที่ต้องการ
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Explore"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // กลับไปหน้าก่อนหน้า
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ช่องค้นหาข้อมูล
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const Gap(10),
            // TabBar สำหรับการแยกหมวดหมู่
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Top'),
                      Tab(text: 'Accounts'),
                      Tab(text: 'Tags'),
                    ],
                  ),
                  SizedBox(
                    height: 400, // แสดงพื้นที่สำหรับเนื้อหาของแต่ละแท็บ
                    child: TabBarView(
                      children: [
                        // **Top** Tab
                        _buildPlaceList(topPlaces),
                        // **Accounts** Tab
                        _buildPlaceList(accountsPlaces),
                        // **Tags** Tab
                        _buildPlaceList(tagsPlaces),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceList(List<Map<String, String>> places) {
    // กรองข้อมูลที่ตรงกับคำค้น
    final filteredPlaces =
        places
            .where(
              (place) => place['name']!.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();

    return ListView.builder(
      itemCount: filteredPlaces.length,
      itemBuilder: (context, index) {
        final place = filteredPlaces[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Image.asset(
              'lib/widgets/picture/${place['image']}', // ใส่เส้นทางของภาพที่ถูกต้อง
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(place['name']!),
            subtitle: Text(place['address']!),
            trailing: IconButton(
              icon: const Icon(Icons.location_on),
              onPressed: () {
                // การดำเนินการเมื่อกดไอคอนตำแหน่ง
              },
            ),
          ),
        );
      },
    );
  }
}
