import 'package:flutter/cupertino.dart';

class AppInfoProvider with ChangeNotifier {
  String _title = 'Weather Moru';
  String _version = '0.0.1';
  int _timer = 0;

  String get title => _title;
  String get version => _version;
  int get timer => _timer;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setTimer(int timer) {
    _timer = timer;
    notifyListeners();
  }

  void incrementTimer() {
    _timer++;
    notifyListeners();
  }

  void setVersion(String version) {
    _version = version;
    notifyListeners();
  }
}
