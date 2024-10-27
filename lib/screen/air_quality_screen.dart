import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:where_and_weather/service/open_weather_api.dart';
import 'package:where_and_weather/widget/air_quality_widget.dart';

class AirQualityScreen extends StatefulWidget {
  const AirQualityScreen({super.key});

  @override
  State<AirQualityScreen> createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          context.read<WeatherApiService>().fetchData(includeAirQuality: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<WeatherApiService>(
          builder: (context, weatherService, child) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Air Quality",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff62BFAD),
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
                          ElevatedButton(
                            onPressed: () {
                              weatherService.fetchData(includeAirQuality: true);
                            },
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    )
                  else if (weatherService.airQualityData != null)
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () =>
                            weatherService.fetchData(includeAirQuality: true),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: AirQualityDisplay(
                            airQualityData: weatherService.airQualityData!,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
