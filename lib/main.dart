import 'package:exercise_4/techno_logIn_validation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: logIn(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _logIn() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      print('Email: $email');
      print('Password: $password');

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login'),
            content: Text('Login Successful!\nEmail: $email'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(253, 253, 253, 1),
                Color.fromARGB(255, 172, 201, 255),
              ],
              stops: [0.04, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 120,
          child: Container(
            width: 196,
            height: 276,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/TechnoDeskWorks.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Positioned(
          top: 350,
          left: 60,
          child: Text(
            'Login to your account',
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 9, 110, 188),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: 400,
          left: 60,
          child: Container(
            width: 290,
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(1, 3),
                  blurRadius: 4,
                  spreadRadius: 0.23,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 470,
          left: 60,
          child: Container(
            width: 290,
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(1, 3),
                  blurRadius: 4,
                  spreadRadius: 0.23,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 170, 0),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 540,
          left: 60,
          child: GestureDetector(
            onTap: _logIn,
            child: Container(
              width: 290,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 250, 230, 194),
                    Color.fromARGB(255, 232, 162, 13),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: Offset(1, 3),
                    blurRadius: 4,
                    spreadRadius: 0.23,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'Log in',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
            top: 650,
            left: 60,
            child: Container(
              height: 1,
              width: 80,
              color: Color.fromRGBO(57, 105, 144, 1),
            )),
        Positioned(
            top: 650,
            left: 270,
            child: Container(
              height: 1,
              width: 80,
              color: Color.fromRGBO(57, 105, 144, 1),
            )),
        Positioned(
            top: 640,
            left: 160,
            child: Center(
                child: Text('or Login with',
                    style: TextStyle(
                      color: Color.fromRGBO(57, 105, 144, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )))),
        Positioned(
          top: 675,
          left: 80,
          child: GestureDetector(
            onTap: () {
              print('Google icon clicked');
            },
            child: Container(
              width: 86,
              height: 44,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/ggl.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 675,
          left: 170,
          child: GestureDetector(
            onTap: () {
              print('Facebook icon clicked');
            },
            child: Container(
              width: 86,
              height: 44,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/fb.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 675,
          left: 260,
          child: GestureDetector(
            onTap: () {
              print('LinkedIn icon clicked');
            },
            child: Container(
              width: 86,
              height: 44,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/lnk.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter, 
          child: Container(
            width: 400,
            height: 80,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: Offset(1, 3),
                  blurRadius: 4,
                  spreadRadius: 0.23,
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account? ",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                            color: Color.fromRGBO(57, 105, 144, 1),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    )
    );
  }
}
