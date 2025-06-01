import 'package:flutter/material.dart';
import 'package:vital_link_chain/Doctor/doctor_home_screen.dart';
import 'package:vital_link_chain/Patient/patient_home_screen.dart';
import 'package:vital_link_chain/Screens/signin_screen.dart';
import 'package:vital_link_chain/Screens/signup_screen.dart';
// import 'package:vital_link_chain/genine/screens/MedApplication.dart';

class MyRoutes {
  static const String signupPage = "/signupPage";
  static const String loginPage = "/loginPage";
  static const String doctorHomePage = "/doctorHome";
  static const String patientHomePage = "/patientHome";
  static const String patientMedicalApplication = "/patientHome";
  
  static final routes = <String, WidgetBuilder>{
    signupPage: (context) => const SignupScreen(),
    loginPage: (context) => const SigninScreen(),
    doctorHomePage: (context) => const DoctorHomeScreen(),
    patientHomePage: (context) => const PatientHomeScreen(),
    // ignore: equal_keys_in_map
    // patientMedicalApplication: (context) => const MedApplication(),
  };
  
}
