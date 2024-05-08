import 'package:flutter/material.dart';
import 'fibonacci_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fibonacci Scroll',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FibonacciScreen(),
    );
  }
}
