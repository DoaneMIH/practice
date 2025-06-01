import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Connector {
  static late EthereumAddress address;
  static late String key;
  static String blockchainUrl =
      "http://127.0.0.1:7545"; // Replace with your Ganache URL

  static Client httpClient = Client();
  static Web3Client ethClient = Web3Client(blockchainUrl, httpClient);

  // Load the HealthSystem contract
  static Future<DeployedContract> getContractHealthSystem() async {
    String abiFile = await rootBundle.loadString(
      "build/contracts/HealthSystem.json",
    );
    Map<String, dynamic> jsonAbi = jsonDecode(abiFile);
    String abi = jsonEncode(jsonAbi['abi']);
    String contractAddress =
        "0x9Ac4CB5B3182FF54EdcF82a52027bc1F5c16fe33"; // Replace with your deployed contract address

    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "HealthSystem"),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  }

  //Load the Medical Certificate contract
  static Future<DeployedContract> getContractMedicalCertificate() async {
    String abiFile = await rootBundle.loadString(
      "build/contracts/MedicalCertificate.json",
    );
    Map<String, dynamic> jsonAbi = jsonDecode(abiFile);
    String abi = jsonEncode(jsonAbi['abi']);
    String contractAddress =
        "0xCa0d373fED28C7Ed76BE3fc0Ee92e2c3E30c0ba9"; // Replace with your deployed contract address

    final contract = DeployedContract(
      ContractAbi.fromJson(abi, "MedicalCertificate"),
      EthereumAddress.fromHex(contractAddress),
    );

    return contract;
  } 

  // Get the role of a user
  static Future<String?> getRole(String privateKey) async {
    try {
      final credentials = EthPrivateKey.fromHex(privateKey);
      final EthereumAddress userAddress = await credentials.extractAddress();

      final contract = await getContractHealthSystem();
      final function = contract.function("getRole");

      final result = await ethClient.call(
        contract: contract,
        function: function,
        params: [userAddress],
      );

      if (result.isNotEmpty) {
        return result[0] as String;
      }
      return null;
    } catch (e) {
      print("Error retrieving role: $e");
      Fluttertoast.showToast(msg: "Error retrieving role: ${e.toString()}");
      return null;
    }
  }

  static Future<String> getName(String userAddress) async {
    try {
      final EthereumAddress address = EthereumAddress.fromHex(userAddress);

      final contract = await getContractHealthSystem();
      final function = contract.function("getName");

      final result = await ethClient.call(
        contract: contract,
        function: function,
        params: [address],
      );

      return result.isNotEmpty ? result[0] as String : "Unknown";
    } catch (e) {
      print("Error fetching name: $e");
      return "Unknown";
    }
  }

  static Future<String> getDoctorLicense(String doctorAddress) async {
  try {
    final contract = await getContractHealthSystem();
    final function = contract.function('doctorLicenses');
    final result = await ethClient.call(
      contract: contract,
      function: function,
      params: [EthereumAddress.fromHex(doctorAddress)],
    );
    return result.isNotEmpty ? result[0] as String : "";
  } catch (e) {
    print("Error fetching doctor license: $e");
    Fluttertoast.showToast(msg: "Error fetching doctor license: ${e.toString()}");
    return "Unknown";
  }
//   String license = await Connector.getDoctorLicense(doctorAddress);
//   print("Doctor's license: $license");
}

  // Add a doctor
  static Future<bool> addDoctor(
    String address,
    String privateKey,
    String name,
  ) async {
    EthereumAddress addr = EthereumAddress.fromHex(address);
    Credentials key = EthPrivateKey.fromHex(privateKey);

    final contract = await getContractHealthSystem();
    final function = contract.function("addDoctor");

    try {
      await ethClient.sendTransaction(
        key,
        Transaction.callContract(
          contract: contract,
          function: function,
          parameters: [addr, name],
          maxGas: 100000,
        ),
        chainId: 1337,
      );
      return true;
    } catch (e) {
      print("Error adding doctor: $e");
      return false;
    }
  }

  // Add a patient
  static Future<bool> addPatient(
    String address,
    String privateKey,
    String name,
  ) async {
    EthereumAddress addr = EthereumAddress.fromHex(address);
    Credentials key = EthPrivateKey.fromHex(privateKey);

    final contract = await getContractHealthSystem();
    final function = contract.function("addPatient");

    try {
      await ethClient.sendTransaction(
        key,
        Transaction.callContract(
          contract: contract,
          function: function,
          parameters: [addr, name],
          maxGas: 100000,
        ),
        chainId: 1337,
      );
      return true;
    } catch (e) {
      print("Error adding patient: $e");
      return false;
    }
  }

  static Future<bool> signUpWithRole(
    String userAddress,
    String privateKey,
    String role,
    String name,
    [String? license] // Make license optional
  ) async {
    try {
      final credentials = EthPrivateKey.fromHex(privateKey);
      final EthereumAddress address = EthereumAddress.fromHex(userAddress);

      final contract = await getContractHealthSystem();
      final function = contract.function("signUp");

      // If your contract supports license, add it to parameters. Otherwise, ignore.
    // final params = (license != null && license.isNotEmpty)
    //     ? [address, name, role, license]
    //     : [address, name, role];
      final params = [address, name, role, license ?? ""];


      final result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: function,
          parameters: params,
          maxGas: 300000, // Increased gas limit
        ),
        chainId: 1337, // Replace with your chain ID
      );

      print("SignUp Transaction Hash: $result");
      return true;
    } catch (e) {
      print("Error during signup: $e");
      return false;
    }
  }

  static Future<bool> grantAccess(
    String patientPrivateKeyHex,
    String doctorAddressHex,
  ) async {
    try {
      final credentials = EthPrivateKey.fromHex(patientPrivateKeyHex);
      final patientAddress = await credentials.extractAddress();
      final doctorAddress = EthereumAddress.fromHex(doctorAddressHex);
      
      // 🧾 Print for debugging
    // final balance = await ethClient.getBalance(patientAddress);
    // print("🧾 Patient: ${patientAddress.hex}");
    // print("💰 Balance: ${balance.getValueInUnit(EtherUnit.ether)} ETH");

      final contract = await getContractHealthSystem();
      final function = contract.function("grantAccess");

      final transactionHash = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: function,
          parameters: [doctorAddress],
          from: patientAddress,
          maxGas: 300000,
        ),
        chainId: 1337,
      );

      final receipt = await waitForTransactionReceipt(transactionHash);
      return receipt != null && receipt.status == true;
    } catch (e) {
      print("Error granting access connector: $e");
      return false;
    }
  }


