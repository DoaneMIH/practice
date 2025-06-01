// // lib/patient_records_page.dart
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:web3dart/web3dart.dart';
// import 'package:web_socket_channel/io.dart';

// class PatientRecordsPage extends StatefulWidget {
//   final String privateKey;
//   final EthereumAddress patientAddress;
//   PatientRecordsPage({required this.privateKey, required this.patientAddress});

//   @override
//   _PatientRecordsPageState createState() => _PatientRecordsPageState();
// }

// class _PatientRecordsPageState extends State<PatientRecordsPage> {
//   final TextEditingController _recordDataController = TextEditingController();
//   String _message = '';
//   Web3Client? _web3client;
//   DeployedContract? _contract;
//   final String _contractAddress = '0xEE261274Ee3047A645938e00AbA4667761285421';
//   final String _rpcUrl = 'http://127.0.0.1:7545';
//   final String _wsUrl = 'ws://127.0.0.1:7545';
//   List<Record> _records = [];

//   @override
//   void initState() {
//     super.initState();
//     _connect();
//   }

//   Future<void> _connect() async {
//     try {
//       _web3client = Web3Client(_rpcUrl, http.Client(), socketConnector: () {
//         return IOWebSocketChannel.connect(_wsUrl).cast<String>();
//       });
//       final abiString = await DefaultAssetBundle.of(context).loadString('assets/MedicalRecords.json');
//       final abiJson = jsonDecode(abiString);
//       final abi = ContractAbi.fromJson(jsonEncode(abiJson['abi']), 'MedicalRecords');

//       _contract = DeployedContract(abi, widget.patientAddress);
//       _loadRecords();
//     } catch (e) {
//       setState(() {
//         _message = 'Error connecting: $e';
//       });
//     }
//   }

//   // Future<void> _loadRecords() async {
//   //   if (_web3client == null || _contract == null) return;
//   //   try {
//   //     final getPatientRecordsFunction = _contract!.function('getPatientRecords');
//   //     final result = await _web3client!.call(contract: _contract!, function: getPatientRecordsFunction, params: [widget.patientAddress]);
//   //     final recordsList = result.first as List;
//   //     _records = recordsList.map((record) => Record(record[0] as String, EthereumAddress.fromHex(record[1]), record[2] as BigInt)).toList();
//   //     setState(() {});
//   //   } catch (e) {
//   //     setState(() {
//   //       _message = 'Error loading records: $e';
//   //     });
//   //   }
//   // }
// Future<void> _loadRecords() async {
//     if (_web3client == null || _contract == null) return;
//     try {
//         final getPatientRecordsFunction = _contract!.function('getPatientRecords');
//         final result = await _web3client!.call(contract: _contract!, function: getPatientRecordsFunction, params: [widget.patientAddress]);

//         print("Raw Result from getPatientRecords: $result"); // Log raw result

//         final recordsList = result.first as List;
//         print("Records List: $recordsList"); // Log records list

//         _records = recordsList.map((record) {
//             print("Record: $record"); // Log each record
//             return Record(
//                 record[0] as String,
//                 EthereumAddress.fromHex(record[1]),
//                 record[2] as BigInt,
//             );
//         }).toList();

//         setState(() {});
//     } catch (e) {
//         print("Error loading records: $e"); // Log error
//         setState(() {
//             _message = 'Error loading records: $e';
//         });
//     }
// }


//   Future<void> _addRecord() async {
//     if (_web3client == null || _contract == null) return;
//     try {
//       final addRecordFunction = _contract!.function('addRecord');
//       final transaction = await _web3client!.sendTransaction(
//         EthPrivateKey.fromHex(widget.privateKey),
//         Transaction.callContract(
//           contract: _contract!,
//           function: addRecordFunction,
//           parameters: [widget.patientAddress, _recordDataController.text],
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Patient Records')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: <Widget>[
//             Text(_message),
//             TextField(
//               controller: _recordDataController,
//               decoration: InputDecoration(labelText: 'Record Data'),
//             ),
//             ElevatedButton(onPressed: _addRecord, child: Text('Add Record')),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _records.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(_records[index].data),
//                     subtitle: Text('Creator: ${_records[index].creator.hex}'),
//                     trailing: Text('Timestamp: ${_records[index].timestamp}'),
//                   );
//                 },
//               ),
//             ),
//           ],
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

