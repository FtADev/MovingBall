import 'package:flutter/material.dart';
import 'ball_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moving Ball',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BallScreen(),
    );
  }
}
