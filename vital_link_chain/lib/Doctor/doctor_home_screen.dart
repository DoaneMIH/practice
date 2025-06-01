import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vital_link_chain/Doctor/doctor_medical_certificate.dart';
import 'package:vital_link_chain/Doctor/doctor_medical_records.dart';
import 'package:vital_link_chain/Doctor/doctor_patient_list.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:vital_link_chain/Utility/routes.dart';
import 'package:web3dart/web3dart.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  bool isSidebarOpen = true;
  String userName = "Loading..."; // Default value while loading the name
  String selectedSection = "Dashboard"; // Tracks the selected section
  List<String> patients = []; // List of patients who granted access
  String Doctorlicense = "Loading..."; // Default value while loading the license

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch the doctor's name
    _fetchLicense(); // Fetch the doctor's license
    
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

Future <void> _fetchLicense() async {
  try{
    String privateKey = Connector.key;
    print("Fetching user name for private key: $privateKey");

    // Derive Ethereum address from private key
    EthPrivateKey creds = EthPrivateKey.fromHex(privateKey);
    EthereumAddress address = await creds.extractAddress();

    String? license = await Connector.getDoctorLicense(address.hex);
    if (license.isNotEmpty) {
      print("Name retrieved: $license");
      setState(() {
        Doctorlicense = license;
      });
    } else {
      print("No name found for the user.");
      setState(() {
        Doctorlicense = "Unknown License";
      });
    }
  }catch (e){
    print("Error fetching license: $e");
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Sidebar remains intact
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Sidebar(
              isOpen: isSidebarOpen,
              onToggle: toggleSidebar,
              userName: userName,
              Doctorlicense: Doctorlicense,
              onSectionSelected: (section) {
                setState(() {
                  selectedSection = section; // Update the selected section
                });
              },
            ),
          ),
          // Main content area
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedSection == "Dashboard") ...[
                    ModernHeaderSection(userName: userName),
                    FeatureSection(),
                    WelcomeSection(),
                    WhyChooseUsSection(),
                    HowItWorksSection(),
                    FooterSection(),
                  ],
                  
                  if (selectedSection == "Patients") _buildPatientListSection(),
                  // if (selectedSection == "General Information") _buildGeneralInfoSection(),
                  if (selectedSection == "Medical Record") _buildMedicalRecordSection(),
                  if (selectedSection == "Medical Certificate") _buildMedicalCertificateSection(),
                  // Add other sections as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


Widget _buildPatientListSection() {
 return PatientListScreen();
 
}


  Widget _buildMedicalRecordSection() {
    final privateKey = Connector.key;
    final creds = EthPrivateKey.fromHex(privateKey);
    final address = creds.address.hexEip55;
    return DoctorMedicalRecords(doctorPublicKey: address);
}

Widget _buildMedicalCertificateSection(){
    return MedicalCertificate();
}
}

class Sidebar extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  final String userName;
  final Function(String) onSectionSelected;
  final String Doctorlicense;

  const Sidebar({
    required this.isOpen,
    required this.onToggle,
    required this.userName,
    required this.onSectionSelected,
    required this.Doctorlicense,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: isOpen ? 230 : 70,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        children: [
          // Logo section
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isOpen) SizedBox(width: 8),
              if (isOpen)
                Flexible(
                  child: Text(
                    "Vital Link Chain",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  ),
                ),
            ],
          ),
          Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: onToggle,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),


          // Profile section - Now using image instead of icon
          Column(
            children: [
              Container(
                width: isOpen ? 60 : 40, // Responsive sizing
                height: isOpen ? 60 : 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isOpen ? 30 : 20),
                  border: Border.all(
                    color: Colors.cyan.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isOpen ? 28 : 18),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 10),
            if (isOpen) ...[
            Text(
              "Dr. $userName",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("License No: $Doctorlicense", style: TextStyle(fontSize: 12)),
            SizedBox(height: 20),
            ]
          ],
          ),
          _buildSidebarItem(Icons.dashboard, "Dashboard", isOpen, onTap: () {
            onSectionSelected("Dashboard");
          }),
          // _buildSidebarItem(Icons.info_outline, "General Information", isOpen, onTap: () {
          //   onSectionSelected("General Information");
          // }),
          _buildSidebarItem(Icons.people, "Patients", isOpen, onTap: () {
            onSectionSelected("Patients");
          }),
          _buildSidebarItem(Icons.description, "Medical Certificate", isOpen, onTap: () {
            onSectionSelected("Medical Certificate");
          }),
          _buildSidebarItem(Icons.folder_shared, "Medical Record", isOpen, onTap: () {
            onSectionSelected("Medical Record");
          }),
          _buildSidebarItem(Icons.receipt_long, "Transactions", isOpen, onTap: () {
            onSectionSelected("Transactions");
          }),
          _buildSidebarItem(Icons.settings, "Settings", isOpen, onTap: () {
            onSectionSelected("Settings");
          }),
          Spacer(),
          _buildSidebarItem(Icons.help_center, "Help Center", isOpen, onTap: () {
            onSectionSelected("Help Center");
          }),
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