// lib/patient_records_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ipfs_client_flutter/ipfs_client_flutter.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';


class PatientRecordsPage extends StatefulWidget {
  final String privateKey;
  final EthereumAddress patientAddress;
  PatientRecordsPage({required this.privateKey, required this.patientAddress});

  @override
  _PatientRecordsPageState createState() => _PatientRecordsPageState();
}

class _PatientRecordsPageState extends State<PatientRecordsPage> {
// Initialize IPFS client
  // final IpfsClient _ipfsClient = IpfsClient();
  IpfsClient ipfsClient = IpfsClient(url: "http://127.0.0.1:5001");
  final TextEditingController _recordDataController = TextEditingController();
  String _message = '';
  Web3Client? _web3client;
  DeployedContract? _contract;
  final String _contractAddress = '0x9c69cc63c530458677fC8F7B233c7ED884a072f3';
  final String _rpcUrl = 'http://127.0.0.1:7545';
  final String _wsUrl = 'ws://127.0.0.1:7545';
  List<Record> _records = [];
  Role _role = Role.None;

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
      
      _contract = DeployedContract(abi, EthereumAddress.fromHex(_contractAddress)); // Change this line
      await _loadRole();
      _loadRecords();
    } catch (e) {
      setState(() {
        _message = 'Error connecting: $e';
      });
    }
  }

    Future<void> _loadRole() async {
    if (_web3client == null || _contract == null) return;
    try {
        final getRoleFunction = _contract!.function('roles');
        final credentials = EthPrivateKey.fromHex(widget.privateKey);
        final doctorAddress = credentials.address;
        final result = await _web3client!.call(
            contract: _contract!, 
            function: getRoleFunction, 
            params: [doctorAddress]
        );

        _role = Role.values[result.first.toInt()];
        print("Loaded Role for Doctor: $_role"); // Debug role loading

        _loadRecords();
    } catch (e) {
        print("Error loading role: $e");
    }
}

Future<void> _addRecord() async {
  print("addRecord function called");
  print("Doctor Role: $_role");

  if (_web3client == null || _contract == null) {
    print("_web3client or _contract is null");
    return;
  }

  try {
    final credentials = EthPrivateKey.fromHex(widget.privateKey);
    final doctorAddress = credentials.address;

    // Check if the doctor has access to the patient's records
    final checkAccessFunction = _contract!.function('checkAccess');
    final accessResult = await _web3client!.call(
      contract: _contract!,
      function: checkAccessFunction,
      params: [widget.patientAddress, doctorAddress],
    );

    bool hasAccess = accessResult.first as bool;
    print("Doctor has access to patient: $hasAccess");

    if (!hasAccess) {
      setState(() {
        _message = 'Access denied: Doctor does not have permission to add records.';
      });
      return;
    }

    print("Attempting to add record...");
    print("Patient Address: ${widget.patientAddress}");
    print("Record Data: ${_recordDataController.text}");

    // Upload the record data to IPFS
    final ipfsHash = await uploadToIPFS(_recordDataController.text);
    if (ipfsHash == null) {
      setState(() {
        _message = 'Error uploading record to IPFS.';
      });
      return;
    }
    print("IPFS Hash: $ipfsHash");

    // Store the IPFS hash on the blockchain
    final addRecordFunction = _contract!.function('addRecord');
    final transaction = await _web3client!.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: _contract!,
        function: addRecordFunction,
        parameters: [widget.patientAddress, ipfsHash],
      ),
      chainId: 1337,
    );

    print("Transaction hash: $transaction");
    setState(() {
      _message = 'Record added. Transaction: $transaction';
    });

    _loadRecords(); // Reload records after adding
  } catch (e) {
    print("Error adding record: $e");
    setState(() {
      _message = 'Error adding record: $e';
    });
  }
}

