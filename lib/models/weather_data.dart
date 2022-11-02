// To parse this JSON data, do
//
//     final weatherData = weatherDataFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

WeatherData weatherDataFromMap(String str) =>
    WeatherData.fromMap(json.decode(str));

String weatherDataToMap(WeatherData data) => json.encode(data.toMap());

class WeatherData {
  WeatherData({
    required this.location,
    required this.current,
  });

  final Location location;
  final Current current;

  factory WeatherData.fromMap(Map<String, dynamic> json) => WeatherData(
        location: Location.fromMap(json["location"]),
        current: Current.fromMap(json["current"]),
      );

  Map<String, dynamic> toMap() => {
        "location": location.toMap(),
        "current": current.toMap(),
      };
}

class Current {
  Current({
    required this.tempC,
    required this.tempF,
    required this.condition,
    required this.humidity,
    required this.cloud,
    required this.feelslikeC,
    required this.feelslikeF,
    required this.uv,
  });

  final double tempC;
  final double tempF;
  final Condition condition;
  final double humidity;
  final double cloud;
  final double feelslikeC;
  final double feelslikeF;
  final double uv;

  factory Current.fromMap(Map<String, dynamic> json) => Current(
        tempC: json["temp_c"].toDouble(),
        tempF: json["temp_f"].toDouble(),
        condition: Condition.fromMap(json["condition"]),
        humidity: json["humidity"].toDouble(),
        cloud: json["cloud"].toDouble(),
        feelslikeC: json["feelslike_c"].toDouble(),
        feelslikeF: json["feelslike_f"].toDouble(),
        uv: json["uv"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "temp_c": tempC,
        "temp_f": tempF,
        "condition": condition.toMap(),
        "humidity": humidity,
        "cloud": cloud,
        "feelslike_c": feelslikeC,
        "feelslike_f": feelslikeF,
        "uv": uv,
      };
}

class Condition {
  Condition({
    required this.text,
    required this.icon,
    required this.code,
  });

  final String text;
  final String icon;
  final int code;

  factory Condition.fromMap(Map<String, dynamic> json) => Condition(
        text: json["text"],
        icon: json["icon"],
        code: json["code"],
      );

  Map<String, dynamic> toMap() => {
        "text": text,
        "icon": icon,
        "code": code,
      };
}

class Location {
  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
  });

  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        name: json["name"],
        region: json["region"],
        country: json["country"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "region": region,
        "country": country,
        "lat": lat,
        "lon": lon,
      };
}
