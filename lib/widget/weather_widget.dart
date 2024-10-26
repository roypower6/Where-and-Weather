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
    final iconColor = WeatherIcons.getIconColor(weatherId);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 왼쪽 컬럼 - 현재 날씨 정보
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text(
                      weatherData['name'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Icon(
                      iconData,
                      size: 70,
                      color: iconColor,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${weatherData['main']['temp'].round()}°C',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      weatherData['weather'][0]['description'],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // 오른쪽 컬럼 - 상세 정보
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    _buildInfoTile(
                      UniconsLine.temperature_half,
                      '체감 온도',
                      '${weatherData['main']['feels_like'].round()}°C',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      Icons.water_drop_rounded,
                      '습도',
                      '${weatherData['main']['humidity']}%',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      Icons.air_outlined,
                      '풍속',
                      '${weatherData['wind']['speed']} m/s',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoTile(
                      UniconsLine.compress_v,
                      '기압',
                      '${weatherData['main']['pressure']} hPa',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            height: 60,
            indent: 30,
            endIndent: 30,
            thickness: 1.3,
            color: Colors.black,
          ),
          if (fiveDayForecast != null) _buildFiveDayForecast(),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.black87),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiveDayForecast() {
    final List<dynamic> forecasts = fiveDayForecast!['list'];
    final Map<String, dynamic> dailyForecasts = {};

    for (var forecast in forecasts) {
      final DateTime date =
          DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
      final String dateKey = DateFormat('yyyy-MM-dd').format(date);

      if (!dailyForecasts.containsKey(dateKey)) {
        dailyForecasts[dateKey] = forecast;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '6일 예보',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.8, // childAspectRatio 조정
            crossAxisSpacing: 10,
            mainAxisSpacing: 5,
          ),
          itemCount: dailyForecasts.length,
          itemBuilder: (context, index) {
            final forecast = dailyForecasts.values.elementAt(index);
            final DateTime date =
                DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
            final weatherId = forecast['weather'][0]['id'];
            final iconData = WeatherIcons.getIconData(weatherId);
            final iconColor = WeatherIcons.getIconColor(weatherId);

            return Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('MM/dd (E)', 'ko_KR').format(date),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis, // 텍스트 overflow 처리
                  ),
                  const SizedBox(height: 4),
                  Icon(iconData, size: 30, color: iconColor),
                  const SizedBox(height: 4),
                  Text(
                    '${forecast['main']['temp'].round()}°C',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                    // 텍스트가 충분한 공간을 차지하도록 확장
                    child: Text(
                      forecast['weather'][0]['description'],
                      style: const TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis, // 텍스트 overflow 처리
                      maxLines: 2, // 최대 2줄로 설정
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
