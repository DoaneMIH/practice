// import 'dart:convert';

// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:medical_records_web_application/screens/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginSignupPage extends StatefulWidget {
//   const LoginSignupPage({super.key});

//   @override
//   _LoginSignupPageState createState() => _LoginSignupPageState();
// }

// class _LoginSignupPageState extends State<LoginSignupPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isSignup = false;
//   String _message = '';

//   Future<void> _signup() async {
//     final prefs = await SharedPreferences.getInstance();
//     final hashedPassword = sha256.convert(utf8.encode(_passwordController.text)).toString();
//     await prefs.setString(_usernameController.text, hashedPassword);
//     setState(() {
//       _message = 'Signup successful. Please log in.';
//     });
//     _isSignup = false;
//   }

//   Future<void> _login() async {
//     final prefs = await SharedPreferences.getInstance();
//     final hashedPassword = sha256.convert(utf8.encode(_passwordController.text)).toString();
//     final storedPassword = prefs.getString(_usernameController.text);

//     if (storedPassword == hashedPassword) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => MyHomePage(privateKey: _usernameController.text)),
//       );
//     } else {
//       setState(() {
//         _message = 'Invalid username or password.';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isSignup ? 'Signup' : 'Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             ElevatedButton(
//               onPressed: _isSignup ? _signup : _login,
//               child: Text(_isSignup ? 'Signup' : 'Login'),
//             ),
//             Text(_message),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _isSignup = !_isSignup;
//                   _message = '';
//                 });
//               },
//               child: Text(_isSignup ? 'Already have an account? Login' : 'Create an account'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/login_signup_page.dart
// import 'package:flutter/material.dart';
// import 'package:medical_records_web_application/screens/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginSignupPage extends StatefulWidget {
//   @override
//   _LoginSignupPageState createState() => _LoginSignupPageState();
// }

// class _LoginSignupPageState extends State<LoginSignupPage> {
//   final TextEditingController _privateKeyController = TextEditingController();
//   String _message = '';
//   bool _isSignup = false;

//   Future<void> _login() async {
//     try {
//       if (_privateKeyController.text.length != 66) {
//         setState(() {
//           _message = 'Invalid private key.';
//         });
//         return;
//       }
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => MyHomePage(privateKey: _privateKeyController.text)),
//       );
//     } catch (e) {
//       setState(() {
//         _message = 'Invalid private key: $e';
//       });
//     }
//   }

//   Future<void> _signup() async {
//     try {
//       if (_privateKeyController.text.length != 66) {
//         setState(() {
//           _message = 'Invalid private key.';
//         });
//         return;
//       }
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(_privateKeyController.text, _privateKeyController.text); //Store private key
//       setState(() {
//         _message = 'Signup successful. Please log in.';
//       });
//       _isSignup = false;
//     } catch (e) {
//       setState(() {
//         _message = 'Signup failed: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isSignup ? 'Signup' : 'Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             TextField(
//               controller: _privateKeyController,
//               decoration: InputDecoration(labelText: 'Private Key (Ganache)'),
//             ),
//             ElevatedButton(
//               onPressed: _isSignup ? _signup : _login,
//               child: Text(_isSignup ? 'Signup' : 'Login'),
//             ),
//             Text(_message),
//             TextButton(
//               onPressed: () {
//                 setState(() {
//                   _isSignup = !_isSignup;
//                   _message = '';
//                 });
//               },
//               child: Text(_isSignup ? 'Already have an account? Login' : 'Create an account'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// lib/login_signup_page.dart
// lib/login_signup_page.dart
import 'package:flutter/material.dart';
import 'package:medical_records_web_application/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Role { None, Patient, Doctor, Admin } // Ensure this matches home_page.dart

class LoginSignupPage extends StatefulWidget {
  @override
  _LoginSignupPageState createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final TextEditingController _privateKeyController = TextEditingController();
  final TextEditingController _roleController = TextEditingController(); // Add role controller
  String _message = '';
  bool _isSignup = false;

  Future<void> _login() async {
    try {
      if (_privateKeyController.text.length != 66) {
        setState(() {
          _message = 'Invalid private key.';
        });
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(privateKey: _privateKeyController.text)),
      );
    } catch (e) {
      setState(() {
        _message = 'Invalid private key: $e';
      });
    }
  }

  Future<void> _signup() async {
    try {
      if (_privateKeyController.text.length != 66) {
        setState(() {
          _message = 'Invalid private key.';
        });
        return;
      }

      final roleInt = int.tryParse(_roleController.text);
      if (roleInt == null || roleInt < 1 || roleInt > 3) {
        setState(() {
          _message = 'Invalid role. Role must be 1, 2, or 3.';
        });
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_privateKeyController.text, _privateKeyController.text); // Store private key
      await prefs.setInt('${_privateKeyController.text}_role', roleInt); // Store role

      setState(() {
        _message = 'Signup successful. Please log in.';
      });
      _isSignup = false;
    } catch (e) {
      setState(() {
        _message = 'Signup failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignup ? 'Signup' : 'Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _privateKeyController,
              decoration: InputDecoration(labelText: 'Private Key (Ganache)'),
            ),
            if (_isSignup) // Only show role field during signup
              TextField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role (1: Patient, 2: Doctor, 3: Admin)'),
                keyboardType: TextInputType.number, // Restrict to numbers
              ),
            ElevatedButton(
              onPressed: _isSignup ? _signup : _login,
              child: Text(_isSignup ? 'Signup' : 'Login'),
            ),
            Text(_message),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignup = !_isSignup;
                  _message = '';
                });
              },
              child: Text(_isSignup ? 'Already have an account? Login' : 'Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}