import 'package:flutter/material.dart';
import 'Screen/HomeScreen.dart';
import 'Screen/SearchScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'veera',
      home: HomeScreen(),
      routes: {
        '/a': (context) => HomeScreen(),
      },
    );
  }
}
