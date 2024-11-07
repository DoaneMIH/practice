import 'package:flutter/material.dart';

class FileOperation extends StatefulWidget {
  const FileOperation({super.key});

  @override
  State<FileOperation> createState() => _FileOperationState();
}

class _FileOperationState extends State<FileOperation> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("File Operation"),);
  }
}