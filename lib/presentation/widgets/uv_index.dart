import 'package:flutter/material.dart';

class UVIndexWidget extends StatelessWidget {
  final int uvIndex;
  final double size;


  const UVIndexWidget({
    Key? key,
    required this.uvIndex,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String level='';
    if(uvIndex<=3){
      level='Низкий';
    }else{
      if(uvIndex<=5){
        level='Умеренный';
      }
      else{
        if(uvIndex<=7){
          level='Высокий';
        }else{
          if(uvIndex<=10){
            level='Высокий';
          }else{
            level='Крайне высокий';
          }
        }
      }
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Текст УФ-индекса вверху
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'УФ-индекс: ${uvIndex.toString()}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Низкий',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Полоса с градиентом и кружком
          Stack(
            alignment: Alignment.center,
            children: [
              // Полоса с градиентом
              Container(
                width: size * 0.7, // Установка ширины для полосы
                height: 10, // Высота полосы
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.green, // Зелёный
                      Colors.yellow, // Жёлтый
                      Colors.orange, // Оранжевый
                      Colors.red, // Красный
                      Colors.purple, // Фиолетовый
                    ],
                    stops: [0.0, 0.25, 0.5, 0.75, 1.0], // Позиции переходов
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(5),
                    bottom: Radius.circular(5),
                  ),
                ),
              ),
              // Маленький круг, который обозначает значение УФ-индекса
              Positioned(
                left: (size * 0.7) * (uvIndex.clamp(0.0, 10.0) / 10) - 15, // Позиция кружка
                top: (10 / 2) - 10, // Центрируем кружок на линии
                child: Container(
                  width: 20, // Ширина кружка
                  height: 20, // Высота кружка
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF2196F3), width: 2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}