// Future<void> _addRecord() async {
//   print("addRecord function called");
//   print("Doctor Role: $_role");

//   if (_web3client == null || _contract == null) {
//     print("_web3client or _contract is null");
//     return;
//   }

//   try {
//     final credentials = EthPrivateKey.fromHex(widget.privateKey);
//     final doctorAddress = credentials.address;

//     // Check if the doctor has access to the patient's records
//     final checkAccessFunction = _contract!.function('checkAccess');
//     final accessResult = await _web3client!.call(
//       contract: _contract!,
//       function: checkAccessFunction,
//       params: [widget.patientAddress, doctorAddress],
//     );

//     bool hasAccess = accessResult.first as bool;
//     print("Doctor has access to patient: $hasAccess");

//     if (!hasAccess) {
//       setState(() {
//         _message = 'Access denied: Doctor does not have permission to add records.';
//       });
//       return;
//     }

//     print("Attempting to add record...");
//     print("Patient Address: ${widget.patientAddress}");
//     print("Record Data: ${_recordDataController.text}");

//     // Upload the record data to IPFS
//     final ipfsResponse = await ipfsClient.write(
//       dir: _recordDataController.text,
//       filePath: '',
//       fileName: '',
//     );
//     final ipfsHash = ipfsResponse; // Extract the IPFS hash
//     print("IPFS Hash: $ipfsHash");

//     // Store the IPFS hash on the blockchain
//     final addRecordFunction = _contract!.function('addRecord');
//     final transaction = await _web3client!.sendTransaction(
//       credentials,
//       Transaction.callContract(
//         contract: _contract!,
//         function: addRecordFunction,
//         parameters: [widget.patientAddress, ipfsHash],
//       ),
//       chainId: 1337,
//     );

//     print("Transaction hash: $transaction");
//     setState(() {
//       _message = 'Record added. Transaction: $transaction';
//     });

//     _loadRecords(); // Reload records after adding
//   } catch (e) {
//     print("Error adding record: $e");
//     setState(() {
//       _message = 'Error adding record: $e';
//     });
//   }
// }


  // Future<void> _addRecord() async {
  //   if (_web3client == null || _contract == null) return;
  //   try {
  //     final addRecordFunction = _contract!.function('addRecord');
  //     final transaction = await _web3client!.sendTransaction(
  //       EthPrivateKey.fromHex(widget.privateKey),
  //       Transaction.callContract(
  //         contract: _contract!,
  //         function: addRecordFunction,
  //         parameters: [widget.patientAddress, _recordDataController.text],
  //       ),
  //       chainId: 1337,
  //     );
  //     setState(() {
  //       _message = 'Record added. Transaction: $transaction';
  //     });
  //     _loadRecords();
  //   } catch (e) {
  //     setState(() {
  //       _message = 'Error adding record: $e';
  //     });
  //   }
  // }

//   Future<void> _addRecord() async {
//       print("addRecord function called");
//       print("Doctor Role: $_role"); // Add the print statement here
//     if (_web3client == null || _contract == null) {
//         print("_web3client or _contract is null");
//         return;
//     }
//     try {
//         print("attempting to add record");
//         print("patient address: ${widget.patientAddress}");
//         print("record data: ${_recordDataController.text}");
//         final addRecordFunction = _contract!.function('addRecord');
//         final transaction = await _web3client!.sendTransaction(
//             EthPrivateKey.fromHex(widget.privateKey),
//             Transaction.callContract(
//                 contract: _contract!,
//                 function: addRecordFunction,
//                 parameters: [widget.patientAddress, _recordDataController.text],
//             ),
//             chainId: 1337,
//         );
//         print("transaction hash: $transaction");
//         setState(() {
//             _message = 'Record added. Transaction: $transaction';
//         });
//         _loadRecords();
//     } catch (e) {
//         print("Error adding record: $e");
//         setState(() {
//             _message = 'Error adding record: $e';
//         });
//     }
// }

//   Future<void> _addRecord() async {
//     print("addRecord function called");
//     print("Doctor Role: $_role"); // Debug: Check doctor's role

