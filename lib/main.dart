import 'package:flutter/material.dart';
import 'package:unit6_assignment_horlador/screens/about_me.dart';
import 'package:unit6_assignment_horlador/screens/home_screen.dart';

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
      // Create the routes here
      // home: const HomScreen(),
      // home: const About_Me(),
      initialRoute: 'home',
      routes: {
        'home' : (BuildContext ctx) => const HomScreen(),
        'about' : (BuildContext ctx) =>const About_Me(),
      },
    );
  }
}
