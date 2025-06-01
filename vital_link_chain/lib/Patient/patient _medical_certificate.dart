import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vital_link_chain/Patient/patient_view_medical_certificate.dart';
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:web3dart/web3dart.dart';

class PatientMedicalCertificate extends StatefulWidget {
  const PatientMedicalCertificate({super.key});

  @override
  State<PatientMedicalCertificate> createState() =>
      _PatientMedicalCertificateState();
}

class _PatientMedicalCertificateState extends State<PatientMedicalCertificate> {
  List<Map<String, dynamic>> certificates = [];
  bool isLoading = true;
  List<Map<String, dynamic>> _certificates = [];
  final apiBaseUrl = dotenv.env['API_BASE_URL'];

  @override
  void initState() {
    super.initState();
    fetchCertificates();
    _loadCertificate();
  }

  Future<void> _loadCertificate() async {
    setState(() => isLoading = true);
    final credentials = EthPrivateKey.fromHex(Connector.key);
    final patientAddress = (await credentials.extractAddress()).hex;
    final backendCertificate = await _fetchBackendCertificate(patientAddress);
    setState(() {
      _certificates = backendCertificate;
      isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchBackendCertificate(
    String patientAddress,
  ) async {
    final uri = Uri.parse(
      '$apiBaseUrl/api/certificates/$patientAddress',
    );
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map<Map<String, dynamic>>((certi) {
          final cert = certi as Map<String, dynamic>;
          final content =
              cert['content'] != null ? jsonDecode(cert['content']) : {};
          return {
            ...content, // <-- this spreads all fields from the certificate content
            'txHash': cert['txHash']?.toString() ?? 'No txHash',
            'issuedAt': cert['issuedAt']?.toString() ?? 'Unknown',
            'rawJson': cert['content'] ?? '',
          };
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
  // Future<void> fetchCertificates() async {
  //   setState(() => isLoading = true);
  //   try {
  //     final credentials = EthPrivateKey.fromHex(Connector.key);
  //     final patientAddress = (await credentials.extractAddress()).hex;
  //     final backendCertificate = await _fetchBackendCertificate(patientAddress);

  //     // Map backendCertificate to List<Map<String, dynamic>>
  //     certificates = backendCertificate.map((cert) => Map<String, dynamic>.from(cert)).toList();

  //     final certStrings = await Connector.getCertificatesForPatient(
  //       patientAddress,
  //     );

  //     certificates =
  //         certStrings.map((certJson) {
  //           try {
  //             // Try to decode as JSON
  //             final certMap = jsonDecode(certJson);
  //             if (certMap is Map<String, dynamic>) {
  //               // --- Add this block to auto-expire ---
  //               String validityStr = certMap["validity"]?.toString() ?? "";
  //               DateTime? validityDate;
  //               try {
  //                 validityDate = DateTime.parse(validityStr);
  //               } catch (_) {
  //                 validityDate = null;
  //               }
  //               String status = certMap["status"]?.toString() ?? "valid";
  //               if (validityDate != null &&
  //                   DateTime.now().isAfter(validityDate)) {
  //                 status = "expired";
  //               }
  //               // --- End block ---
  //               return {
  //                 "date": certMap["date"]?.toString() ?? "",
  //                 "doctor": certMap["doctor"]?.toString() ?? "",
  //                 "reason": certMap["reason"]?.toString() ?? "",
  //                 "status": status,
  //                 "institution": certMap["institution"]?.toString() ?? "",
  //                 "purpose": certMap["purpose"],
  //                 "validity": certMap["validity"]?.toString() ?? "",
  //                 "blockchain": certMap["blockchain"]?.toString() ?? "",
  //                 "doctorAddress": certMap["doctorAddress"]?.toString() ?? "",
  //                 "fee": certMap["fee"]?.toString() ?? "0",
  //                 "txHash":
  //                     certMap["txHash"]?.toString() ?? "", // <-- Add this line
  //                 "rawJson": certJson, // <-- add this line
  //               };
  //             } else {
  //               // If not a map, fallback to string
  //               return {
  //                 "date": "",
  //                 "doctor": "",
  //                 "reason": certJson.toString(),
  //                 "status": "",
  //                 "institution": "",
  //                 "purpose": "",
  //                 "validity": "",
  //                 "blockchain": "",
  //                 "doctorAddress": "",
  //                 "fee": "0",
  //                 "rawJson": certJson,
  //               };
  //             }
  //           } catch (_) {
  //             // If not JSON, fallback to string
  //             return {
  //               "date": "",
  //               "doctor": "",
  //               "reason": certJson.toString(),
  //               "status": "",
  //               "institution": "",
  //               "purpose": "",
  //               "validity": "",
  //               "blockchain": "",
  //               "doctorAddress": "",
  //               "fee": "0",
  //               "rawJson": certJson,
  //             };
  //           }
  //         }).toList();
  //     // Sort certificates by date descending (latest first)
  //     certificates.sort((a, b) {
  //       final dateA = DateTime.tryParse(a["date"] ?? "") ?? DateTime(1900);
  //       final dateB = DateTime.tryParse(b["date"] ?? "") ?? DateTime(1900);
  //       return dateB.compareTo(dateA);
  //     });
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: "Failed to fetch certificates: $e");
  //     certificates = [];
  //     _certificates = [];
  //   }
  //   setState(() => isLoading = false);
  // }

  Future<void> fetchCertificates() async {
    setState(() => isLoading = true);
    try {
      final credentials = EthPrivateKey.fromHex(Connector.key);
      final patientAddress = (await credentials.extractAddress()).hex;
      final backendCertificate = await _fetchBackendCertificate(patientAddress);

      // Use only backend data (with ...content spread)
      certificates = backendCertificate;

      // Sort certificates by date descending (latest first)
      certificates.sort((a, b) {
        final dateA = DateTime.tryParse(a["date"] ?? "") ?? DateTime(1900);
        final dateB = DateTime.tryParse(b["date"] ?? "") ?? DateTime(1900);
        return dateB.compareTo(dateA);
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to fetch certificates: $e");
      certificates = [];
    }
    setState(() => isLoading = false);
  }

  Future<void> payForCertificate(String doctorAddress, String fee) async {
    setState(() => isLoading = true); // Start loading

    try {
      await Connector.payForCertificate(doctorAddress, fee);
      Fluttertoast.showToast(msg: "Payment successful!");

      await fetchCertificates(); // Refresh the list
    } catch (e) {
      Fluttertoast.showToast(msg: "Payment failed: $e");
      setState(() => isLoading = false); // Stop loading on error
    }
  }

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    // Get the current patient's address (replace with your actual logic)
    final credentials = EthPrivateKey.fromHex(Connector.key);
    final patientAddress = (await credentials.extractAddress()).hex;

    // 1. Get granted doctors from HealthSystem
    final grantedDoctors = await Connector.getGrantedDoctors(patientAddress);

    // 2. For each doctor, fetch their certificate fee from MedicalCertificate
    List<Map<String, dynamic>> doctorsWithFees = [];
    for (final doctor in grantedDoctors) {
      final doctorAddress = doctor["address"];
      final doctorName = doctor["name"];
      String fee = await Connector.getCertificateFee(doctorAddress);
      doctorsWithFees.add({
        "name": doctorName,
        "address": doctorAddress,
        "fee": fee,
      });
    }
    return doctorsWithFees;
  }

  // Widget _doctorList(List<Map<String, dynamic>> doctors) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "Available Doctors",
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //       ),
  //       const SizedBox(height: 8),
  //       ...doctors.map(
  //         (doctor) => Card(
  //           child: ListTile(
  //             title: Text(doctor["name"]),
  //             subtitle: Text("Fee: ${doctor["fee"]} wei"),
  //             trailing: ElevatedButton(
  //               onPressed: () async {
  //                 await payForCertificate(doctor["address"], doctor["fee"]);
  //               },
  //               child: const Text("Pay for Certificate"),
  //             ),
  //           ),
  //         ),
  //       ),
  //       const SizedBox(height: 24),
  //     ],
  //   );
  // }

  String _purposeToString(dynamic purpose) {
    if (purpose is String) return purpose;
    if (purpose is Map) {
      List<String> parts = [];
      if (purpose["enrollment"] == true) parts.add("Enrollment");
      if ((purpose["participation"] ?? "").toString().isNotEmpty)
        parts.add("Participation: ${purpose["participation"]}");
      if (purpose["otherPurpose"] == true) parts.add("Other");
      return parts.join(", ");
    }
    return "";
  }

  void _showQR(String txHash) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Certificate QR Code"),
            content: SizedBox(
              height: 220,
              width: 220,
              child:
                  txHash.isNotEmpty
                      ? QrImageView(
                        data: jsonEncode({"txHash": txHash}),
                        version: QrVersions.auto,
                        size: 200.0,
                      )
                      : const Center(
                        child: Text(
                          "TxHash not available from on-chain data.\nPlease ask your doctor for the QR code.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final latest = certificates.isNotEmpty ? certificates.first : null;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
          onRefresh: fetchCertificates,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchDoctors(),
            builder: (context, snapshot) {
              // final doctors = snapshot.data ?? [];
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // if (doctors.isNotEmpty)
                    // ...existing code for latest certificate and history...
                    // Latest Medical Certificate & Verification
                    if (latest != null)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Latest Medical Certificate
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Latest Medical Certificate",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _infoRow("Issue Date:", latest["date"]),
                                  _infoRow("Issuing Doctor:", latest["doctor"]),
                                  _infoRow(
                                    "Purpose:",
                                    _purposeToString(latest["purpose"]),
                                    bold: true,
                                  ),
                                  _infoRow(
                                    "Institution:",
                                    latest["institution"],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Status:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              latest["status"] == "valid"
                                                  ? Colors.green[100]
                                                  : Colors.red[100],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          latest["status"] == "valid"
                                              ? "Valid"
                                              : "Expired",
                                          style: TextStyle(
                                            color:
                                                latest["status"] == "valid"
                                                    ? Colors.green[800]
                                                    : Colors.red[800],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  _infoRow(
                                    "Validity Period:",
                                    latest["validity"],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Verification
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              margin: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Verification",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text("Blockchain Certificate"),
                                  // _infoRow(
                                  //   "Transaction Hash",
                                  //   latest["txHash"] ?? "No txHash",
                                  //   // bold: true,
                                  // ),
                                  Text(
                                    latest["txHash"] ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 147, 199, 241),
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // TODO: Download PDF logic
                                        },
                                        child: const Text("Download PDF"),
                                      ),
                                      const SizedBox(width: 16),
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => ViewMedicalCertificate(
                                                    jsonData:
                                                        latest["rawJson"] ?? "",
                                                  ),
                                            ),
                                          );
                                        },
                                        child: const Text("View Details"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 32),
                    // Medical Certificate History
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Medical Certificate History",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _historyTable(certificates),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
  }

  Widget _infoRow(String label, String? value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text("$label", style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value ?? "",
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyTable(List<Map<String, dynamic>> certs) {
    return DataTable(
      columns: const [
        DataColumn(label: Text("Date Issued")),
        DataColumn(label: Text("Doctor")),
        // DataColumn(label: Text("Reason")),
        DataColumn(label: Text("Status")),
        DataColumn(label: Text("QR Code")),
        DataColumn(label: Text("Actions")),
      ],
      rows:
          certs
              .map(
                (cert) => DataRow(
                  cells: [
                    DataCell(Text(cert["date"] ?? "")),
                    DataCell(Text(cert["doctor"] ?? "")),
                    // DataCell(Text(cert["reason"] ?? "")),
                    DataCell(
                      cert["status"] == "unpaid"
                          ? ElevatedButton(
                            onPressed:
                                (cert["doctorAddress"] != null &&
                                        cert["fee"] != null)
                                    ? () async {
                                      await payForCertificate(
                                        cert["doctorAddress"] ?? "",
                                        cert["fee"] ?? "0",
                                      );
                                    }
                                    : null,
                            child: const Text("Pay"),
                          )
                          : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  cert["status"] == "valid"
                                      ? Colors.green[100]
                                      : Colors.red[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              cert["status"] == "valid" ? "Valid" : "Expired",
                              style: TextStyle(
                                color:
                                    cert["status"] == "valid"
                                        ? Colors.green[800]
                                        : Colors.red[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                    ),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.qr_code, size: 28),
                        tooltip: "Show QR",
                        onPressed:
                            (cert["txHash"] != null &&
                                    cert["txHash"].toString().isNotEmpty)
                                ? () => _showQR(cert["txHash"])
                                : null,
                      ),
                    ), // txHash column
                    DataCell(
                      TextButton.icon(
                        icon: const Icon(Icons.remove_red_eye, size: 18),
                        label: const Text("View"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ViewMedicalCertificate(
                                    jsonData: cert["rawJson"] ?? "",
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
    );
  }
}