//     if (_web3client == null || _contract == null) {
//         print("_web3client or _contract is null");
//         return;
//     }

//     try {
//         final credentials = EthPrivateKey.fromHex(widget.privateKey);
//         final doctorAddress = credentials.address;

//         // Check if doctor has access before proceeding
//         final checkAccessFunction = _contract!.function('checkAccess');
//         final accessResult = await _web3client!.call(
//             contract: _contract!,
//             function: checkAccessFunction,
//             params: [widget.patientAddress, doctorAddress],
//         );

//         bool hasAccess = accessResult.first as bool;
//         print("Doctor has access to patient: $hasAccess");

//         if (!hasAccess) {
//             setState(() {
//                 _message = 'Access denied: Doctor does not have permission to add records.';
//             });
//             return;
//         }

//         print("Attempting to add record...");
//         print("Patient Address: ${widget.patientAddress}");
//         print("Record Data: ${_recordDataController.text}");

//         // Upload record data to IPFS
//         final response = await _ipfsClient.addString(Uint8List.fromList(utf8.encode(_recordDataController.text)));
//         final ipfsHash = response['Hash']; // Extract the hash from the response
//         print("IPFS Hash: $ipfsHash");

//         // Store IPFS hash on the blockchain
//         final addRecordFunction = _contract!.function('addRecord');
//         final transaction = await _web3client!.sendTransaction(
//             credentials,
//             Transaction.callContract(
//                 contract: _contract!,
//                 function: addRecordFunction,
//                 parameters: [widget.patientAddress, ipfsHash],
//             ),
//             chainId: 1337,
//         );

//         print("Transaction hash: $transaction");
//         setState(() {
//             _message = 'Record added. Transaction: $transaction';
//         });

//         _loadRecords();
//     } catch (e) {
//         print("Error adding record: $e");
//         setState(() {
//             _message = 'Error adding record: $e';
//         });
//     }
// }

// Future<void> _addRecord() async {
//     print("addRecord function called");
//     print("Doctor Role: $_role");

//     if (_web3client == null || _contract == null) {
//       print("_web3client or _contract is null");
//       return;
//     }

//     try {
//       final credentials = EthPrivateKey.fromHex(widget.privateKey);
//       final doctorAddress = credentials.address;

//       final checkAccessFunction = _contract!.function('checkAccess');
//       final accessResult = await _web3client!.call(contract: _contract!, function: checkAccessFunction, params: [widget.patientAddress, doctorAddress]);

//       bool hasAccess = accessResult.first as bool;
//       print("Doctor has access to patient: $hasAccess");

//       if (!hasAccess) {
//         setState(() {
//           _message = 'Access denied: Doctor does not have permission to add records.';
//         });
//         return;
//       }

//       print("Attempting to add record...");
//       print("Patient Address: ${widget.patientAddress}");
//       print("Record Data: ${_recordDataController.text}");

//       final ipfsHash = await ipfsClient.write(dir: _recordDataController.text, filePath: '', fileName: '');
//       print("Ipfs Hash: $ipfsHash"); //log the ipfs hash

//       final addRecordFunction = _contract!.function('addRecord');
//       final transaction = await _web3client!.sendTransaction(
//         credentials,
//         Transaction.callContract(contract: _contract!, function: addRecordFunction, parameters: [widget.patientAddress, ipfsHash]),
//         chainId: 1337,
//       );

//       print("Transaction hash: $transaction");
//       setState(() {
//         _message = 'Record added. Transaction: $transaction';
//       });

