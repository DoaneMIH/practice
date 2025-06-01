import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ViewMedicalCertificate extends StatelessWidget {
  final String jsonData;

  const ViewMedicalCertificate({super.key, required this.jsonData});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> cert = jsonDecode(jsonData);

    return Scaffold(
      appBar: AppBar(
        title: const Text("View Certificate"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: const [
                  Text(
                    "West Visayas State University",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "La Paz, Iloilo City\nTel No. 3203070 (703)",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Divider(thickness: 2, height: 30),

            _buildRow(FontAwesomeIcons.calendar, "Issued Date", cert["date"]),
            _buildRow(FontAwesomeIcons.user, "Date of Birth", cert["dob"]),
            _buildRow(FontAwesomeIcons.userTag, "Role", cert["role"]),
            _buildRow(FontAwesomeIcons.circleQuestion, "Other Reason", cert["otherReason"]),
            _buildRow(FontAwesomeIcons.heartPulse, "Age", cert["age"]),
            _buildRow(FontAwesomeIcons.venusMars, "Sex", cert["sex"]),
            _buildRow(FontAwesomeIcons.ring, "Civil Status", cert["civilStatus"]),
            _buildRow(FontAwesomeIcons.house, "Resident of", cert["resident"]),
            _buildRow(FontAwesomeIcons.stethoscope, "Visited Clinic On", cert["visitedClinicOn"]),
            _buildRow(FontAwesomeIcons.clock, "Validity", cert["validity"]),
            _buildRow(FontAwesomeIcons.checkDouble, "Enrollment", cert["purpose"]["enrollment"] ? "Yes" : "No"),
            _buildRow(FontAwesomeIcons.peopleGroup, "Participation", cert["purpose"]["participation"]),
            _buildRow(FontAwesomeIcons.ellipsis, "Other Purpose", cert["purpose"]["otherPurpose"] ? "Yes" : "No"),

            const Divider(thickness: 2, height: 30),
            _sectionTitle("Remarks & Recommendations"),
            Text(
              cert["remarks"],
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16),
            ),

            const Divider(thickness: 2, height: 30),
            _sectionTitle("Issued By"),
            _buildRow(FontAwesomeIcons.userDoctor, "Doctor", cert["doctor"]),
            _buildRow(FontAwesomeIcons.wallet, "Doctor Address", cert["doctorAddress"]),
            _buildRow(FontAwesomeIcons.school, "Institution", cert["institution"]),
            _buildRow(FontAwesomeIcons.coins, "Fee", cert["fee"]),
            _buildRow(FontAwesomeIcons.shieldHalved, "Status", cert["status"]),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }
}