static Future<bool> revokeAccess(String patientPrivateKey, String doctorAddress) async {
  try {
    final credentials = EthPrivateKey.fromHex(patientPrivateKey);
    final patientAddress = await credentials.extractAddress();

    // 🧾 Print for debugging
    // final balance = await ethClient.getBalance(patientAddress);
    // print("🧾 Patient: ${patientAddress.hex}");
    // print("💰 Balance: ${balance.getValueInUnit(EtherUnit.ether)} ETH");

    final contract = await getContractHealthSystem();
    final function = contract.function("revokeAccess");

    final transactionHash = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [EthereumAddress.fromHex(doctorAddress)],
        from: patientAddress,
        gasPrice: EtherAmount.inWei(BigInt.from(20000000000)), // ✅ Set to 20 Gwei
        maxGas: 100000,
        value: EtherAmount.zero(), // ✅ Ensure no ETH is being sent
      ),
      chainId: 1337,
    );

    final receipt = await waitForTransactionReceipt(transactionHash);
    return receipt != null && receipt.status == true;
  } catch (e) {
    print("❌ Error revoking access in connector: $e");
    return false;
  }
}



  // Get patients for a doctor
  static Future<List<Map<String, String>>> getPatientsForDoctor(
    String privateKey,
  ) async {
    try {
      final credentials = EthPrivateKey.fromHex(privateKey);
      final EthereumAddress doctorAddress = await credentials.extractAddress();

      final contract = await getContractHealthSystem();
      final function = contract.function("getPatientsForDoctor");

      final result = await ethClient.call(
        contract: contract,
        function: function,
        params: [doctorAddress],
      );

      List<dynamic> patientAddresses = result[0];
      List<dynamic> patientNames = result[1];
      List<dynamic> timestamps = result[2];

      List<Map<String, String>> patients = [];
      for (int i = 0; i < patientAddresses.length; i++) {
        patients.add({
          "address": patientAddresses[i].toString(),
          "name": patientNames[i].toString(),
          "timestamp":
              DateTime.fromMillisecondsSinceEpoch(
                BigInt.parse(timestamps[i].toString()).toInt() * 1000,
              ).toString(),
        });
      }

      return patients;
    } catch (e) {
      print("Error fetching patients for doctor: $e");
      return [];
    }
  }

  // Wait for transaction receipt (you might not need this if using getTransactionReceipt with timeout)
  static Future<TransactionReceipt?> waitForTransactionReceipt(
    String transactionHash,
  ) async {
    int attempts = 0;
    const int maxAttempts = 60;
    const Duration delay = Duration(seconds: 1);

    while (attempts < maxAttempts) {
      try {
        final receipt = await ethClient.getTransactionReceipt(transactionHash);
        if (receipt != null) {
          return receipt;
        }
      } catch (e) {
        print("Error fetching transaction receipt: $e");
      }

      await Future.delayed(delay);
      attempts++;
    }

    return null;
  }

  static Future<List<Map<String, dynamic>>> getGrantedDoctors(
    String patientAddressHex,
  ) async {
    final EthereumAddress patientAddress = EthereumAddress.fromHex(
      patientAddressHex,
    );

    final contract = await getContractHealthSystem();
    final function = contract.function("getGrantedDoctors");

    final result = await ethClient.call(
      contract: contract,
      function: function,
      params: [patientAddress],
    );

    // Decode results
    List<dynamic> addresses = result[0];
    List<dynamic> names = result[1];
    List<dynamic> timestamps = result[2];

    List<Map<String, dynamic>> doctors = [];
    for (int i = 0; i < addresses.length; i++) {
      doctors.add({
        "address": addresses[i].toString(),
        "name": names[i],
        "timestamp":
            DateTime.fromMillisecondsSinceEpoch(
              (timestamps[i] as BigInt).toInt() * 1000,
            ).toString(),
      });
    }

    return doctors;
  }

    // Doctor requests access to a patient's record
  // static Future<void> requestAccessToPatient(String doctorPrivateKey, String patientAddressHex) async {
  //   try{
  //     final credentials  = EthPrivateKey.fromHex(doctorPrivateKey);
  //     final doctorAddress = await credentials.extractAddress();
  //     final patientAddress = EthereumAddress.fromHex(patientAddressHex);

  //     final contract = await getContractHealthSystem();
  //     final function = contract.function("requestAccess");

  //     final transactionHash = await ethClient.sendTransaction(
  //       credentials,
  //       Transaction.callContract(
  //         contract: contract,
  //         function: function,
  //         parameters: [patientAddress],
  //         from: doctorAddress,
  //         maxGas: 100000,
  //       ),
  //       chainId: 1337,
  //     );
  //     final receipt = await waitForTransactionReceipt(transactionHash);
  //     if(receipt != null && receipt.status == true){
  //       Fluttertoast.showToast(msg: "Access request sent to patient $patientAddressHex");
  //     }else{
  //       Fluttertoast.showToast(msg: "Failed to send access request");
  //     }
  //   }catch(e){
  //     print("Error requesting access connector: $e");
  //   }
  // }

  static Future<void> requestAccessToPatient(String doctorPrivateKey, String patientAddressHex) async {
  try {
    final credentials = EthPrivateKey.fromHex(doctorPrivateKey);
    final doctorAddress = await credentials.extractAddress();
    final patientAddress = EthereumAddress.fromHex(patientAddressHex);

    final contract = await getContractHealthSystem();
    final function = contract.function("requestAccess");

    final transactionHash = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [patientAddress],
        from: doctorAddress,
        maxGas: 100000,
      ),
      chainId: 1337,
    );

    final receipt = await waitForTransactionReceipt(transactionHash);
    if (receipt != null && receipt.status == true) {
      Fluttertoast.showToast(
        msg: "Access request sent to patient $patientAddressHex",
        backgroundColor: Colors.green,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed to send access request",
        backgroundColor: Colors.red,
      );
    }
  } catch (e) {
    print("Error requesting access connector: $e");
    Fluttertoast.showToast(
      msg: "Error: ${e.toString()}",
      backgroundColor: Colors.red,
    );
  }
}


