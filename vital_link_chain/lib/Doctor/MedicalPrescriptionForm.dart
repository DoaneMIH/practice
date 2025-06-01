import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:web3dart/web3dart.dart';

class MedicalPrescriptionForm extends StatefulWidget {
  final String patientAddress;
  const MedicalPrescriptionForm({super.key, required this.patientAddress});

  @override
  _MedicalPrescriptionFormState createState() => _MedicalPrescriptionFormState();
}

class _MedicalPrescriptionFormState extends State<MedicalPrescriptionForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _ptrController = TextEditingController();
  final TextEditingController _s2Controller = TextEditingController();
  final apiBaseUrl = dotenv.env['API_BASE_URL'];

    @override
void initState() {
  super.initState();
  _fetchLatestMedicalApplication();
  _fetchDoctorLicenseNumber();
}

  Future<void> _selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), // Changed this to current date
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
  );
  if (pickedDate != null) {
    setState(() {
      _dobController.text =
          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";
    });
  }
}

Future<void> _fetchDoctorLicenseNumber() async {
  try {
    final credentials = EthPrivateKey.fromHex(Connector.key);
    final doctorAddress = await credentials.extractAddress();
    final licenseNumber = await Connector.getDoctorLicense(doctorAddress.hex);
    setState(() {
      _licenseController.text = licenseNumber ?? '';
    });
  } catch (e) {
    print("Error fetching license number: $e");
  }
}

Future<void> _fetchLatestMedicalApplication() async {
  final patientAddress = widget.patientAddress;
  final response = await http.get(
    Uri.parse('$apiBaseUrl/api/medical-applications/$patientAddress'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> apps = jsonDecode(response.body);
    if (apps.isNotEmpty) {
      // Assuming the latest is the last one (or sort by date if needed)
      final latest = apps.last;
      final formData = latest['formData'] as Map<String, dynamic>;
      // Fill controllers with data
      setState(() {
        _nameController.text = formData['Full Name'] ?? '';
        _ageController.text = formData['Age'] ?? '';
        _dobController.text = formData['Date of Birth'] ?? '';
        // Add more fields if needed
      });
    }
  }
}

 Future<void> _sendPrescription() async {
  try {
    final credentials = EthPrivateKey.fromHex(Connector.key);
    final doctorAddress = await credentials.extractAddress();
    final now = DateTime.now().toIso8601String();

    // Gather all form data
    final fullName = _nameController.text.trim();
    final age = _ageController.text.trim();
    final dob = _dobController.text.trim();
    final notes = _notesController.text.trim();
    final license = _licenseController.text.trim();
    final ptr = _ptrController.text.trim();
    final s2 = _s2Controller.text.trim();

    // Compose prescription string
    final prescription = "$fullName#$age#$dob#$notes#$license#$ptr#$s2#$now#${doctorAddress.hex}";

    print("Sending prescription with:");
    print("  patientAddress: ${widget.patientAddress}");
    print("  doctorAddress: ${doctorAddress.hex}");
    print("  prescription: $prescription");

    // Send to blockchain
    final txHash = await Connector.setPrescription(
      prescription,
      widget.patientAddress,
      Connector.key
    );

    // Send to backend
    await http.post(
      Uri.parse('$apiBaseUrl/api/prescriptions'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "patientAddress": widget.patientAddress,
        "doctorAddress": doctorAddress.hex,
        "content": prescription,
        "txHash": txHash,
      }),
    );

    print("Prescription issued with txHash: $txHash");
    Fluttertoast.showToast(msg: "Prescription sent!");
    Navigator.pop(context);
    // Optionally: _showQR(txHash);
  } catch (e) {
    print("❌ Error sending prescription: $e");
    Fluttertoast.showToast(msg: "Failed to send prescription: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 231, 231),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Row(
              children: [
                Container(
                  width: 215,
                  height: 75,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 85, 199, 221),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Vital Link Chain',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  children: const [
                    Text(
                      'West Visayas State University',
                      style: TextStyle(
                        color: Color.fromARGB(255, 7, 3, 3),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'La Paz, Iloilo City',
                      style: TextStyle(
                        color: Color.fromARGB(255, 92, 90, 90),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Tel. No. 3203070 (703)',
                      style: TextStyle(
                        color: Color.fromARGB(255, 92, 90, 90),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 215,
                  height: 75,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 85, 199, 221),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: Text(
                          '1',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Medical Prescription',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                    ),
                    const SizedBox(height: 10),

                    const Text(
                      "Patient's Section",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: "Full Name",
                              hintText: "Enter your name",
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _ageController,
                            decoration: const InputDecoration(
                              labelText: "Age",
                              hintText: "Enter age",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: const InputDecoration(
                        labelText: "Date of birth",
                        hintText: "dd/mm/yyyy",
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _notesController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: "Medical Notes",
                        hintText: "Enter medical details here...",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Doctor's Section",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _licenseController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: "License No.",
                              hintText: "Enter your license no.",
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _ptrController,
                            decoration: const InputDecoration(
                              labelText: "PTR No.",
                              hintText: "Enter your ptr no.",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _s2Controller,
                      decoration: const InputDecoration(
                        labelText: "S2 No.",
                        hintText: "Enter your S2 no.",
                      ),
                    ),

                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Signature upload logic here
                            },
                            child: const Text(
                              "*upload signature",
                              style: TextStyle(
                                color: Colors.blue,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text("M.D. Signature"),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _sendPrescription,
                        child: const Text(
                          "Submit Prescription",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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