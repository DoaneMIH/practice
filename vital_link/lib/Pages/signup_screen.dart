
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vital_link/Utils/connector.dart';
import 'package:vital_link/Utils/routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController address = TextEditingController();
  TextEditingController privateKey = TextEditingController();
  TextEditingController role = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool adding = false;

  _showPicker() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.0))),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                  child: Text(
                    "Roles",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                    leading: const Icon(
                      CupertinoIcons.person_alt_circle,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Patient',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      role.text = "Patient";
                      setState(() {});
                      Navigator.pop(context);
                    }),
                ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.userDoctor,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Doctor',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      role.text = "Doctor";
                      setState(() {});
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        adding = true;
      });

      try {
        bool success;
        if (role.text == 'Patient') {
          success = await Connector.signUpPatient(address.text, privateKey.text);
        } else {
          success = await Connector.signUpDoctor(address.text, privateKey.text);
        }

        if (success) {
          Fluttertoast.showToast(msg: '${role.text} signup successful!');
          Navigator.pushReplacementNamed(context, MyRoutes.loginPage); // Navigate to login after signup
        } else {
          Fluttertoast.showToast(msg: 'Signup failed. Please try again.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: const EdgeInsets.fromLTRB(0,0,0, 16),
                child: Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100)),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      child: Image.asset('assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                    height: 10.0,
              ),
              Center(
                    child: Text(
                      "Sign-Up",
                      style: GoogleFonts.lato(
                          fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
                  child: CupertinoFormSection(
                    backgroundColor: Colors.transparent,
                    children: [
                      CupertinoFormRow(
                          //padding: EdgeInsets.only(left: 0),
                          child: CupertinoTextFormFieldRow(
                            style: GoogleFonts.poppins(),
                            controller: address,
                            placeholder: "Enter your Etherium Address",
                            prefix: Text(
                              "Address      ",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            padding: const EdgeInsets.only(left: 0),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Address can't be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                        CupertinoFormRow(
                          //padding: EdgeInsets.only(left: 0),
                          child: CupertinoTextFormFieldRow(
                            style: GoogleFonts.poppins(),
                            controller: privateKey,
                            placeholder: "Enter your private key",
                            prefix: Text(
                              "Key      ",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            padding: const EdgeInsets.only(left: 0),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Key can't be empty";
                              }
                              return null;
                            },
                          ),
                        ),
                        CupertinoTextFormFieldRow(
                          style: GoogleFonts.poppins(),
                          controller: role,
                          onTap: _showPicker,
                          placeholder: "Tap to Show Roles",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                      return 'Please select a role';
                    }
                    return null;
                          },
                          decoration: const BoxDecoration(color: Colors.white),
                          prefix: Text(
                            "Role            ",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          readOnly: true,
                        ),
                    ],
                  ),
                ),

                Padding(
                    padding: EdgeInsets.all(32),
                    child: adding
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: CupertinoActivityIndicator(
                                radius: 20,
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 7,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: () =>_signup(),
                                icon: const Icon(Icons.send_outlined),
                                iconSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, MyRoutes.loginPage);
                    },
                    child: Text('Already have an account? Log in',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}