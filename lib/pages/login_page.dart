// By Fluke page5 login_page
// // อันนี้เป็นโค้ด log in page ใน Lab10 นะ 




//// import 'package:flutter/material.dart';
// // import 'home_page.dart';
// import 'dart:math'; 

// PageRouteBuilder _fadeRoute(Widget page) {
//   //Task01
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => page,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       return FadeTransition(opacity: animation, child: child);
//     },
//   );
// }

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
  
//   //Task02
//   late AnimationController _shakeController;
//   late Animation<double> _shakeAnimation; //nimationController ใช้เพื่อควบคุมการสั่น
  

//   @override
//   void initState() {
//     super.initState();
//       //Task02
//     _shakeController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
//     _shakeAnimation = Tween<double>(begin: -1, end: 1).animate(_shakeController); //กำหนดให้ค่าของ _shakeAnimation แกว่งไปมาระหว่าง -1 และ 1
//   }

//   void _login() {
//     if (usernameController.text == "admin" && passwordController.text == "1234") {
//       // Navigator.of(context).pushReplacement(_fadeRoute(HomeScreen()));
     
//     } else {
//       //Task03
//       _shakeController.forward(from: 0);
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         //Task03
//         child: AnimatedBuilder(
//         animation: _shakeController,
//         builder: (context, child) {
//           return Transform.translate(
//             offset: Offset(sin(_shakeAnimation.value * pi * 10) * 10, 0), 
//             child: child,
//           );
//         },

//         child: Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(controller: usernameController, decoration: InputDecoration(labelText: "Username")),
//                 TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
//                 SizedBox(height: 20),
//                 ElevatedButton(onPressed: _login, child: Text("Login")),
//               ],
//             ),
//           ),
//         ),
//       )
//     );
//   }
// }

