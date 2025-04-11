import 'package:flutter/material.dart';
import 'dart:math';
class Compass1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(150, 150), // Размер компаса
      painter: CompassPainter(),
    );
  }
}
class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    _drawDirections(canvas, size);
    // Рисуем черточки для градусов
    _drawDegreeMarks(canvas, size);

    // Рисуем направления


    // Рисуем стрелку компаса
    _drawArrow(canvas, size,40);
  }

  void _drawDegreeMarks(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    final Paint paintFor  = Paint()
    ..color=Colors.white70
    ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;

    // Устанавливаем шаг в 30.9 градусов
    double angleStep = 30/9;

    // Вычисляем количество шагов в 360 градусах
    int steps = (360 / angleStep).ceil();

    for (int i = 0; i < steps; i++) {
      double angleDeg = i * angleStep;
      double angleRad = (angleDeg * pi) / 180;

      double xStart = radius + (radius - 10) * cos(angleRad);
      double yStart = radius + (radius - 10) * sin(angleRad);
      double xEnd = radius + radius * cos(angleRad);
      double yEnd = radius + radius * sin(angleRad);

      // Рисуем черточку, если это не одно из направлений
      if ((angleDeg.toInt() % 90 > 4) && (angleDeg.toInt() % 90 < 86)) {
        if(angleDeg.toInt()%30==0)
          canvas.drawLine(Offset(xStart, yStart), Offset(xEnd, yEnd), paintFor);
        else
          canvas.drawLine(Offset(xStart, yStart), Offset(xEnd, yEnd), paint);
      }
    }
  }

  void _drawDirections(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2;

    // Основные направления
    List<String> directions = ['В', 'Ю', 'З', 'С'];
    List<double> angles = [0, 90, 180, 270];

    for (int i = 0; i < directions.length; i++) {
      double angleRad = (angles[i] * pi) / 180;
      double x = radius + (radius - 5) * cos(angleRad);
      double y = radius + (radius - 5) * sin(angleRad);

      // Рисуем текст направления
      TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: directions[i],
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }
  }

  void _drawArrow(Canvas canvas, Size size, double degrees) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint centerCirclePaint = Paint()
      ..color = Colors.lightBlueAccent // Цвет центрального круга
      ..style = PaintingStyle.fill;

    final double radius = size.width / 2;
    double angleRad = (degrees * pi) / 180;

    // Ширина и длина стрелки
    double arrowWidth = 5;
    double arrowLength = radius - 5;
    double triangleHeight = 5; // Высота треугольника
    double triangleBaseWidth = 20; // Ширина основания треугольника
    double circleRadius = 5; // Радиус круга на конце стрелки
    double centerCircleRadius = 35; // Радиус меньшего центра круга

    // Отображаем стрелку
    // Сохраняем текущее состояние канваса
    canvas.save();

    // Перемещаем центр канваса в середину стрелки
    canvas.translate(radius, radius);

    // Вращаем канвас для выставления стрелки (нужно вращать по часовой стрелке)
    canvas.rotate(-angleRad); // Вращаем на -angleRad для часовой стрелки

    // Рисуем основную часть стрелки (прямоуголник)
    Rect arrowRect = Rect.fromCenter(
      center: Offset(0, -arrowLength / 2), // Центрировать в верхней части
      width: arrowWidth,
      height: arrowLength,
    );
    canvas.drawRect(arrowRect, paint);

    // Рисуем круг на конце стрелки
    canvas.drawCircle(Offset(0, -arrowLength), circleRadius, paint);

    // Рисуем обратную часть стрелки (прямоуголник)
    Rect reverseArrowRect = Rect.fromCenter(
      center: Offset(0, arrowLength / 2), // Центрировать в нижней части
      width: arrowWidth,
      height: arrowLength,
    );
    canvas.drawRect(reverseArrowRect, paint);

    // Рисуем треугольник на конце обратной стрелки
    Path reverseTrianglePath = Path();
    reverseTrianglePath.moveTo(0, arrowLength + triangleHeight); // Вершина треугольника на конце обратной линии
    reverseTrianglePath.lineTo(-triangleBaseWidth / 2, arrowLength); // Левый угол треугольника
    reverseTrianglePath.lineTo(triangleBaseWidth / 2, arrowLength); // Правый угол треугольника
    reverseTrianglePath.close(); // Закрываем путь
    canvas.drawPath(reverseTrianglePath, paint);

    // Восстанавливаем состояние канваса, чтобы добавить текст
    canvas.restore();

    // Рисуем меньший круг в центре компаса
    canvas.drawCircle(Offset(radius, radius), centerCircleRadius, centerCirclePaint);

    // Добавляем текст в меньший круг
    // Настройки текста
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: '60', // Большая цифра
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    // Рисуем текст по центру круга
    textPainter.paint(canvas, Offset(radius - textPainter.width / 2, radius - textPainter.height / 2 - 10)); // Смещение для выравнивания по центру

    // Добавляем km/h под большой цифрой
    TextPainter unitTextPainter = TextPainter(
      text: TextSpan(
        text: 'км/ч', // Текст единицы измерения
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    unitTextPainter.layout();
    // Рисуем текст внизу
    unitTextPainter.paint(canvas, Offset(radius - unitTextPainter.width / 2, radius + textPainter.height / 2 + 1)); // Выравниваем по центру

    // Восстанавливаем состояние канваса
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}