import 'package:flutter/material.dart';

class PatientRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF00C4FF),
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Home', style: TextStyle(fontSize: 20)),
            Row(
              children: [
                Stack(
                  children: [
                    Icon(Icons.notifications, color: Colors.white, size: 28),
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 6,
                        backgroundColor: Colors.red,
                        child: Text('1', style: TextStyle(fontSize: 8, color: Colors.white)),
                      ),
                    )
                  ],
                ),
                SizedBox(width: 15),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Color(0xFF26D0E9)),
                ),
                SizedBox(width: 8),
                Text('Jane Doe', style: TextStyle(color: Colors.white, fontSize: 16))
              ],
            )
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 3,
        padding: EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monday, 27 February 2025', style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Regular Checkup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFD4F9E2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('Completed', style: TextStyle(color: Colors.green[700]))
                    )
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue),
                    SizedBox(width: 6),
                    Text('WVSU Clinic')
                  ],
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View Details', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
