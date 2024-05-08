import 'package:flutter/material.dart';

List<Map<String, dynamic>> generateFibonacciDetails(int n) {
  List<int> fibs = [0, 1];
  for (int i = 2; i < n; i++) {
    fibs.add(fibs[i - 1] + fibs[i - 2]);
  }

  return List.generate(fibs.length, (index) {
    IconData icon;
    if (fibs[index] % 5 == 0) {
      icon = Icons.close;
    } else if (fibs[index] % 2 == 0) {
      icon = Icons.fiber_manual_record;
    } else {
      icon = Icons.rectangle_outlined;
    }
    return {
      'number': fibs[index],
      'icon': icon,
      'index': index
    };
  });
}
