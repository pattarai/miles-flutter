// The [BottomNavigationBar] has four [BottomNavigationBarItem]
// widgets, which means it defaults to [BottomNavigationBarType.shifting], and
// the [currentIndex] is set to index 0. The selected item is amber in color.
// With each [BottomNavigationBarItem] widget, backgroundColor property is
// also defined, which changes the background color of [BottomNavigationBar],
// when that item is selected. The `_onItemTapped` function changes the
// selected item's index and displays a corresponding message in the center of
// the [Scaffold].

import 'package:flutter/material.dart';

import 'fragments/ride.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    RideNow(),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pedal_bike_rounded),
            label: 'Ride',
            backgroundColor: Color(0xffFCCB00),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_rounded),
            label: 'Fitness+',
            backgroundColor: Color(0xffFCCB00),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_rounded),
            label: 'Wallet',
            backgroundColor: Color(0xffFCCB00),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_contact_calendar_rounded),
            label: 'My Profile',
            backgroundColor: Color(0xffFCCB00),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        onTap: _onItemTapped,
      ),
    );
  }
}
