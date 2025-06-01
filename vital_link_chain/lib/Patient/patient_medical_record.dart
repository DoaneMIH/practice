import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vital_link_chain/Patient/patient_view_prescription.dart';
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:web3dart/web3dart.dart';

class MedicalRecord extends StatefulWidget {
  final String patientAddress; // Patient's public key
  const MedicalRecord({required this.patientAddress, super.key});

  @override
  State<MedicalRecord> createState() => _MedicalRecordState();
}

class _MedicalRecordState extends State<MedicalRecord> {
  List<Map<String, String>> _records = [];
  List<List<String>> prescriptions = [];
  bool _isLoading = true;
  List<List<String>> allPrescriptions = [];
  List<Map<String, dynamic>> _prescriptions = [];
  List<Map<String, dynamic>> _medicalApplications = [];
  final apiBaseUrl = dotenv.env['API_BASE_URL'];

  @override
  void initState() {
    super.initState();
    _loadRecords();
    // _loadPrescriptions();
    _loadAllPrescriptions();
    _loadMedicalApplications();
  }

  Future<void> _loadAllPrescriptions() async {
  setState(() => _isLoading = true);

  // Fetch separately
  final onChainPrescriptions = await _fetchOnChainPrescriptions(widget.patientAddress);
  final backendPrescriptions = await _fetchBackendPrescriptions(widget.patientAddress.toLowerCase());


  setState(() {
    prescriptions = onChainPrescriptions;
    _prescriptions = backendPrescriptions;
    // prescriptions = combinedPrescriptions;
    _isLoading = false;
  });
}

  Future<void> _loadRecords() async {
    setState(() {
      _isLoading = true;
    });

    final records = await _fetchPatientRecords(widget.patientAddress);
    // final prescriptionBackend = await _fetchBackendPrescriptions(
      // widget.patientAddress,
    // );

    setState(() {
      // _prescriptions = prescriptionBackend;
      _records = records;
      _isLoading = false;
    });
  }

  Future<List<Map<String, dynamic>>> fetchPrescriptions(String patientAddress) async {
  final url = Uri.parse('$apiBaseUrl/api/prescriptions/$patientAddress');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load prescriptions');
  }
}

  Future<List<Map<String, String>>> _fetchPatientRecords(
    String patientAddress,
  ) async {
    final uri = Uri.parse('http://localhost:3000/api/records/$patientAddress');
    print("Fetching records for patientAddress: $patientAddress");

    try {
      final response = await http.get(uri);
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // print("Parsed Data: $data");

        return data.map<Map<String, String>>((record) {
          final rec = record as Map<String, dynamic>;
          return {
            'fileName': rec['fileName']?.toString() ?? 'Untitled Record',
            'ipfsHash': rec['ipfsHash']?.toString() ?? '',
            'uploadDate': rec['uploadedAt']?.toString() ?? '',
            'doctorPublicKey': rec['doctorPublicKey']?.toString() ?? 'Unknown',
            'doctorName': rec['doctorName']?.toString() ?? 'Unknown Doctor',
          };
        }).toList();
      } else {
        print("❌ Failed to fetch records: ${response.body}");
        return [];
      }
    } catch (e) {
      print("❌ Error fetching records: $e");
      return [];
    }
  }


  String? _getBackendTxHash(List<String> prescription) {
  // Join the first 5 fields to match backend content
  final normalizedContent = prescription.take(5).join('#').trim();
  final match = _prescriptions.firstWhere(
    (p) => (p['content']?.trim() ?? '').startsWith(normalizedContent),
    orElse: () => {},
  );
  return match['txHash'];
}

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  }


  Future<List<List<String>>> _fetchOnChainPrescriptions(String patientAddress) async {
  try {
    final credentials = EthPrivateKey.fromHex(Connector.key);
    final address = await credentials.extractAddress();
    final result = await Connector.getPresc(address);
    List<String> prescList = (result as List).cast<String>();
    return prescList.map((e) => e.split('#')).toList();
  } catch (e) {
    print("Error fetching on-chain prescriptions: $e");
    return [];
  }
}


Future<List<Map<String, String>>> _fetchBackendPrescriptions(String patientAddress) async {
  final uri = Uri.parse('$apiBaseUrl/api/prescriptions/$patientAddress');
  print("Fetching backend prescriptions for patientAddress: $patientAddress");

  try {
    final response = await http.get(uri);
    print("API Response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> presList = jsonDecode(response.body);
      if (presList.isEmpty) return [];

      return presList.map<Map<String, String>>((presc) {
        final pres = presc as Map<String, dynamic>;
        return {
          'doctorAddress': pres['doctorAddress']?.toString() ?? 'Doctor Unknown',
          'content': pres['content']?.toString() ?? 'No Content',
          'txHash': pres['txHash']?.toString() ?? 'No txHash',
          'issuedAt': pres['issuedAt']?.toString() ?? 'Unknown',
        };
      }).toList();
    } else {
      print("❌ Failed to fetch backend prescriptions: ${response.body}");
      return [];
    }
  } catch (e) {
    print("❌ Error fetching backend prescriptions: $e");
    return [];
  }
}

  // void _showQR(String txHash) {
  //   showDialog(
  //     context: context,
  //     builder:
  //         (_) => AlertDialog(
  //           title: const Text("Prescription QR Code"),
  //           content: SizedBox(
  //             height: 220,
  //             width: 220,
  //             child:
  //                 txHash.isNotEmpty
  //                     ? QrImageView(
  //                       data: jsonEncode({"txHash": txHash}),
  //                       version: QrVersions.auto,
  //                       size: 200.0,
  //                     )
  //                     : const Center(
  //                       child: Text(
  //                         "TxHash not available from on-chain data.\nPlease ask your doctor for the QR code.",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(color: Colors.red),
  //                       ),
  //                     ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text("Close"),
  //             ),
  //           ],
  //         ),
  //   );
  // }

  

