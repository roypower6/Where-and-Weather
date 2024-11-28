import 'package:flutter/material.dart';
import 'package:where_and_weather/icon/weather_icons.dart';
import 'package:intl/intl.dart';
import 'package:unicons/unicons.dart';

class WeatherDisplay extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final Map<String, dynamic>? fiveDayForecast;

  const WeatherDisplay({
    super.key,
    required this.weatherData,
    this.fiveDayForecast,
  });

  @override
  Widget build(BuildContext context) {
    final weatherId = weatherData['weather'][0]['id'];
    final iconData = WeatherIcons.getIconData(weatherId);
    const iconColor = Colors.white;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Text(
                "${weatherData['name']}, ${weatherData['sys']['country']}",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    size: 80,
                    color: iconColor,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '${weatherData['main']['temp'].round()}°C',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                weatherData['weather'][0]['description'],
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildDetailCard(
              UniconsLine.temperature_half,
              '체감 온도',
              '${weatherData['main']['feels_like'].round()}°C',
            ),
            _buildDetailCard(
              Icons.water_drop_rounded,
              '습도',
              '${weatherData['main']['humidity']}%',
            ),
            _buildDetailCard(
              Icons.air_outlined,
              '풍속',
              '${weatherData['wind']['speed']} m/s',
            ),
            _buildDetailCard(
              UniconsLine.compress_v,
              '기압',
              '${weatherData['main']['pressure']} hPa',
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (fiveDayForecast != null) _buildFiveDayForecast(),
      ],
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiveDayForecast() {
    final List<dynamic> forecasts = fiveDayForecast!['list'];
    final Map<String, dynamic> dailyForecasts = {};
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    for (var forecast in forecasts) {
      final DateTime date =
          DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
      final String dateKey = DateFormat('yyyy-MM-dd').format(date);

      if (!dailyForecasts.containsKey(dateKey) && dateKey != today) {
        dailyForecasts[dateKey] = forecast;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5일 예보',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 170, // 카드의 높이 지정
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 가로 스크롤 설정
            itemCount: dailyForecasts.length,
            itemBuilder: (context, index) {
              final forecast = dailyForecasts.values.elementAt(index);
              final DateTime date =
                  DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
              final weatherId = forecast['weather'][0]['id'];
              final iconData = WeatherIcons.getIconData(weatherId);
              const iconColor = Colors.white;

              return Container(
                width: 120, // 카드의 너비 지정
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('MM/dd (E)', 'ko_KR').format(date),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Icon(iconData, size: 35, color: iconColor),
                    const SizedBox(height: 8),
                    Text(
                      '${forecast['main']['temp'].round()}°C',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      forecast['weather'][0]['description'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
