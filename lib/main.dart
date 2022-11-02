import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_moru/providers/app_info_provider.dart';
import 'package:weather_moru/providers/weather_data_provider.dart';
import 'package:weather_moru/routes/routes_name.dart';
import 'routes/routes.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppInfoProvider()),
      ChangeNotifierProvider(create: (_) => WeatherDataProvider()),
    ],
    child: const WeatherApp(),
  ));
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RoutesName.help,
    );
  }
}