//       _loadRecords();
//     } catch (e) {
//       print("Error adding record: $e");
//       setState(() {
//         _message = 'Error adding record: $e';
//       });
//     }
//   }


  // Future<void> _loadRecords() async {
  //   if (_web3client == null || _contract == null) return;
  //   try {
  //     final getPatientRecordsFunction = _contract!.function('getPatientRecords');
  //     final result = await _web3client!.call(
  //       contract: _contract!, function: 
  //       getPatientRecordsFunction, 
  //       params: [widget.patientAddress]
  //     );

  //     print("Raw Result from getPatientRecords: $result"); // Log raw result

  //     final recordsList = result.first as List;
  //     print("Records List: $recordsList"); // Log records list

  //     // _records = recordsList.map((record) {
  //     //   print("Record: $record"); // Log each record
  //     //   return Record(
  //     //     record[0] as String,
  //     //     EthereumAddress.fromHex(record[1]),
  //     //     record[2] as BigInt,
  //     //   );
  //     // }).toList();

  //     _records = await Future.wait(recordsList.map((record) async {
  //       // final data = await _ipfsClient.catString(record[0] as String);

  //       try {
  //         final data = await _ipfsClient.cat(record[0] as String);
  //         return Record(data, EthereumAddress.fromHex(record[1]), record[2] as BigInt);
  //       } catch (ipfsError) {
  //         print("IPFS Error retrieving data for ${record[0]}: $ipfsError");
  //         return Record('IPFS Error: Could not retrieve data', EthereumAddress.fromHex(record[1]), record[2] as BigInt);
  //       }
  //     }).toList());
  //     setState(() {});
  //   } catch (e) {
  //     print("Error loading records: $e"); // Log error
  //     setState(() {
  //       _message = 'Error loading records: $e';
  //     });
  //   }
  // }



//   Future<void> _loadRecords() async {
//     if (_web3client == null || _contract == null) return;
//     try {
//         final getPatientRecordsFunction = _contract!.function('getPatientRecords');
//         final result = await _web3client!.call(
//             contract: _contract!,
//             function: getPatientRecordsFunction,
//             params: [widget.patientAddress]
//         );

//         print("Raw Result from getPatientRecords: $result"); // Log raw result

//         final recordsList = result.first as List;
//         print("Records List: $recordsList"); // Log records list

//         _records = await Future.wait(recordsList.map((record) async {
//             // Fetch data from IPFS using hash
//             final dataBytes = await _ipfsClient.cat(record[0] as String);
//             final data = utf8.decode(dataBytes);

//             return Record(
//                 data,
//                 EthereumAddress.fromHex(record[1]),
//                 record[2] as BigInt
//             );
//         }).toList());

//         setState(() {});
//     } catch (e) {
//         print("Error loading records: $e"); // Log error
//         setState(() {
//             _message = 'Error loading records: $e';
//         });
//     }
// }

// Future<void> _loadRecords() async {
//   if (_web3client == null || _contract == null) return;

//   try {
//     final getPatientRecordsFunction = _contract!.function('getPatientRecords');
//     final result = await _web3client!.call(
//       contract: _contract!,
//       function: getPatientRecordsFunction,
//       params: [widget.patientAddress],
//     );

//     print("Raw Result from getPatientRecords: $result"); // Log raw result

//     final recordsList = result.first as List;
//     print("Records List: $recordsList"); // Log records list

//     _records = await Future.wait(recordsList.map((record) async {
//       // Fetch data from IPFS using hash
//       final data = await fetchFromIPFS(record[0] as String) ?? "Failed to fetch from IPFS";

//       return Record(
//         data,
//         EthereumAddress.fromHex(record[1]),
//         record[2] as BigInt,
//       );
//     }).toList());

//     setState(() {});
//   } catch (e) {
//     print("Error loading records: $e");
//     setState(() {
//       _message = 'Error loading records: $e';
//     });
//   }
// }


// Future<String?> uploadToIPFS(String data) async {
//   try {
//     var uri = Uri.parse("http://127.0.0.1:5001/api/v0/add"); // Update with your IPFS node URL

//     var request = http.MultipartRequest('POST', uri)
//       ..files.add(http.MultipartFile.fromString('file', data));

//     var response = await request.send();
//     if (response.statusCode == 200) {
//       var responseData = await response.stream.bytesToString();
//       var jsonData = jsonDecode(responseData);
//       return jsonData['Hash']; // The IPFS hash
//     } else {
//       print("IPFS Upload Failed: ${response.statusCode}");
//       return null;
//     }
//   } catch (e) {
//     print("Error uploading to IPFS: $e");
//     return null;
//   }
// }

