import 'package:flutter/material.dart';

class MedicalCertificateForm extends StatefulWidget {
  const MedicalCertificateForm({super.key});

  @override
  State<MedicalCertificateForm> createState() => _MedicalCertificateFormState();
}

class _MedicalCertificateFormState extends State<MedicalCertificateForm> {
  final TextEditingController dobController = TextEditingController();
  final TextEditingController otherReasonController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController civilStatusController = TextEditingController();
  final TextEditingController residentController = TextEditingController();
  final TextEditingController visitedController = TextEditingController();
  final TextEditingController participationController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController validityController = TextEditingController();
  // RoleType? selectedRole;

  bool isEnrollment = false;
  bool isOtherPurpose = false;
  bool isLoading = false;
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void dispose() {
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 231, 231),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Row(
              children: [
                Container(
                  width: 215,
                  height: 75,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 85, 199, 221),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Vital Link Chain',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  children: const [
                    Text(
                      'West Visayas State University',
                      style: TextStyle(
                        color: Color.fromARGB(255, 7, 3, 3),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'La Paz, Iloilo City',
                      style: TextStyle(
                        color: Color.fromARGB(255, 92, 90, 90),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Tel. No. 3203070 (703)',
                      style: TextStyle(
                        color: Color.fromARGB(255, 92, 90, 90),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: 215,
                  height: 75,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 85, 199, 221),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white,
                        child: Text(
                          '2',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Medical Certificate',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                    ),
                    const SizedBox(height: 8),
                    const Text("Date of birth"),
                    const SizedBox(height: 8),
                    TextField(
                      controller: dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: const InputDecoration(
                        hintText: 'dd/mm/yyyy',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Select one:"),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (_) {}),
                        const Text("Student"),
                        Checkbox(value: false, onChanged: (_) {}),
                        const Text("Faculty"),
                        Checkbox(value: false, onChanged: (_) {}),
                        const Text("Staff"),
                        Checkbox(value: false, onChanged: (_) {}),
                        const Text("Others"),
                      ],
                    ),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: "Specify other reasons",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "To Whom It May Concern:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text("This is to certify that"),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '',
                              enabledBorder: UnderlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: TextField(decoration: InputDecoration(labelText: 'Age', border: UnderlineInputBorder()))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(decoration: InputDecoration(labelText: 'Sex', border: UnderlineInputBorder()))),
                        const SizedBox(width: 10),
                        Expanded(child: TextField(decoration: InputDecoration(labelText: 'Civil Status', border: UnderlineInputBorder()))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Resident of:', border: UnderlineInputBorder()),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Visited the clinic on:', border: UnderlineInputBorder()),
                    ),
                    const SizedBox(height: 20),
                    const Text("This medical certificate is issued for the purpose of:"),
                    CheckboxListTile(
                      value: false,
                      onChanged: (_) {},
                      title: const Text("Enrollment"),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Participation in:', border: UnderlineInputBorder()),
                    ),
                    CheckboxListTile(
                      value: false,
                      onChanged: (_) {},
                      title: const Text("Others:"),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const SizedBox(height: 10),
                    const Text("Remarks and Recommendations:"),
                    const SizedBox(height: 8),
                    TextField(
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Enter medical details here...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Name of Attending Physician",
                        border: UnderlineInputBorder(),
                      ),
                      controller: validityController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("University Dentist"),
                            SizedBox(height: 4),
                            Text("License No.: ____________________"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("University Physician"),
                            SizedBox(height: 4),
                            Text("License No.: ____________________"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Text("Issue Certificate"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
