import 'package:flutter/material.dart';

class FileInventory extends StatefulWidget {
  const FileInventory({super.key});

  @override
  State<FileInventory> createState() => _FileInventoryState();
}

class _FileInventoryState extends State<FileInventory> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("File Inventory"),);
  }
}