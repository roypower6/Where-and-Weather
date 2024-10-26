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
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffE8F9FD),
        body: Consumer<WeatherApiService>(
          builder: (context, weatherService, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Where and Weather",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff2155CD),
                          ),
                        ),
                      ],
                    ),
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
                      RefreshIndicator(
                        onRefresh: () => weatherService.fetchData(
                          includeWeather: true,
                          includeForecast: true,
                        ),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: WeatherDisplay(
                              weatherData: weatherService.weatherData!,
                              fiveDayForecast: weatherService.forecastData,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
