class AirQualityData {
  final String location;
  final int aqi;
  final double pm10;
  final double pm25;
  final double so2;
  final double no2;
  final double o3;
  final double co;

  AirQualityData({
    required this.location,
    required this.aqi,
    required this.pm10,
    required this.pm25,
    required this.so2,
    required this.no2,
    required this.o3,
    required this.co,
  });

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    final components = json['list'][0]['components'];
    final main = json['list'][0]['main'];

    final String location = json['city']['name'] ?? "위치 정보 없음";

    return AirQualityData(
      location: location,
      aqi: main['aqi'],
      pm10: components['pm10'].toDouble(),
      pm25: components['pm2_5'].toDouble(),
      so2: components['so2'].toDouble(),
      no2: components['no2'].toDouble(),
      o3: components['o3'].toDouble(),
      co: components['co'].toDouble(),
    );
  }
}
