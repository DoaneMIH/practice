import 'package:flutter/material.dart';

import 'ApplicationSubmittedScreen.dart';

class MedApplication extends StatefulWidget {
  const MedApplication({super.key});

  @override
  State<MedApplication> createState() => _MedApplicationState();
}

class _MedApplicationState extends State<MedApplication> {
  String? selectedSex;
  String? selectedStatus;
  String? selectedCategory;
  DateTime? selectedDate;
  DateTime? lastMensDate;
  String? selectedCampus;
  String? selectedCollege;

  final Map<String, bool?> medicalHistoryAnswers = {
    'Recent Illness': null,
    'Recent Medications': null,
    'Hospitalization': null,
    'Surgery': null,
    'Allergy': null,
    'Immunization': null,
    'Illness in the Family': null,
  };

  final Map<String, TextEditingController> medicalDetailsControllers = {};

  @override
  void initState() {
    for (var key in medicalHistoryAnswers.keys) {
      medicalDetailsControllers[key] = TextEditingController();
    }
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in medicalDetailsControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildUniversityInfo(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                label: const Text(
                  'Back',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE1F8FA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdownsSection(),
                    const SizedBox(height: 20),
                    const Text(
                      'Personal Data',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildUnderlineField('Full Name')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildUnderlineField('Address')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildUnderlineField('Date of Birth')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildUnderlineField('Age')),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Combining Sex and Civil Status in one row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildRadioGroup('Sex', ['Male', 'Female'], selectedSex, (val) {
                            setState(() => selectedSex = val);
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildRadioGroup(
                            'Civil Status',
                            ['Single', 'Married', 'Divorced', 'Widowed'],
                            selectedStatus,
                            (val) {
                              setState(() => selectedStatus = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildUnderlineField('Course, & Year Level/Position'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildUnderlineField('Telephone/Cellphone Number'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildUnderlineField('Emergency Contact Person'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildUnderlineField('Emergency Contact Number'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildMedicalHistory(),
                    const SizedBox(height: 20),
                    const Text(
                      'For Females',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _buildUnderlineField('Age of onset')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildLastMensDateField()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ApplicationSubmittedScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00CFE8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          'Submit Application',
                          style: TextStyle(color: Colors.white),
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
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF00CFE8),
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: const [
              Icon(Icons.medical_services, color: Colors.white),
              SizedBox(width: 6),
              Text(
                'Vital Link Chain',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF00CFE8),
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: const [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.white,
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Color(0xFF00CFE8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Medical Application',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUniversityInfo() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'West Visayas State University',
            style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
          ),
          Text('La Paz, Iloilo City', style: TextStyle(color: Colors.black54)),
          Text(
            'Tel. No. 3203070 (1703)',
            style: TextStyle(color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownsSection() {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: Text('Campus', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Text('College/Department Unit', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Text('Date of Examination', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildCampusDropdown()),
            const SizedBox(width: 8),
            Expanded(child: _buildCollegeDropdown()),
            const SizedBox(width: 8),
            Expanded(child: _buildCategoryDropdown()),
            const SizedBox(width: 8),
            Expanded(child: _buildDatePickerField()),
          ],
        ),
      ],
    );
  }

  Widget _buildCampusDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCampus,
      items: const [
        DropdownMenuItem(value: 'CAF', child: Text('CAF')),
        DropdownMenuItem(value: 'Calinog', child: Text('Calinog')),
        DropdownMenuItem(value: 'Himamaylan', child: Text('Himamaylan')),
        DropdownMenuItem(value: 'Janiuay', child: Text('Janiuay')),
        DropdownMenuItem(value: 'Lambunao', child: Text('Lambunao')),
        DropdownMenuItem(value: 'MAIN', child: Text('Main Campus')),
        DropdownMenuItem(value: 'Pototan', child: Text('Pototan')),
      ],
      onChanged: (value) {
        setState(() => selectedCampus = value);
      },
      decoration: InputDecoration(
        hintText: 'Select Campus',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: const Color(0xFFF6F9FA),
      ),
    );
  }

  Widget _buildCollegeDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCollege,
      items: const [
        DropdownMenuItem(value: 'CAS', child: Text('CAS')),
        DropdownMenuItem(value: 'CBM', child: Text('CBM')),
        DropdownMenuItem(value: 'COE', child: Text('COE')),
        DropdownMenuItem(value: 'COC', child: Text('COC')),
        DropdownMenuItem(value: 'COM', child: Text('COM')),
        DropdownMenuItem(value: 'CON', child: Text('CON')),
        DropdownMenuItem(value: 'PESCAR', child: Text('PESCAR')),
        DropdownMenuItem(value: 'COL', child: Text('COL')),
        DropdownMenuItem(value: 'CICT', child: Text('CICT')),
        DropdownMenuItem(value: 'ILS', child: Text('ILS')),
      ],
      onChanged: (value) {
        setState(() => selectedCollege = value);
      },
      decoration: InputDecoration(
        hintText: 'Select College',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: const Color(0xFFF6F9FA),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      items: const [
        DropdownMenuItem(value: 'Faculty', child: Text('Faculty')),
        DropdownMenuItem(value: 'Non-teaching', child: Text('Non-teaching')),
        DropdownMenuItem(value: 'Student', child: Text('Student')),
        
      ],
      onChanged: (value) {
        setState(() => selectedCategory = value);
      },
      decoration: InputDecoration(
        hintText: 'Select Category',
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: const Color(0xFFF6F9FA),
      ),
    );
  }

  Widget _buildDatePickerField() {
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: 'Select Date',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.medical_services, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFF6F9FA),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          selectedDate != null
              ? "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}"
              : 'Select Date',
          style: TextStyle(
            fontSize: 16,
            color: selectedDate != null ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildLastMensDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of last mens',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: lastMensDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                lastMensDate = picked;
              });
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.medical_services, color: Colors.grey),
              filled: true,
              fillColor: Color(0xFFF6F9FA),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            child: Text(
              lastMensDate != null
                  ? "${lastMensDate!.month}/${lastMensDate!.day}/${lastMensDate!.year}"
                  : 'Select Date',
              style: TextStyle(
                fontSize: 16,
                color: lastMensDate != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioGroup(
    String title,
    List<String> options,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          children: options
              .map((option) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: option,
                      groupValue: selectedValue,
                      onChanged: onChanged,
                    ),
                    Text(option),
                    const SizedBox(width: 10),
                  ],
                );
              })
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMedicalHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medical History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ...medicalHistoryAnswers.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(entry.key)),
                Expanded(
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: entry.value,
                        onChanged: (val) {
                          setState(() {
                            medicalHistoryAnswers[entry.key] = val;
                          });
                        },
                      ),
                      const Text("Yes"),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: entry.value,
                        onChanged: (val) {
                          setState(() {
                            medicalHistoryAnswers[entry.key] = val;
                          });
                        },
                      ),
                      const Text("No"),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: medicalDetailsControllers[entry.key],
                    decoration: const InputDecoration(
                      hintText: "Please specify",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildUnderlineField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
            hintText: label,
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}