import 'package:flutter/material.dart';

class HumidityWidget extends StatelessWidget {
  final int humidity;
  final double dewPoint;
  final double size;

  const HumidityWidget({
    Key? key,
    required this.humidity,
    required this.dewPoint,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$humidity%',
          style: const TextStyle(color: Colors.white, fontSize: 65),
        ),
        const SizedBox(height: 8),
        Text(
          'Точка росы сейчас: ${dewPoint.toStringAsFixed(1)}°C',
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ],
    );
  }
}