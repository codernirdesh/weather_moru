import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_info_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, AppInfoProvider appInfo, child) {
          return Text(appInfo.title);
        }),
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}
