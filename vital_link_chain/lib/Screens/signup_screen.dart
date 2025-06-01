import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:vital_link_chain/Utility/routes.dart';
import 'package:vital_link_chain/genine/screens/InstructionPage.dart';
import 'package:web3dart/web3dart.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final List<String> privateKeys = [
    '0xb20cc74cda55715fa99e2d246de82b613e06301ae5b9702bd30eb8c434b486a1',
    '0x6a2671db94f60fa7abe349a6114301739cdb50534b106cc62d2f4f29b98baf46',
    '0xcc603c276741df22770acb6f093f349f142ddee312ab2b6e7c81c8025b26e067',
    '0xc9e878eb166616a02fe970d3e513ea950addc3fa278f1a2f9763f9cdc703624f',
    '0x0ab51042b6964ecb546908aca20fafc64ce4532db5102a510462ba26854d7c9f',
    '0x5ff0d489d1e0c3f32dce9776b2c72ea4b5953e590a2f8aa7cd265e1c10849796',
    '0xd4fafc588ebd02ac0cccad2e3e6e3a33c21f56f2273e9a6b2fec5e396558b5e2',
    '0x33c1b51c3eef171d53a684f7fa5faa93694bddcf18755e07ef19de0eb1e6c6f6',
    '0x2a601b51c0476476e4955537e0a05776f01ee560b1fd93d82f56245824b59243',
    '0x48fdc09803e951566feaca27b64af418c824159f4cdfcfe7f89501ef9ae124e6',
  ];

  // Track which keys have been assigned
  final Set<int> usedKeyIndices = <int>{};
  final Random _random = Random();

  // Step 1 controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  // Step 2 controllers
  TextEditingController addressController = TextEditingController();
  TextEditingController privateKeyController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
    bool _obscureConfirmPassword = true;
  int _currentStep = 0; // Track which step we're on
  // TextEditingController address = TextEditingController();
  // TextEditingController privateKey = TextEditingController();
  // TextEditingController name = TextEditingController();

  TextEditingController role = TextEditingController();
  TextEditingController licenseNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool adding = false;
  String selectedRole = 'patient'; // Default role
  final apiBaseUrl = dotenv.env['API_BASE_URL'];

  @override
  void dispose() {
    // address.dispose();
    // privateKey.dispose();
    // name.dispose();
    usernameController.dispose();
    passwordController.dispose();
    privateKeyController.dispose();
    addressController.dispose();   
    emailController.dispose();
    confirmPasswordController.dispose();
    role.dispose();
    licenseNumber.dispose();
    super.dispose();
  }

  void _generateAndFillKey() {
    final availableIndices = <int>[];
    for (int i = 0; i < privateKeys.length; i++) {
      if (!usedKeyIndices.contains(i)) {
        availableIndices.add(i);
      }
    }
    if (availableIndices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No more keys available from Ganache!'), backgroundColor: Colors.red),
      );
      return;
    }
    final randomIndex = availableIndices[_random.nextInt(availableIndices.length)];
    final selectedKey = privateKeys[randomIndex];
    usedKeyIndices.add(randomIndex);

    final credentials = EthPrivateKey.fromHex(selectedKey);
    final addressHex = credentials.address.hexEip55;

    setState(() {
      privateKeyController.text = selectedKey;
      addressController.text = addressHex;
    });
  }

  Future<void> _storeUserData(String addressHex, String privateKeyHex) async {
    final url = Uri.parse(
      '$apiBaseUrl/api/users',
    ); // Replace with your backend URL
    final Map<String, dynamic> userData = {
      "ethereumAddress": addressHex,
      "privateKey": privateKeyHex,
      "username": usernameController.text,
      "email": emailController.text,
      "role": selectedRole.toLowerCase(),
      "licenseNumber": role.text == 'doctor' ? licenseNumber.text : null,
      "password": confirmPasswordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(userData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(msg: 'User data stored in MongoDB!');
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to store user data: ${response.body}',
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
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


  // Future<bool> _isAddressRegistered(String address) async {
  //   // You need to implement this in your Connector class.
  //   // It should call your smart contract's isExists or similar function.
  //   return await Connector.isUserExists(address);
  // }

  // Future<void> _showGetKeyDialog() async {
  //   int? selectedIdx;
  //   await showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder:
  //             (context, setState) => AlertDialog(
  //               title: const Text('Select a Private Key'),
  //               content: SizedBox(
  //                 width: 400,
  //                 height: 300,
  //                 child: ListView.builder(
  //                   itemCount: privateKeys.length,
  //                   itemBuilder: (context, idx) {
  //                     final key = privateKeys[idx];
  //                     final address = EthPrivateKey.fromHex(key).address.hex;
  //                     final isUsed = usedKeyIndices.contains(idx);

  //                     return FutureBuilder<bool>(
  //                       future: _isAddressRegistered(address),
  //                       builder: (context, snapshot) {
  //                         final alreadyRegistered = snapshot.data ?? false;
  //                         if (alreadyRegistered) {
  //                           // Remove from list if already registered
  //                           WidgetsBinding.instance.addPostFrameCallback((_) {
  //                             setState(() {
  //                               usedKeyIndices.add(idx);
  //                             });
  //                           });
  //                         }
  //                         return ListTile(
  //                           title: Text(
  //                             key,
  //                             style: TextStyle(
  //                               fontSize: 12,
  //                               color:
  //                                   (isUsed || alreadyRegistered)
  //                                       ? Colors.grey
  //                                       : Colors.black,
  //                             ),
  //                           ),
  //                           subtitle: Text(
  //                             (isUsed || alreadyRegistered)
  //                                 ? 'Already used'
  //                                 : 'Address: $address',
  //                             style: TextStyle(
  //                               color:
  //                                   (isUsed || alreadyRegistered)
  //                                       ? Colors.red
  //                                       : Colors.green,
  //                               fontSize: 11,
  //                             ),
  //                           ),
  //                           enabled: !(isUsed || alreadyRegistered),
  //                           selected: selectedIdx == idx,
  //                           onTap:
  //                               (isUsed || alreadyRegistered)
  //                                   ? null
  //                                   : () {
  //                                     setState(() {
  //                                       selectedIdx = idx;
  //                                     });
  //                                   },
  //                         );
  //                       },
  //                     );
  //                   },
  //                 ),
  //               ),
  //               actions: [
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: const Text('Cancel'),
  //                 ),
  //                 ElevatedButton(
  //                   onPressed:
  //                       selectedIdx != null &&
  //                               !usedKeyIndices.contains(selectedIdx)
  //                           ? () {
  //                             final key = privateKeys[selectedIdx!];
  //                             final address =
  //                                 EthPrivateKey.fromHex(key).address.hex;
  //                             setState(() {
  //                               privateKeyController.text = key;
  //                               addressController.text = address;
  //                               usedKeyIndices.add(selectedIdx!);
  //                             });
  //                             Navigator.pop(context);
  //                           }
  //                           : null,
  //                   child: const Text('Use This Key'),
  //                 ),
  //               ],
  //             ),
  //       );
  //     },
  //   );
  // }

  void _continueToNextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        adding = true;
      });

      try {
        // Generate key and address automatically
        final availableIndices = <int>[];
        for (int i = 0; i < privateKeys.length; i++) {
          if (!usedKeyIndices.contains(i)) {
            availableIndices.add(i);
          }
        }

        if (availableIndices.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No more keys available from Ganache!'),
                backgroundColor: Colors.red),
          );
          setState(() {
            adding = false;
          });
          return;
        }


        final randomIndex =
            availableIndices[_random.nextInt(availableIndices.length)];
        final selectedKey = privateKeys[randomIndex];
        usedKeyIndices.add(randomIndex);
        final credentials = EthPrivateKey.fromHex(selectedKey);
        final addressHex = credentials.address.hexEip55;


        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));
        bool success = await Connector.signUpWithRole(
          addressHex,
          selectedKey,
          selectedRole,
          usernameController.text,
          selectedRole.toLowerCase() == 'doctor'
              ? licenseNumber.text
              : null, // Pass license only for doctor
        );

        if (success) {
          await _storeUserData(addressHex, selectedKey); // <-- Store user data in backend after blockchain signup

          Fluttertoast.showToast(msg: '$selectedRole signup successful!');
          if (selectedRole.toLowerCase() == 'doctor') {
            await Connector.registerDoctorOnMedicalCertificate(
              selectedKey,
              usernameController.text,
            );
            await Connector.registerDoctorOnDoctorforAll(
              selectedKey,
              usernameController.text,
            );
            // Fluttertoast.showToast(msg: 'Please wait for admin approval.');
          } else if (selectedRole.toLowerCase() == 'patient') {
            await Connector.registerPatientforAll(
              selectedKey,
              usernameController.text,
            );
          }
          Navigator.pushReplacementNamed(context, MyRoutes.loginPage);
        } else {
          Fluttertoast.showToast(
            msg: 'Signup failed. Please check your details.',
          );
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

  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
            labelStyle: const TextStyle(color: Colors.grey),
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  if (value.length < 4) {
                                    return 'Username must be at least 4 characters';
                                  }
                                  return null;
                                },
                              ),
        const SizedBox(height: 10),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email address',
            labelStyle: const TextStyle(color: Colors.grey),
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            labelStyle: const TextStyle(color: Colors.grey),
            hintStyle: TextStyle(color: Colors.grey.shade400),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
          validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (!RegExp(r'^(?=.*[A-Z])(?=.*\d).+$')
                                      .hasMatch(value)) {
                                    return 'Password must have at least one capital letter and one number';
                                  }
                                  if (value.length < 8) {
                                    return 'Password must be at least 8 characters long';
                                  }
                                  if (value.length > 20) {
                                    return 'Password must be at most 20 characters long';
                                  }
                                  if (value.contains(' ')) {
                                    return 'Password cannot contain spaces';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  hintText: 'Re-enter your password',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade300,
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
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility, color: Colors.grey,),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
        const SizedBox(height: 10),
        const Text('Role', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [buildRoleOption('Patient'), buildRoleOption('Doctor')],
        ),
        const SizedBox(height: 20),
        if (selectedRole.toLowerCase() == 'doctor') ...[
          const SizedBox(height: 10),
          TextFormField(
            controller: licenseNumber,
            decoration: InputDecoration(
              labelText: 'License Number',
              hintText: 'Enter your license number',
              labelStyle: TextStyle(color: Colors.grey),
              hintStyle: TextStyle(color: Colors.grey.shade400),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            validator: (value) {
              if (selectedRole.toLowerCase() == 'doctor' &&
                  (value == null || value.isEmpty)) {
                return 'Please enter your license number';
              }
              return null;
            },
          ),
        ],
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
                _signup(); // _signup now handles user data storage and key generation
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: Colors.cyan,
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text(
            'Sign Up', // Changed from 'Sign Up' to 'Continue' as per request
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Blockchain Information',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Colors.grey),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Ethereum Address',
                  hintText: 'Enter your wallet address',
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Ethereum address';
                  }
                  if (!RegExp(r'^(0x)?[0-9a-fA-F]{40}$').hasMatch(value)) {
                    return 'Please enter a valid Ethereum address';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                // _showInfoDialog(
                //   'Ethereum Address',
                //   'An Ethereum address is a unique identifier for your blockchain wallet. It\'s a 42-character string starting with "0x" that allows others to send you cryptocurrency and interact with your account on the Ethereum network. You can find this in your crypto wallet (like MetaMask, Trust Wallet, etc.).',
                // );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InstructionsPage(),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: privateKeyController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Private Key',
                  hintText: 'Enter your private key',
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Private key can't be empty";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _generateAndFillKey,
              // onPressed: () {
              // _showInfoDialog(
              //   'Private Key',
              //   'Your private key is a secret 64-character string that gives you access to your Ethereum wallet. It\'s like a master password that controls your cryptocurrency and allows you to sign transactions. NEVER share this with anyone - whoever has your private key has full access to your wallet and funds. Keep it secure and confidential.',
              // );
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const GetKey()));

              // },
              icon: const Icon(Icons.key, color: Color.fromARGB(255, 158, 158, 158)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentStep -= 1;
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.grey),
                ),
                child: const Text('Back', style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: adding ? null : _signup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.cyan,
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child:
                    adding
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Sign Up', // This remains 'Sign Up' as it's the final submission
                          style: TextStyle(color: Colors.white),
                        ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
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
                  // This assumes you have an image in assets/images/logo.png
                  // If not, you might want to replace it with a placeholder or remove it.
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
                              if (_currentStep == 0) _buildStepOne(),
                              // if (_currentStep == 1) _buildStepTwo(),
                              const SizedBox(height: 15),
                              // Social sign-in options only appear on step 0
                              if (_currentStep == 0) ...[
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                        side: const BorderSide(
                                          color: Colors.grey,
                                        ),
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
                                        side: const BorderSide(
                                          color: Colors.grey,
                                        ),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          MyRoutes.loginPage,
                                        );
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
