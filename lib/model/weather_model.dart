class WeatherData {
  final CurrentWeather current;
  final DayWeather day;
  final AstroWeather astro;
  final List<HourWeather> hour;

  WeatherData({
    required this.current,
    required this.day,
    required this.astro,
    required this.hour,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, int index) {
    return WeatherData(
      current: CurrentWeather.fromJson(json['current']),
      day: DayWeather.fromJson(json['forecast']['forecastday'][index]['day']),
      astro: AstroWeather.fromJson(
          json['forecast']['forecastday'][index]['astro']),
      hour: (json['forecast']['forecastday'][index]['hour'] as List)
          .map((hourJson) => HourWeather.fromJson(hourJson))
          .toList(),
    );
  }
}

class CurrentWeather {
  final int lastUpdatedEpoch;
  final String lastUpdated;
  final double tempC;
  final double tempF;
  final double feelsLikeC;
  final double feelsLikeF;
  final String icon;
  String weatherStateName;

  CurrentWeather({
    required this.lastUpdatedEpoch,
    required this.lastUpdated,
    required this.tempC,
    required this.tempF,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.icon,
    required this.weatherStateName,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
        lastUpdatedEpoch: json['last_updated_epoch'],
        lastUpdated: json['last_updated'],
        tempC: json['temp_c'].toDouble(),
        feelsLikeC: json['feelslike_c'].toDouble(),
        feelsLikeF: json['feelslike_f'].toDouble(),
        tempF: json['temp_f'].toDouble(),
        icon: json['icon'] ?? "",
        weatherStateName: json['condition']['text']);
  }
}

class DayWeather {
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final double avgTempC;
  final double avgTempF;
  final String text;
  final String icon;
  final int code;
  final int dailyWillItRain;
  final int dailyWillItSnow;
  final int dailyChanceOfRain;
  final int dailyChanceOfSnow;

  DayWeather({
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.text,
    required this.icon,
    required this.code,
    required this.dailyWillItRain,
    required this.dailyWillItSnow,
    required this.dailyChanceOfRain,
    required this.dailyChanceOfSnow,
  });

  factory DayWeather.fromJson(Map<String, dynamic> json) {
    return DayWeather(
      maxTempC: json['maxtemp_c']?.toDouble(),
      maxTempF: json['maxtemp_f']?.toDouble(),
      minTempC: json['mintemp_c']?.toDouble(),
      minTempF: json['mintemp_f']?.toDouble(),
      avgTempC: json['avgtemp_c']?.toDouble(),
      avgTempF: json['avgtemp_f']?.toDouble(),
      text: json['day']?['condition']?['text'] ?? "",
      icon: json['day']?['condition']?['icon'] ?? "",
      code: json['day']?['condition']?['code'] ?? 0,
      dailyWillItRain: json['day']?['daily_will_it_rain'] ?? 0,
      dailyWillItSnow: json['day']?['daily_will_it_snow'] ?? 0,
      dailyChanceOfRain: json['day']?['daily_chance_of_rain'] ?? 0,
      dailyChanceOfSnow: json['day']?['daily_chance_of_snow'] ?? 0,
    );
  }
}

class AstroWeather {
  final String sunrise;
  final String sunset;

  AstroWeather({
    required this.sunrise,
    required this.sunset,
  });

  factory AstroWeather.fromJson(Map<String, dynamic> json) {
    return AstroWeather(
      sunrise: json['sunrise'],
      sunset: json['sunset'],
    );
  }
}

class HourWeather {
  final String time;
  final double tempC;
  final double tempF;
  final bool isDay;
  final String text;
  final String icon;
  final double feelsLikeC;
  final double feelsLikeF;
  final int timeEpoch;

  HourWeather({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.isDay,
    required this.text,
    required this.icon,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.timeEpoch,
  });

  factory HourWeather.fromJson(Map<String, dynamic> json) {
    return HourWeather(
      time: json['time'],
      tempC: json['temp_c'].toDouble(),
      tempF: json['temp_f'].toDouble(),
      isDay: json['is_day'] == 1,
      text: json['condition']['text'],
      icon: json['condition']['icon'],
      feelsLikeC: json['feelslike_c'].toDouble(),
      feelsLikeF: json['feelslike_f'].toDouble(),
      timeEpoch: json['time_epoch'],
    );
  }
}
