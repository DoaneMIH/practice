import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vital_link_chain/Utility/connector.dart';
import 'package:web3dart/web3dart.dart';

class AccessControlScreen extends StatefulWidget {
  const AccessControlScreen({super.key});

  @override
  State<AccessControlScreen> createState() => _AccessControlScreenState();
}

class _AccessControlScreenState extends State<AccessControlScreen> {
  // List<String> requestedDoctors = [];
  List<Map<String, dynamic>> requestedDoctors = [];

  List<Map<String, dynamic>> grantedDoctors =
      []; // Store as Map for easier access
  final TextEditingController doctorAddress = TextEditingController();
  List<Map<String, dynamic>> allDoctors = [];

  @override
  void initState() {
    super.initState();
    _fetchAccessData();
    _fetchAllDoctors();
  }

  Future<void> _fetchAllDoctors() async {
  try {
    final doctors = await Connector.getAllDoctors();
    setState(() {
      allDoctors = doctors;
    });
  } catch (e) {
    print("Error fetching all doctors: $e");
  }
}

  Future<void> _fetchAccessData() async {
    try {
      // Get patient's Ethereum address from private key
      final credentials = EthPrivateKey.fromHex(Connector.key);
      final address = await credentials.extractAddress();

      // Fetch list of granted doctors
      List<Map<String, dynamic>> fetchedDoctors =
          await Connector.getGrantedDoctors(address.hex);

      // Fetch list of requesting doctors
      // List<String> fetchedRequestedDoctors = (await Connector.getRequestingDoctors(address.hex)).cast<String>(); // Ensure this returns a list of addresses or names.
      List<Map<String, dynamic>> fetchedRequestedDoctors =
          (await Connector.getRequestingDoctors(
            address.hex,
          )).cast<Map<String, dynamic>>();
      // List<Map<String, dynamic>> fetchedRequestedDoctors = (await Connector.getPatientsForDoctor(address.hex)).cast<Map<String, dynamic>>();

      setState(() {
        grantedDoctors =
            fetchedDoctors; // Directly store the list of granted doctors
        requestedDoctors =
            fetchedRequestedDoctors
                .cast<
                  Map<String, dynamic>
                >(); // Store the list of requesting doctors
      });
    } catch (e) {
      print("Error fetching access data: $e");
    }
  }

  Future<void> _grantAccess(String doctorAddress) async {
    if (doctorAddress.isEmpty) {
      Fluttertoast.showToast(msg: "Doctor address cannot be empty");
      return;
    }

    try {
      // final credentials = EthPrivateKey.fromHex(Connector.key);
      // final address = await credentials.extractAddress();
      // print("Attempting to grant access from: ${address.hex} to: $doctorAddress"); // Log addresses

      bool success = await Connector.grantAccess(Connector.key, doctorAddress);
      String name =
          await Connector.getName(doctorAddress); // Fetch doctor's name
      // print("Grant access result: $success"); // Log the boolean result

      if (success) {
        Fluttertoast.showToast(msg: "Access granted to $name");
        // ✅ Remove from requestedDoctors list
        setState(() {
          requestedDoctors.removeWhere(
            (doctor) => doctor["address"] == doctorAddress,
          );
        });
        await Future.delayed(
          const Duration(seconds: 2),
        ); // Add a 2-second delay
        await _fetchAccessData();
      } else {
        Fluttertoast.showToast(
          msg: "Failed to grant access. Please try again.",
        );
      }
    } catch (e) {
      print("Error granting access: $e"); // Log the full error
      Fluttertoast.showToast(msg: "Error granting access: ${e.toString()}");
    }
  }

  Future<void> _denyAccess(String doctorAddress) async {
    setState(() {
      requestedDoctors.removeWhere(
        (doctor) => doctor["address"] == doctorAddress,
      );
    });
    Fluttertoast.showToast(msg: "Access denied for $doctorAddress");
  }

  Future<void> _revokeAccess(String doctorAddress) async {
    if (doctorAddress.isEmpty) {
      Fluttertoast.showToast(msg: "Doctor address cannot be empty");
      return;
    }
    try {
      // final credentials = EthPrivateKey.fromHex(Connector.key);
      // final address = await credentials.extractAddress();

      bool success = await Connector.revokeAccess(Connector.key, doctorAddress);
      if (success) {
        Fluttertoast.showToast(msg: "Access Revoke Successful");
        await Future.delayed(
          const Duration(seconds: 2),
        ); // Add a 2-second delay
        await _fetchAccessData();
      } else {
        Fluttertoast.showToast(msg: "Failed to revoke access");
      }
    } catch (e) {
      print("Error revoking access: $e"); // Log the full error
      Fluttertoast.showToast(msg: "Error revoking access");
    }
  }
  //make this public key
  // Future<void> _grantAccessByPrivateKey() async {
  //   String privateKey = doctorAddress.text.trim();
  //   if (privateKey.isEmpty) {
  //     Fluttertoast.showToast(msg: "Please enter a private key");
  //     return;
  //   }

