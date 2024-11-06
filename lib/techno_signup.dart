// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';


class TechnoSignup extends StatelessWidget {
  const TechnoSignup({super.key});

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
                child: const TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
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
                child: const TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
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
                child: const TextField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: InputDecoration(
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
                child: const TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
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
                ),
              ),
              const SizedBox(height: 20),
              GradientElevatedButton(
                  onPressed: () {},
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
                child: const Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Log In",
                          style: TextStyle(
                              color: Color.fromRGBO(9, 110, 188, 1),
                              fontWeight: FontWeight.bold),
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
    );
  }
}
