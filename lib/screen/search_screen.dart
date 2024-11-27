import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:where_and_weather/service/open_weather_api.dart';
import 'package:where_and_weather/screen/city_detail_screen.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Map<String, dynamic>> searchHistory = [];

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherApiService>().searchResults = null;
    });
  }

  Future<void> _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('citySearchHistory') ?? [];
    setState(() {
      searchHistory = historyJson
          .map((item) => json.decode(item) as Map<String, dynamic>)
          .toList();
    });
  }

  Future<void> _addToSearchHistory(Map<String, dynamic> city) async {
    if (searchHistory.any((item) =>
        item['name'] == city['name'] &&
        item['lat'] == city['lat'] &&
        item['lon'] == city['lon'])) {
      return;
    }

    setState(() {
      searchHistory.insert(0, city);
      if (searchHistory.length > 10) {
        // 최대 10개까지만 저장
        searchHistory.removeLast();
      }
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'citySearchHistory',
      searchHistory.map((item) => json.encode(item)).toList(),
    );
  }

  Future<void> _removeFromSearchHistory(int index) async {
    setState(() {
      searchHistory.removeAt(index);
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'citySearchHistory',
      searchHistory.map((item) => json.encode(item)).toList(),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        context.read<WeatherApiService>().searchResults = null;
        setState(() {});
      } else {
        context.read<WeatherApiService>().searchCities(query);
      }
    });
  }

  Widget _buildSearchHistory() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: searchHistory.length,
      itemBuilder: (context, index) {
        final city = searchHistory[index];
        return Card(
          color: Colors.white.withOpacity(0.2),
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            leading: const Icon(Icons.history, color: Colors.white),
            title: Text(
              city['name'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${city['country']}${city['state'] != null ? ', ${city['state']}' : ''}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.white70),
              onPressed: () => _removeFromSearchHistory(index),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CityDetailScreen(
                    cityName: city['name'],
                    lat: city['lat'],
                    lon: city['lon'],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "도시 검색",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: '도시 검색',
                          labelStyle: const TextStyle(color: Colors.white70),
                          hintText: '도시 이름을 입력하세요',
                          hintStyle: const TextStyle(color: Colors.white60),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.white),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.white),
                                  onPressed: () {
                                    _searchController.clear();
                                    context
                                        .read<WeatherApiService>()
                                        .searchResults = null;
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: _onSearchChanged,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<WeatherApiService>(
                  builder: (context, weatherService, child) {
                    if (weatherService.isLoading) {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: Colors.white));
                    }

                    if (weatherService.error != null) {
                      return Center(
                        child: Text(
                          weatherService.error!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    if (weatherService.searchResults == null) {
                      return _buildSearchHistory(); // 검색 결과가 없을 때 검색 기록 표시
                    }

                    if (weatherService.searchResults!.isEmpty) {
                      return const Center(
                        child: Text(
                          '검색 결과가 없습니다',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: weatherService.searchResults!.length,
                      itemBuilder: (context, index) {
                        final city = weatherService.searchResults![index];
                        return Card(
                          color: Colors.white.withOpacity(0.2),
                          elevation: 0,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(
                              city['name'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${city['country']}${city['state'] != null ? ', ${city['state']}' : ''}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            onTap: () {
                              _addToSearchHistory(city); // 도시 선택 시 검색 기록에 추가
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CityDetailScreen(
                                    cityName: city['name'],
                                    lat: city['lat'],
                                    lon: city['lon'],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
