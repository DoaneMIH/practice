import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF24C6DC),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Home', style: TextStyle(color: Colors.white)),
            Row(
              children: [
                Icon(Icons.notifications, color: Colors.white),
                SizedBox(width: 8),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF24C6DC)),
                ),
                SizedBox(width: 4),
                Text('Dr. Sarah Smith', style: TextStyle(color: Colors.white)),
              ],
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search and Sort
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for patients...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade600), // gray border
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade600), // darker gray on focus
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400), // light gray when enabled
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: DropdownButton<String>(
                    underline: const SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    value: 'Last Visit',
                    items: ['Last Visit', 'Name']
                        .map((e) => DropdownMenuItem(value: e, child: Text('Sort by: $e')))
                        .toList(),
                    onChanged: (_) {},
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            // Patients List
            Expanded(
              child: ListView(
                children: const [
                  PatientCard(
                    name: 'Jane Doe',
                    id: 'VTL-2025-1234',
                    lastVisit: 'March 25, 2025',
                    condition: 'Type 2 Diabetes',
                    medications: 'Metformin, Insulin',
                    labResults: 'HbA1c: 7.2%',
                    lastAccessed: 'April 1, 2025',
                  ),
                  SizedBox(height: 16),
                  PatientCard(
                    name: 'Michael Brown',
                    id: 'VTL-2025-3452',
                    lastVisit: 'March 2, 2025',
                    condition: 'High Fever',
                    medications: 'Insulin',
                    labResults: 'Need Monitoring',
                    lastAccessed: 'April 1, 2025',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  final String name;
  final String id;
  final String lastVisit;
  final String condition;
  final String medications;
  final String labResults;
  final String lastAccessed;

  const PatientCard({
    super.key,
    required this.name,
    required this.id,
    required this.lastVisit,
    required this.condition,
    required this.medications,
    required this.labResults,
    required this.lastAccessed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('ID: $id', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Last Visit', style: TextStyle(color: Colors.grey)),
                    Text(lastVisit, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text('Current Medications', style: TextStyle(color: Colors.grey)),
                    Text(medications),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Primary Condition', style: TextStyle(color: Colors.grey)),
                    Text(condition, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    const Text('Lab Results', style: TextStyle(color: Colors.grey)),
                    Text(labResults),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Buttons
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.note_add, size: 16),
                  label: const Text('Add Notes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF24C6DC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(FontAwesomeIcons.pills, size: 16),
                  label: const Text('Prescribe'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF24C6DC),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Access info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text('Last Accessed: $lastAccessed', style: const TextStyle(fontSize: 12)),
                  const Spacer(),
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  const Text('Accessed by: Dr. Sarah Smith', style: TextStyle(fontSize: 12)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
