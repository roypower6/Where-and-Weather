import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class WeatherIcons {
  static IconData getIconData(int weatherId) {
    // 천둥번개: 200-299
    if (weatherId >= 200 && weatherId < 300) {
      return UniconsLine.bolt;
    }
    // 이슬비: 300-399
    else if (weatherId >= 300 && weatherId < 400) {
      return UniconsLine.raindrops;
    }
    // 비: 500-599
    else if (weatherId >= 500 && weatherId < 600) {
      return UniconsLine.cloud_showers_heavy;
    }
    // 눈: 600-699
    else if (weatherId >= 600 && weatherId < 700) {
      return UniconsLine.snowflake;
    }
    // 안개/황사 등: 700-799
    else if (weatherId >= 700 && weatherId < 800) {
      return Icons.foggy;
    }
    // 맑음: 800
    else if (weatherId == 800) {
      return UniconsLine.sun;
    }
    // 구름 조금/많음: 801-899
    else if (weatherId > 800) {
      return UniconsLine.clouds;
    }
    // 기본값
    return Icons.question_mark;
  }

  // 날씨 상태에 따른 색상 반환
  static Color getIconColor(int weatherId) {
    if (weatherId >= 200 && weatherId < 300) {
      return Colors.deepPurple; // 천둥번개
    } else if (weatherId >= 300 && weatherId < 400) {
      return Colors.lightBlue; // 이슬비
    } else if (weatherId >= 500 && weatherId < 600) {
      return Colors.blue; // 비
    } else if (weatherId >= 600 && weatherId < 700) {
      return Colors.lightBlue[100]!; // 눈
    } else if (weatherId >= 700 && weatherId < 800) {
      return Colors.grey; // 안개
    } else if (weatherId == 800) {
      return Colors.orange; // 맑음
    } else if (weatherId > 800) {
      return Colors.grey[600]!; // 구름
    }
    return Colors.grey; // 기본값
  }
}
