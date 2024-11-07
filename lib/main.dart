import 'package:exercisce_unit4/Navigation.dart';
import 'package:exercisce_unit4/techno_searchBar.dart';
import 'package:exercisce_unit4/techno_signUp_validated.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TechnoWorks",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(255, 255, 255, 1)),
        // scaffoldBackgroundColor: const Color.fromRGBO(207, 229, 251, 1.0)
      ),
      initialRoute: 'Homepage',
      routes: {
        '/' : (BuildContext ctx) => const RegistrationTechno(),
        'Homepage': (BuildContext ctx) => const NavigationTechno(),
        'SearchBar' : (BuildContext ctx) => const Searchbar(),
      },

    );
  }
}
