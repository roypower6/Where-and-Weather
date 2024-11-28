import 'package:flutter/material.dart';
import 'package:where_and_weather/screen/app_info_screen.dart';
import 'package:where_and_weather/screen/search_screen.dart';
import 'package:where_and_weather/screen/weather_screen.dart';
import 'package:where_and_weather/screen/air_quality_screen.dart';
import 'package:unicons/unicons.dart';
import 'package:provider/provider.dart';
import 'package:where_and_weather/service/open_weather_api.dart';

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

  void _onTabChanged(int index) {
    if (_selectedIndex != index) {
      if (index == 0) {
        context.read<WeatherApiService>().restoreCurrentLocationData();
      }
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BottomNavigationBar(
            backgroundColor: Colors.white.withOpacity(0.95),
            selectedItemColor: const Color(0xFF2196F3),
            unselectedItemColor: Colors.grey.shade600,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
            ),
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            elevation: 0,
            onTap: _onTabChanged,
            items: [
              _buildNavItem(UniconsLine.sun, '날씨'),
              _buildNavItem(UniconsLine.search, '도시 검색'),
              _buildNavItem(UniconsLine.wind, '대기질'),
              _buildNavItem(UniconsLine.info_circle, '앱 정보'),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Icon(icon),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Icon(
          icon,
          size: 26,
        ),
      ),
      label: label,
    );
  }
}
