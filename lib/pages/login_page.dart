import 'dart:math';
import 'package:flutter/material.dart';

PageRouteBuilder _fadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation =
        Tween<double>(begin: -1, end: 1).animate(_shakeController);
  }

  void _login() {
    if (usernameController.text == "admin" &&
        passwordController.text == "1234") {
      // Navigator.of(context).pushReplacement(_fadeRoute(HomeScreen()));
    } else {
      _shakeController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            // พื้นหลังเหลืองโค้งล่าง
            Positioned(
              top: 300,
              left: 0,
              right: 0,
              bottom: 0, // ให้เต็มถึงล่าง
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

            // เนื้อหาทั้งหมดที่ scroll ได้
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height, // ดันความสูงให้พอดีจอ
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Icon(Icons.arrow_back),
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),
                      const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Please login to continue.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),

                      const SizedBox(height: 150),

                      // กล่องสั่น
                      AnimatedBuilder(
                        animation: _shakeController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                                sin(_shakeAnimation.value * pi * 10) * 10, 0),
                            child: child,
                          );
                        },
                        child: Column(
                          children: [
                            // Email field
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4EFE9),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 24),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Password field
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4EFE9),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 24),
                                ),
                              ),
                            ),
                            const SizedBox(height: 60),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 80,
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Sign up link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don’t have an account? ",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: push to SignUpPage
                            },
                            child: const Text(
                              "Sign Up",
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
            ),
          ],
        ),
      ),
    );
  }
}
