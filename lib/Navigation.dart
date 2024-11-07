import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:exercisce_unit4/techno_FileInvantory.dart';
import 'package:exercisce_unit4/techno_Notification.dart';
import 'package:exercisce_unit4/techno_fileOperation.dart';
import 'package:exercisce_unit4/techno_homepage.dart';
import 'package:exercisce_unit4/techno_profile.dart';
import 'package:flutter/material.dart';

class NavigationTechno extends StatefulWidget {
  const NavigationTechno({super.key});

  @override
  State<NavigationTechno> createState() => _NavigationTechnoState();
}

class _NavigationTechnoState extends State<NavigationTechno> {
  
  int _page = 0; // Tracks the current selected page index
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List <Widget> _navigationItems = [
    const Icon(Icons.filter_list),
    const Icon(Icons.book),
    const Icon(Icons.grid_view),
    const Icon(Icons.notifications),
    const Icon(Icons.person),
  ];

   final List<Widget> _pages = [
    const Homepage(),
    const FileInventory(),
    const FileOperation(),
    const NotificationTech(),
    const Profile(),
  ];
  
  Color bgColor = Colors.amberAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        height: 70,
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: bgColor,
        items: _navigationItems,
        index: _page,
        onTap: (index){
          setState(() {
            _page = index;
            switch(index){
              case 0:
                bgColor = Colors.amberAccent;
                break;
              case 1:
                bgColor = Colors.blue;
                break;
              case 2:
                bgColor = Colors.cyan;
                break;
              case 3:
                bgColor = Colors.deepOrange;
                break;
              case 4:
                bgColor = Colors.greenAccent;
                break;
            }
          });
        },
        letIndexChange: (index) => true,
        ),
        body: _pages[_page],
    );
  }
}