// Assuming Connector.name is accessible
class ModernHeaderSection extends StatefulWidget {
  final String userName;
  const ModernHeaderSection({super.key, required this.userName});

  @override
  State<ModernHeaderSection> createState() => _ModernHeaderSectionState();
}

class _ModernHeaderSectionState extends State<ModernHeaderSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[50],
      child: Column(
        children: [
          // Top Navigation Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF00BCD4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Vital Link Chain",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Home",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Stack(
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: const Text(
                              '1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    // User profile section
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white, width: 1),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.userName, // Access from widget
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Hero Section
          Container(
            padding: const EdgeInsets.all(40),
            child: Row(
              children: [
                // Left side - Text content
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Instant access, ultimate security",
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Your health data,\nour confidence.",
                        style: TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Add your action buttons here if needed
                    ],
                  ),
                ),

                const SizedBox(width: 40),

                // Right side - Image
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 500,
                    child: Image.asset(
                      'assets/images/Illustration.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class FeatureSection extends StatelessWidget {
  const FeatureSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FeatureCard(
            icon: Icons.event_available,
            title: "Online Appointment",
            description:
                "Book and manage your medical appointments anytime, anywhere with just a few clicks.",
          ),
          SizedBox(width: 40),
          FeatureCard(
            icon: Icons.local_hospital,
            title: "Clinic",
            description:
                "Access information about nearby clinics, services offered, and real-time availability for walk-ins or scheduled visits.",
          ),
          SizedBox(width: 40),
          FeatureCard(
            icon: Icons.security,
            title: "Secured Records",
            description:
                "Your medical history is stored with top-level encryption, ensuring your privacy and easy access whenever you need it.",
          ),
        ],
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      height: 350,
      padding: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF00BCD4),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
          SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          Container(width: 50, height: 3, color: Color(0xFF00BCD4)),
          SizedBox(height: 16),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40.0),
      color: Colors.grey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "WELCOME TO VITAL LINK CHAIN",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00BCD4),
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Where trust and transparency meets innovation",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Experience the future of healthcare data management with our blockchain-powered platform that ensures your medical information remains secure, accessible, and under your complete control.",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class WhyChooseUsSection extends StatelessWidget {
  const WhyChooseUsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(40),
      color: Colors.white,
      child: Column(
        children: [
          Text(
            "Why Choose Us?",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Discover the benefits of secure and accessible healthcare data.",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              WhyChooseUsCard(
                imagePath: 'assets/images/shield.svg',
                title: "Secure and Encrypted",
                description:
                    "Your data is protected with advanced security protocols.",
              ),
              WhyChooseUsCard(
                imagePath: 'assets/images/block.png',
                title: "Blockchain and Security",
                description:
                    "Medical data is stored using blockchain technology for secure record-keeping.",
              ),
              WhyChooseUsCard(
                imagePath: 'assets/images/clipboard.svg',
                title: "Instant Medical Records",
                description: "View and update your records anytime.",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WhyChooseUsCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const WhyChooseUsCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  bool get isSvg => imagePath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 390,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Center(
              child:
                  isSvg
                      ? SvgPicture.asset(
                        imagePath,
                        width: 60,
                        height: 120,
                        fit: BoxFit.contain,
                      )
                      : Image.asset(
                        imagePath,
                        width: 80,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
            ),
          ),
          SizedBox(height: 24),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 20,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            "How it works",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Simple steps to secure your health data",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StepCard(
                step: "1",
                title: "Register",
                description: "Create your secure account",
              ),
              StepCard(
                step: "2",
                title: "Connect",
                description: "Link with healthcare providers",
              ),
              StepCard(
                step: "3",
                title: "Manage",
                description: "Control your data access",
              ),
              StepCard(
                step: "4",
                title: "Share",
                description: "Share securely when needed",
              ),
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
  final String description;

  const StepCard({
    super.key,
    required this.step,
    required this.title,
    this.description = "",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xFF00BCD4),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00BCD4).withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              step,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        if (description.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF00BCD4),
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            "Vital Link Chain",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Quick Links",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Home", style: TextStyle(color: Colors.white70)),
                  Text("Features", style: TextStyle(color: Colors.white70)),
                  Text("Contact Us", style: TextStyle(color: Colors.white70)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Contact Us",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "vital@link.com",
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text("+1234567890", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Divider(color: Colors.white30),
          SizedBox(height: 10),
          Text(
            "© 2024 Vital Link Chain. All rights reserved.",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
