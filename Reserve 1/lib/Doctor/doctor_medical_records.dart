import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:vital_link_chain/Utility/connector.dart';

class DoctorMedicalRecords extends StatefulWidget {
  final String doctorPublicKey; // Doctor's public key
  const DoctorMedicalRecords({required this.doctorPublicKey, super.key});

  @override
  State<DoctorMedicalRecords> createState() => _DoctorMedicalRecordsState();
}

class _DoctorMedicalRecordsState extends State<DoctorMedicalRecords> {
  Map<String, List<Map<String, String>>> _patients = {};
  bool _isLoading = true;
  final Map<String, String> _patientNames = {}; // <-- Add this line

  @override
  void initState() {
    super.initState();
    _loadPatients();

    // Periodically refresh the patient list every 10 seconds
    Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _loadPatients();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _loadPatients() async {
    setState(() {
      _isLoading = true;
    });

    final patients = await _fetchPatients(widget.doctorPublicKey);

    // Fetch patient names for each address
  for (final address in patients.keys) {
    if (!_patientNames.containsKey(address)) {
      final name = await Connector.getName(address);
      _patientNames[address] = name;
    }
  }
    setState(() {
      _patients = patients;
      _isLoading = false;
    });
  }

  Future<Map<String, List<Map<String, String>>>> _fetchPatients(
    String doctorPublicKey,
  ) async {
    final uri = Uri.parse(
      'http://localhost:3000/api/doctor/records/${doctorPublicKey.toLowerCase()}',
    );
    print(
      "Fetching records for doctorPublicKey: ${doctorPublicKey.toLowerCase()}",
    );

    try {
      final response = await http.get(uri);
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("Parsed Data: $data");

        return data.map<String, List<Map<String, String>>>((
          patientAddress,
          records,
        ) {
          final List<dynamic> recordList = records as List<dynamic>;
          return MapEntry(
            patientAddress,
            recordList.map<Map<String, String>>((record) {
              final rec = record as Map<String, dynamic>;
              return {
                'fileName': rec['fileName']?.toString() ?? 'Untitled Record',
                'ipfsHash': rec['ipfsHash']?.toString() ?? '',
                'uploadDate': rec['uploadedAt']?.toString() ?? '',
              };
            }).toList(),
          );
        });
      } else if (response.statusCode == 404) {
        print("No records found for this doctor.");
        return {};
      } else {
        print("❌ Failed to fetch records: ${response.body}");
        return {};
      }
    } catch (e) {
      print("❌ Error fetching records: $e");
      return {};
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _patients.isEmpty
              ? const Center(
                child: Text(
                  "No patients have granted you access.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _patients.keys.length,
                itemBuilder: (context, index) {
                  final patientAddress = _patients.keys.elementAt(index);
                  final records = _patients[patientAddress] ?? [];
                  // final patientName = patientAddress.split('@')[0];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ExpansionTile(
                      title: Text(
                        // "Patient: $patientAddress",
                        "Patient: ${_patientNames[patientAddress] ?? patientAddress}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      children:
                          records.map((record) {
                            return ListTile(
                              title: Text(
                                record['fileName'] ?? 'Untitled Record',
                              ),
                              subtitle: Text(
                                "Uploaded On: ${record['uploadDate']}",
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  final url =
                                      "https://gateway.pinata.cloud/ipfs/${record['ipfsHash']}";
                                  _launchUrl(url);
                                },
                                child: const Text("View"),
                              ),
                            );
                          }).toList(),
                    ),
                  );
                },
              ),
    );
  }
}
