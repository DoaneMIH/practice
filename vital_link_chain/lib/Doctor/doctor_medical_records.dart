import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  final Map<String, List<Map<String, dynamic>>> _patientMedicalApps = {};
  bool _isLoading = true;
  final Map<String, String> _patientNames = {}; // <-- Add this line
  final apiBaseUrl = dotenv.env['API_BASE_URL'];

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

    // Fetch medical applications for this patient
    final appsResp = await http.get(
      Uri.parse('$apiBaseUrl/api/medical-applications/${address.toLowerCase()}'),
    );
    if (appsResp.statusCode == 200) {
      final List<dynamic> apps = jsonDecode(appsResp.body);
      _patientMedicalApps[address] = apps.cast<Map<String, dynamic>>();
    } else {
      _patientMedicalApps[address] = [];
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
      '$apiBaseUrl/api/doctor/records/${doctorPublicKey.toLowerCase()}',
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
                      children: [
  // Medical Applications Section
  if ((_patientMedicalApps[patientAddress]?.isNotEmpty ?? false)) ...[
    const Padding(
      padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
      child: Text(
        "Patient Records",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    ),
    ..._patientMedicalApps[patientAddress]!.map((app) => ListTile(
      title: Text(app['fileName'] ?? 'Medical Application'),
      subtitle: Text("Uploaded: ${app['uploadedAt'] ?? ''}"),
      trailing: ElevatedButton(
        onPressed: () {
          final url = "https://gateway.pinata.cloud/ipfs/${app['ipfsHash']}";
          _launchUrl(url);
        },
        child: const Text("View"),
      ),
      onTap: () {
        // Optionally show details dialog here
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
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
                onPressed: () => Navigator.of(dialogContext).pop(),
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
      },
    )),
    const Divider(),
  ],
  // Existing Records Section
  ...records.map((record) {
    return ListTile(
      title: Text(record['fileName'] ?? 'Untitled Record'),
      subtitle: Text("Uploaded On: ${record['uploadDate']}"),
      trailing: ElevatedButton(
        onPressed: () {
          final url = "https://gateway.pinata.cloud/ipfs/${record['ipfsHash']}";
          _launchUrl(url);
        },
        child: const Text("View"),
      ),
    );
  }).toList(),
],
                    ),
                  );
                },
              ),
    );
  }
}
