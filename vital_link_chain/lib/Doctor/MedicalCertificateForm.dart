import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:web3dart/web3dart.dart';

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
  final TextEditingController nameController = TextEditingController();
  final apiBaseUrl = dotenv.env['API_BASE_URL'];

  RoleType? selectedRole;
  bool isEnrollment = false;
  bool isOtherPurpose = false;
  bool isLoading = false;
  DateTime? selectedDate;
  DateTime? selectedVisitedDate;
  DateTime? selectedValidityDate;

  @override
void initState() {
  super.initState();
  _fetchLatestMedicalApplication();
}

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _fetchLatestMedicalApplication() async {
  final patientAddress = widget.patient['address'];
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
        nameController.text = formData['Full Name'] ?? '';
        dobController.text = formData['Date of Birth'] ?? '';
        ageController.text = formData['Age'] ?? '';
        sexController.text = formData['Sex'] ?? '';
        civilStatusController.text = formData['Civil Status'] ?? '';
        residentController.text = formData['Address'] ?? '';
        // Add more fields as needed
      });
    }
  }
}

  Future<void> _pickVisitedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedVisitedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedVisitedDate = picked;
        visitedController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickValidityDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedValidityDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedValidityDate = picked;
        validityController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

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
    nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => isLoading = true);

    final credentials = EthPrivateKey.fromHex(Connector.key);
    final address = await credentials.extractAddress();
    String doctorAddress = address.hex;
    String doctorName = await Connector.getName(doctorAddress);
    String fee = await Connector.getCertificateFee(doctorAddress);

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
      "validity": validityController.text,
      "name": nameController.text,
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
    };

    final content = jsonEncode(certData);

    try {
      // await Connector.issueCertificate(
      //   content,
      //   widget.patient['address']!,
      //   Connector.key,
      // );
      final txHash = await Connector.issueCertificate(
        content,
        widget.patient['address']!,
        Connector.key,
      );

      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/certificates'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "patientAddress": widget.patient['address'],
          "doctorAddress": doctorAddress,
          "content": content,
          "txHash": txHash,
        }),
      );
      print('Backend response: ${response.statusCode} ${response.body}');
      print("Transaction Hash for Certificate: $txHash");
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
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 85, 199, 221),
                    borderRadius: BorderRadius.only(
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
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 85, 199, 221),
                    borderRadius: BorderRadius.only(
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
                        child: Text('2', style: TextStyle(color: Colors.black)),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Medical Certificate',
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
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
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
                    const SizedBox(height: 8),
                    const Text("Date of birth"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: const InputDecoration(
                        hintText: 'dd/mm/yyyy',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Patient:"),
                    Column(
                      children: [
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
                    if (selectedRole == RoleType.others)
                      TextField(
                        controller: otherReasonController,
                        decoration: const InputDecoration(
                          hintText: "Specify other reasons",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      "To Whom It May Concern:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text("This is to certify that"),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'Full Name',
                              enabledBorder: UnderlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: ageController,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: sexController,
                            decoration: const InputDecoration(
                              labelText: 'Sex',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: civilStatusController,
                            decoration: const InputDecoration(
                              labelText: 'Civil Status',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: residentController,
                      decoration: const InputDecoration(
                        labelText: 'Resident of:',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: visitedController,
                      readOnly: true,
                      onTap: () => _pickVisitedDate(context),
                      decoration: const InputDecoration(
                        labelText: 'Visited the clinic on:',
                        border: UnderlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: validityController,
                      readOnly: true,
                      onTap: () => _pickValidityDate(context),
                      decoration: const InputDecoration(
                        labelText: 'Validity of Certificate:',
                        border: UnderlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "This medical certificate is issued for the purpose of:",
                    ),
                    CheckboxListTile(
                      value: isEnrollment,
                      onChanged:
                          (v) => setState(() => isEnrollment = v ?? false),
                      title: const Text("Enrollment"),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    TextField(
                      controller: participationController,
                      decoration: const InputDecoration(
                        labelText: 'Participation in:',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    CheckboxListTile(
                      value: isOtherPurpose,
                      onChanged:
                          (v) => setState(() => isOtherPurpose = v ?? false),
                      title: const Text("Others:"),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 10),
                    const Text("Remarks and Recommendations:"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: remarksController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Enter medical details here...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("University Dentist"),
                            SizedBox(height: 4),
                            Text("License No.: ____________________"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("University Physician"),
                            SizedBox(height: 4),
                            Text("License No.: ____________________"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child:
                          isLoading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 15,
                                  ),
                                ),
                                onPressed: _submit,
                                child: const Text("Issue Certificate"),
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
