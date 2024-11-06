import 'package:flutter/material.dart';

void main() => runApp(const ProfilePageApp());

class ProfilePageApp extends StatelessWidget {
  const ProfilePageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Edrianne Luise D. Parales',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[300], // Set AppBar background to light blue
        title: Text('Edrianne Luise D. Parales', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile section as a row
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xFF0000FF),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage( 'https://scontent.fceb8-1.fna.fbcdn.net/v/t39.30808-6/434943982_7340265372736244_3496409132464978281_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeGZx2eXiJdDW8mYjFVPExkSedot-X1CjQx52i35fUKNDNfc_8t3MDopDmyxMasW7d5nYc0CPs9RX10j4Q5oye0y&_nc_ohc=tNZBzZp78PcQ7kNvgFtAEqG&_nc_zt=23&_nc_ht=scontent.fceb8-1.fna&_nc_gid=A1SMvRv74eENYtThXvjiPaa&oh=00_AYCW2ibrqnmVl1ziFMRcAvwW44Zv-SV6ELkfVR4yv_M6bQ&oe=66F94201'
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edrianne Luise D. Parales',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Pinakagwapo sang Capiz',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(20.0),
              child: const Column( // Use a Column to hold both Rows
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.cake, size: 30, color: Colors.white),
                          SizedBox(width: 5),
                          Text('Birthday: ', style: TextStyle(fontSize: 18, color: Colors.white)),
                          SizedBox(width: 10),
                          Text('August 20, 2003', style: TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.house, size: 30, color: Colors.white),
                          SizedBox(width: 5),
                          Text('Address: ', style: TextStyle(fontSize: 18, color: Colors.white)),
                          SizedBox(width: 10),
                          Text('Roxas City, Capiz', style: TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.phone, size: 30, color: Colors.white),
                          SizedBox(width: 5),
                          Text('Contact Number: ', style: TextStyle(fontSize: 18, color: Colors.white)),
                          SizedBox(width: 10),
                          Text('09291539847', style: TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.email, size: 30, color: Colors.white),
                          SizedBox(width: 6),
                          Text('Email: ', style: TextStyle(fontSize: 18, color: Colors.white)),
                          SizedBox(width: 10),
                          Text('edrianneluise.parales@wvsu.edu.ph', style: TextStyle(fontSize: 14, color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('          Edrianne is a student at CICT WVSU\n'
                              '         He enjoys playing video games and\n'
                              '         learning new skills.\n'
                              '         He aspires to be successful in life\n'
                              '         and become the bread winner of the family.',
                      style: TextStyle(fontSize: 14, color: Colors.white ),
                            textAlign: TextAlign.center,),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Text(
              'Hobbies',
              style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 1),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  Container(
                    color: Colors.lightBlueAccent,
                    child: Image.asset('assets/hobby1.jpg', fit: BoxFit.contain,),
                  ),
                  Container(
                    color: Colors.lightBlueAccent,
                    child: Image.asset('assets/hobby2.jpg', fit: BoxFit.contain,),
                  ),
                  Container(
                    color: Colors.lightBlueAccent,
                    child: Image.asset('assets/hobby3.jpg', fit: BoxFit.fill,),
                  ),
                  Container(
                    color: Colors.lightBlueAccent,
                    child: Image.asset('assets/hobby4.jpg', fit: BoxFit.fill,),
                  ),
                  Container(
                    color: Colors.lightBlueAccent,
                    child: Image.asset('assets/hobby5.jpg', fit: BoxFit.contain,),
                  ),
                  Container(
                    color: Colors.lightBlueAccent,
                    child: Image.asset('assets/hobby6.jpg', fit: BoxFit.fill,),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


}
