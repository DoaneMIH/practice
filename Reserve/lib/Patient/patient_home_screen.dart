import 'package:flutter/material.dart';
import 'package:vital_link_chain/Patient/patient%20_medical_certificate.dart';
import 'package:vital_link_chain/Patient/patient_access_control_screen.dart';
import 'package:vital_link_chain/Patient/patient_medical_record.dart';
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:vital_link_chain/Utility/routes.dart';
import 'package:web3dart/web3dart.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  bool isSidebarOpen = true;
  String selectedSection = "Dashboard"; // Tracks the selected section
  String userName = "Loading..."; // Default value while loading the name

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch the user's name when the screen loads
  }

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  Future<void> _fetchUserName() async {
    try {
      String privateKey = Connector.key;

      print("Fetching user name for private key: $privateKey");

      // Derive Ethereum address from private key
      EthPrivateKey creds = EthPrivateKey.fromHex(privateKey);
      EthereumAddress address = await creds.extractAddress();

      String? name = await Connector.getName(address.hex);

      if (name.isNotEmpty) {
        print("Name retrieved: $name");
        setState(() {
          userName = name;
        });
      } else {
        print("No name found for the user.");
        setState(() {
          userName = "Unknown User";
        });
      }
    } catch (e) {
      print("Error fetching user name: $e");
      setState(() {
        userName = "Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Sidebar(
              isOpen: isSidebarOpen,
              onToggle: toggleSidebar,
              userName: userName,
              onSectionSelected: (section) {
                setState(() {
                  selectedSection = section; // Update the selected section
                  print("Selected Section: $selectedSection");
                });
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedSection == "Dashboard") ...[
                    HeaderSection(),
                    FeatureSection(),
                    WelcomeSection(),
                    WhyChooseUsSection(),
                    HowItWorksSection(),
                    FooterSection(),
                  ],
                  if (selectedSection == "General Information")
                    _buildGeneralInfoSection(),
                  if (selectedSection == "Access Control")
                    _buildPatientAccessControl(),
                  if (selectedSection == "Medical Record")
                    _buildMedicalRecordSection(),
                  if (selectedSection == "Medical Certificate")
                    _buildMedicalCertificateSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "General Information",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text("This is the general information section."),
        ],
      ),
    );
  }

  Widget _buildPatientAccessControl() {
    return AccessControlScreen();
  }

  // Widget _buildMedicalRecordSection() {
  //   final privateKey = Connector.key;
  //   final creds = EthPrivateKey.fromHex(privateKey);
  //   final address = creds.address.hexEip55;

  //   return MedicalRecord(patientAddress: address);
  // }

  Widget _buildMedicalRecordSection() {
  try {
    final privateKey = Connector.key;
    final creds = EthPrivateKey.fromHex(privateKey);
    final address = creds.address.hexEip55;

    return MedicalRecord(patientAddress: address);

  } catch (e) {
    print("Error in _buildMedicalRecordSection: $e");
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text("Failed to load medical records. Error: $e"),
    );
  }
}

Widget _buildMedicalCertificateSection(){
  return PatientMedicalCertificate();
}
}

