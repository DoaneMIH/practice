import 'package:flutter/material.dart';

class TabWidget1 extends StatelessWidget {
  const TabWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.contacts),
        SizedBox(height: 20),
        Text("Contacts Screen!"),
      ],
    );
  }
}