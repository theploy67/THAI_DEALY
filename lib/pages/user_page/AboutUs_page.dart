import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          //Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 16),
            decoration: const BoxDecoration(color: Color(0xFFF3CC54)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD2B047),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Hind',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  top: 6,
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          //Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),

                  //Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'About ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 29,
                                fontFamily: 'Hind',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'THAI DR',
                              style: TextStyle(
                                color: Color(0xFFD5702B),
                                fontSize: 29,
                                fontFamily: 'Hind',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  //Description
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'ศูนย์รวมเครื่องเอกซเรย์มือสองคุณภาพดี\n'
                      'มีให้ท่านเลือกหลายยี่ห้อ หลายขนาด 100-200-300 mA\n'
                      'เป็นผลิตภัณฑ์จากเอเชีย และยุโรป สำหรับคลินิกทั่วไป\n'
                      'คลินิกสัตว์ และโรงพยาบาลสัตว์\n'
                      'เครื่องเอกซเรย์ทุกเครื่อง เราปรับปรุงสภาพใหม่ทั้งหมด\n'
                      'พร้อมรับประกันอะไหล่ทุกชิ้น 1 ปี\n'
                      'และมีทีมช่างดูแลตลอดการใช้งาน',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'เน้นใช้งานง่าย ไม่ซ้ำซ้อน ลดต้นทุนการนำเข้า\n'
                      'ใช้ได้ทั้งคลินิกคนและสัตว์\n'
                      'เรามีทีมช่างเอกซเรย์ประสบการณ์กว่าสามสิบปี\n'
                      'รวมทั้งนักรังสีและวิศวกรซอฟแวร์พร้อมให้บริการและปรึกษา',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //X-ray image
                  Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      'assets/images/room.png',
                      width: double.infinity,
                      height: 230,
                      fit: BoxFit.cover,
                    ),
                  ),

                  //Contact Section
                  Container(
                    color: const Color(0xFFFEF3D7),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Stack รูปทีมแนวตั้ง
                        SizedBox(
                          width: 120,
                          height: 280,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                child: _teamPhoto('assets/images/m1.jpg'),
                              ),
                              Positioned(
                                top: 90,
                                left: 10,
                                child: _teamPhoto('assets/images/m2.jpg'),
                              ),
                              Positioned(
                                top: 180,
                                left: 20,
                                child: _teamPhoto('assets/images/g1.jpg'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 24),

                        //QR Code & Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Contact Us',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Hind',
                                  color: Color(0xFF443838),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/qr.png',
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Widget สำหรับรูปโปรไฟล์
  Widget _teamPhoto(String path) {
    return Container(
      width: 85,
      height: 85,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
    );
  }
}