  //   try {
  //     final credentials = EthPrivateKey.fromHex(privateKey);
  //     final EthereumAddress docAddress = await credentials.extractAddress();

  //     // ✅ Fetch doctor name from the smart contract
  //     String? doctorName = await Connector.getName(docAddress.hex);

  //     print("Doctor Address: ${docAddress.hex}");
  //     print("Doctor Name: $doctorName");

  //     // ✅ Grant access
  //     bool success = await Connector.grantAccess(Connector.key, docAddress.hex);

  //     if (success) {
  //       Fluttertoast.showToast(msg: "Access granted to $doctorName");

  //       // ✅ Refresh doctor list after granting access
  //       _fetchAccessData();
  //     } else {
  //       Fluttertoast.showToast(msg: "Failed to grant access");
  //     }
  //   } catch (e) {
  //     print("Error granting access by private key: $e");
  //     Fluttertoast.showToast(msg: "Error granting access: ${e.toString()}");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
  "All Registered Doctors",
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
const SizedBox(height: 10),
allDoctors.isEmpty
    ? const Text("No registered doctors found.")
    : ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: allDoctors.length,
        itemBuilder: (context, index) {
          final doctor = allDoctors[index];
          final alreadyGranted = grantedDoctors.any((g) => g["address"] == doctor["address"]);
          return Card(
            child: ListTile(
              title: Text(
                "Doctor Name: ${doctor["name"]}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Public Key: ${doctor["address"]}"),
              trailing: ElevatedButton(
                onPressed: alreadyGranted
                    ? null
                    : () async {
                        await _grantAccess(doctor["address"]);
                        // Optionally refresh the doctor list after granting access
                        await _fetchAccessData();
                      },
                child: Text(alreadyGranted ? "Granted" : "Grant"),
              ),
            ),
          );
        },
      ),
          // const Text(
          //   "Grant Access by Private Key",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 10),
          // TextField(
          //   controller: doctorAddress,
          //   decoration: const InputDecoration(
          //     border: OutlineInputBorder(),
          //     labelText: "Enter Doctor's Private Key",
          //   ),
          // ),
          // const SizedBox(height: 10),
          // ElevatedButton(
          //   onPressed: _grantAccessByPrivateKey,
          //   child: const Text("Grant Access"),
          // ),
          // const SizedBox(height: 20),
          const Text(
            "Doctors with Access",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          grantedDoctors.isEmpty
              ? const Text("No doctors have access.")
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: grantedDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = grantedDoctors[index]; // Directly use the Map
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                        "Doctor Name: ${doctor["name"]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text("Public Key: ${doctor["address"]}"),
                          Text("Access Granted At: ${doctor["timestamp"]}"),
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          ElevatedButton(
                            onPressed: () => _revokeAccess(doctor["address"]),
                            child: const Text("Revoke"),
                          ),
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     try {
                          //       print(
                          //         "Pay Fee button pressed for doctor: ${doctor["address"]}",
                          //       );
                          //       Fluttertoast.showToast(msg: "Fetching fee...");
                          //       String fee = await Connector.getFee(
                          //         EthereumAddress.fromHex(doctor["address"]),
                          //       );
                          //       print("Fetched fee: $fee");

                          //       if (fee == "0" || fee.isEmpty) {
                          //         Fluttertoast.showToast(
                          //           msg: "No fee set by doctor.",
                          //         );
                          //         print("No fee set by doctor.");
                          //         return;
                          //       }

                          //       Fluttertoast.showToast(msg: "Paying fee...");
                          //       await Connector.payForPrescription(
                          //         EthereumAddress.fromHex(doctor["address"]),
                          //         fee,
                          //       );
                          //       Fluttertoast.showToast(msg: "Fee paid!");
                          //       print("Fee paid successfully!");
                          //     } catch (e, stack) {
                          //       print("Error in Pay Fee: $e");
                          //       print(stack);
                          //       Fluttertoast.showToast(
                          //         msg: "Error paying fee: ${e.toString()}",
                          //       );
                          //     }
                          //   },
                          //   child: const Text("Pay Fee"),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          const SizedBox(height: 20),
          const Text(
            "Doctors Requesting Access",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          requestedDoctors.isEmpty
              ? const Text("No doctors requesting access.")
              : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: requestedDoctors.length,
                itemBuilder: (context, index) {
                  final doctor = requestedDoctors[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        "Doctor Name: ${doctor["name"]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Text("Public Key: ${doctor["address"]}"),
                          Text("Request Time: ${doctor["timestamp"]}"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () => _grantAccess(doctor["address"]),
                            child: const Text("Grant"),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _denyAccess(doctor["address"]),
                            child: const Text("Deny"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ],
      ),
    );
  }
}
