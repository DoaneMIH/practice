import 'package:flutter/material.dart';
import 'package:vital_link/Pages/doctor_homepage.dart';
import 'package:vital_link/Pages/login_screen.dart';
import 'package:vital_link/Pages/patient_homepage.dart';
import 'package:vital_link/Pages/signup_screen.dart';

class MyRoutes {
  static const String signupPage = "/signupPage";
  static const String loginPage = "/loginPage";
  static const String doctorHomePage = "/doctorHome";
  static const String patientHomePage = "/patientHome";

  static final routes = <String, WidgetBuilder>{
    signupPage: (context) => const SignupPage(),
    loginPage: (context) => const LoginPage(),
    doctorHomePage: (context) => const DoctorHomePage(),
    patientHomePage: (context) => const PatientHomePage(),
  };
}
