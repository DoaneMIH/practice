import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:web3dart/web3dart.dart';

import '../Utility/connector.dart'; // Adjust the import path as needed

enum RoleType { student, faculty, staff, others }

class MedicalCertificateForm extends StatefulWidget {
  final Map<String, String> patient;

  const MedicalCertificateForm({super.key, required this.patient});

  @override
  State<MedicalCertificateForm> createState() => _MedicalCertificateFormState();
}

class _MedicalCertificateFormState extends State<MedicalCertificateForm> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController otherReasonController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController civilStatusController = TextEditingController();
  final TextEditingController residentController = TextEditingController();
  final TextEditingController visitedController = TextEditingController();
  final TextEditingController participationController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController validityController = TextEditingController();
  RoleType? selectedRole;

  bool isEnrollment = false;
  bool isOtherPurpose = false;
  bool isLoading = false;

  @override
  void dispose() {
    dobController.dispose();
    otherReasonController.dispose();
    ageController.dispose();
    sexController.dispose();
    civilStatusController.dispose();
    residentController.dispose();
    visitedController.dispose();
    participationController.dispose();
    remarksController.dispose();
    validityController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => isLoading = true);

    // Get doctor info
    final credentials = EthPrivateKey.fromHex(Connector.key);
    final address = await credentials.extractAddress();
    String doctorAddress = address.hex;
    String doctorName = await Connector.getName(doctorAddress);
    String fee = await Connector.getCertificateFee(doctorAddress);

    // Compose the certificate content as a JSON string
    final certData = {
      "date": DateTime.now().toIso8601String(),
      "dob": dobController.text,
      "role": selectedRole?.name ?? "Not specified",
      "otherReason": otherReasonController.text,
      "age": ageController.text,
      "sex": sexController.text,
      "civilStatus": civilStatusController.text,
      "resident": residentController.text,
      "visitedClinicOn": visitedController.text,
      "validity": validityController.text, // <-- Add this line
      "purpose": {
        "enrollment": isEnrollment,
        "participation": participationController.text,
        "otherPurpose": isOtherPurpose,
      },
      "remarks": remarksController.text,
      "doctor": doctorName,
      "doctorAddress": doctorAddress,
      "institution": "WVSU Clinic",
      "fee": fee,
      "status": "valid",
      // "blockchain": "", // Optionally fill with tx hash after issuing
    };

    final content = jsonEncode(certData);

    try {
      await Connector.issueCertificate(
        content,
        widget.patient['address']!,
        Connector.key, // Doctor's private key
      );
      Fluttertoast.showToast(msg: "Certificate issued!");
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Certificate"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: const [
                  Text(
                    "West Visayas State University",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "La Paz, Iloilo City\nTel No. 3203070 (703)",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dobController,
              decoration: const InputDecoration(labelText: "Date of Birth"),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select one:"),
                RadioListTile<RoleType>(
                  title: const Text('Student'),
                  value: RoleType.student,
                  groupValue: selectedRole,
                  onChanged: (RoleType? value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                ),
                RadioListTile<RoleType>(
                  title: const Text('Faculty'),
                  value: RoleType.faculty,
                  groupValue: selectedRole,
                  onChanged: (RoleType? value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                ),
                RadioListTile<RoleType>(
                  title: const Text('Staff'),
                  value: RoleType.staff,
                  groupValue: selectedRole,
                  onChanged: (RoleType? value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                ),
                RadioListTile<RoleType>(
                  title: const Text('Others'),
                  value: RoleType.others,
                  groupValue: selectedRole,
                  onChanged: (RoleType? value) {
                    setState(() {
                      selectedRole = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: otherReasonController,
              decoration: const InputDecoration(
                hintText: "Specify other reasons",
              ),
            ),
            const Divider(height: 30),
            const Text("To Whom It May Concern:"),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: "Age"),
            ),
            TextField(
              controller: sexController,
              decoration: const InputDecoration(labelText: "Sex"),
            ),
            TextField(
              controller: civilStatusController,
              decoration: const InputDecoration(labelText: "Civil Status"),
            ),
            TextField(
              controller: residentController,
              decoration: const InputDecoration(labelText: "Resident of"),
            ),
            TextField(
              controller: visitedController,
              decoration: const InputDecoration(
                labelText: "Visited the clinic on",
              ),
            ),
            TextField(
              controller: validityController,
              decoration: const InputDecoration(labelText: "Validity Period"),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              value: isEnrollment,
              onChanged: (v) => setState(() => isEnrollment = v ?? false),
              title: const Text("Enrollment"),
            ),
            TextField(
              controller: participationController,
              decoration: const InputDecoration(labelText: "Participation in"),
            ),
            CheckboxListTile(
              value: isOtherPurpose,
              onChanged: (v) => setState(() => isOtherPurpose = v ?? false),
              title: const Text("Others"),
            ),
            const SizedBox(height: 10),
            const Text("Remarks and Recommendations:"),
            TextField(
              controller: remarksController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Enter medical details here...",
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("University Dentist"),
                      Text("License No.: __________________"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("University Physician"),
                      Text("License No.: __________________"),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child:
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _submit,
                        child: const Text("Issue Certificate"),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
