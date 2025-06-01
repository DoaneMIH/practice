import 'package:flutter/material.dart';

class DoctorProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Profile',
      home: DoctorProfilePage(),
      debugShowCheckedModeBanner: false,
    );
    
  }
}

class DoctorProfilePage extends StatelessWidget {
  final Color primaryColor = Color(0xFF00C0E0);
  final Color verifiedColor = Color(0xFF4CAF50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER
            Container(
              color: primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Home", style: TextStyle(color: Colors.white, fontSize: 16)),
                  Row(
                    children: [
                      Icon(Icons.notifications_none, color: Colors.white),
                      SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: primaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// PROFILE HEADER CARD
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                // Removed borderRadius
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Dr. Sarah Smith", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: verifiedColor.withOpacity(0.1),
                                // Removed borderRadius
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.verified, size: 16, color: verifiedColor),
                                  SizedBox(width: 4),
                                  Text("Verified", style: TextStyle(color: verifiedColor, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text("Specialization: Cardiology", style: TextStyle(fontSize: 14)),
                        Text("License No.: 3486572    Experience: 12 years", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// ROW: Availability + Blockchain
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Availability and Contact
                  Expanded(
                    child: _customCard(
                      title: "Availability and Contact",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _availabilityRow("Primary Location", "La Paz, Iloilo City"),
                          SizedBox(height: 12),
                          _availabilityRow("Contact Information", "(+63) 878 356 2156\n(+63) 823 356 2331"),
                          SizedBox(height: 12),
                          _availabilityRow("Consultation Hours", "Mon - Fri: 8:00 AM – 5:00 PM"),
                          SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text("Add more"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  /// Blockchain
                  Expanded(
                    child: _customCard(
                      title: "Blockchain Verification",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              // Removed borderRadius
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.verified, color: verifiedColor),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    "Verified Credentials\nAll credentials are verified and secured on blockchain",
                                    style: TextStyle(color: Colors.green[800], fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Text("Last Verification:\nBlockchain ID: 0x56a...d47\n2 hours ago", style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Credentials + Reviews
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: _customCard(
                      title: "Credentials and Background",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow(Icons.school, "Education", "West Visayas State University\nCollege Graduate"),
                          SizedBox(height: 12),
                          _infoRow(Icons.workspace_premium, "Certifications", "Board Certified in Cardiology"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _customCard(
                      title: "Patient Reviews",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text("4.9", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Row(
                                children: List.generate(5, (index) => Icon(Icons.star, color: Colors.amber, size: 20)),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(radius: 0, backgroundColor: Colors.grey[300]),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Michael Brown", style: TextStyle(fontWeight: FontWeight.bold)),
                                    Row(
                                      children: List.generate(4, (index) => Icon(Icons.star, color: Colors.amber, size: 16))
                                        ..add(Icon(Icons.star_border, color: Colors.amber, size: 16)),
                                    ),
                                    Text("Excellent Doctor! Very thorough and caring. Explains everything well."),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text("View all reviews"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Services
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: _customCard(
                title: "Services and Specialties",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _serviceBullet("Cardiac Consultation"),
                    _serviceBullet("ECG/Echo"),
                    _serviceBullet("Heart Disease Management"),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _customCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        SizedBox(width: 12),
        Expanded(child: Text("$label\n$content", style: TextStyle(fontSize: 14))),
      ],
    );
  }

  Widget _availabilityRow(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _serviceBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 18),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
  