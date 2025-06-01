// lib/doctor_dashboard.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_records_web_application/screens/patient_records.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class DoctorDashboard extends StatefulWidget {
  final String privateKey;
  DoctorDashboard({required this.privateKey});

  @override
  _DoctorDashboardState createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  String _message = '';
  Web3Client? _web3client;
  DeployedContract? _contract;
  final String _contractAddress = '0x9c69cc63c530458677fC8F7B233c7ED884a072f3';
  final String _rpcUrl = 'http://127.0.0.1:7545';
  final String _wsUrl = 'ws://127.0.0.1:7545';
  List<EthereumAddress> _accessiblePatients = [];

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    try {
      _web3client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      });
      final abiString = await DefaultAssetBundle.of(context).loadString('assets/MedicalRecords.json');
      final abiJson = jsonDecode(abiString);
      final abi = ContractAbi.fromJson(jsonEncode(abiJson['abi']), 'MedicalRecords');

      _contract = DeployedContract(abi, EthereumAddress.fromHex(_contractAddress));
      _loadAccessiblePatients();
    } catch (e) {
      setState(() {
        _message = 'Error connecting: $e';
      });
    }
  }

  // Future<void> _loadAccessiblePatients() async {
  //   if (_web3client == null || _contract == null) return;
  //   try {
  //     // Implement logic to retrieve the list of patients who granted access.
  //     // This will depend on how you store the access information in your contract.
  //     // Example:
  //     // final accessiblePatientsFunction = _contract!.function('getAccessiblePatients');
  //     // final result = await _web3client!.call(contract: _contract!, function: accessiblePatientsFunction, params: []);
  //     // _accessiblePatients = (result.first as List).map((address) => EthereumAddress.fromHex(address)).toList();

  //     // For demonstration purposes, I will add a fake list.
  //     _accessiblePatients = [EthereumAddress.fromHex("0x5B38Da6a701c568545dCfcB03FcB875f56beddC4"), EthereumAddress.fromHex("0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2")];

  //     setState(() {});
  //   } catch (e) {
  //     setState(() {
  //       _message = 'Error loading patient list: $e';
  //     });
  //   }
  // }

//  Future<void> _loadAccessiblePatients() async {
//     if (_web3client == null || _contract == null) return;
//     try {
//         final accessiblePatientsFunction = _contract!.function('getAccessiblePatients');
//         final result = await _web3client!.call(contract: _contract!, function: accessiblePatientsFunction, params: [EthereumAddress.fromHex(widget.privateKey)]);

//         print("Doctor Address: ${widget.privateKey}"); // Log doctor address
//         print("Raw Result: ${result.first}"); // Log raw result

//         _accessiblePatients = (result.first as List).map((address) => EthereumAddress.fromHex(address)).toList();

//         print("Accessible Patients: $_accessiblePatients"); // Log processed result

//         setState(() {});
//     } catch (e) {
//         setState(() {
//             _message = 'Error loading patient list: $e';
//         });
//     }
// }

// Future<void> _loadAccessiblePatients() async {
//     if (_web3client == null || _contract == null) {
//         print("Web3Client or Contract is null");
//         return;
//     }
//     try {
//         final accessiblePatientsFunction = _contract!.function('getAccessiblePatients');
//         final result = await _web3client!.call(contract: _contract!, function: accessiblePatientsFunction, params: [EthereumAddress.fromHex(widget.privateKey)]);

//         print("Doctor Address (privateKey): ${widget.privateKey}");
//         print("Raw Result from getAccessiblePatients: ${result.first}");

//         if (result.first is List) {
//             _accessiblePatients = (result.first as List).map((address) => EthereumAddress.fromHex(address)).toList();
//             print("Processed Accessible Patients: $_accessiblePatients");
//         } else {
//             print("Result from getAccessiblePatients is not a List: ${result.first.runtimeType}");
//         }

//         setState(() {});
//     } catch (e) {
//         print("Error loading patient list: $e");
//         setState(() {
//             _message = 'Error loading patient list: $e';
//         });
//     }
// }

//  Future<void> _loadAccessiblePatients() async {
//     if (_web3client == null || _contract == null) return;
//     try {
//       final credentials = EthPrivateKey.fromHex(widget.privateKey); // Convert private key to credentials
//       final doctorAddress = credentials.address; // Get the address

//       final accessiblePatientsFunction = _contract!.function('getAccessiblePatients');
//       final result = await _web3client!.call(contract: _contract!, function: accessiblePatientsFunction, params: [doctorAddress]); // Pass the address

//       _accessiblePatients = (result.first as List).map((address) => EthereumAddress.fromHex(address)).toList();

//       setState(() {});
//     } catch (e) {
//       setState(() {
//         _message = 'Error loading patient list: $e';
//       });
//     }
//   }

// Future<void> _loadAccessiblePatients() async {
//     if (_web3client == null || _contract == null) {
//         print("Web3Client or Contract is null");
//         return;
//     }
//     try {
//         final credentials = EthPrivateKey.fromHex(widget.privateKey);
//         final doctorAddress = credentials.address;

//         print("Doctor Address (derived from private key): $doctorAddress");

//         final accessiblePatientsFunction = _contract!.function('getAccessiblePatients');
//         final result = await _web3client!.call(contract: _contract!, function: accessiblePatientsFunction, params: [doctorAddress]);

//         print("Raw Result from getAccessiblePatients: $result");

//         if (result.first is List) {
//             final addressList = result.first as List;
//             print("Address List from Contract: $addressList");

//             _accessiblePatients = addressList.map((address) => EthereumAddress.fromHex(address)).toList();
//             print("Processed Accessible Patients: $_accessiblePatients");
//         } else {
//             print("Result from getAccessiblePatients is not a List: ${result.first.runtimeType}");
//         }

//         setState(() {});
//     } catch (e) {
//         print("Error loading patient list: $e");
//         setState(() {
//             _message = 'Error loading patient list: $e';
//         });
//     }
// }

 Future<void> _loadAccessiblePatients() async {
    if (_web3client == null || _contract == null) return;
    try {
      final credentials = EthPrivateKey.fromHex(widget.privateKey);
      final doctorAddress = credentials.address;

      print("Doctor Address (derived from private key): $doctorAddress");

      final accessiblePatientsFunction = _contract!.function('getAccessiblePatients');
      final result = await _web3client!.call(contract: _contract!, function: accessiblePatientsFunction, params: [doctorAddress]);

      print("Raw Result from getAccessiblePatients: $result");

      if (result.first is List) {
          final addressList = result.first as List;
          print("Address List from Contract: $addressList");

          _accessiblePatients = addressList.map((address) => address as EthereumAddress).toList(); // Cast to EthereumAddress

          print("Processed Accessible Patients: $_accessiblePatients");
      } else {
          print("Result from getAccessiblePatients is not a List: ${result.first.runtimeType}");
      }

      setState(() {});
    } catch (e) {
      print("Error loading patient list: $e");
      setState(() {
        _message = 'Error loading patient list: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor Dashboard')),
      body: ListView.builder(
        itemCount: _accessiblePatients.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_accessiblePatients[index].hex),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientRecordsPage(privateKey: widget.privateKey, patientAddress: _accessiblePatients[index])),
              );
            },
          );
        },
      ),
    );
  }
}