Future<List<Map<String, dynamic>>> getPendingRequests(String patientHex) async {
  final contract = await getContractHealthSystem();
  final function = contract.function('getAccessRequestsWithDetails');
  final patient = EthereumAddress.fromHex(patientHex);

  final result = await ethClient.call(
    contract: contract,
    function: function,
    params: [patient],
  );

  final addresses = result[0] as List;
  final names = result[1] as List;
  final timestamps = result[2] as List;

  return List.generate(addresses.length, (i) => {
    'address': addresses[i] as EthereumAddress,
    'name': names[i] as String,
    'timestamp': BigInt.parse(timestamps[i].toString()).toInt(),
  });
}


  static Future<List<Map<String, dynamic>>> getRequestingDoctors(String patientAddressHex) async {
  try {
    final patientAddress = EthereumAddress.fromHex(patientAddressHex);

    final contract = await getContractHealthSystem();
    final function = contract.function("getAccessRequestsWithDetails");

    final result = await ethClient.call(
      contract: contract,
      function: function,
      params: [patientAddress],
    );

    List<dynamic> addresses = result[0];
    List<dynamic> names = result[1];
    List<dynamic> timestamps = result[2];

    List<Map<String, dynamic>> requestingDoctors = [];

    for (int i = 0; i < addresses.length; i++) {
      requestingDoctors.add({
        "address": addresses[i].toString(),
        "name": names[i],
        "timestamp": DateTime.fromMillisecondsSinceEpoch(
          (timestamps[i] as BigInt).toInt() * 1000,
        ).toString(),
      });
    }

    return requestingDoctors;
  } catch (e) {
    print("❌ Error in getRequestingDoctors: $e");
    return [];
  }
}

