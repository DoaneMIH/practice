import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:web3dart/web3dart.dart';
// import 'package:web3dart/web3dart.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  List<String> patients = [];
  final TextEditingController patientAddress = TextEditingController();
  // final TextEditingController feeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController vitalsController = TextEditingController();
  final TextEditingController medicinesController = TextEditingController();
  final TextEditingController adviceController = TextEditingController();
  String _status = '';
  bool showLoading = false;
  // BigInt feeController = 10000000000000000;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
    _setDefaultDoctorFee();
  }

  Future<void> _fetchPatients() async {
    try {
      String privateKey = Connector.key;

      List<Map<String, String>> fetchedPatients =
          await Connector.getPatientsForDoctor(privateKey);

      setState(() {
        patients =
            fetchedPatients.map((patient) {
              return jsonEncode(patient);
            }).toList();
      });
    } catch (e) {
      print("Error fetching patients: $e");
      Fluttertoast.showToast(msg: "Error fetching patients");
    }
  }

  Future<void> _requestAccessFromPatient(String patientAddress) async {
    try {
      await Connector.requestAccessToPatient(Connector.key, patientAddress);

      Fluttertoast.showToast(
        msg: "Access request sent to patient $patientAddress",
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      print("❌ Error requesting access: $e");
      Fluttertoast.showToast(msg: "Failed to request access");
    }
  }

  /// Save record metadata to the backend
  Future<void> _saveRecordMetadata(
    String patientAddress,
    String fileName,
    String ipfsHash,
  ) async {
    final ethPrivateKey = EthPrivateKey.fromHex(Connector.key);
    final EthereumAddress publicKey = await ethPrivateKey.extractAddress();

    final uri = Uri.parse('http://localhost:3000/api/records');
    final body = jsonEncode({
      'patientAddress': patientAddress,
      'fileName': fileName,
      'ipfsHash': ipfsHash,
      'doctorPublicKey': publicKey.hex,
    });

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 201) {
        print("✅ Metadata saved to backend!");
      } else {
        print("❌ Failed to save metadata: ${response.body}");
      }
    } catch (e) {
      print("❌ Error saving metadata: $e");
    }
  }

  /// Generate PDF in-memory
  Future<Uint8List> _generatePdfBytes(
    String diagnosis,
    String doctor,
    String date,
    String notes,
  ) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build:
            (_) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Diagnosis: $diagnosis'),
                pw.SizedBox(height: 8),
                pw.Text('Doctor: $doctor'),
                pw.SizedBox(height: 8),
                pw.Text('Date: $date'),
                pw.SizedBox(height: 8),
                pw.Text('Notes: $notes'),
              ],
            ),
      ),
    );
    return pdf.save();
  }

  /// Upload to Pinata
  Future<String> _uploadToPinata(Uint8List bytes) async {
    const apiKey = 'bdd036bcfbcde858a1a1';
    const apiSecret =
        '032489ba73f168172806135b085f8c9654d175aba20e7973749ab57640cbe654';
    final uri = Uri.parse('https://api.pinata.cloud/pinning/pinFileToIPFS');

    final req =
        http.MultipartRequest('POST', uri)
          ..headers.addAll({
            'pinata_api_key': apiKey,
            'pinata_secret_api_key': apiSecret,
          })
          ..files.add(
            http.MultipartFile.fromBytes(
              'file',
              bytes,
              filename: 'certificate.pdf',
              contentType: MediaType('application', 'pdf'),
            ),
          );

    final res = await req.send();
    final body = await http.Response.fromStream(res);
    if (res.statusCode == 200) {
      final data = jsonDecode(body.body);
      return data['IpfsHash'] as String;
    }
    throw Exception('Pinata upload failed: ${res.statusCode}\n${body.body}');
  }

  Future<void> _generateAndUploadCertificate(
    String patientName,
    String patientAddress,
  ) async {
    final diagCtrl = TextEditingController();
    final docCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Generate Certificate for $patientName'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: diagCtrl,
                  decoration: const InputDecoration(labelText: 'Diagnosis'),
                ),
                TextField(
                  controller: docCtrl,
                  decoration: const InputDecoration(labelText: 'Doctor'),
                ),
                TextField(
                  controller: dateCtrl,
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => _status = 'Generating PDF…');
                try {
                  final pdfBytes = await _generatePdfBytes(
                    diagCtrl.text,
                    docCtrl.text,
                    dateCtrl.text,
                    notesCtrl.text,
                  );
                  setState(() => _status = 'Uploading to IPFS via Pinata…');
                  final cid = await _uploadToPinata(pdfBytes);
                  setState(() => _status = '✅ Uploaded! CID: $cid');

                  // Save metadata to the backend
                  await _saveRecordMetadata(
                    patientAddress,
                    'certificate.pdf',
                    cid,
                  );

                  Fluttertoast.showToast(
                    msg: 'Certificate uploaded successfully!\nCID: $cid',
                  );
                } catch (e) {
                  setState(() => _status = 'Upload failed: $e');
                  Fluttertoast.showToast(msg: 'Failed to upload certificate.');
                }
              },
              child: const Text('Generate & Upload'),
            ),
          ],
        );
      },
    );
  }

  //Prescription Added
  void updateFee(String newAmount) async {
    if (newAmount.isEmpty) {
      Fluttertoast.showToast(msg: "Amount cannot be empty");
      return;
    }
    setState(() {
      showLoading = true;
    });
    await Connector.updateFee(newAmount);
    Fluttertoast.showToast(
      msg: "Fee updated successfully for the patient.",
      backgroundColor: Colors.green,
    );
    setState(() {
      showLoading = false;
    });
  }

  void getFee() async {
    // feeController = await Connector.getFee(Connector.address);
    await Connector.getFee(Connector.address);
    setState(() {});
  }

  Future<void> _showPrescriptionForm(String patientAddress) async {
    final notesController = TextEditingController();
    final vitalsController = TextEditingController();
    final medicinesController = TextEditingController();
    final adviceController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Send Prescription"),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(labelText: "Notes"),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Notes cannot be empty"
                                  : null,
                      maxLines: null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: vitalsController,
                      decoration: const InputDecoration(labelText: "Vitals"),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Vitals cannot be empty"
                                  : null,
                      maxLines: null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: medicinesController,
                      decoration: const InputDecoration(labelText: "Medicines"),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Medicines cannot be empty"
                                  : null,
                      maxLines: null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: adviceController,
                      decoration: const InputDecoration(labelText: "Advice"),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Advice cannot be empty"
                                  : null,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context); // Close dialog
                    await _sendPrescription(
                      patientAddress,
                      notesController.text,
                      vitalsController.text,
                      medicinesController.text,
                      adviceController.text,
                    );
                  }
                },
                child: const Text("Send"),
              ),
            ],
          ),
    );
  }

  // Helper to send prescription (implement this to call your contract)
 Future<void> _sendPrescription(
  String patientAddress,
  String notes,
  String vitals,
  String medicines,
  String advice,
) async {
  try {
    // final prescription = "$notes#$vitals#$medicines#$advice";
        final credentials = EthPrivateKey.fromHex(Connector.key);
final doctorAddress = await credentials.extractAddress();
    final now = DateTime.now().toIso8601String();
final prescription = "$notes#$vitals#$medicines#$advice#$now#${doctorAddress.hex}";

print("Sending prescription with:");
print("  patientAddress: $patientAddress");
print("  doctorAddress: ${doctorAddress.hex}");
print("  prescription: $prescription");
    await Connector.setPrescription(
      prescription,
      patientAddress,
      doctorAddress.hex, // Doctor's address as string
      Connector.key,
    );
    Fluttertoast.showToast(msg: "Prescription sent!");
  } catch (e) {
    print ("❌ Error sending prescription: $e");
    Fluttertoast.showToast(msg: "Failed to send prescription: $e");
  }
}

