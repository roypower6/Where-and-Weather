import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:where_and_weather/service/open_weather_api.dart';
import 'package:where_and_weather/widget/air_quality_widget.dart';
import 'package:where_and_weather/widget/weather_widget.dart';

class CityDetailScreen extends StatefulWidget {
  final String cityName;
  final double lat;
  final double lon;

  const CityDetailScreen({
    super.key,
    required this.cityName,
    required this.lat,
    required this.lon,
  });

  @override
  State<CityDetailScreen> createState() => _CityDetailScreenState();
}

class _CityDetailScreenState extends State<CityDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<WeatherApiService>().fetchCityData(
            lat: widget.lat,
            lon: widget.lon,
            cityName: widget.cityName,
          ),
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.cityName,
              style: const TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Consumer<WeatherApiService>(
            builder: (context, weatherService, child) {
              if (weatherService.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (weatherService.error != null) {
                return Center(
                  child: Text(
                    weatherService.error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (weatherService.weatherData != null)
                        WeatherDisplay(
                          weatherData: weatherService.weatherData!,
                        ),
                      const SizedBox(height: 20),
                      if (weatherService.airQualityData != null)
                        AirQualityDisplay(
                          airQualityData: weatherService.airQualityData!,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
