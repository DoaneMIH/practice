import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Connector {
  static late EthereumAddress address;
  static late String key;
  static String blockchainUrl = "http://127.0.0.1:7545";

  static Client httpClient = Client();
  static Web3Client ethClient = Web3Client(blockchainUrl, httpClient);

  static Future<int> getChainId() async {
    try {
      final networkId = await ethClient.getNetworkId();
      return networkId;
    } catch (e) {
      print("Error getting chain ID: $e");
      Fluttertoast.showToast(msg: "Error getting chain ID");
      return 1337; // Default to Ganache chain ID, or handle appropriately
    }
  }

  // static Future<TransactionReceipt?> waitForTransactionReceipt(
  //     Transaction transaction) async {
  //   int attempts = 0;
  //   while (attempts < 60) {
  //     try {
  //       TransactionReceipt? receipt =
  //           await ethClient.getTransactionReceipt(Object.hash as String);
  //       if (receipt != null && receipt.status == true) {
  //         return receipt;
  //       }
  //       await Future.delayed(const Duration(seconds: 5));
  //       attempts++;
  //     } catch (e) {
  //       print("Error getting transaction receipt: $e");
  //       Fluttertoast.showToast(msg: "Error getting transaction receipt");
  //       return null; // Or handle the error as needed.
  //     }
  //   }
  //   return null; // Transaction confirmation timed out
  // }

  static Future<TransactionReceipt?> waitForTransactionReceipt(String transactionHash) async {
  int attempts = 0;
  const int maxAttempts = 60; // Wait for up to 60 seconds
  const Duration delay = Duration(seconds: 1);

  while (attempts < maxAttempts) {
    try {
      final receipt = await ethClient.getTransactionReceipt(transactionHash);
      if (receipt != null) {
        return receipt; // Transaction is confirmed
      }
    } catch (e) {
      print("Error fetching transaction receipt: $e");
    }

    await Future.delayed(delay);
    attempts++;
  }

  return null; // Transaction confirmation timed out
}


  static Future<DeployedContract> getContractPatient() async {
  String abiFilePatient = await rootBundle.loadString("assets/patient.json");
  Map<String, dynamic> jsonAbi = jsonDecode(abiFilePatient); // Decode the JSON
  String abi = jsonEncode(jsonAbi['abi']); // Extract the 'abi' field and encode it as a string
  String contractAddress = "0x842cAf9E03d6859A784057171f92349b0e84BEf6"; // Replace with your Ganache-deployed address

  final contractPatient = DeployedContract(
    ContractAbi.fromJson(abi, "Patient"),
    EthereumAddress.fromHex(contractAddress),
  );

  return contractPatient;
}
  static Future<DeployedContract> getContractDoctor() async {
  String abiFileDoctor = await rootBundle.loadString("assets/doctor.json");
  Map<String, dynamic> jsonAbi = jsonDecode(abiFileDoctor); // Decode the JSON
  String abi = jsonEncode(jsonAbi['abi']); // Extract the 'abi' field and encode it as a string
  String contractAddress = "0xf8a8f3bC4220aA0E20147EF7F90f2c5cdC0De3D1"; // Replace with your Ganache-deployed address

  final contractDoctor = DeployedContract(
    ContractAbi.fromJson(abi, "Doctor"),
    EthereumAddress.fromHex(contractAddress),
  );

  return contractDoctor;
}


static Future<bool> signUpPatient(String address, String privateKey) async {
  EthereumAddress addr = EthereumAddress.fromHex(address);
  Credentials key = EthPrivateKey.fromHex(privateKey);

  final contract = await getContractPatient();
  final function = contract.function("addPatient");

  try {
    await ethClient.sendTransaction(
      key,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [addr],
        maxGas: 100000, // Set a reasonable gas limit
        maxFeePerGas: EtherAmount.inWei(BigInt.from(50000000000)), // 50 Gwei
        maxPriorityFeePerGas: EtherAmount.inWei(BigInt.from(2000000000)), // 2 Gwei
      ),
      chainId: 1337, // Replace with your Ganache chain ID
    );
    return true;
  } catch (e) {
    print("Error signing up patient: $e");
    return false;
  }
}

static Future<bool> signUpDoctor(String address, String privateKey) async {
  EthereumAddress addr = EthereumAddress.fromHex(address);
  Credentials key = EthPrivateKey.fromHex(privateKey);

  final contract = await getContractDoctor();
  final function = contract.function("addDoctor");

  try {
    await ethClient.sendTransaction(
      key,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [addr],
        maxGas: 100000, // Set a reasonable gas limit
        maxFeePerGas: EtherAmount.inWei(BigInt.from(50000000000)), // 2 Gwei
        maxPriorityFeePerGas: EtherAmount.inWei(BigInt.from(2000000000)), // 1 Gwei
      ),
      chainId: 1337, // Replace with your Ganache chain ID
    );
    return true;
  } catch (e) {
    print("Error signing up doctor: $e");
    return false;
  }
}