Future<void> _setDefaultDoctorFee() async {
  try {
    // Set your default fee here (e.g., 0.01 ETH in wei)
    const defaultFee = "10000000000000000"; // 0.01 ETH in wei
    await Connector.updateFee(defaultFee);
    print("Default doctor fee set to $defaultFee wei");
  } catch (e) {
    print("Error setting default doctor fee: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Request Access to Patient",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: patientAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter Patient's Public Key",
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed:
                () => _requestAccessFromPatient(patientAddress.text.trim()),
            child: const Text("Request Access"),
          ),
          const SizedBox(height: 20),
          const Text(
            "Patients Who Granted Access",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          patients.isEmpty
              ? const Text("No patients have granted access.")
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> patient = jsonDecode(patients[index]);

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(patient["name"] ?? "Unknown"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Public Key: ${patient["address"]}"),
                          Text("Granted At: ${patient["timestamp"]}"),
                          const SizedBox(height: 5),
                          // TextField(
                          //   controller: feeController,
                          //   decoration: const InputDecoration(
                          //     border: OutlineInputBorder(),
                          //     labelText: "Enter Fee (in Wei)",
                          //   ),
                          //   keyboardType: TextInputType.number,
                          // ),
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     await Connector.updateFee(feeController.text);
                          //     Fluttertoast.showToast(msg: "Fee updated!");
                          //   },
                          //   child: Text("Set Fee"),
                          // ),
                          // const SizedBox(height: 5),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed:
                                    () => _generateAndUploadCertificate(
                                      patient["name"],
                                      patient["address"],
                                    ),
                                icon: const Icon(Icons.upload),
                                label: const Text(
                                  "Generate & Upload Certificate",
                                ),
                              ),
                              const SizedBox(width: 5),
                              ElevatedButton.icon(
                                onPressed:
                                    () => _showPrescriptionForm(
                                      patient["address"],
                                    ),
                                icon: const Icon(Icons.medical_services),
                                label: const Text("Send Prescription"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          const SizedBox(height: 20),
          SelectableText(_status, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