//ONGOING 

  static Future<void> addRecord(
  String privateKey,
  String patientAddress,
  String ipfsHash,
) async {
  try {
    final credentials = EthPrivateKey.fromHex(privateKey);
    final EthereumAddress patient = EthereumAddress.fromHex(patientAddress);

    final contract = await getContractHealthSystem();
    final function = contract.function("addRecord");

    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [patient, ipfsHash],
      ),
      chainId: 1337, // Set to your chain ID
    );

    print("Record added successfully on-chain.");
  } catch (e) {
    print("Error adding record on-chain: $e");
    throw e;
  }
}

static Future<List<String>> getRecords(
  String privateKey,
  String patientAddress,
) async {
  try {
    final credentials = EthPrivateKey.fromHex(privateKey);
    final EthereumAddress patient = EthereumAddress.fromHex(patientAddress);

    final contract = await getContractHealthSystem();
    final function = contract.function("getRecords");

    final result = await ethClient.call(
      contract: contract,
      function: function,
      params: [patient, credentials.address],
    );

    return (result[0] as List<dynamic>).map((e) => e.toString()).toList();
  } catch (e) {
    print("Error fetching records: $e");
    return [];
  }
}

static Future<dynamic> getPresc(EthereumAddress address) async {
    try {
      final contract = await getContractHealthSystem();
      final result = await ethClient.call(
          contract: contract,
          function: contract.function("viewPrescription"),
          params: [address]);
      return result[0];
    } catch (e) {
      print("Error getting prescription: $e");
      Fluttertoast.showToast(msg: "Error getting prescription");
      return null;
    }
  }

  static Future<void> updateDoctorFee(String privateKey, String amount) async {
  try {
    Credentials key = EthPrivateKey.fromHex(privateKey);
    final contract = await getContractHealthSystem();
    final function = contract.function("updateFee");

    await ethClient.sendTransaction(
      key,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [BigInt.parse(amount)],
        maxGas: 100000,
      ),
      chainId: 1337,
    );
  } catch (e) {
    print("Error updating doctor fee: $e");
    Fluttertoast.showToast(msg: "Error updating doctor fee: ${e.toString()}");
  }
}

