import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:vital_link_chain/Utility/routes.dart';

bool adding = false;

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController privateKey = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void moveToHome() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        adding = true;
      });

      try {
        // Fetch the role using the private key
        String? role = await Connector.getRole(privateKey.text);

        if (role == null || role.isEmpty) {
          Fluttertoast.showToast(msg: "Role not found for this private key");
          setState(() {
            adding = false;
          });
          return;
        }

        // Debugging: Print the role
        print("Role retrieved: $role");

        // Navigate based on the role
        if (role == 'Patient') {
          Fluttertoast.showToast(msg: "Login Success as Patient");
          Connector.key = privateKey.text;
          await Navigator.pushReplacementNamed(
            context,
            MyRoutes.patientHomePage,
          );
        } else if (role == 'Doctor') {
          Fluttertoast.showToast(msg: "Login Success as Doctor");
          Connector.key = privateKey.text;
          await Navigator.pushReplacementNamed(
            context,
            MyRoutes.doctorHomePage,
          );
        } else {
          Fluttertoast.showToast(msg: "Unknown role: $role");
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
                  // Replace with your actual logo image
                  Image.asset(
                    'assets/images/logo.png', // Add your logo image in the assets folder
                    height: 550,
                    // width: 700,
                    fit: BoxFit.cover,
                  ),
                  // const SizedBox(height: 10),
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
                        color: Color.fromARGB(255, 255, 255, 255),
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
                            TextFormField(
                              controller: privateKey,
                              decoration: InputDecoration(
                                labelText: 'Private Key',
                                hintText: 'Enter your private key',
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                contentPadding: EdgeInsets.symmetric(
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
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ), // Customize as needed
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your private key';
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
                                    'assets/images/google.png', // Add Google logo
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
                                    'assets/images/apple-logo.png', // Add Apple logo
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
                                    'Sign in',
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
