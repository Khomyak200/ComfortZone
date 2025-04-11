import 'package:flutter/material.dart';
import 'wind.dart'; // Убедитесь, что этот файл доступен

class WindInfoWidget extends StatelessWidget {
  final int windSpeed;
  final int windGusts;
  final int direction;
  final double size;

  const WindInfoWidget({
    Key? key,
    required this.windSpeed,
    required this.windGusts,
    required this.direction,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Текст слева
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ветер: ' + windSpeed.toString() + ' км/ч',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Порывы: ' + windGusts.toString() + ' км/ч',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Направление: ' + direction.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Компас справа
          Container(
            width: size * 0.5, // Установка ширины для компаса
            height: size * 0.5, // Установка высоты для компаса
            child: Compass1(), // Вставляем компас
          ),
        ],
      ),
    );
  }
}