import 'package:flutter/material.dart';
import 'package:vital_link_chain/Screens/splash_screen.dart';
import 'package:vital_link_chain/Utility/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Splash2(),
      routes: MyRoutes.routes,
      // home 
    );
  }
}