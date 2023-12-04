import 'package:dr_appointment/screens/no_internet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'pages/home_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int bottomNavIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
  ];

  // check internet connectivity
  Future<bool> checkInternetConnectivity() async {
    final isConnected = await InternetConnectionChecker().hasConnection;
    return isConnected;
  }

  // check internet connectivity and then navigate to screen
  void _onItemTapped(int index) async {
    final isConnected = await checkInternetConnectivity();

    if (isConnected) {
      setState(() {
        bottomNavIndex = index;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NoInternetScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFE2F5FC),
      appBar: AppBar(),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          child: _widgetOptions[bottomNavIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 24,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          // nav bar items
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.laptop_mac_outlined,
            ),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book_outlined,
            ),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outlined,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: bottomNavIndex,
        selectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
