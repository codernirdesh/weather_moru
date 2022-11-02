import 'package:flutter/cupertino.dart';
import 'package:weather_moru/models/weather_data.dart';

class WeatherDataProvider with ChangeNotifier {
  WeatherData? _weatherData;

  WeatherData? get weatherData => _weatherData;

  void setWeatherData(WeatherData weatherData) {
    _weatherData = weatherData;
    notifyListeners();
  }

  void clearWeatherData() {
    _weatherData = null;
    notifyListeners();
  }

  void fetchWeatherData() {}
}
