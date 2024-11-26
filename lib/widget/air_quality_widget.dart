import 'package:flutter/material.dart';
import 'package:where_and_weather/model/air_quality_model.dart';

class AirQualityDisplay extends StatelessWidget {
  final AirQualityData airQualityData;

  const AirQualityDisplay({
    super.key,
    required this.airQualityData,
  });

  String getAQIDescription(int aqi) {
    switch (aqi) {
      case 1:
        return '매우 좋음';
      case 2:
        return '좋음';
      case 3:
        return '보통';
      case 4:
        return '나쁨';
      case 5:
        return '매우 나쁨';
      default:
        return '알 수 없음';
    }
  }

  Color getAQIColor(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                airQualityData.location,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const Text(
                  '대기질 지수',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: getAQIColor(airQualityData.aqi),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    getAQIDescription(airQualityData.aqi),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                _buildPollutantSection('미세먼지 (PM10)', airQualityData.pm10),
                _buildPollutantSection('초미세먼지 (PM2.5)', airQualityData.pm25),
                _buildPollutantSection('이산화황 (SO₂)', airQualityData.so2),
                _buildPollutantSection('이산화질소 (NO₂)', airQualityData.no2),
                _buildPollutantSection('오존 (O₃)', airQualityData.o3),
                _buildPollutantSection('일산화탄소 (CO)', airQualityData.co),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPollutantSection(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Text(
            '${value.toStringAsFixed(1)} μg/m³',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
