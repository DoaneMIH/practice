// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _privateKeyController = TextEditingController();
//   final TextEditingController _doctorAddressController = TextEditingController();
//   bool? _accessStatus;

//   // Grant access API call
//   Future<void> grantAccess() async {
//     final response = await http.post(
//       Uri.parse("http://localhost:3000/grant-access"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "patient_private_key": _privateKeyController.text,
//         "doctor_address": _doctorAddressController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Access Granted")));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Grant Access")));
//     }
//   }

//   // Check access API call
//   Future<void> checkAccess() async {
//     final response = await http.get(Uri.parse(
//       "http://localhost:3000/check-access?patient=${_privateKeyController.text}&doctor=${_doctorAddressController.text}",
//     ));

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         _accessStatus = data["access"];
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Check Access")));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Medical Records Access Control")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _privateKeyController,
//               decoration: const InputDecoration(labelText: "Your Private Key"),
//               obscureText: true,
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _doctorAddressController,
//               decoration: const InputDecoration(labelText: "Doctor's Address"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: grantAccess,
//               child: const Text("Grant Access"),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: checkAccess,
//               child: const Text("Check Access"),
//             ),
//             const SizedBox(height: 20),
//             if (_accessStatus != null)
//               Text(
//                 _accessStatus! ? "Doctor has access ✅" : "Doctor does not have access ❌",
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class HomeScreen extends StatefulWidget {
//   final String currentAddress;
//   const HomeScreen({super.key, required this.currentAddress});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _doctorAddressController = TextEditingController();
//   bool? _accessStatus;

//   // Grant access using MetaMask
//   Future<void> grantAccess() async {
//     final response = await http.post(
//       Uri.parse("http://localhost:7545/grant-access"),
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "patient_address": widget.currentAddress,
//         "doctor_address": _doctorAddressController.text,
//       }),
//     );

//     if (response.statusCode == 200) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Access Granted")));
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Grant Access")));
//     }
//   }

//   // Check access API call
//   Future<void> checkAccess() async {
//     final response = await http.get(Uri.parse(
//       "http://localhost:7545/check-access?patient=${widget.currentAddress}&doctor=${_doctorAddressController.text}",
//     ));

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       setState(() {
//         _accessStatus = data["access"];
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Check Access")));
//     }
//   }

//   // Revoke access API call
// Future<void> revokeAccess() async {
//   final response = await http.post(
//     Uri.parse("http://localhost:7545/revoke-access"),
//     headers: {"Content-Type": "application/json"},
//     body: jsonEncode({
//       "patient_address": widget.currentAddress,
//       "doctor_address": _doctorAddressController.text,
//     }),
//   );

//   if (response.statusCode == 200) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Access Revoked")));
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to Revoke Access")));
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text("Connected Wallet: ${widget.currentAddress}", style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _doctorAddressController,
//               decoration: const InputDecoration(labelText: "Doctor's Address"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: grantAccess,
//               child: const Text("Grant Access"),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: revokeAccess,
//               child: const Text("Revoke Access"),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: checkAccess,
//               child: const Text("Check Access"),
//             ),
//             const SizedBox(height: 20),
//             if (_accessStatus != null)
//               Text(
//                 _accessStatus! ? "Doctor has access ✅" : "Doctor does not have access ❌",
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_web3/ethereum.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:web3modal_flutter/web3modal_flutter.dart';

// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => MedicalRecordsModel(),
//       child: const MyApp(),
//     ),
//   );
// }
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String? currentAddress;
//   bool get isConnected => currentAddress != null;

//   Future<void> connectWallet1() async {
//     if (ethereum != null) {
//       final accounts = await ethereum!.requestAccount();
//       if (accounts.isNotEmpty) {
//         setState(() {
//           currentAddress = accounts.first;
//         });
//       }
//     } else {
//       print("MetaMask not installed!");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Medical Records Access',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: Scaffold(
//         appBar: AppBar(title: const Text("Medical Records - MetaMask")),
//         body: Center(
//           child: isConnected
//               // ? HomeScreen(currentAddress: currentAddress!)
//               ? HomePage()
//               : ElevatedButton(
//                   onPressed: connectWallet1,
//                   child: const Text("Connect MetaMask"),
//                 ),
//         ),
//       ),
//     );
//   }
// }
// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Medical Records',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //       ),
// //       home: const HomePage(),
// //     );
// //   }
// // }

// class MedicalRecordsModel with ChangeNotifier {
//   late Web3Client _client;
//   late DeployedContract _contract;
//   late EthereumAddress _contractAddress;
//   late String _rpcUrl;
//   Credentials? _credentials;
//   W3MService? _w3mService;
//   bool _isInitialized = false;
//   bool _isConnected = false;
//   String _currentAddress = '';

//   Future<void> initialize() async {
//     _rpcUrl = 'https://sepolia.infura.io/v3/54cdd774912d41909eefb8363fe3c4ad'; // Use your Infura or Alchemy URL
//     _client = Web3Client(_rpcUrl, http.Client());
    
//     // Replace with your contract address
//     _contractAddress = EthereumAddress.fromHex('0x2a2EDC32F1BdeAd9F77a4cA648c8c960270D9a02');
    
//     final contractAbi = await _loadContractAbi();
//     _contract = DeployedContract(contractAbi, _contractAddress);
    
//     // Initialize Web3Modal for MetaMask connection
//     _w3mService = W3MService(
//       projectId: '1d3962b91d5556c288af8df92cf49501', // Get from walletconnect.com
//       metadata: const PairingMetadata(
//         name: 'Medical Records App',
//         description: 'A decentralized medical records application',
//         url: 'http://localhost:7545',
//         icons: ['https://medchain-records.vercel.app/icon.png'],
//       ),
//     );
    
//     _isInitialized = true;
//     notifyListeners();
//   }

//   Future<ContractAbi> _loadContractAbi() async {
//     // Replace with your contract's full ABI
//     const abi = '''[
//       {
//         "anonymous": false,
//         "inputs": [
//           {
//             "indexed": true,
//             "internalType": "address",
//             "name": "patient",
//             "type": "address"
//           },
//           {
//             "indexed": true,
//             "internalType": "address",
//             "name": "doctor",
//             "type": "address"
//           }
//         ],
//         "name": "AccessGranted",
//         "type": "event"
//       },
//       {
//         "anonymous": false,
//         "inputs": [
//           {
//             "indexed": true,
//             "internalType": "address",
//             "name": "creator",
//             "type": "address"
//           },
//           {
//             "indexed": true,
//             "internalType": "address",
//             "name": "patient",
//             "type": "address"
//           }
//         ],
//         "name": "RecordAdded",
//         "type": "event"
//       },
//       {
//         "anonymous": false,
//         "inputs": [
//           {
//             "indexed": true,
//             "internalType": "address",
//             "name": "user",
//             "type": "address"
//           },
//           {
//             "indexed": false,
//             "internalType": "enum MedicalRecords.Role",
//             "name": "role",
//             "type": "uint8"
//           }
//         ],
//         "name": "RoleAssigned",
//         "type": "event"
//       },
//       {
//         "inputs": [
//           {
//             "internalType": "address",
//             "name": "",
//             "type": "address"
//           }
//         ],
//         "name": "roles",
//         "outputs": [
//           {
//             "internalType": "enum MedicalRecords.Role",
//             "name": "",
//             "type": "uint8"
//           }
//         ],
//         "stateMutability": "view",
//         "type": "function"
//       },
//       {
//         "inputs": [
//           {
//             "internalType": "enum MedicalRecords.Role",
//             "name": "role",
//             "type": "uint8"
//           }
//         ],
//         "name": "assignRole",
//         "outputs": [],
//         "stateMutability": "nonpayable",
//         "type": "function"
//       },
//       {
//         "inputs": [
//           {
//             "internalType": "address",
//             "name": "patient",
//             "type": "address"
//           },
//           {
//             "internalType": "string",
//             "name": "data",
//             "type": "string"
//           }
//         ],
//         "name": "addRecord",
//         "outputs": [],
//         "stateMutability": "nonpayable",
//         "type": "function"
//       },
//       {
//         "inputs": [
//           {
//             "internalType": "address",
//             "name": "doctor",
//             "type": "address"
//           }
//         ],
//         "name": "grantAccess",
//         "outputs": [],
//         "stateMutability": "nonpayable",
//         "type": "function"
//       },
//       {
//         "inputs": [],
//         "name": "getMyRecords",
//         "outputs": [
//           {
//             "components": [
//               {
//                 "internalType": "string",
//                 "name": "data",
//                 "type": "string"
//               },
//               {
//                 "internalType": "address",
//                 "name": "creator",
//                 "type": "address"
//               },
//               {
//                 "internalType": "uint256",
//                 "name": "timestamp",
//                 "type": "uint256"
//               }
//             ],
//             "internalType": "struct MedicalRecords.Record[]",
//             "name": "",
//             "type": "tuple[]"
//           }
//         ],
//         "stateMutability": "view",
//         "type": "function"
//       },
//       {
//         "inputs": [
//           {
//             "internalType": "address",
//             "name": "patient",
//             "type": "address"
//           }
//         ],
//         "name": "getPatientRecords",
//         "outputs": [
//           {
//             "components": [
//               {
//                 "internalType": "string",
//                 "name": "data",
//                 "type": "string"
//               },
//               {
//                 "internalType": "address",
//                 "name": "creator",
//                 "type": "address"
//               },
//               {
//                 "internalType": "uint256",
//                 "name": "timestamp",
//                 "type": "uint256"
//               }
//             ],
//             "internalType": "struct MedicalRecords.Record[]",
//             "name": "",
//             "type": "tuple[]"
//           }
//         ],
//         "stateMutability": "view",
//         "type": "function"
//       }
//     ]''';
//     return ContractAbi.fromJson(abi, 'MedicalRecords');
//   }

//   Future<void> connectWallet() async {
//     if (!_isInitialized) await initialize();
    
//     try {
//       await _w3mService!.init();
//       // // ignore: deprecated_member_use
//       await _w3mService!.openModal();
      
//       if (_w3mService!.session != null) {
//         _currentAddress = _w3mService!.session!.address!;
//         _credentials = _w3mService! as Credentials?;
//         _isConnected = true;
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint('Error connecting wallet: $e');
//     }
//   }

//   Future<void> disconnectWallet() async {
//     await _w3mService!.disconnect();
//     _credentials = null;
//     _isConnected = false;
//     _currentAddress = '';
//     notifyListeners();
//   }

//   Future<String> assignRole(int role) async {
//     if (!_isConnected) throw Exception('Wallet not connected');
    
//     final function = _contract.function('assignRole');
//     final txHash = await _client.sendTransaction(
//       _credentials!,
//       Transaction.callContract(
//         contract: _contract,
//         function: function,
//         parameters: [BigInt.from(role)],
//       ),
//       chainId: 11155111, // Sepolia testnet (change for other networks)
//     );
    
//     return txHash;
//   }

//   Future<String> addRecord(String patientAddress, String data) async {
//     if (!_isConnected) throw Exception('Wallet not connected');
    
//     final function = _contract.function('addRecord');
//     final txHash = await _client.sendTransaction(
//       _credentials!,
//       Transaction.callContract(
//         contract: _contract,
//         function: function,
//         parameters: [EthereumAddress.fromHex(patientAddress), data],
//       ),
//       chainId: 11155111,
//     );
    
//     return txHash;
//   }

//   Future<String> grantAccess(String doctorAddress) async {
//     if (!_isConnected) throw Exception('Wallet not connected');
    
//     final function = _contract.function('grantAccess');
//     final txHash = await _client.sendTransaction(
//       _credentials!,
//       Transaction.callContract(
//         contract: _contract,
//         function: function,
//         parameters: [EthereumAddress.fromHex(doctorAddress)],
//       ),
//       chainId: 11155111,
//     );
    
//     return txHash;
//   }

//   Future<List<dynamic>> getMyRecords() async {
//     if (!_isConnected) throw Exception('Wallet not connected');
    
//     final function = _contract.function('getMyRecords');
//     final result = await _client.call(
//       contract: _contract,
//       function: function,
//       params: [],
//     );
    
//     return result;
//   }

//   Future<List<dynamic>> getPatientRecords(String patientAddress) async {
//     if (!_isConnected) throw Exception('Wallet not connected');
    
//     final function = _contract.function('getPatientRecords');
//     final result = await _client.call(
//       contract: _contract,
//       function: function,
//       params: [EthereumAddress.fromHex(patientAddress)],
//     );
    
//     return result;
//   }

//   Future<int> getRole(String address) async {
//     if (!_isInitialized) await initialize();
    
//     final function = _contract.function('roles');
//     final result = await _client.call(
//       contract: _contract,
//       function: function,
//       params: [EthereumAddress.fromHex(address)],
//     );
    
//     return (result[0] as BigInt).toInt();
//   }

//   String get currentAddress => _currentAddress;
//   bool get isConnected => _isConnected;
// }

// class CustomCredentials extends Credentials {
//   final W3MService w3mService;

//   CustomCredentials(this.w3mService);

//   @override
//   Future<EthereumAddress> extractAddress() async {
//     // return EthereumAddress.fromHex(w3mService.session!.address);
//     return EthereumAddress.fromHex(w3mService.session!.address);
//   }

//   @override
//   Future<MsgSignature> signToSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false}) {
//     throw UnimplementedError('Custom signing not implemented');
//   }

//   @override
//   Future<String> signPersonalMessage(Uint8List payload) {
//     throw UnimplementedError('Custom signing not implemented');
//   }

//   @override
//   Future<Uint8List> signToEcSignature(Uint8List payload, {int? chainId, bool isEIP1559 = false}) {
//     throw UnimplementedError('Custom signing not implemented');
//   }
  
//   @override
//   // TODO: implement address
//   EthereumAddress get address => throw UnimplementedError();
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _dataController = TextEditingController();
//   final TextEditingController _doctorController = TextEditingController();
//   final TextEditingController _patientController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<MedicalRecordsModel>(context, listen: false).initialize();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final model = Provider.of<MedicalRecordsModel>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Medical Records'),
//         actions: [
//           if (model.isConnected)
//             IconButton(
//               icon: const Icon(Icons.account_balance_wallet),
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Wallet Connected'),
//                     content: Text('Connected with: ${model.currentAddress}'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('OK'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           model.disconnectWallet();
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Disconnect'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             )
//           else
//             TextButton(
//               onPressed: () => connectWallet(),
//               child: const Text('Connect Wallet'),
//             ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               if (!model.isConnected)
//                 const Card(
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text(
//                       'Please connect your wallet to interact with the Medical Records contract',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 )
//               else ...[
//                 _buildRoleAssignment(model),
//                 const SizedBox(height: 20),
//                 _buildAccessControl(model),
//                 const SizedBox(height: 20),
//                 _buildRecordManagement(model),
//                 const SizedBox(height: 20),
//                 _buildRecordViewer(model),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildRoleAssignment(MedicalRecordsModel model) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text('Assign Role', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await model.assignRole(1); // 1 for Patient
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Assigned Patient role (transaction sent)')),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               },
//               child: const Text('Become Patient'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await model.assignRole(2); // 2 for Doctor
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Assigned Doctor role (transaction sent)')),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               },
//               child: const Text('Become Doctor'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAccessControl(MedicalRecordsModel model) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text('Access Control', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _doctorController,
//               decoration: const InputDecoration(
//                 labelText: 'Doctor Address',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await model.grantAccess(_doctorController.text);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Access granted (transaction sent)')),
//                   );
//                   _doctorController.clear();
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               },
//               child: const Text('Grant Access to Doctor'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecordManagement(MedicalRecordsModel model) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text('Record Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _patientController,
//               decoration: const InputDecoration(
//                 labelText: 'Patient Address',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _dataController,
//               decoration: const InputDecoration(
//                 labelText: 'Record Data',
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 3,
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await model.addRecord(_patientController.text, _dataController.text);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Record added (transaction sent)')),
//                   );
//                   _patientController.clear();
//                   _dataController.clear();
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               },
//               child: const Text('Add Record'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRecordViewer(MedicalRecordsModel model) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             const Text('View Records', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   final records = await model.getMyRecords();
//                   _showRecordsDialog(context, records);
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               },
//               child: const Text('View My Records'),
//             ),
//             const SizedBox(height: 10),
//             TextField(
//               controller: _addressController,
//               decoration: const InputDecoration(
//                 labelText: 'Patient Address',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   final records = await model.getPatientRecords(_addressController.text);
//                   _showRecordsDialog(context, records);
//                   _addressController.clear();
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               },
//               child: const Text('View Patient Records'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showRecordsDialog(BuildContext context, List<dynamic> records) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Medical Records'),
//           content: SizedBox(
//             width: double.maxFinite,
//             child: records.isEmpty
//                 ? const Text('No records found')
//                 : ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: records.length,
//                     itemBuilder: (context, index) {
//                       final record = records[index];
//                       return ListTile(
//                         title: Text(record[0]), // data
//                         subtitle: Text('Created by: ${record[1]}\nTimestamp: ${record[2]}'),
//                       );
//                     },
//                   ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _addressController.dispose();
//     _dataController.dispose();
//     _doctorController.dispose();
//     _patientController.dispose();
//     super.dispose();
//   }
// }

// lib/home_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:medical_records_web_application/screens/doctor_dashboard.dart';
import 'package:medical_records_web_application/screens/patient_dashboard.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class MyHomePage extends StatefulWidget {
  final String privateKey;
  MyHomePage({required this.privateKey});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _patientAddressController = TextEditingController();
  final TextEditingController _doctorAddressController = TextEditingController();
  final TextEditingController _recordDataController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  String _message = '';
  List<Record> _records = [];
  Role _role = Role.None;
  EthereumAddress? _userAddress;
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

//  Future<void> _connect() async {
//   try {
//     final credentials = EthPrivateKey.fromHex(widget.privateKey);
//     _userAddress = credentials.address;

//     _web3client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
//       return IOWebSocketChannel.connect(_wsUrl).cast<String>();
//     });
//     final abiString = await DefaultAssetBundle.of(context).loadString('assets/MedicalRecords.json');
//     final abiJson = jsonDecode(abiString);
//     final abi = ContractAbi.fromJson(jsonEncode(abiJson['abi']), 'MedicalRecords');

//     _contract = DeployedContract(abi, EthereumAddress.fromHex(_contractAddress));

//     final prefs = await SharedPreferences.getInstance();
//     final roleInt = prefs.getInt('${widget.privateKey}_role'); // Retrieve role
//     if (roleInt != null) {
//       _role = Role.values[roleInt];
//     } else {
//       // Handle the case where the role is not found (e.g., set to None or show an error)
//       _message = "Role not found. Please log in again.";
//       return;
//     }

//     setState(() {
//       _message = 'Connected. Role: $_role';
//     });
//     _loadRecords();
//   } catch (e) {
//     setState(() {
//       _message = 'Error connecting: $e';
//     });
//   }
// }

  Future<void> _connect() async {
    try {
      final credentials = EthPrivateKey.fromHex(widget.privateKey);
      _userAddress = credentials.address;

      _web3client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      });
      final abiString = await DefaultAssetBundle.of(context).loadString('assets/MedicalRecords.json');
      final abiJson = jsonDecode(abiString);
      final abi = ContractAbi.fromJson(jsonEncode(abiJson['abi']), 'MedicalRecords');

      _contract = DeployedContract(abi, EthereumAddress.fromHex(_contractAddress));

      final rolesFunction = _contract!.function('roles');
      final rolesResult = await _web3client!.call(contract: _contract!, function: rolesFunction, params: [_userAddress!]);
      _role = Role.values[rolesResult.first.toInt()];

      setState(() {
        _message = 'Connected. Role: $_role';
      });

      // Navigate based on role
      if (_role != Role.None) {
        _navigateToDashboard(_role); // Call the navigation function
      }

      _loadRecords(); // Load records after navigation
    } catch (e) {
      setState(() {
        _message = 'Error connecting: $e';
      });
    }
  }

  void _navigateToDashboard(Role role) { // Navigation function
    Widget dashboardWidget;
    switch (role) {
      case Role.Patient:
        dashboardWidget = PatientDashboard(privateKey: widget.privateKey); // Create patient dashboard
        break;
      case Role.Doctor:
        dashboardWidget = DoctorDashboard(privateKey: widget.privateKey); // Create doctor dashboard
        break;
      case Role.Admin:
        dashboardWidget = AdminDashboard(privateKey: widget.privateKey); // Create admin dashboard
        break;
      default:
        return; // If None, stay on the current page
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => dashboardWidget),
    );
  }


  Future<void> _loadRecords() async {
    if (_web3client == null || _contract == null || _userAddress == null) return;
    try {
      List<dynamic> result;
      if (_role == Role.Patient) {
        final getRecordsFunction = _contract!.function('getMyRecords');
        result = await _web3client!.call(contract: _contract!, function: getRecordsFunction, params: []);
      } else if (_role == Role.Doctor) {
        final getPatientRecordsFunction = _contract!.function('getPatientRecords');
        result = await _web3client!.call(contract: _contract!, function: getPatientRecordsFunction, params: [EthereumAddress.fromHex(_patientAddressController.text)]);
      } else {
        return;
      }

      final recordsList = result.first as List;
      _records = recordsList.map((record) => Record(record[0] as String, EthereumAddress.fromHex(record[1]), record[2] as BigInt)).toList();
      setState(() {});
    } catch (e) {
      setState(() {
        _message = 'Error loading records: $e';
      });
    }
  }

  Future<void> _addRecord() async {
    if (_web3client == null || _contract == null || _userAddress == null) return;
    try {
      final addRecordFunction = _contract!.function('addRecord');
      final transaction = await _web3client!.sendTransaction(
        EthPrivateKey.fromHex(widget.privateKey),
        Transaction.callContract(
          contract: _contract!,
          function: addRecordFunction,
          parameters: [EthereumAddress.fromHex(_patientAddressController.text), _recordDataController.text],
        ),
        chainId: 1337,
      );
      setState(() {
        _message = 'Record added. Transaction: $transaction';
      });
      _loadRecords();
    } catch (e) {
      setState(() {
        _message = 'Error adding record: $e';
      });
    }
  }

  Future<void> _grantAccess() async {
    if (_web3client == null || _contract == null || _userAddress == null) return;
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

  Future<void> _assignRole() async {
    if (_web3client == null || _contract == null || _userAddress == null) return;
    try {
      final assignRoleFunction = _contract!.function('assignRole');
      final roleBigInt = BigInt.from(int.parse(_roleController.text));
      final transaction = await _web3client!.sendTransaction(
        EthPrivateKey.fromHex(widget.privateKey),
        Transaction.callContract(
          contract: _contract!,
          function: assignRoleFunction,
          parameters: [roleBigInt],
        ),
        chainId: 1337,
      );
      setState(() {
        _message = 'Role assigned. Transaction: $transaction';
      });
      _connect();
    } catch (e) {
      setState(() {
        _message = 'Error assigning role: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Records'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(_message),
              if (_role == Role.Doctor) ...[
                TextField(
                  controller: _patientAddressController,
                  decoration: InputDecoration(labelText: 'Patient Address'),
                ),
                TextField(
                  controller: _recordDataController,
                  decoration: InputDecoration(labelText: 'Record Data'),
                ),
                ElevatedButton(onPressed: _addRecord, child: Text('Add Record')),
              ],
              if (_role == Role.Patient) ...[
                TextField(
                  controller: _doctorAddressController,
                  decoration: InputDecoration(labelText: 'Doctor Address'),
                ),
                ElevatedButton(onPressed: _grantAccess, child: Text('Grant Access')),
              ],
              if (_role == Role.None) ...[
                TextField(
                  controller: _roleController,
                  decoration: InputDecoration(labelText: 'Role (1 for Patient, 2 for Doctor)'),
                ),
                ElevatedButton(onPressed: _assignRole, child: Text('Assign Role')),
              ],
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_records[index].data),
                    subtitle: Text('Creator: ${_records[index].creator.hex}'),
                    trailing: Text('Timestamp: ${_records[index].timestamp}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Record {
  final String data;
  final EthereumAddress creator;
  final BigInt timestamp;

  Record(this.data, this.creator, this.timestamp);
}

enum Role { None, Patient, Doctor, Admin }

// Create the dashboard widgets (e.g., PatientDashboard, DoctorDashboard, AdminDashboard)
// class PatientDashboard extends StatelessWidget {
//   final String privateKey;
//   PatientDashboard({required this.privateKey});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Patient Dashboard')),
//       body: Center(child: Text('Patient Dashboard Content')),
//     );
//   }
// }

// class DoctorDashboard extends StatelessWidget {
//   final String privateKey;
//   const DoctorDashboard({required this.privateKey});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Doctor Dashboard')),
//       body: Center(child: Text('Doctor Dashboard Content')),
//     );
//   }
// }

class AdminDashboard extends StatelessWidget {
  final String privateKey;
  AdminDashboard({required this.privateKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: Center(child: Text('Admin Dashboard Content')),
    );
  }
}

// import 'dart:convert';

// // lib/home_page.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_web3/flutter_web3.dart';
// import 'package:http/http.dart' as http;
// import 'package:web3dart/web3dart.dart';
// import 'package:web_socket_channel/io.dart';

// class MyHomePage extends StatefulWidget {
//   final String privateKey;
//   MyHomePage({required this.privateKey});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _patientAddressController = TextEditingController();
//   final TextEditingController _doctorAddressController = TextEditingController();
//   final TextEditingController _recordDataController = TextEditingController();
//   final TextEditingController _roleController = TextEditingController();
//   String _message = '';
//   List<Record> _records = [];
//   Role _role = Role.None;
//   EthereumAddress? _userAddress;
//   Web3Client? _web3client;
//   DeployedContract? _contract;
//   final String _contractAddress = 'YOUR_CONTRACT_ADDRESS';
//   final String _rpcUrl = 'http://127.0.0.1:7545';
//   final String _wsUrl = 'ws://127.0.0.1:7545';

//   @override
//   void initState() {
//     super.initState();
//     _connect();
//   }

//   Future<void> _connect() async {
//     try {
//       final credentials = EthPrivateKey.fromHex(widget.privateKey);
//       _userAddress = credentials.address;

//       _web3client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
//         return IOWebSocketChannel.connect(_wsUrl).cast<String>();
//       });
//       final abiString = await DefaultAssetBundle.of(context).loadString('assets/MedicalRecords.json');
//       final abiJson = jsonDecode(abiString);
//       final abi = ContractAbi.fromJson(jsonEncode(abiJson['abi']), 'MedicalRecords');

//       _contract = DeployedContract(abi, EthereumAddress.fromHex(_contractAddress));

//       final rolesFunction = _contract!.function('roles');
//       final rolesResult = await _web3client!.call(contract: _contract!, function: rolesFunction, params: [_userAddress!]);
//       _role = Role.values[rolesResult.first.toInt()];

//       setState(() {
//         _message = 'Connected. Role: $_role';
//       });
//       _loadRecords();
//     } catch (e) {
//       setState(() {
//         _message = 'Error connecting: $e';
//       });
//     }
//   }

//   Future<void> _loadRecords() async {
//     if (_web3client == null || _contract == null || _userAddress == null) return;
//     try {
//       List<dynamic> result;
//       if (_role == Role.Patient) {
//         final getRecordsFunction = _contract!.function('getMyRecords');
//         result = await _web3client!.call(contract: _contract!, function: getRecordsFunction, params: []);
//       } else if (_role == Role.Doctor) {
//         final getPatientRecordsFunction = _contract!.function('getPatientRecords');
//         result = await _web3client!.call(contract: _contract!, function: getPatientRecordsFunction, params: [EthereumAddress.fromHex(_patientAddressController.text)]);
//       } else {
//         return;
//       }

//       final recordsList = result.first as List;
//       _records = recordsList.map((record) => Record(record[0] as String, EthereumAddress.fromHex(record[1]), record[2] as BigInt)).toList();
//       setState(() {});
//     } catch (e) {
//       setState(() {
//         _message = 'Error loading records: $e';
//       });
//     }
//   }

//   Future<void> _addRecord() async {
//     if (_web3client == null || _contract == null || _userAddress == null) return;
//     try {
//       final addRecordFunction = _contract!.function('addRecord');
//       final transaction = await _web3client!.sendTransaction(
//         EthPrivateKey.fromHex(widget.privateKey),
//         Transaction.callContract(
//           contract: _contract!,
//           function: addRecordFunction,
//           parameters: [EthereumAddress.fromHex(_patientAddressController.text), _recordDataController.text],
//         ),
//         chainId: 1337,
//       );
//       setState(() {
//         _message = 'Record added. Transaction: $transaction';
//       });
//       _loadRecords();
//     } catch (e) {
//       setState(() {
//         _message = 'Error adding record: $e';
//       });
//     }
//   }

//   Future<void> _grantAccess() async {
//     if (_web3client == null || _contract == null || _userAddress == null) return;
//     try {
//       final grantAccessFunction = _contract!.function('grantAccess');
//       final transaction = await _web3client!.sendTransaction(
//         EthPrivateKey.fromHex(widget.privateKey),
//         Transaction.callContract(
//           contract: _contract!,
//           function: grantAccessFunction,
//           parameters: [EthereumAddress.fromHex(_doctorAddressController.text)],
//         ),
//         chainId: 1337,
//       );
//       setState(() {
//         _message = 'Access granted. Transaction: $transaction';
//       });
//     } catch (e) {
//       setState(() {
//         _message = 'Error granting access: $e';
//       });
//     }
//   }

//   Future<void> _assignRole() async {
//     if (_web3client == null || _contract == null || _userAddress == null) return;
//     try {
//       final assignRoleFunction = _contract!.function('assignRole');
//       final roleBigInt = BigInt.from(int.parse(_roleController.text));
//       final transaction = await _web3client!.sendTransaction(
//         EthPrivateKey.fromHex(widget.privateKey),
//         Transaction.callContract(
//           contract: _contract!,
//           function: assignRoleFunction,
//           parameters: [roleBigInt],
//         ),
//         chainId: 1337,
//       );
//       setState(() {
//         _message = 'Role assigned. Transaction: $transaction';
//       });
//       _connect();
//     } catch (e) {
//       setState(() {
//         _message = 'Error assigning role: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Medical Records'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               Text(_message),
//               if (_role == Role.Doctor) ...[
//                 TextField(
//                   controller: _patientAddressController,
//                   decoration: InputDecoration(labelText: 'Patient Address'),
//                 ),
//                 TextField(
//                   controller: _recordDataController,
//                   decoration: InputDecoration(labelText: 'Record Data'),
//                 ),
//                 ElevatedButton(onPressed: _addRecord, child: Text('Add Record')),
//               ],
//               if (_role == Role.Patient) ...[
//                 TextField(
//                   controller: _doctorAddressController,
//                   decoration: InputDecoration(labelText: 'Doctor Address'),
//                 ),
//                 ElevatedButton(onPressed: _grantAccess, child: Text('Grant Access')),
//               ],
//               if (_role == Role.None) ...[
//                 TextField(
//                   controller: _roleController,
//                   decoration: InputDecoration(labelText: 'Role (1 for Patient, 2 for Doctor)'),
//                 ),
//                 ElevatedButton(onPressed: _assignRole, child: Text('Assign Role')),
//               ],
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: _records.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_records[index].data),
//                     subtitle: Text('Creator: ${_records[index].creator.hex}'),
//                     trailing: Text('Timestamp: ${_records[index].timestamp}'),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Record {
//   final String data;
//   final EthereumAddress creator;
//   final BigInt timestamp;

//   Record(this.data, this.creator, this.timestamp);
// }

// enum Role { None, Patient, Doctor }