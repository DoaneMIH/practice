import 'package:flutter/material.dart';

class HomScreen extends StatelessWidget {
  const HomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gesture and Navigation"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("This is supposed to be a Home Screen"),
          const SizedBox(height: 20),
          
          // INSERT CODE BELOW
          TextButton(
            onPressed: () => Navigator.pushNamed(context, 'about'), 
          child: const Text("Go to About Me"))
        ],
      ),
    );
  }
}