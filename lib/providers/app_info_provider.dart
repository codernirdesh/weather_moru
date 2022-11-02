import 'package:flutter/cupertino.dart';

class AppInfoProvider with ChangeNotifier {
  String _title = 'Weather Moru';
  String _version = '0.0.1';

  String get title => _title;
  String get version => _version;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setVersion(String version) {
    _version = version;
    notifyListeners();
  }
}
