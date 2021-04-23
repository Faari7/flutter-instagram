import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const String routName = '/splash';

  static Route rout() {
    return MaterialPageRoute(
      builder: (_) => SplashScreen(),
      settings: const RouteSettings(name: routName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
