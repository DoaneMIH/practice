// main.dart
import 'package:flutter/material.dart';
import 'package:medical_records_web_application/screens/login_signup.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Records',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginSignupPage(), // Start with the LoginSignupPage
    );
  }
}

