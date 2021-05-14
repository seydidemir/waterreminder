import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:waterreminder/screens/profile_screen.dart';
import 'package:waterreminder/screens/history_screen.dart';
import 'package:waterreminder/screens/home_screen.dart';

class BottomNavbar extends StatefulWidget {
  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  PageController _pageController;

  List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HistoryScreen(),
    ProfilScreen(),
  ];
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome.tint,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome.history,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesome.cog,
            ),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
        selectedItemColor: Colors.blue[800],
      ),
    );

    // return Scaffold(
    //     body: SizedBox.expand(
    //       child: PageView(
    //         controller: _pageController,
    //         onPageChanged: (index) {
    //           setState(() => _selectedIndex = index);
    //         },

    //         // child: _widgetOptions.elementAt(_selectedIndex),
    //         children: [
    //           HomeScreen(),
    //           HistoryScreen(),
    //           ProfilScreen(),
    //         ],
    //       ),
    //     ),
    //     bottomNavigationBar: BottomNavyBar(
    //       selectedIndex: _selectedIndex,
    //       showElevation: true, // use this to remove appBar's elevation
    //       onItemSelected: (index) => setState(() {
    //         _selectedIndex = index;
    //         _pageController.animateToPage(index,
    //             duration: Duration(milliseconds: 300), curve: Curves.ease);
    //       }),
    //       items: [
    //         BottomNavyBarItem(
    //           icon: Icon(Icons.apps),
    //           title: Text('Home'),
    //           activeColor: Colors.red,
    //         ),
    //         BottomNavyBarItem(
    //             icon: Icon(Icons.people),
    //             title: Text('Users'),
    //             activeColor: Colors.purpleAccent),
    //         BottomNavyBarItem(
    //             icon: Icon(Icons.settings),
    //             title: Text('Settings'),
    //             activeColor: Colors.blue),
    //       ],
    //     ));
  }
}
