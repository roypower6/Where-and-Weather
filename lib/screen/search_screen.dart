import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:where_and_weather/service/open_weather_api.dart';
import 'package:where_and_weather/widget/weather_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<WeatherApiService>().clear();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "City Search",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff62BFAD),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: '도시 검색',
                      hintText: '도시 이름을 입력하세요',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        context
                            .read<WeatherApiService>()
                            .fetchData(city: value, includeWeather: true);
                        setState(() => _hasSearched = true);
                      }
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<WeatherApiService>(
                builder: (context, weatherService, child) {
                  if (!_hasSearched) {
                    return const Center(
                      child: Text('도시 이름을 입력하고 검색해보세요'),
                    );
                  }

                  if (weatherService.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (weatherService.error != null) {
                    return Center(
                      child: Text(
                        weatherService.error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (weatherService.weatherData == null) {
                    return const Center(
                      child: Text('검색 결과가 없습니다'),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: WeatherDisplay(
                      weatherData: weatherService.weatherData!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
