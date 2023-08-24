import 'package:flutter/material.dart';
import 'package:devtime/screens/mypage_screen.dart';
import 'package:devtime/screens/stopwatch_screen.dart';

import 'date_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  // ignore: unused_field
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: 마이페이지',
      style: optionStyle,
    ),
    Text(
      'Index 1: 스톱워치',
      style: optionStyle,
    ),
    Text(
      'Index 2: 캘린더',
      style: optionStyle,
    ),
  ];

  static List<Widget> pages = <Widget>[
    const MyPageScreen(), //친구관리탭
    const StopWatchScreen(), //채팅방
    const DateScreen(), //친구매칭탭
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.timer_rounded,
              ),
              label: 'time'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month_rounded,
              ),
              label: 'plan'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromRGBO(2, 73, 255, 1),
        onTap: _onItemTapped,
      ),
      body: pages[_selectedIndex],
    );
  }
}