static Future<void> updateFee(String fee) async {
  final credentials = EthPrivateKey.fromHex(Connector.key);
  final contract = await getContractHealthSystem();
  final function = contract.function('updateFee');
  await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: function,
      parameters: [BigInt.parse(fee)],
    ),
    chainId: 1337,
  );
}

static Future<String> getFee(EthereumAddress address) async {
  try {
    print("Calling getFee for address: $address");
    final contract = await getContractHealthSystem();
    final function = contract.function("getFee");
    final result = await ethClient.call(
      contract: contract,
      function: function,
      params: [address]
    );
    print("getFee result: $result");
    String fee = result[0].toString();
    print("Parsed fee: $fee");
    if (fee.isEmpty || fee == "0" || !RegExp(r'^\d+$').hasMatch(fee)) {
      print("🚨 Invalid fee returned: $fee");
      return "0"; 
    }
    return fee;
  } catch (e) {
    print("🚨 Error getting fee: $e");
    Fluttertoast.showToast(msg: "Error getting fee");
    return "0";
  }
}

static Future<void> payForPrescription(EthereumAddress doctorAddress, String fee) async {
  try {
    print("payForPrescription called with doctorAddress: $doctorAddress, fee: $fee");
    final credentials = EthPrivateKey.fromHex(Connector.key);
    final contract = await getContractHealthSystem();
    final function = contract.function('payForPrescription');
    print("Sending transaction...");
    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [doctorAddress],
        value: EtherAmount.inWei(BigInt.parse(fee)),
      ),
      chainId: 1337,
    );
    print("Transaction sent!");
  } catch (e) {
    print("Error in payForPrescription: $e");
    Fluttertoast.showToast(msg: "Error paying fee: ${e.toString()}");
    rethrow;
  }
}

static Future<void> setPrescription(
  String content,
  String patientAddress,
  String doctorAddress,
  String privateKey,
) async {
  final credentials = EthPrivateKey.fromHex(privateKey);
  final contract = await getContractHealthSystem();
  final function = contract.function('setPrescription');
  await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: function,
      parameters: [
        content,
        EthereumAddress.fromHex(patientAddress),
        EthereumAddress.fromHex(doctorAddress),
      ],
    ),
    chainId: 1337,
  );
}

static Future<List<dynamic>> getMyPrescriptions(String privateKey) async {
  final credentials = EthPrivateKey.fromHex(privateKey);
  final EthereumAddress callerAddress = await credentials.extractAddress();
  final contract = await getContractHealthSystem();
  final function = contract.function('getMyPrescriptions');
  final result = await ethClient.call(
    contract: contract,
    function: function,
    params: [],
    sender: callerAddress,
  );
  return result[0] is List ? result[0] : result;
}


//Medical Certificate


// Get patients who granted access to the doctor
static Future<List<Map<String, String>>> getGrantedPatientsForDoctor(String doctorPrivateKey) async {
  final credentials = EthPrivateKey.fromHex(doctorPrivateKey);
  final doctorAddress = await credentials.extractAddress();
  final contract = await getContractHealthSystem();
  final function = contract.function('getPatientsForDoctor');
  final result = await ethClient.call(
    contract: contract,
    function: function,
    params: [doctorAddress],
  );
  // result[0] is a List of addresses
  List<EthereumAddress> addresses = (result[0] as List).cast<EthereumAddress>();
  List<Map<String, String>> patients = [];
  for (final addr in addresses) {
    // Use your getName function here
    final name = await getName(addr.hex);
    patients.add({
      'name': name,
      'address': addr.hex,
    });
  }
  return patients;
}

static Future<void> payForCertificate(String doctorAddress, String fee) async {
  try {
    print("payForCertificate called with doctorAddress: $doctorAddress, fee: $fee");
    final credentials = EthPrivateKey.fromHex(Connector.key);
    final contract = await getContractMedicalCertificate();
    final function = contract.function('payForCertificate');
    print("Sending certificate payment transaction...");
    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [EthereumAddress.fromHex(doctorAddress)],
        value: EtherAmount.inWei(BigInt.parse(fee)),
      ),
      chainId: 1337,
    );
    print("Certificate payment transaction sent!");
    Fluttertoast.showToast(msg: "Certificate fee paid!");
  } catch (e, stack) {
    print("Error in payForCertificate: $e");
    print(stack);
    Fluttertoast.showToast(msg: "Error paying certificate fee: ${e.toString()}");
    rethrow;
  }
}

