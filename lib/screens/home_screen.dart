import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_moru/routes/routes_name.dart';

import '../providers/app_info_provider.dart';
import '../providers/weather_data_provider.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final TextEditingController _cityNameController = TextEditingController();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherDataProvider =
        Provider.of<WeatherDataProvider>(context, listen: false);
    SharedPreferences.getInstance().then((prefs) {
      String last_location = prefs.getString('last_location') ?? "";
      if (last_location != "") {
        _cityNameController.text = last_location;
        weatherDataProvider.fetchWeatherDataByCityName(last_location);
      } else {
        if (weatherDataProvider.serviceEnabled &&
            weatherDataProvider.permissionGranted == PermissionStatus.granted) {
          weatherDataProvider.getCurrentLocation();
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, AppInfoProvider appInfo, child) {
          return Text(appInfo.title);
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.pushReplacementNamed(context, RoutesName.help);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
          child: Column(
            children: weatherDataProvider.serviceEnabled &&
                    weatherDataProvider.permissionGranted ==
                        PermissionStatus.granted
                ? [
                    TextField(
                      controller: _cityNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'City',
                        hintText: "Enter the city's name",
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    MaterialButton(
                      onPressed: () {
                        if (_cityNameController.text == "") {
                          weatherDataProvider.fetchWeatherDataByLatLon();
                        } else {
                          weatherDataProvider.fetchWeatherDataByCityName(
                              _cityNameController.text);
                        }
                      },
                      minWidth: MediaQuery.of(context).size.width,
                      height: 55.0,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: const Text('Get Weather Data'),
                    ),
                    const SizedBox(height: 20.0),
                    Consumer(builder:
                        (_, WeatherDataProvider weatherDataProvider, __) {
                      if (weatherDataProvider.failed) {
                        return const Text(
                          'Failed to get weather data',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            Image.network(
                              weatherDataProvider
                                      .weatherData?.current.condition.icon
                                      .toString()
                                      .replaceAll(RegExp(r'//'), 'https://') ??
                                  "https://cdn.weatherapi.com/weather/64x64/day/116.png",
                            ),
                            Text(
                              "Status : ${weatherDataProvider.weatherData?.current.condition.text ?? 0}",
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Status : ${weatherDataProvider.failed}",
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Location : ${weatherDataProvider.weatherData?.location.name ?? 0}/${weatherDataProvider.weatherData?.location.country ?? 0}",
                            ),
                            Text(
                              "Latitude/Longitude : ${weatherDataProvider.weatherData?.location.lat ?? 0}/${weatherDataProvider.weatherData?.location.lon ?? 0}",
                            ),
                            Text(
                              "Temperature in celcius: ${weatherDataProvider.weatherData?.current.tempC ?? 0}",
                            ),
                            Text(
                              "Temperature in Fahrenheit: ${weatherDataProvider.weatherData?.current.tempF ?? 0}",
                            ),
                            Text(
                              "Temperature feels like in C: ${weatherDataProvider.weatherData?.current.feelslikeC ?? 0}",
                            ),
                            Text(
                              "Temperature feels like in F: ${weatherDataProvider.weatherData?.current.feelslikeF ?? 0}",
                            ),
                          ],
                        );
                      }
                    })
                  ]
                : [
                    const Text("Location service is not enabled"),
                    Text(weatherDataProvider.locationData.toString()),
                    ElevatedButton(
                      onPressed: () {
                        weatherDataProvider.checkLocationServiceStatus();
                        weatherDataProvider.checkLocationPermissionStatus();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.red[400]),
                        elevation: MaterialStateProperty.all(1),
                      ),
                      child: const Text('Enable'),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
