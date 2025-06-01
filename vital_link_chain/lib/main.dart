import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vital_link_chain/Screens/splash_screen.dart';
import 'package:vital_link_chain/Utility/routes.dart';

void main() async{
  await dotenv.load(); // Load environment variables if needed
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Splash2(),
      routes: MyRoutes.routes,
      // home: MedicalPrescriptionForm(), 
    );
  }
}




//Genine Side
// import 'package:flutter/material.dart';
// import 'package:vital_link_chain/genine/screens/InstructionPage.dart';
// import 'package:vital_link_chain/genine/screens/MedApplication.dart';
// import 'package:vital_link_chain/genine/screens/PatientRecord.dart';
// import 'package:vital_link_chain/genine/screens/PatientsScreen.dart';
// import 'package:vital_link_chain/genine/screens/SignUpScreen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Medical Records',
//       debugShowCheckedModeBanner: false,
//       home: const HomeScreen(),
//       routes: {
//         '/home': (context) => const HomeScreen(),
//         '/signup': (context) => const SignupScreen(),
//         '/patient_record': (context) => PatientRecord(),
//         '/med_application': (context) => const MedApplication(),
//         '/patients_screen': (context) => PatientsScreen(),
//         '/instructionpage': (context) => InstructionsPage(),
//       },
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Medical Records'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               child: const Text('Patient Records'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/patient_record');
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Medical Application Form'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/med_application');
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Patients List'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/patients_screen');
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Sign Up'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/signup');
//               },
//             ),
//             ElevatedButton(
//               child: const Text('Instruction Page'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/instructionpage');
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



//Jhules Side

// import 'package:flutter/material.dart';
// import 'package:vital_link_chain/jhules/doctorProfile.dart';
// import 'package:vital_link_chain/jhules/medicalPrescriptionForm.dart';

// import 'jhules/medicalCertificateForm.dart';


// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Navigation Demo',
//       home: MainPage(),
//       routes: {
//         '/page1': (context) => MedicalPrescriptionForm(),
//         // '/page2': (context) => MedicalTransactionsPage(),
//         '/page3': (context) => MedicalCertificateForm(),
//         '/page4': (context) => DoctorProfileApp(),
//       },
//     );
//   }
// }

// class MainPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Main Page')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/page1'),
//               child: Text('Medical Prescription Form'),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/page2'),
//               child: Text('Medical Transactions Page'),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/page3'),
//               child: Text('Medical Certificate Form'),
//             ),
//             ElevatedButton(
//               onPressed: () => Navigator.pushNamed(context, '/page4'),
//               child: Text('doctor profile'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class Page2 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Page 2')),
//       body: Center(child: Text('This is Page 2')),
//     );
//   }
// }

// class Page4 extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Page 4')),
//       body: Center(child: Text('This is Page 4')),
//     );
//   }
// }


