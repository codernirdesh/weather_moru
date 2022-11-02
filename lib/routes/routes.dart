import 'package:flutter/material.dart';
import 'package:weather_moru/screens/help_screen.dart';
import 'package:weather_moru/screens/home_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'home_screen':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case 'help_screen':
        return MaterialPageRoute(builder: (_) => const HelpScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("Maybe we're lost?"),
            ),
          ),
        );
    }
  }
}
