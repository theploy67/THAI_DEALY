import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchAPage extends StatefulWidget {
  const SearchAPage({super.key});

  @override
  _SearchAPageState createState() => _SearchAPageState();
}

class _SearchAPageState extends State<SearchAPage> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> topPlaces = [
    {
      'name': 'Andaman International Clinic',
      'address':
          'Andaman International Clinic Klong Nin 33-33/1 ตำบล เกาะลันตาใหญ่ อำเภอเกาะลันตา กระบี่ 81150',
      'image': 'loca1.png',
    },
    {
      'name': 'คลินิกแพทย์ศุภฤกษ์',
      'address':
          'แพทย์ศุภฤกษ์ คลินิกกระดูกและข้อ จันทบุรี 226 97 ตำบล ท่าช้าง อ.เมือง จันทบุรี 22000',
      'image': 'loca1.png',
    },
    {
      'name': 'คลินิกสามพัฒนาชุมชน 2 (หมอศศินา)',
      'address':
          '179/45 ถนน เศรษฐกิจ 1, ตำบล ตลาดกระทุ่มแบน, อำเภอกระทุ่มแบน 74110 สมุทรสาคร',
      'image': 'loca1.png',
    },
  ];

  final List<Map<String, String>> accountsPlaces = [
    {
      'name': 'โรงพยาบาลสัตว์ PET CASTLE',
      'address': 'นนทบุรี',
      'image': 'loca1.png',
    },
    {
      'name': 'โรงพยาบาลสัตว์จุฬา',
      'address': 'กรุงเทพฯ',
      'image': 'loca1.png',
    },
  ];

  List<Map<String, String>> tagsPlaces = [];  // เก็บสถานที่ที่เป็นโปรด

  // ใช้ Map ในการเก็บสถานะของหัวใจ
  Map<String, bool> favorites = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDE712C),
        title: const Text("Explore", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 213, 213, 213),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        searchQuery = '';
                        _searchController.clear();
                        FocusScope.of(context).unfocus(); // ปิดคีย์บอร์ดด้วย
                      });
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      indicatorColor: Colors.black,
                      tabs: [
                        Tab(text: 'Top'),
                        Tab(text: 'Accounts'),
                        Tab(text: 'Tags'),
                      ],
                    ),
                    const Gap(5),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildPlaceList(topPlaces, 'Top'),
                          _buildPlaceList([...topPlaces, ...accountsPlaces], 'Accounts'), // รวมทั้ง 'topPlaces' และ 'accountsPlaces'
                          _buildPlaceList(tagsPlaces, 'Tags'),  // แสดงแท็บ Tags
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceList(List<Map<String, String>> places, String tab) {
    final filtered = places
        .where((p) => p['name']!
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final place = filtered[index];
        bool isFavorite = favorites[place['name']] ?? false; // ใช้ค่า favorites สำหรับสถานที่นั้นๆ

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  place['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(place['address']!),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.location_on_outlined),
                      onPressed: () {
                        _openMap(place['address']!);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          if (place['name'] != null) {
                            favorites[place['name']!] =
                                !isFavorite; // เปลี่ยนสถานะของ favorite
                            if (isFavorite) {
                              tagsPlaces.remove(place);  // ลบจาก Tags ถ้าไม่ใช่โปรด
                            } else {
                              tagsPlaces.add(place);  // เพิ่มไปที่ Tags ถ้ากดเป็นโปรด
                            }
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(12)),
                child: Image.asset(
                  'assets/images/${place['image']}',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openMap(String address) async {
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถเปิด Google Maps ได้')),
        );
      }
    }
  }
}
