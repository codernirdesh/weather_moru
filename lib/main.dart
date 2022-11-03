import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_moru/providers/app_info_provider.dart';
import 'package:weather_moru/providers/weather_data_provider.dart';
import 'package:weather_moru/routes/routes_name.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? hasPressedSkip = prefs.getBool("hasPressedSkip");
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppInfoProvider()),
      ChangeNotifierProvider(create: (_) => WeatherDataProvider()),
    ],
    child: WeatherApp(
      hasPressedSkip: hasPressedSkip ?? false,
    ),
  ));
}

class WeatherApp extends StatelessWidget {
  final bool hasPressedSkip;
  const WeatherApp({Key? key, required this.hasPressedSkip}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: Routes.generateRoute,
      // if hasPressedSkip is true, then we go to the home screen
      initialRoute: hasPressedSkip ? RoutesName.home : RoutesName.help,
    );
  }
}
