import 'package:flutter/material.dart';
import 'package:where_and_weather/screen/app_info_screen.dart';
import 'package:where_and_weather/screen/search_screen.dart';
import 'package:where_and_weather/screen/weather_screen.dart';
import 'package:where_and_weather/screen/air_quality_screen.dart';
import 'package:unicons/unicons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const WeatherScreen(),
    const SearchScreen(),
    const AirQualityScreen(),
    const AppInfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffF9F7E8),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.grey,
        selectedItemColor: const Color(0xff62BFAD),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color(0xffF9F7E8),
            icon: Icon(UniconsLine.sun),
            label: '날씨',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xffF9F7E8),
            icon: Icon(UniconsLine.search),
            label: '도시 검색',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xffF9F7E8),
            icon: Icon(UniconsLine.wind),
            label: '미세먼지',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color(0xffF9F7E8),
            icon: Icon(UniconsLine.info_circle),
            label: '앱 정보',
          ),
        ],
      ),
    );
  }
}
