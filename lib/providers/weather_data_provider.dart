import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_moru/models/weather_data.dart';
import 'package:http/http.dart' as http;

class WeatherDataProvider with ChangeNotifier {
  WeatherData? _weatherData;
  bool _serviceEnabled = false;
  bool _failed = true;
  late loc.PermissionStatus _permissionGranted;
  loc.LocationData _locationData = loc.LocationData.fromMap({});

  WeatherData? get weatherData => _weatherData;
  bool get serviceEnabled => _serviceEnabled;
  bool get failed => _failed;
  loc.PermissionStatus get permissionGranted => _permissionGranted;
  loc.LocationData get locationData => _locationData;

  void setWeatherData(WeatherData weatherData) {
    _weatherData = weatherData;
    notifyListeners();
  }

  void checkLocationServiceStatus() async {
    loc.Location location = loc.Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        if (kDebugMode) {
          print("Service : $_serviceEnabled");
        }
        _serviceEnabled = false;
        notifyListeners();
        return;
      }
    }
    _serviceEnabled = true;
    notifyListeners();
  }

  void checkLocationPermissionStatus() async {
    loc.Location location = loc.Location();

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        _permissionGranted = loc.PermissionStatus.denied;
        notifyListeners();
        return;
      }
    }
    _permissionGranted = loc.PermissionStatus.granted;
    notifyListeners();
  }

  Future<loc.LocationData> getCurrentLocation() async {
    loc.Location location = loc.Location();

    if (_serviceEnabled && _permissionGranted == loc.PermissionStatus.granted) {
      _locationData = await location.getLocation();
      notifyListeners();
      return _locationData;
    } else {
      checkLocationServiceStatus();
      checkLocationPermissionStatus();
      return _locationData;
    }
  }

  void fetchWeatherDataByLatLon() async {
    final locationData = await getCurrentLocation();
    http.Client()
        .get(
      Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=1bc0383d81444b58b1432929200711&q=${locationData.latitude},${locationData.longitude}',
      ),
    )
        .then((response) {
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body.toString().contains("error"));
        }
        // if the response contains "error" key, it means that the API has failed
        if (response.body.toString().contains("error")) {
          _failed = true;
          notifyListeners();
          return;
        } else {
          WeatherData weatherData =
              WeatherData.fromMap(jsonDecode(response.body));
          _failed = false;
          setWeatherData(weatherData);
        }
      } else {
        _failed = true;
        notifyListeners();
        if (kDebugMode) {
          print("Failed!");
        }
      }
    });
  }

  void fetchWeatherDataByCityName(String cityName) async {
    http.Client()
        .get(
      Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=1bc0383d81444b58b1432929200711&q=$cityName',
      ),
    )
        .then((response) {
      if (kDebugMode) {
        print(response.body);
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body.toString().contains("error"));
        }
        // if the response contains "error" key, it means that the API has failed
        if (response.body.toString().contains("error")) {
          _failed = true;
          notifyListeners();
          return;
        } else {
          WeatherData weatherData =
              WeatherData.fromMap(jsonDecode(response.body));
          _failed = false;
          setWeatherData(weatherData);
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('lastLocation', cityName);
            if (kDebugMode) {
              print("Saved last location: ${prefs.getString("lastLocation")}");
            }
          });
        }
      } else {
        _failed = true;
        notifyListeners();
        if (kDebugMode) {
          print("Failed!");
        }
      }
    });
  }
}