class Sidebar extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  final String userName;
  final Function(String) onSectionSelected;

  const Sidebar({
    required this.isOpen,
    required this.onToggle,
    required this.userName,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isOpen ? 230 : 70,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.only(
        //   topRight: Radius.circular(30), // 👈 Top-right corner rounded
        // ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 50),
              if (isOpen)
                Text(
                  "Vital Link Chain",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                ),
            ],
          ),
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: onToggle,
              splashColor: Colors.transparent, // optional
              highlightColor: Colors.transparent,
            ),
          ),
          if (isOpen) ...[
            CircleAvatar(radius: 30),
            SizedBox(height: 10),
            Text(userName, style: TextStyle(fontWeight: FontWeight.bold)),
            Text("sarahsmith@gmail.com", style: TextStyle(fontSize: 12)),
            SizedBox(height: 20),
          ],
          _buildSidebarItem(
            Icons.dashboard,
            "Dashboard",
            isOpen,
            onTap: () {
              onSectionSelected("Dashboard");
            },
          ),
          _buildSidebarItem(
            Icons.info_outline,
            "General Information",
            isOpen,
            onTap: () {
              onSectionSelected("General Information");
            },
          ),
          _buildSidebarItem(
            Icons.info_outline,
            "Access Control",
            isOpen,
            onTap: () {
              onSectionSelected("Access Control");
            },
          ),
          _buildSidebarItem(
            Icons.folder_shared,
            "Medical Record",
            isOpen,
            onTap: () {
              onSectionSelected("Medical Record");
            },
          ),
          _buildSidebarItem(
            Icons.people,
            "Medical Certificate",
            isOpen,
            onTap: () {
              onSectionSelected("Medical Certificate");
            },
          ),
          _buildSidebarItem(
            Icons.receipt_long,
            "Transactions",
            isOpen,
            onTap: () {
              onSectionSelected("Transactions");
            },
          ),
          _buildSidebarItem(
            Icons.settings,
            "Settings",
            isOpen,
            onTap: () {
              onSectionSelected("Settings");
            },
          ),
          Spacer(),
          _buildSidebarItem(
            Icons.help_center,
            "Help Center",
            isOpen,
            onTap: () {
              onSectionSelected("Help Center");
            },
          ),
          _buildSidebarItem(
            Icons.logout,
            "Logout",
            isOpen,
            onTap: () {
              print("Logging out...");
              Connector.key = "";
              Navigator.of(context).pushNamedAndRemoveUntil(
                MyRoutes.loginPage,
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    IconData icon,
    String title,
    bool showText, {
    VoidCallback? onTap,
  }) {
    return SafeArea(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.cyan.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.cyan),
              if (showText) ...[
                SizedBox(width: 10),
                Expanded(child: Text(title, style: TextStyle(fontSize: 14))),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      color: Colors.cyan[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Vital Link Chain",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  TextButton(onPressed: () {}, child: Text("Home")),
                  TextButton(onPressed: () {}, child: Text("Login")),
                  ElevatedButton(onPressed: () {}, child: Text("Sign Up")),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),
          Text("100% ultimate security", style: TextStyle(fontSize: 16)),
          Text(
            "Your health data, our confidence.",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Image.asset('assets/images/Illustration.png', height: 200),
        ],
      ),
    );
  }
}

class FeatureSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FeatureCard(
            title: "Appointments",
            description: "Book appointments securely",
          ),
          FeatureCard(
            title: "Clinic",
            description: "Connect with trusted clinics",
          ),
          FeatureCard(
            title: "Medical Record",
            description: "Manage and access records",
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String title;
  final String description;

  FeatureCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 100,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Icon(Icons.health_and_safety, size: 40, color: Colors.cyan),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(description, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class WelcomeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "WELCOME TO VITAL LINK CHAIN",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "Where trust and transparency meets innovation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit..."),
        ],
      ),
    );
  }
}

class WhyChooseUsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            "Why Choose Us?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FeatureCard(
                title: "Secure and Encrypted",
                description: "Your data is always protected",
              ),
              FeatureCard(
                title: "Blockchain Security",
                description: "Advanced security with blockchain",
              ),
              FeatureCard(
                title: "Instant Medical Records",
                description: "Access records anytime",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "How it works",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StepCard(step: "1", title: "Register"),
              StepCard(step: "2", title: "Connect"),
              StepCard(step: "3", title: "Manage"),
              StepCard(step: "4", title: "Share"),
            ],
          ),
        ],
      ),
    );
  }
}

class StepCard extends StatelessWidget {
  final String step;
  final String title;

  const StepCard({super.key, required this.step, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          child: Text(step, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.cyan,
        ),
        SizedBox(height: 10),
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class FooterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan[200],
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Vital Link Chain",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Quick Links"),
                  Text("Home"),
                  Text("Features"),
                  Text("Contact Us"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Contact Us"),
                  Text("vital@link.com"),
                  Text("+1234567890"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
