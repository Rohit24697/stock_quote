import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stock_quote/stock_getx_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer for 3 seconds before navigating to the HomeScreen
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => StockGetxPage()), // Navigate to HomeScreen after 3 seconds
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
          children: [
            // Display the logo image
            Image.asset("assets/axolotls_logo.jpg"),
            const SizedBox(height: 20), // Add some space between the logo and text
            const Text(
              "Developed by Rohit Hegade", // Display developer's name
              style: TextStyle(
                fontSize: 16.0, // Set font size
                fontWeight: FontWeight.bold, // Make the text bold
                fontStyle: FontStyle.italic, // Make the text italic
                color: Colors.blue, // Set text color to yellow
              ),
            ),
          ],
        ),
      ),
    );
  }
}