static Future<bool> isDoctor(EthereumAddress doctorAddress) async {
  try {
    final contract = await getContractDoctor(); // Load the doctor contract
    final function = contract.function("isDoctor"); // Smart contract function to check existence

    // Call the smart contract function
    List<dynamic> result = await ethClient.call(
      contract: contract,
      function: function,
      params: [doctorAddress],
    );

    // Return the result (assuming the function returns a boolean)
    return result.isNotEmpty && result[0] as bool;
  } catch (e) {
    print("Error checking if doctor exists: $e");
    Fluttertoast.showToast(msg: "Error checking if doctor exists");
    return false;
  }
}

  static Future<bool> isDoctorExists(EthereumAddress address) async {
    try {
      final contract = await getContractDoctor();
      final result = await ethClient.call(
          contract: contract,
          function: contract.function("isDoctor"),
          params: [address]);
      return result[0];
    } catch (e) {
      print("Error checking doctor existence: $e");
      Fluttertoast.showToast(msg: "Error checking doctor existence");
      return false;
    }
  }

  static Future<bool> isPatientExists(EthereumAddress address) async {
    try {
        final contract = await getContractPatient();
        final result = await ethClient.call(
            contract: contract,
            function: contract.function("isPatient"),
            params: [address]);
        return result[0] as bool; // Cast to boolean
    } catch (e) {
        print("Error checking patient existence: $e");
        Fluttertoast.showToast(msg: "Error checking patient existence");
        return false;
    }
}

  static Future<String> getFee(EthereumAddress address) async {
  try {
    final contract = await getContractDoctor();
    final function = contract.function("getFee");
    final result = await ethClient.call(
      contract: contract,
      function: function,
      params: [address]
    );

    String fee = result[0].toString();
    print("🔹 Raw Fee from Contract: $fee"); // Debugging

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

  static Future<bool> isAuthorized(
      EthereumAddress doc, EthereumAddress pat) async {
    try {
      final contract = await getContractPatient();
      final result = await ethClient.call(
          contract: contract,
          function: contract.function("isAuthorized"),
          params: [doc, pat]);
      return result[0];
    } catch (e) {
      print("Error checking authorization: $e");
      Fluttertoast.showToast(msg: "Error checking authorization");
      return false;
    }
  }

  static Future<dynamic> getPresc(EthereumAddress address) async {
    try {
      final contract = await getContractPatient();
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

  static Future<bool> logInDoctor(String address, String privateKey) async {
    try {
      EthereumAddress addr = EthereumAddress.fromHex(address);
      bool result = await isDoctorExists(addr);
      if (result) return true;

      Credentials key = EthPrivateKey.fromHex(privateKey);
      final contract = await getContractDoctor();
      final function = contract.function("addDoctor");
      final chainId = await getChainId();

      Transaction transaction = (await ethClient.sendTransaction(
          key,
          Transaction.callContract(
              contract: contract, function: function, parameters: [addr]),
          chainId: chainId)) as Transaction;

      TransactionReceipt? receipt = await waitForTransactionReceipt(transaction as String);
      if (receipt == null) {
        throw Exception("Transaction confirmation timed out.");
      }
      result = await isDoctorExists(addr);
      return result;
    } catch (e) {
      print("Error logging in doctor: $e");
      Fluttertoast.showToast(msg: "Error logging in doctor: ${e.toString()}");
      return false;
    }
  }

  static Future<bool> logInPatient(String address, String privateKey) async {
    try {
      EthereumAddress addr = EthereumAddress.fromHex(address);
      bool result = await isPatientExists(addr);
      if (result) return true;

      Credentials key = EthPrivateKey.fromHex(privateKey);
      final contract = await getContractPatient();
      final function = contract.function("addPatient");
      final chainId = await getChainId();

      Transaction transaction = (await ethClient.sendTransaction(
          key,
          Transaction.callContract(
              contract: contract, function: function, parameters: [addr]),
          chainId: chainId)) as Transaction;

      TransactionReceipt? receipt = await waitForTransactionReceipt(transaction as String);
      if (receipt == null) {
        throw Exception("Transaction confirmation timed out.");
      }
      result = await isPatientExists(addr);
      return result;
    } catch (e) {
      print("Error logging in patient: $e");
      Fluttertoast.showToast(msg: "Error logging in patient: ${e.toString()}");
      return false;
    }
  }

  // static Future<String> updateDoctorFee(
  //     EthereumAddress address, String privateKey, String amount) async {
  //   try {
  //     Credentials key = EthPrivateKey.fromHex(privateKey);
  //     final contract = await getContractDoctor();
  //     final function = contract.function("updateFee");
  //     final chainId = await getChainId();

  //     Transaction transaction = (await ethClient.sendTransaction(
  //         key,
  //         Transaction.callContract(
  //             contract: contract,
  //             function: function,
  //             parameters: [address, BigInt.parse(amount)]),
  //         chainId: chainId)) as Transaction;

  //     TransactionReceipt? receipt = await waitForTransactionReceipt(transaction);
  //     if (receipt == null) {
  //       throw Exception("Transaction confirmation timed out.");
  //     }
  //     String result = await getFee(address);
  //     return result;
  //   } catch (e) {
  //     print("Error updating doctor fee: $e");
  //     Fluttertoast.showToast(msg: "Error updating doctor fee: ${e.toString()}");
  //     return "0";
  //   }
  // }

  static Future<String> updateDoctorFee(
    EthereumAddress address, String privateKey, String amount) async {
  try {
    Credentials key = EthPrivateKey.fromHex(privateKey);
    final contract = await getContractDoctor();
    final function = contract.function("updateFee");
    final chainId = await getChainId();

    // Send the transaction and get the transaction hash
    String transactionHash = await ethClient.sendTransaction(
      key,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [address, BigInt.parse(amount)],
        maxGas: 100000, // Set a reasonable gas limit
      ),
      chainId: chainId,
    );

    // Wait for the transaction receipt using the transaction hash
    // TransactionReceipt? receipt = await waitForTransactionReceipt(transactionHash as Transaction);
    // if (receipt == null) {
    //   throw Exception("Transaction confirmation timed out.");
    // }

    // Fetch the updated fee
    String result = await getFee(address);
    return result;
  } catch (e) {
    print("Error updating doctor fee: $e");
    Fluttertoast.showToast(msg: "Error updating doctor fee: ${e.toString()}");
    return "0";
  }
}


// static Future<bool> addAuthorization(
//     EthereumAddress doc, EthereumAddress pat, String privateKey) async {
//   try {
//     // Check if already authorized
//     bool result = await isAuthorized(doc, pat);
//     if (result) return true;

//     // Get transaction fee
//     String fee = await getFee(doc);
//     print("Fee Retrieved: $fee");


//     // Generate credentials
//     Credentials key = EthPrivateKey.fromHex(privateKey);

//     // Get contract instance
//     final contract = await getContractPatient();
//     final function = contract.function("addAuthorization");

//     // Send transaction
//     final txHash = await ethClient.sendTransaction(
//       key,
//       Transaction.callContract(
//         value: EtherAmount.fromUnitAndValue(EtherUnit.wei, fee),
//         contract: contract,
//         function: function,
//         parameters: [doc, pat, BigInt.parse(fee)],
//       ),
//       chainId: 1337, // Change this to match your private blockchain
//     );

//     print("Transaction sent: $txHash");

//     print("Transaction confirmation timeout!");
//     return false;
//   } catch (e) {
//     print("Error in addAuthorization: $e");
//     return false;
//   }
// }

static Future<bool> addAuthorization(
    EthereumAddress doc, EthereumAddress pat, String privateKey) async {
  try {
    bool result = await isAuthorized(doc, pat);
    if (result) return true;

    String fee = await getFee(doc);
    print("🔹 Fee Retrieved: $fee"); // Debugging

    // Ensure the fee is valid
    if (fee.isEmpty || fee == "0" || !RegExp(r'^\d+$').hasMatch(fee)) {
      print("🚨 Invalid fee: $fee");
      Fluttertoast.showToast(msg: "Error: Invalid fee retrieved");
      return false;
    }

    BigInt feeBigInt;
    try {
      feeBigInt = BigInt.parse(fee);
      print("✅ Parsed Fee: $feeBigInt");
    } catch (e) {
      print("🚨 Error parsing fee: $e");
      return false;
    }

    Credentials key = EthPrivateKey.fromHex(privateKey);
    final contract = await getContractPatient();
    final function = contract.function("addAuthorization");

    final txHash = await ethClient.sendTransaction(
      key,
      Transaction.callContract(
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, feeBigInt),
        contract: contract,
        function: function,
        parameters: [doc, pat, feeBigInt],
      ),
      chainId: 1337, // Update with your private blockchain chain ID
    );

    print("✅ Transaction sent: $txHash");
    return true;
  } catch (e) {
    print("🚨 Error in addAuthorization: $e");
    return false;
  }
}
  static Future<void> setPresc(EthereumAddress doc, EthereumAddress pat,
      String privateKey, String prescription) async {
    try {
      if (await isAuthorized(doc, pat)) {
        Credentials key = EthPrivateKey.fromHex(privateKey);
        final contract = await getContractPatient();
        final function = contract.function("setPrescription");
        final chainId = await getChainId();
        Transaction transaction = (await ethClient.sendTransaction(
            key,
            Transaction.callContract(
                contract: contract,
                function: function,
                parameters: [prescription, pat, doc]),
            chainId: chainId)) as Transaction;
        TransactionReceipt? receipt =
            await waitForTransactionReceipt(transaction as String);
        if (receipt == null) {
          throw Exception("Transaction confirmation timed out.");
        }
      } else {
        Fluttertoast.showToast(msg: "You are not authorized");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Prescription set successfully");

      // print("Error setting prescription: $e");
      // Fluttertoast.showToast(msg: "Error setting prescription: ${e.toString()}");
    }
  }

  static Future<String> getGanacheBalance(String address) async {
    try {
      EthereumAddress ethAddress = EthereumAddress.fromHex(address);
      EtherAmount balance = await ethClient.getBalance(ethAddress);
      return balance.getValueInUnit(EtherUnit.ether).toString();
    } catch (e) {
      print("Error getting balance: $e");
      Fluttertoast.showToast(msg: "Error getting balance");
      return "0";
    }
  }

  static Future<List<String>> getAuthorizedPatients(EthereumAddress doctorAddress) async {
  try {
    // Load the patient contract
    final contract = await getContractPatient();

    // Get the function to fetch authorized patients
    final function = contract.function("getAccessiblePatients");

    // Call the function with the doctor's address
    final result = await ethClient.call(
      contract: contract,
      function: function,
      params: [doctorAddress],
    );

    // Convert the result to a list of strings (public keys)
    List<String> authorizedPatients = (result[0] as List<dynamic>)
        .map((e) => e.toString())
        .toList();

    return authorizedPatients;
  } catch (e) {
    print("Error fetching authorized patients: $e");
    Fluttertoast.showToast(msg: "Error fetching authorized patients");
    return [];
  }
}

// static Future<bool> revokeAuthorization(
//     EthereumAddress doctorAddress, EthereumAddress patientAddress, String privateKey) async {
//   try {
//     Credentials key = EthPrivateKey.fromHex(privateKey);
//     EthereumAddress senderAddress = await key.extractAddress();

//     // Ensure only the patient can revoke
//     if (senderAddress != patientAddress) {
//       print("🚨 Error: Only the patient can revoke authorization.");
//       Fluttertoast.showToast(msg: "Only the patient can revoke authorization");
//       return false;
//     }

//     final contract = await getContractPatient();
//     final function = contract.function("revokeAuthorization");

//     // Send the transaction to revoke authorization
//     final txHash = await ethClient.sendTransaction(
//       key,
//       Transaction.callContract(
//         contract: contract,
//         function: function,
//         parameters: [doctorAddress], // ✅ Fix: Only doctorAddress
//         maxGas: 100000, // Set a reasonable gas limit
//       ),
//       chainId: 1337, // Replace with your blockchain's chain ID
//     );

//     print("✅ Authorization revoked: $txHash");
//     return true;
//   } catch (e) {
//     print("🚨 Error revoking authorization: $e");
//     Fluttertoast.showToast(msg: "Error revoking authorization");
//     return false;
//   }
// }

static Future<bool> revokeAuthorization(
    EthereumAddress doctorAddress, EthereumAddress patientAddress, String privateKey) async {
  try {
    Credentials key = EthPrivateKey.fromHex(privateKey);
    final contract = await getContractPatient();
    final function = contract.function("revokeAuthorization");

    // Send the transaction to revoke authorization
    final txHash = await ethClient.sendTransaction(
      key,
      Transaction.callContract(
        contract: contract,
        function: function,
        parameters: [doctorAddress],
        maxGas: 100000, // Set a reasonable gas limit
      ),
      chainId: 1337, // Replace with your blockchain's chain ID
    );

    print("✅ Authorization revoked: $txHash");
    return true;
  } catch (e) {
    print("🚨 Error revoking authorization: $e");
    Fluttertoast.showToast(msg: "Error revoking authorization");
    return false;
  }
}
}