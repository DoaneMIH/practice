// lib/patient_dashboard.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class PatientDashboard extends StatefulWidget {
  final String privateKey;
  PatientDashboard({required this.privateKey});

  @override
  _PatientDashboardState createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final TextEditingController _doctorAddressController = TextEditingController();
  String _message = '';
  Web3Client? _web3client;
  DeployedContract? _contract;
  final String _contractAddress = '0x9c69cc63c530458677fC8F7B233c7ED884a072f3';
  final String _rpcUrl = 'http://127.0.0.1:7545';
  final String _wsUrl = 'ws://127.0.0.1:7545';

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
    } catch (e) {
      setState(() {
        _message = 'Error connecting: $e';
      });
    }
  }

  Future<void> _grantAccess() async {
    if (_web3client == null || _contract == null) return;
    try {
      final grantAccessFunction = _contract!.function('grantAccess');
      final transaction = await _web3client!.sendTransaction(
        EthPrivateKey.fromHex(widget.privateKey),
        Transaction.callContract(
          contract: _contract!,
          function: grantAccessFunction,
          parameters: [EthereumAddress.fromHex(_doctorAddressController.text)],
        ),
        chainId: 1337,
      );
      setState(() {
        _message = 'Access granted. Transaction: $transaction';
      });
    } catch (e) {
      setState(() {
        _message = 'Error granting access: $e';
      });
    }
  }

  Future<void> _revokeAccess() async {
    if (_web3client == null || _contract == null) return;
    try {
      final revokeAccessFunction = _contract!.function('revokeAccess');
      final transaction = await _web3client!.sendTransaction(
        EthPrivateKey.fromHex(widget.privateKey),
        Transaction.callContract(
          contract: _contract!,
          function: revokeAccessFunction,
          parameters: [EthereumAddress.fromHex(_doctorAddressController.text)],
        ),
        chainId: 1337,
      );
      setState(() {
        _message = 'Access revoked. Transaction: $transaction';
      });
    } catch (e) {
      setState(() {
        _message = 'Error revoking access: $e';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(_message),
            TextField(
              controller: _doctorAddressController,
              decoration: InputDecoration(labelText: 'Doctor Address'),
            ),
            ElevatedButton(onPressed: _grantAccess, child: Text('Grant Access')),
            ElevatedButton(
                  onPressed: _revokeAccess,
                  child: Text('Revoke Access'),
                ),
          ],
        ),
      ),
    );
  }
}