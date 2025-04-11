// By Fluke page3 AboutUs_page
// หน้านี้ใส่ข้อความไว้หมดแล้ว เหลือรูป
// สิ่งที่ต้องแก้ : เพิ่มรูป

import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD966),
        title: const Text("About Us"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // About Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[100], // พื้นหลังสำหรับ About
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'About\nTHAI DR\n\n'
                  'ศูนย์รวมเครื่องเอกซเรย์ดิจิตอลคุณภาพดี\n'
                  'มีให้เลือกหลายรุ่น หลายขนาด 100-200-300 mA\n'
                  'เป็นผลิตภัณฑ์จากต่างประเทศ และยุโรป สำหรับเครื่องที่มีขนาดเล็กที่สุด\n'
                  'และเครื่องเอกซเรย์ เครื่องเอกซเรย์เคลื่อนที่ (Mobile X-ray)\n'
                  'เราปรับปรุงอุปกรณ์ใหม่ทั้งหมดยกชุด พร้อมปรับอุปกรณ์ให้ทันสมัยภายใน 1 ปี\n'
                  'และมีทีมงานดูแลตลอดการใช้งาน\n\n'
                  'นำเข้าใช้งาน ไม่จำกัดชั่วโมงการใช้งาน'
                  'ใช้เทคโนโลยีดีฟ และสตีม',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 30),

              // Contact Section
              const Text(
                "Contact Us",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Contact Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/person_1.jpg'),
                    radius: 30,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/person_2.jpg'),
                    radius: 30,
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/person_3.jpg'),
                    radius: 30,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // QR Code
              const Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/qr_code.png'),
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: Color(0xFFFFD966),
        child: const Text(
          "For more info, visit our website!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}
