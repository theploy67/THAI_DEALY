// By Fluke page3 SearchU_page
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchUPage extends StatefulWidget {
  const SearchUPage({super.key});

  @override
  _SearchUPageState createState() => _SearchUPageState();
}

class _SearchUPageState extends State<SearchUPage> {
  String searchQuery = '';

  final List<Map<String, String>> topPlaces = [
    {
      'name': 'Andaman International Clinic',
      'address': '51 18, Ko Yao Noi, Ko Yao District, Phang Nga 82160',
      'image': 'loca1.png',
    },
    {
      'name': 'คลินิกแพทย์ศุภฤกษ์',
      'address': '913 13 The Muang, Tha Muang District, Kanchanaburi 71110',
      'image': 'loca1.png',
    },
    {
      'name': 'คลินิกสามพัฒนาชุมชน 2 (หมอศศินา)',
      'address': '179/45 ถนน เสรีพัฒนา 1 ตำบล ตลาดกระทุ่มแบน',
      'image': 'loca1.png',
    },
  ];

  final List<Map<String, String>> accountsPlaces = [
    {
      'name': 'Andaman International Clinic',
      'address': '51 18, Ko Yao Noi, Ko Yao District, Phang Nga 82160',
      'image': 'loca1.png',
    },
    {
      'name': 'คลินิกแพทย์ศุภฤกษ์',
      'address': '913 13 The Muang, Tha Muang District, Kanchanaburi 71110',
      'image': 'loca1.png',
    },
    {
      'name': 'โรงพยาบาลสัตว์ PET CASTLE',
      'address': 'ถนนราชวิถี (ตรงข้ามเซ็นทรัลรัตนาธิเบศร์)',
      'image': 'loca1.png',
    },
  ];

  final List<Map<String, String>> tagsPlaces = [
    {
      'name': 'คลินิกสัตวแพทย์',
      'address': '111/12 ซอยสามัคคี 8 หมู่ 10 ถนนสุขสวัสดิ์',
      'image': 'loca1.png',
    },
    {
      'name': 'โรงพยาบาลสัตว์จุฬา',
      'address': '26 ถนนจุฬา, แขวงวังใหม่, กรุงเทพ',
      'image': 'loca1.png',
    },
    {
      'name': 'คลินิกสัตว์เจริญวัฒนา',
      'address': '29/4 ถนนจรัญสนิทวงศ์, กรุงเทพ',
      'image': 'loca1.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD966),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Explore", style: TextStyle(color: Colors.black)),
        centerTitle: true,
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
                          _buildPlaceList(topPlaces),
                          _buildPlaceList(accountsPlaces),
                          _buildPlaceList(tagsPlaces),
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

  Widget _buildPlaceList(List<Map<String, String>> places) {
    final filtered = places
        .where((p) => p['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final place = filtered[index];
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
                trailing: IconButton(
                  icon: const Icon(Icons.location_on_outlined),
                  onPressed: () {},
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
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
}