Future<void> _loadMedicalApplications() async {
  setState(() => _isLoading = true);
  final uri = Uri.parse('$apiBaseUrl/api/medical-applications/${widget.patientAddress}');
  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _medicalApplications = data.cast<Map<String, dynamic>>();
      });
    } else {
      setState(() {
        _medicalApplications = [];
      });
    }
  } catch (e) {
    setState(() {
      _medicalApplications = [];
    });
  }
  setState(() => _isLoading = false);
}

void _showMedicalApplicationDetails(Map<String, dynamic> app) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(app['fileName'] ?? 'Medical Application'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("IPFS Hash: ${app['ipfsHash'] ?? ''}"),
              Text("Uploaded: ${app['uploadedAt'] ?? ''}"),
              const Divider(),
              ...((app['formData'] as Map<String, dynamic>?)?.entries.map((e) =>
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text("${e.key}: ${e.value}"),
                )
              ) ?? [const Text("No form data")]),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        if (app['ipfsHash'] != null)
          TextButton(
            onPressed: () {
              final url = "https://gateway.pinata.cloud/ipfs/${app['ipfsHash']}";
              _launchUrl(url);
            },
            child: const Text("View PDF"),
          ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
  padding: EdgeInsets.all(10.0),
  child: Text(
    "Medical Applications",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  ),
),
SizedBox(
  height: 300,
  child: _isLoading
      ? const Center(child: CircularProgressIndicator())
      : _medicalApplications.isEmpty
          ? const Center(child: Text("No Medical Applications Found"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _medicalApplications.length,
              itemBuilder: (context, index) {
                final app = _medicalApplications[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      app['fileName'] ?? 'Untitled Application',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Uploaded: ${app['uploadedAt'] ?? ''}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () => _showMedicalApplicationDetails(app),
                    ),
                  ),
                );
              },
            ),
),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Medical Records",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 300,
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _records.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          Text("Medical Records for: ${widget.patientAddress}"),
                          const SizedBox(height: 16),
                          Image.asset(
                            'assets/images/no-record.png',
                            width: 150,
                            height: 150,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "No Medical Records Found",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Your medical records will appear here once uploaded.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _records.length,
                      itemBuilder: (context, index) {
                        final record = _records[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            title: Text(
                              record['fileName'] ?? 'Untitled Record',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Uploaded On: ${record['uploadDate']}"),
                                Text("Doctor: ${record['doctorName']}"),
                                Text(
                                  "Doctor Public Key: ${record['doctorPublicKey']}",
                                ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                final url =
                                    "https://gateway.pinata.cloud/ipfs/${record['ipfsHash']}";
                                _launchUrl(url);
                              },
                              child: const Text("View"),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          // Prescriptions Section
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Prescriptions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          (_isLoading == false && _prescriptions.isNotEmpty)
              ?
 FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchPrescriptions(widget.patientAddress.toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // final _prescriptions = snapshot.data!;
        return SizedBox(
          height: 300,
          child: ListView.builder(
        itemCount: _prescriptions.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPrescription(
                      index: index + 1, record: prescriptions[index]),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Colors.black,
                          child: Text(
                            "  ${index + 1}  ",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(thickness: 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(FontAwesomeIcons.clock, size: 15),
                              const SizedBox(width: 10),
                              Text(
                                prescriptions[index][7], 
                              ),
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(FontAwesomeIcons.userDoctor, 
                                  size: 15, color: Colors.grey),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  prescriptions[index][8], // Doctor key
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis, // Prevents overflow
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () {
                      final prescription = _prescriptions[index];
            final txHash = prescription['txHash'] ?? '';
            if (txHash.isNotEmpty) {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text("Prescription QR Code"),
                  content: SizedBox(
                    height: 220,
                    width: 220,
                    child: QrImageView(
                      data: txHash,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  actions: [
                    TextButton(
  onPressed: () {
    Navigator.of(dialogContext).pop();
  },
  child: const Text("Close"),
),
                  ],
                ),
              );
            }

                    }, icon: Icon(Icons.qr_code)),
                  ],
                ),
              ),
            ),
          );
          
        },
      ),
        );
      },
 )
          
//         ListView.builder(
//   shrinkWrap: true,
//   physics: NeverScrollableScrollPhysics(),
//   itemCount: prescriptions.length,
//   itemBuilder: (context, index) {
//     final prescription = _prescriptions[index];
//     return Card(
//       child: ListTile(
//         title: Text(prescription['content'] ?? ''),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Issued At: ${prescription['issuedAt'] ?? ''}'),
//             Text('TxHash: ${prescription['txHash'] ?? ''}'),
//           ],
//         ),
//         trailing: IconButton(
//           icon: Icon(Icons.qr_code),
//           onPressed: () {
//             final txHash = prescription['txHash'] ?? '';
//             if (txHash.isNotEmpty) {
//               showDialog(
//                 context: context,
//                 builder: (_) => AlertDialog(
//                   title: const Text("Prescription QR Code"),
//                   content: SizedBox(
//                     height: 220,
//                     width: 220,
//                     child: QrImageView(
//                       data: txHash,
//                       version: QrVersions.auto,
//                       size: 200.0,
//                     ),
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text("Close"),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   },
// )
//         );
//       },
//     )

              : _isLoading == true
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: CupertinoActivityIndicator(radius: 20),
                ),
              )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}