Future<String?> uploadToIPFS(String data) async {
  try {
    final uri = Uri.parse("http://127.0.0.1:5001/api/v0/add");

    var request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile.fromString('file', data));

    var response = await request.send();

    print("Response Status Code: ${response.statusCode}");
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      print("Response Data: $responseData");
      var jsonData = jsonDecode(responseData);
      return jsonData['Hash'];
    } else {
      print("IPFS Upload Failed: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error uploading to IPFS: $e");
    return null;
  }
}
// Future<String?> fetchFromIPFS(String hash) async {
//   try {
//     var url = "http://127.0.0.1:8080/ipfs/$hash"; // Change this if using Infura
//     var response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       return response.body; // Return the IPFS stored data
//     } else {
//       print("IPFS Fetch Failed: ${response.statusCode}");
//       return null;
//     }
//   } catch (e) {
//     print("Error fetching from IPFS: $e");
//     return null;
//   }
// }

  // Future<void> _loadRecords() async {
  //   if (_web3client == null || _contract == null) return;
  //   try {
  //     final getPatientRecordsFunction = _contract!.function('getPatientRecords');
  //     final result = await _web3client!.call(contract: _contract!, function: getPatientRecordsFunction, params: [widget.patientAddress]);

  //     print("Raw Result from getPatientRecords: $result");
  //     final recordsList = result.first as List;
  //     print("Records List: $recordsList");

  //     _records = await Future.wait(recordsList.map((record) async {
  //       try {
  //         final dataBytes = await ipfsClient.read(record[0] as String, dir: '');
  //         final data = utf8.decode(dataBytes);
  //         return Record(data, EthereumAddress.fromHex(record[1]), record[2] as BigInt);
  //       } catch (ipfsError) {
  //         print("IPFS Error retrieving data for ${record[0]}: $ipfsError");
  //         return Record('IPFS Error: Could not retrieve data', EthereumAddress.fromHex(record[1]), record[2] as BigInt);
  //       }
  //     }).toList());

  //     setState(() {});
  //   } catch (e) {
  //     print("Error loading records: $e");
  //     setState(() {
  //       _message = 'Error loading records: $e';
  //     });
  //   }
  // }
  

  Future<void> _loadRecords() async {
  if (_web3client == null || _contract == null) return;

  try {
    final getPatientRecordsFunction = _contract!.function('getPatientRecords');
    final result = await _web3client!.call(
      contract: _contract!,
      function: getPatientRecordsFunction,
      params: [widget.patientAddress],
    );

    print("Raw Result from getPatientRecords: $result");
    final recordsList = result.first as List;
    print("Records List: $recordsList");

    _records = await Future.wait(recordsList.map((record) async {
      try {
        // Fetch data from IPFS using the hash
        final dataBytes = await ipfsClient.read(dir: record[0] as String);
        final data = utf8.decode(dataBytes);
        return Record(data, EthereumAddress.fromHex(record[1]), record[2] as BigInt);
      } catch (ipfsError) {
        print("IPFS Error retrieving data for ${record[0]}: $ipfsError");
        return Record('IPFS Error: Could not retrieve data', EthereumAddress.fromHex(record[1]), record[2] as BigInt);
      }
    }).toList());

    setState(() {});
  } catch (e) {
    print("Error loading records: $e");
    setState(() {
      _message = 'Error loading records: $e';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Records')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(_message),
            TextField(
              controller: _recordDataController,
              decoration: InputDecoration(labelText: 'Record Data'),
            ),
            ElevatedButton(onPressed: _addRecord, child: Text('Add Record')),
            Expanded(
              child: ListView.builder(
                itemCount: _records.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_records[index].data),
                    subtitle: Text('Creator: ${_records[index].creator.hex}'),
                    trailing: Text('Timestamp: ${_records[index].timestamp}'),
                  );
                },
              ),
            ),
          ],
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
enum Role { None, Patient, Doctor } // Define the Role enum