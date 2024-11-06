import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('assets/image/photo.png'),
          const Text("PERSONAL INFORMATION"),
          TextField(
            decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Input your email',
                icon: Icon(
                  Icons.person_2,
                  color: Colors.deepPurple[200],
                  size: 80,
                )),
          ),
          const Text('\n'),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Input your Password',
                icon: Icon(
                  Icons.key,
                  color: Colors.deepPurple[200],
                  size: 80,
                )),
          ),
          const Text('\n'),
          RadioListTile(
              title: const Text("Female"),
              value: "female",
              groupValue: "female",
              onChanged: (value) {}),
          RadioListTile(
              title: const Text("Male"),
              value: "male",
              groupValue: "male",
              onChanged: (value) {}),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(150, 50),
              backgroundColor: Colors.deepPurple[200],
            ),
            child: const Text("Sumbit"),
          ),
        ],
      ),
    );
  }
}
