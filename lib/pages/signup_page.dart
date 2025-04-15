import 'package:flutter/material.dart';
import 'package:thai_dealy/pages/animated_button.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.arrow_back),
                      Text('Sign UP',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
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
                  _inputField(hint: "Username"),
                  const SizedBox(height: 20),
                  _inputField(hint: "Email"),
                  const SizedBox(height: 20),
                  _inputField(hint: "Password", obscure: true),
                  const SizedBox(height: 20),
                  _inputField(hint: "Confirm Password", obscure: true),
                  const SizedBox(height: 40),
                  AnimatedButton(
                      text: 'Sign Up',
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      isDark: true),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ",
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login'),
                        child: const Text("Login",
                            style: TextStyle(
                                color: Color(0xFF333EB9),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

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
