import 'package:flutter/material.dart';

class RainfallWidget extends StatelessWidget {
  final int sizeRainfall;
  final double size;

  const RainfallWidget({
    Key? key,
    required this.sizeRainfall,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      //alignment: Alignment.centerLeft, // Выравнивание по левому краю
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            sizeRainfall.toString() + ' мм',
            style: const TextStyle(color: Colors.white, fontSize: 65),
          ),
          const SizedBox(height: 8),
          Text(
            'Сегодня',
            style: const TextStyle(color: Colors.white, fontSize: 40),
          ),
        ],
      ),
    );
  }
}