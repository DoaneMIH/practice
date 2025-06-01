import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:vital_link_chain/Utility/routes.dart';

bool adding = false;

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // TextEditingController privateKey = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final apiBaseUrl = dotenv.env['API_BASE_URL'];

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // New helper function to fetch private key from backend using name and password
  Future<String?> fetchPrivateKey(String username, String password) async {
    try {
      var response = await http.post(
        Uri.parse('$apiBaseUrl/api/login'), // Replace with your backend URL
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['privateKey'];
        
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching private key: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserCredentials(String username, String password) async {
  try {
    var response = await http.post(
      Uri.parse('$apiBaseUrl/api/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return {
        'privateKey': data['privateKey'],
        'email': data['email'],
        'role': data['role'],
      };
    } else {
      return null;
    }
  } catch (e) {
    print("Error fetching credentials: $e");
    return null;
  }
}

void moveToHome() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      adding = true;
    });

    try {
      // Fetch credentials from backend (privateKey, email, role)
      final credentials = await fetchUserCredentials(
        usernameController.text,
        passwordController.text,
      );

      if (credentials == null || credentials['privateKey'] == null) {
        Fluttertoast.showToast(msg: "Invalid username or password");
        setState(() {
          adding = false;
        });
        return;
      }

      // String? fetchedPrivateKey =
      //       await fetchPrivateKey(usernameController.text, passwordController.text);

      //   if (fetchedPrivateKey == null || fetchedPrivateKey.isEmpty) {
      //     Fluttertoast.showToast(msg: "Invalid username or password");
      //     setState(() {
      //       adding = false;
      //     });
      //     return;
      //   }

      String fetchedPrivateKey = credentials['privateKey'];
      String? email = credentials['email'];
      // String? role = credentials['role'];
      // String? role = await Connector.getRole(fetchedPrivateKey);


      // Use the fetched private key for the rest of the logic
      String? chainRole = await Connector.getRole(fetchedPrivateKey);

      if (chainRole == null || chainRole.isEmpty) {
        Fluttertoast.showToast(msg: "Role not found for this user");
        setState(() {
          adding = false;
        });
        return;
      }

      print("Role retrieved: $chainRole");

      if (chainRole == 'Patient') {
        Fluttertoast.showToast(msg: "Login Success as Patient");
        Connector.key = fetchedPrivateKey;
        await Navigator.pushReplacementNamed(
          context,
          MyRoutes.patientHomePage,
          arguments: {
            'email': email,
          },
        );
      } else if (chainRole == 'Doctor') {
        Fluttertoast.showToast(msg: "Login Success as Doctor");
        Connector.key = fetchedPrivateKey;
        await Navigator.pushReplacementNamed(
          context,
          MyRoutes.doctorHomePage,
          arguments: {
            'email': email,
          },
        );
      } else {
        Fluttertoast.showToast(msg: "Unknown role: $chainRole");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error during login: ${e.toString()}");
      print("Error during login: $e");
    } finally {
      setState(() {
        adding = false;
      });
    }
  }
}

  // void moveToHome() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       adding = true;
  //     });

  //     try {
  //       // Fetch private key from backend using name and password
  //       String? fetchedPrivateKey = await fetchPrivateKey(
  //         nameController.text,
  //         passwordController.text,
  //       );

  //       if (fetchedPrivateKey == null || fetchedPrivateKey.isEmpty) {
  //         Fluttertoast.showToast(msg: "Invalid name or password");
  //         setState(() {
  //           adding = false;
  //         });
  //         return;
  //       }

  //       // Fetch credentials from backend
  //     final credentials = await fetchUserCredentials(
  //       nameController.text,
  //       passwordController.text,
  //     );

  //     // String fetchedPrivateKey = credentials['privateKey'];
  //     String? email = credentials['email'];
  //     String? role = credentials['role'];

  //       if (credentials == null || credentials['privateKey'] == null) {
  //       Fluttertoast.showToast(msg: "Invalid name or password");
  //       setState(() {
  //         adding = false;
  //       });
  //       return;
  //     }

  //       // Use the fetched private key for the rest of the logic
  //       String? role = await Connector.getRole(fetchedPrivateKey);

  //       if (role == null || role.isEmpty) {
  //         Fluttertoast.showToast(msg: "Role not found for this user");
  //         setState(() {
  //           adding = false;
  //         });
  //         return;
  //       }

  //       print("Role retrieved: $role");

  //       if (role == 'Patient') {
  //         Fluttertoast.showToast(msg: "Login Success as Patient");
  //         Connector.key = fetchedPrivateKey;
  //         await Navigator.pushReplacementNamed(
  //           context,
  //           MyRoutes.patientHomePage,
  //           arguments: {
  //             'email': email,
  //           },
  //         );
  //       } else if (role == 'Doctor') {
  //         Fluttertoast.showToast(msg: "Login Success as Doctor");
  //         Connector.key = fetchedPrivateKey;

  //         // Register doctor on Medical Certificate contract and Store Doctor in DoctorForAll contract
  //         // final credentials = EthPrivateKey.fromHex(fetchedPrivateKey);
  //         // final address = await credentials.extractAddress();
  //         // String name = await Connector.getName(address.hex);
  //         // await Connector.registerDoctorOnMedicalCertificate(
  //         //   fetchedPrivateKey,
  //         //   name,
  //         // );
  //         // await Connector.registerDoctorOnDoctorforAll(
  //         //   fetchedPrivateKey,
  //         //   name,
  //         // );
  //         await Navigator.pushReplacementNamed(
  //           context,
  //           MyRoutes.doctorHomePage,
  //         );
  //       } else {
  //         Fluttertoast.showToast(msg: "Unknown role: $role");
  //       }
  //     } catch (e) {
  //       Fluttertoast.showToast(msg: "Error during login: ${e.toString()}");
  //       print("Error during login: $e");
  //     } finally {
  //       setState(() {
  //         adding = false;
  //       });
  //     }
  //   }
  // }

  // void moveToHome() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       adding = true;
  //     });

  //     try {
  //       // Fetch the role using the private key
  //       String? role = await Connector.getRole(privateKey.text);

  //       if (role == null || role.isEmpty) {
  //         Fluttertoast.showToast(msg: "Role not found for this private key");
  //         setState(() {
  //           adding = false;
  //         });
  //         return;
  //       }

  //       // Debugging: Print the role
  //       print("Role retrieved: $role");

  //       // Navigate based on the role
  //       if (role == 'Patient') {
  //         Fluttertoast.showToast(msg: "Login Success as Patient");
  //         Connector.key = privateKey.text;
  //         await Navigator.pushReplacementNamed(
  //           context,
  //           MyRoutes.patientHomePage,
  //         );
  //       } else if (role == 'Doctor') {
  //         Fluttertoast.showToast(msg: "Login Success as Doctor");
  //         Connector.key = privateKey.text;
  //         await Navigator.pushReplacementNamed(
  //           context,
  //           MyRoutes.doctorHomePage,
  //         );
  //       } else {
  //         Fluttertoast.showToast(msg: "Unknown role: $role");
  //       }
  //     } catch (e) {
  //       Fluttertoast.showToast(msg: "Error during login: ${e.toString()}");
  //       print("Error during login: $e");
  //     } finally {
  //       setState(() {
  //         adding = false;
  //       });
  //     }
  //   }
  // }

  //   @override
  //   Widget build(BuildContext context) {
  //     final screenWidth = MediaQuery.of(context).size.width;
  //     final isTablet = screenWidth > 600; // Basic check for larger screens
  //     return Scaffold(
  //       body: Row(
  //         children: [
  //           // Left Side (Logo and Text)
  //           Expanded(
  //             flex: isTablet ? 2 : 1,
  //             child: Container(
  //               color: Colors.white,
  //               padding: const EdgeInsets.all(40.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   // Replace with your actual logo image
  //                   Image.asset(
  //                     'assets/images/logo.png', // Add your logo image in the assets folder
  //                     height: 550,
  //                     // width: 700,
  //                     fit: BoxFit.cover,
  //                   ),
  //                   // const SizedBox(height: 10),
  //                   const Text(
  //                     'Vital Link Chain',
  //                     style: TextStyle(
  //                       fontSize: 50,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.cyan,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           // Right Side (Welcome and Sign Up Form)
  //           Expanded(
  //             flex: 2,
  //             child: Container(
  //               decoration: const BoxDecoration(
  //                 color: Colors.cyan,
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(30.0),
  //                   bottomLeft: Radius.circular(30.0),
  //                 ),
  //               ),
  //               child: Center(
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     const Text(
  //                       'Welcome Back',
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(
  //                         fontSize: 50,
  //                         fontWeight: FontWeight.bold,
  //                         color: Color.fromARGB(255, 255, 255, 255),
  //                         fontFamily: 'poppins',
  //                         letterSpacing: 3,
  //                       ),
  //                     ),
  //                     Container(
  //                       width: isTablet ? 500 : double.infinity,
  //                       margin: const EdgeInsets.all(10.0),
  //                       padding: const EdgeInsets.all(30.0),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(20.0),
  //                       ),
  //                       child: Form(
  //                         key: _formKey,
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.stretch,
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             const Text(
  //                               'Sign In',
  //                               textAlign: TextAlign.center,
  //                               style: TextStyle(
  //                                 fontSize: 24,
  //                                 color: Colors.grey,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 15),
  //                             TextFormField(
  //                               controller: privateKey,
  //                               decoration: InputDecoration(
  //                                 labelText: 'Private Key',
  //                                 hintText: 'Enter your private key',
  //                                 labelStyle: TextStyle(color: Colors.grey),
  //                                 hintStyle: TextStyle(
  //                                   color: Colors.grey.shade400,
  //                                 ),
  //                                 contentPadding: EdgeInsets.symmetric(
  //                                   horizontal: 16,
  //                                   vertical: 16,
  //                                 ),
  //                                 border: OutlineInputBorder(
  //                                   borderRadius: BorderRadius.circular(12),
  //                                   borderSide: BorderSide(
  //                                     color: Colors.grey.shade300,
  //                                   ),
  //                                 ),
  //                                 enabledBorder: OutlineInputBorder(
  //                                   borderRadius: BorderRadius.circular(12),
  //                                   borderSide: BorderSide(
  //                                     color: Colors.grey.shade300,
  //                                   ),
  //                                 ),
  //                                 focusedBorder: OutlineInputBorder(
  //                                   borderRadius: BorderRadius.circular(12),
  //                                   borderSide: BorderSide(
  //                                     color: Colors.blue,
  //                                   ), // Customize as needed
  //                                 ),
  //                               ),
  //                               validator: (value) {
  //                                 if (value == null || value.isEmpty) {
  //                                   return 'Please enter your private key';
  //                                 }
  //                                 return null;
  //                               },
  //                             ),
  //                             const SizedBox(height: 20),
  //                             ElevatedButton(
  //                               onPressed: () => moveToHome(),
  //                               style: ElevatedButton.styleFrom(
  //                                 padding: const EdgeInsets.symmetric(
  //                                   vertical: 15,
  //                                 ),
  //                                 backgroundColor: Colors.cyan,
  //                                 textStyle: const TextStyle(fontSize: 18),
  //                               ),
  //                               child: const Text(
  //                                 'Log In',
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                             ),
  //                             const SizedBox(height: 15),
  //                             const Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 Expanded(child: Divider(color: Colors.grey)),
  //                                 Padding(
  //                                   padding: EdgeInsets.symmetric(
  //                                     horizontal: 10.0,
  //                                   ),
  //                                   child: Text(
  //                                     'or',
  //                                     style: TextStyle(
  //                                       color: Colors.grey,
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Expanded(child: Divider(color: Colors.grey)),
  //                               ],
  //                             ),
  //                             const SizedBox(height: 15),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                               children: [
  //                                 OutlinedButton.icon(
  //                                   onPressed: () {
  //                                     // Handle Google sign-in
  //                                   },
  //                                   icon: Image.asset(
  //                                     'assets/images/google.png', // Add Google logo
  //                                     height: 24,
  //                                   ),
  //                                   label: const Text(
  //                                     'Sign in with Google',
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                   ),
  //                                   style: OutlinedButton.styleFrom(
  //                                     side: const BorderSide(color: Colors.grey),
  //                                   ),
  //                                 ),
  //                                 OutlinedButton.icon(
  //                                   onPressed: () {
  //                                     // Handle Apple sign-in
  //                                   },
  //                                   icon: Image.asset(
  //                                     'assets/images/apple-logo.png', // Add Apple logo
  //                                     height: 24,
  //                                   ),
  //                                   label: const Text(
  //                                     'Sign in with Apple',
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                   ),
  //                                   style: OutlinedButton.styleFrom(
  //                                     side: const BorderSide(color: Colors.grey),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             const SizedBox(height: 20),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 const Text(
  //                                   "Don't have an account?",
  //                                   style: TextStyle(fontWeight: FontWeight.bold),
  //                                 ),
  //                                 TextButton(
  //                                   onPressed:
  //                                       () => Navigator.pushReplacementNamed(
  //                                         context,
  //                                         MyRoutes.signupPage,
  //                                       ),
  //                                   child: const Text(
  //                                     'Sign in',
  //                                     style: TextStyle(
  //                                       color: Colors.cyan,
  //                                       fontWeight: FontWeight.bold,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600; // Basic check for larger screens
    return Scaffold(
      body: Row(
        children: [
          // Left Side (Logo and Text)
          Expanded(
            flex: isTablet ? 2 : 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 550,
                    fit: BoxFit.cover,
                  ),
                  const Text(
                    'Vital Link Chain',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right Side (Welcome and Sign Up Form)
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'poppins',
                        letterSpacing: 3,
                      ),
                    ),
                    Container(
                      width: isTablet ? 500 : double.infinity,
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Name Field
                            TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),

                            // Password Field
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: () => moveToHome(),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                backgroundColor: Colors.cyan,
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                              child: const Text(
                                'Log In',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(child: Divider(color: Colors.grey)),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    'or',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey)),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // Handle Google sign-in
                                  },
                                  icon: Image.asset(
                                    'assets/images/google.png',
                                    height: 24,
                                  ),
                                  label: const Text(
                                    'Sign in with Google',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.grey),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    // Handle Apple sign-in
                                  },
                                  icon: Image.asset(
                                    'assets/images/apple-logo.png',
                                    height: 24,
                                  ),
                                  label: const Text(
                                    'Sign in with Apple',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Navigator.pushReplacementNamed(
                                        context,
                                        MyRoutes.signupPage,
                                      ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