static Future<void> issueCertificate(String content, String patientAddress, String doctorPrivateKey) async {
  try {
    print("issueCertificate called with content: $content, patientAddress: $patientAddress");
    final credentials = EthPrivateKey.fromHex(doctorPrivateKey);
  final contract = await getContractMedicalCertificate();
  final function = contract.function('issueCertificate');
  await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
      contract: contract,
      function: function,
      parameters: [
        content,
        EthereumAddress.fromHex(patientAddress),
      ],
    ),
    chainId: 1337,
  );
    print("Certificate issued successfully!");
    Fluttertoast.showToast(msg: "Certificate issued successfully!");
  } catch (e, stack) {
    print("Error in issueCertificate: $e");
    print(stack);
    Fluttertoast.showToast(msg: "Error issuing certificate: ${e.toString()}");
    rethrow;
  }
}

static Future<String> getCertificateFee(String doctorAddress) async {
  try {
    print("getCertificateFee called for doctor: $doctorAddress");
    final contract = await getContractMedicalCertificate();
    final function = contract.function('getCertificateFee');
    final result = await ethClient.call(
      contract: contract,
      function: function,
      params: [EthereumAddress.fromHex(doctorAddress)],
    );
    print("getCertificateFee result: $result");
    String fee = result[0].toString();
    print("Parsed certificate fee: $fee");
    return fee;
  } catch (e, stack) {
    print("Error in getCertificateFee: $e");
    print(stack);
    Fluttertoast.showToast(msg: "Error getting certificate fee: ${e.toString()}");
    return "0";
  }
}

static Future<void> setCertificateFee(String doctorPrivateKey, String fee) async {
  try {
    final credentials = EthPrivateKey.fromHex(doctorPrivateKey);
    final contract = await getContractMedicalCertificate();
    final function = contract.function('setCertificateFee');
    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [BigInt.parse(fee)],
      ),
      chainId: 1337,
    );
    Fluttertoast.showToast(msg: "Certificate fee set!");
  } catch (e) {
    print("Error setting certificate fee: $e");
    Fluttertoast.showToast(msg: "Error setting certificate fee: ${e.toString()}");
  }
}

static Future<List<String>> getCertificatesForPatient(String patientAddress) async {
  print("[DEBUG] getCertificatesForPatient called for address: $patientAddress");
  try {
    final contract = await getContractMedicalCertificate();
    print("[DEBUG] MedicalCertificate contract loaded.");
    final function = contract.function('viewCertificates');
    print("[DEBUG] Calling viewCertificates for $patientAddress...");
    final result = await ethClient.call(
      contract: contract,
      function: function,
      params: [EthereumAddress.fromHex(patientAddress)],
    );
    print("[DEBUG] Raw result from contract: $result");
    final certs = (result[0] as List).map((e) => e.toString()).toList();
    print("[DEBUG] Parsed certificates: $certs");
    return certs;
  } catch (e, stack) {
    print("[ERROR] Failed to fetch certificates: $e");
    print(stack);
    Fluttertoast.showToast(msg: "Error fetching certificates: ${e.toString()}");
    return [];
  }
}

static Future<void> registerDoctorOnMedicalCertificate(String doctorPrivateKey, String doctorName) async {
  try {
    final credentials = EthPrivateKey.fromHex(doctorPrivateKey);
    final contract = await getContractMedicalCertificate();
    final function = contract.function('addDoctor');
    print("[DEBUG] Registering doctor on MedicalCertificate: $doctorName");
    await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [
          await credentials.extractAddress(), // doctor address
          doctorName,                         // doctor name
        ],
      ),
      chainId: 1337, // <-- set your chainId
    );
    Fluttertoast.showToast(msg: "Doctor registered on MedicalCertificate!");
  } catch (e) {
    print("[ERROR] Failed to register doctor: $e");
    Fluttertoast.showToast(msg: "Error registering doctor: $e");
  }
}

}
