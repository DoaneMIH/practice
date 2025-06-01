// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key, required this.title});
//   final String title;

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//     final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController specializationController = TextEditingController();
//   String selectedRole = 'patient';
//   final String baseUrl = "http://localhost:8080/signup";

//   Future<void> signup() async {
//     String url = "$baseUrl/$selectedRole";
//     Map<String, dynamic> userData = {
//       "name": nameController.text,
//       "email": emailController.text,
//       "password": passwordController.text,
//       "role": selectedRole,
//     };
    
//     if (selectedRole == "doctor") {
//       userData["specialization"] = specializationController.text;
//     }

//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(userData),
//       );
      
//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signup successful!")));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${response.body}")));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error connecting to server")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
//             TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
//             TextField(controller: passwordController, decoration: const InputDecoration(labelText: "Password"), obscureText: true),
//             DropdownButton<String>(
//               value: selectedRole,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   selectedRole = newValue!;
//                 });
//               },
//               items: ["patient", "doctor"].map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value.toUpperCase()),
//                 );
//               }).toList(),
//             ),
//             if (selectedRole == "doctor")
//               TextField(controller: specializationController, decoration: const InputDecoration(labelText: "Specialization")),
//               const SizedBox(height: 20),
//               ElevatedButton(onPressed: signup, child: const Text("Signup"))
//           ],
//         ),
//       ),
//     );
//   }
// }