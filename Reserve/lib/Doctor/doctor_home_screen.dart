import 'package:flutter/material.dart';
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
                  if (selectedSection == "Dashboard") WelcomeSection(),
                  if (selectedSection == "Patients") _buildPatientListSection(),
                  if (selectedSection == "General Information") _buildGeneralInfoSection(),
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

  Widget _buildMedicalRecordSection() {
    final privateKey = Connector.key;
    final creds = EthPrivateKey.fromHex(privateKey);
    final address = creds.address.hexEip55;
    return DoctorMedicalRecords(doctorPublicKey: address);
}

Widget _buildMedicalCertificateSection(){
  // MedicalCertificateScreen(
  //   doctorPublicKey: Connector.key,
  //   patientAddress: patients[0], // Example, replace with actual patient address
  // );
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
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          ),
          if (isOpen) ...[
            CircleAvatar(radius: 30),
            SizedBox(height: 10),
            Text(
              "Dr. $userName",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("License No: $Doctorlicense", style: TextStyle(fontSize: 12)),
            SizedBox(height: 20),
          ],
          _buildSidebarItem(Icons.dashboard, "Dashboard", isOpen, onTap: () {
            onSectionSelected("Dashboard");
          }),
          _buildSidebarItem(Icons.info_outline, "General Information", isOpen, onTap: () {
            onSectionSelected("General Information");
          }),
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