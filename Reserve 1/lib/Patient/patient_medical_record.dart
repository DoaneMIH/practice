import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    _loadRecords();
    _loadPrescriptions();
  }

  Future<void> _loadRecords() async {
    setState(() {
      _isLoading = true;
    });

    final records = await _fetchPatientRecords(widget.patientAddress);

    setState(() {
      _records = records;
      _isLoading = false;
    });
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
        print("Parsed Data: $data");

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

  // void getPrescriptions() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   List<dynamic> result = await Connector.getPresc(Connector.address);
  //   for (var element in result) {
  //     prescriptions.add(element.toString().split('#'));
  //   }
  //   prescriptions = prescriptions.reversed.toList();
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  void _loadPrescriptions() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final credentials = EthPrivateKey.fromHex(Connector.key);
    final patientAddress = await credentials.extractAddress();
    final result = await Connector.getPresc(patientAddress);

    // result[0] is a List<dynamic> of prescription strings
    List<String> prescList = (result as List).cast<String>();
    setState(() {
      prescriptions = prescList.map((e) => e.split('#')).toList();
    });
  } catch (e) {
    print("Error fetching prescriptions: $e");
    Fluttertoast.showToast(msg: "Error fetching prescriptions");
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
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
          //Prescriptions Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Prescriptions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          (_isLoading == false && prescriptions.isNotEmpty) 
    ? ListView.builder(
        itemCount: prescriptions.length,
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
                                prescriptions[index][4], // Timestamp
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
                                  prescriptions[index][5], // Doctor key
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis, // Prevents overflow
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      )
    : _isLoading == true
        ? const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: CupertinoActivityIndicator(radius: 20),
            ),
          )
        : const SizedBox.shrink()
        ],
      ),
    );
  }
}
