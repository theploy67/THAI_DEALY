// By Fluke page6 signup_page

import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            // พื้นหลังสีเหลืองด้านล่าง
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF3CC54),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
              ),
            ),

            // เนื้อหาเลื่อนขึ้นได้
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.arrow_back),
                          Text('Sign UP',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ],
                      ),

                      const SizedBox(height: 50),
                      const Text('Sign Up',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Colors.black)),
                      const SizedBox(height: 10),
                      const Text('Please Sign up to continue.',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),

                      const SizedBox(height: 60),

                      // Username
                      _inputField(hint: "Username"),
                      const SizedBox(height: 20),

                      // Email
                      _inputField(hint: "Email"),
                      const SizedBox(height: 20),

                      // Password
                      _inputField(hint: "Password", obscure: true),
                      const SizedBox(height: 20),

                      // Confirm Password
                      _inputField(hint: "Confirm Password", obscure: true),
                      const SizedBox(height: 40),

                      // Sign Up button
                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Register logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Login link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: Navigator.push to LoginPage
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xFF333EB9),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันสร้างช่องกรอกข้อมูลแบบมน
  Widget _inputField({required String hint, bool obscure = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF4EFE9),
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 24),
          hintStyle: const TextStyle(
            color: Color(0xFFA4A4A4),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}
