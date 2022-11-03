import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_moru/providers/app_info_provider.dart';
import '../providers/weather_data_provider.dart';
import '../routes/routes_name.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherDataProvider =
        Provider.of<WeatherDataProvider>(context, listen: false);
    weatherDataProvider.checkLocationServiceStatus();
    weatherDataProvider.checkLocationPermissionStatus();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      int theTimer = Provider.of<AppInfoProvider>(context, listen: false).timer;
      if (kDebugMode) {
        print(theTimer);
      }
      if (theTimer < 5) {
        Provider.of<AppInfoProvider>(context, listen: false).incrementTimer();
      } else {
        timer.cancel();
        Provider.of<AppInfoProvider>(context, listen: false).setTimer(0);
        Navigator.pushReplacementNamed(context, RoutesName.home);
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Help to the user',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: const Text(
                  'This is an app where we show you the weather in your city.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red[400]),
                  elevation: MaterialStateProperty.all(1),
                ),
                child: const Text('Skip'),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Consumer(
                    builder: (context, AppInfoProvider appInfoProvider, child) {
                  return Text(
                    'You will be redirected to the main screen in ${appInfoProvider.timer} seconds.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
