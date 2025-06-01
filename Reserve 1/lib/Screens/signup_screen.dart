import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:vital_link_chain/Utility/routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
  
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController address = TextEditingController();
  TextEditingController privateKey = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController licenseNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool adding = false;
  String selectedRole = 'patient'; // Default role

  @override
void dispose() {
  address.dispose();
  privateKey.dispose();
  name.dispose();
  role.dispose();
  licenseNumber.dispose();
  super.dispose();
}

  Widget buildRoleOption(String role) {
    bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.grey.shade100 : Colors.transparent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              role,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey),
              ),
              child:
                  isSelected
                      ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade700,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }


void _signup() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      adding = true;
    });

    try {

     bool success = await Connector.signUpWithRole(
        address.text,
        privateKey.text,
        selectedRole,
        name.text,
        selectedRole.toLowerCase() == 'doctor' ? licenseNumber.text : null, // Pass license only for doctor
      );

      if (success) {
        Fluttertoast.showToast(msg: '$selectedRole signup successful!');
        Navigator.pushReplacementNamed(context, MyRoutes.loginPage);
      } else {
        Fluttertoast.showToast(msg: 'Signup failed. Please check your details.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error during signup: ${e.toString()}');
      print('Error during signup: $e');
    } finally {
      setState(() {
        adding = false;
      });
    }
  }
} 

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
                      'Welcome',
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
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Create Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: name,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  hintText: 'Enter your name',
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
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: address,
                                decoration: InputDecoration(
                                  labelText: 'Ethereum Address',
                                  hintText: 'Enter your Ethereum Address',
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
                                    return 'Please enter your Ethereum address';
                                  }
                                  if (!RegExp(
                                    r'^(0x)?[0-9a-fA-F]{40}$',
                                  ).hasMatch(value)) {
                                    return 'Please enter a valid Ethereum address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: privateKey,
                                // obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Private Key',
                                  hintText: 'Enter your Private Key',
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
                                  if (value!.isEmpty) {
                                    return "Key can't be empty";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Role',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  buildRoleOption('Patient'),
                                  buildRoleOption('Doctor'),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (selectedRole.toLowerCase() == 'doctor')
                          ...[
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: licenseNumber,
                              decoration: InputDecoration(
                                labelText: 'License Number',
                                hintText: 'Enter your license number',
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
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
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (selectedRole.toLowerCase() == 'doctor' && (value == null || value.isEmpty)) {
                                  return 'Please enter your license number';
                                }
                                return null;
                              },
                            ),
                          ],
                              const SizedBox(height: 20),
                        
                              ElevatedButton(
                                onPressed: () => _signup(),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  backgroundColor: Colors.cyan,
                                  textStyle: const TextStyle(fontSize: 18),
                                ),
                                child: const Text(
                                  'Sign Up',
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
                                    "Have an account?",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Navigate to sign-in screen
                                      Navigator.pushReplacementNamed(context, MyRoutes.loginPage);
                                    },
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
