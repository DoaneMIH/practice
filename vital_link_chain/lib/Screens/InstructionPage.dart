import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';

class GetKey extends StatefulWidget {
  const GetKey({super.key});

  @override
  State<GetKey> createState() => _GetKeyState();
}

class _GetKeyState extends State<GetKey> {

  final List<String> privateKeys = [
'0xb20cc74cda55715fa99e2d246de82b613e06301ae5b9702bd30eb8c434b486a1',
'0x6a2671db94f60fa7abe349a6114301739cdb50534b106cc62d2f4f29b98baf46',
'0xcc603c276741df22770acb6f093f349f142ddee312ab2b6e7c81c8025b26e067',
'0xc9e878eb166616a02fe970d3e513ea950addc3fa278f1a2f9763f9cdc703624f',
'0x0ab51042b6964ecb546908aca20fafc64ce4532db5102a510462ba26854d7c9f',
'0x5ff0d489d1e0c3f32dce9776b2c72ea4b5953e590a2f8aa7cd265e1c10849796',
'0xd4fafc588ebd02ac0cccad2e3e6e3a33c21f56f2273e9a6b2fec5e396558b5e2',
'0x33c1b51c3eef171d53a684f7fa5faa93694bddcf18755e07ef19de0eb1e6c6f6',
'0x2a601b51c0476476e4955537e0a05776f01ee560b1fd93d82f56245824b59243',
'0x48fdc09803e951566feaca27b64af418c824159f4cdfcfe7f89501ef9ae124e6',
    ];

  // Track which keys have been assigned
  final Set<int> usedKeyIndices = <int>{};
  Map<String, String>? assignedAccount;
  final Random _random = Random();

  Future<Map<String, String>> getRandomKey() async {
    // Get available key indices
    final availableIndices = <int>[];
    for (int i = 0; i < privateKeys.length; i++) {
      if (!usedKeyIndices.contains(i)) {
        availableIndices.add(i);
      }
    }

    if (availableIndices.isEmpty) {
      throw Exception('No more keys available');
    }

    // Pick a random available key
    final randomIndex =
        availableIndices[_random.nextInt(availableIndices.length)];
    final selectedKey = privateKeys[randomIndex];

    // Mark this key as used
    usedKeyIndices.add(randomIndex);

    // Generate the account info
    final credentials = EthPrivateKey.fromHex(selectedKey);
    final EthereumAddress address = await credentials.extractAddress();

    return {
      'public': address.hex,
      'private': selectedKey,
      'index': '${randomIndex + 1}',
    };
  }

  void assignKey() async {
    try {
      final account = await getRandomKey();
      setState(() {
        assignedAccount = account;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ganache Key Distribution',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ganache Key Distribution'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          leading:
              assignedAccount != null
                  ? IconButton(
                    onPressed: () {
                      setState(() {
                        assignedAccount = null;
                      });
                    },
                    icon: const Icon(Icons.arrow_back),
                    tooltip: 'Back to Landing',
                  )
                  : null,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight -
                  40, // Account for padding and app bar
            ),
            child: Column(
              mainAxisAlignment:
                  assignedAccount == null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                const Icon(Icons.key, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                const Text(
                  'Get Your Random Key',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Available Keys: ${privateKeys.length - usedKeyIndices.length}/${privateKeys.length}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Get Key Button
                if (assignedAccount == null)
                  SizedBox(
                    width: 200,
                    height: 60,
                    child: ElevatedButton(
                      onPressed:
                          usedKeyIndices.length < privateKeys.length
                              ? assignKey
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Get Key',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Display assigned key
                if (assignedAccount != null) ...[
                  const Icon(Icons.check_circle, size: 60, color: Colors.green),
                  const SizedBox(height: 20),
                  const Text(
                    'Your Key Has Been Assigned!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Text(
                                  assignedAccount!['index']!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Account ${assignedAccount!['index']}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.public,
                                      color: Colors.green,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Public Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SelectableText(
                                  assignedAccount!['public']!,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.key,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Private Key',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SelectableText(
                                  assignedAccount!['private']!,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Keep your private key secure! This key is now exclusively yours and cannot be reassigned.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (usedKeyIndices.length >= privateKeys.length &&
                    assignedAccount == null)
                  const Column(
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red),
                      SizedBox(height: 20),
                      Text(
                        'No More Keys Available',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'All keys have been distributed to users.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}