import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:where_and_weather/service/open_weather_api.dart';
import 'package:where_and_weather/widget/weather_widget.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<WeatherApiService>().fetchData(
          includeWeather: true,
          includeForecast: true,
        ));
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
          body: RefreshIndicator(
            onRefresh: () => context.read<WeatherApiService>().fetchData(
                  includeWeather: true,
                  includeForecast: true,
                ),
            child: Consumer<WeatherApiService>(
              builder: (context, weatherService, child) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Where and Weather",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${DateTime.now().year}년 ${DateTime.now().month}월 ${DateTime.now().day}일",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (weatherService.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else if (weatherService.error != null)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weatherService.error!,
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    weatherService.fetchData(
                                      includeWeather: true,
                                      includeForecast: true,
                                    );
                                  },
                                  child: const Text('다시 시도'),
                                ),
                              ],
                            ),
                          )
                        else if (weatherService.weatherData == null)
                          const Center(
                            child: Text('날씨 정보를 불러오는 중입니다...'),
                          )
                        else
                          WeatherDisplay(
                            weatherData: weatherService.weatherData!,
                            fiveDayForecast: weatherService.forecastData,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
