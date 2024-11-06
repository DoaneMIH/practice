import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';
import 'techno_logIn_validation.dart';

class RegistrationTechno extends StatefulWidget {
  const RegistrationTechno({super.key});

  @override
  State<RegistrationTechno> createState() => _RegistrationTechnoState();
}

class _RegistrationTechnoState extends State<RegistrationTechno> {
final _formfield = GlobalKey<FormState>();
final emailController = TextEditingController();
final passController = TextEditingController();
final passConfirmController = TextEditingController();
final nameController = TextEditingController();
final TapGestureRecognizer _logInRecognizer = TapGestureRecognizer();
bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(207, 229, 251, 1.0)
              ])),
          child: Form(
            key: _formfield,
            child: Center(
                child: Column(
              children: <Widget>[
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('images/TechnoDeskWorks.png'),
                ),
                Container(
                  width: 330,
                  alignment: Alignment.centerLeft,
                  child: const Text("Register Form",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(9, 110, 188, 1),
                      )),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(114, 0, 0, 0),
                          spreadRadius: 1,
                          blurRadius: 2,
                          blurStyle: BlurStyle.normal,
                        )
                      ]),
                  width: 300,
                  child: TextFormField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Full name',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.circle_rounded,
                          color: Color.fromRGBO(21, 131, 220, 1.0),
                        ),
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please enter your full name";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(114, 0, 0, 0),
                          spreadRadius: 1,
                          blurRadius: 2,
                          blurStyle: BlurStyle.normal,
                        )
                      ]),
                  width: 300,
                  child: TextFormField(
                    controller: emailController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Email',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.circle_rounded,
                          color: Color.fromRGBO(244, 166, 50, 1.0),
                        ),
                      ),
                    ),
                    validator: (value){
                      bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                      if(value.isEmpty){
                        return "Enter Email";
                      } else if(!emailValid){
                        return "Please enter valid email";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(114, 0, 0, 0),
                          spreadRadius: 1,
                          blurRadius: 2,
                          blurStyle: BlurStyle.normal,
                        )
                      ]),
                  width: 300,
                  child: TextFormField(
                    controller: passController,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Password',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.circle_rounded,
                          color: Color.fromRGBO(21, 131, 220, 1.0),
                        ),
                      ),
                    ),
                    validator: (value){
                      if (value!.isEmpty){
                        return "Please enter your password";
                      } else if (passController.text.length < 6){
                        return "Password Length Should be more than 6 characters";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(114, 0, 0, 0),
                          spreadRadius: 1,
                          blurRadius: 2,
                          blurStyle: BlurStyle.normal,
                        )
                      ]),
                  width: 300,
                  child: TextFormField(
                    controller: passConfirmController,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: 'Confirmed Password',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(
                          Icons.circle_rounded,
                          color: Color.fromRGBO(244, 166, 50, 1.0),
                        ),
                      ),
                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return "Please confirm your password";
                      } else if(value != passController.text){
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                GradientElevatedButton(
                    onPressed: () {
                      if (_formfield.currentState!.validate()){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registration Successful!')),
                        );
                        // print("Data Added Successfully");
                        emailController.clear();
                        passController.clear();
                        passConfirmController.clear();
                      }
                    },
                    style: GradientElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 110),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(255, 149, 0, 1)
                          ],
                        )),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 20),
                const SizedBox(
                  height: 20,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Divider(
                        color: Color.fromRGBO(57, 105, 144, 1),
                        height: 10,
                        indent: 20,
                        endIndent: 20,
                      )),
                      Text(
                        "or Sign up with",
                        style: TextStyle(
                            color: Color.fromRGBO(57, 105, 144, 1),
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                          child: Divider(
                        color: Color.fromRGBO(57, 105, 144, 1),
                        height: 10,
                        indent: 20,
                        endIndent: 20,
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  height: 80,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset("images/ggl.png")),
                      ),
                      InkWell(
                        onTap: () {},
                        child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset("images/fb.png")),
                      ),
                      InkWell(
                        onTap: () {},
                        child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Image.asset("images/lnk.png")),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  width: 500,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Login',
                               style: const TextStyle(
                                color: Color.fromRGBO(9, 110, 188, 1),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: _logInRecognizer
                              ..onTap = () {
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                  const logIn()
                                  ),
                                );
                              }
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}