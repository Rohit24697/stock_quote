import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_quote/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      title: 'Stock Quote App',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}