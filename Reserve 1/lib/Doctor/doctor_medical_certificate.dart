import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vital_link_chain/Doctor/MedicalCertificateForm.dart';
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:web3dart/web3dart.dart';

class MedicalCertificate extends StatefulWidget {
  const MedicalCertificate({super.key});

  @override
  State<MedicalCertificate> createState() => _MedicalCertificateState();
}

class _MedicalCertificateState extends State<MedicalCertificate> {
  List<Map<String, String>> _patients = [];
  TextEditingController _feeController = TextEditingController();
  bool _loadingPatients = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  Future<void> _fetchPatients() async {
    setState(() => _loadingPatients = true);
    try {
      final patients = await Connector.getGrantedPatientsForDoctor(
        Connector.key,
      );
      setState(() {
        _patients = patients;
        _loadingPatients = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load patients: $e");
      setState(() => _loadingPatients = false);
    }
  }

  void _showCertificateDialog(Map<String, String> patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicalCertificateForm(patient: patient),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _feeController,
          decoration: const InputDecoration(
            labelText: "Enter Fee",
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            final credentials = EthPrivateKey.fromHex(Connector.key);
            final address = await credentials.extractAddress();
            String name = await Connector.getName(address.hex);
            await Connector.registerDoctorOnMedicalCertificate(
              Connector.key,
              name,
            );
            await Connector.setCertificateFee(
              Connector.key,
              _feeController.text,
            );
          },
          child: Text("Set Certificate Fee"),
        ),

        SizedBox(
          height: 300,
          child:
              _loadingPatients
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _patients.length,
                    itemBuilder: (context, index) {
                      final patient = _patients[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(patient['name'] ?? 'Unknown'),
                          subtitle: Text(patient['address'] ?? ''),
                          trailing: ElevatedButton.icon(
                            icon: const Icon(Icons.medical_services),
                            label: const Text("Issue Certificate"),
                            onPressed: () => _showCertificateDialog(patient),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
