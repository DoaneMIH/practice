import 'package:flutter/material.dart';

class TabWidget2 extends StatelessWidget {
  const TabWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.pages),
        SizedBox(height: 20),
        Text("This is another screen"),
      ],
    );
  }
}