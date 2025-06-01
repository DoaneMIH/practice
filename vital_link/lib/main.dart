import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as flutter_services;
import 'package:google_fonts/google_fonts.dart' as google_fonts_services;

import 'Pages/splash_screen.dart';
import 'Utils/routes.dart';

void main() {
  flutter_services.SystemChrome.setSystemUIOverlayStyle(const flutter_services.SystemUiOverlayStyle(
      statusBarColor: Colors.black, statusBarIconBrightness: Brightness.light));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: google_fonts_services.GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const Splash2(),
      routes: MyRoutes.routes,
    );
  }
}
