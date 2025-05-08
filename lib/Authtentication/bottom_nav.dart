import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => BottomNavState();
}
class BottomNavState extends State<BottomNav> {
  int myIndex=0;
  List<Widget> widgetList = const [
    Text('Home',style: TextStyle(fontSize: 40),),
    Text('Edit',style: TextStyle(fontSize: 40),),
    Text('Notification',style: TextStyle(fontSize: 40),),
    Text('Message',style: TextStyle(fontSize: 40),),
  ];
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: widgetList[myIndex],
      ),
      appBar: AppBar(
        title: const Text("Softrack"),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: const GNav(
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon:  Icons.edit,
              text: 'Likes',
            ),
            GButton(
              icon: Icons.search,
              text: 'Search',
            ),
            GButton(
              icon: Icons.message,
              text: 'Profile',
            )
          ]
      ),
    );
  }
}
