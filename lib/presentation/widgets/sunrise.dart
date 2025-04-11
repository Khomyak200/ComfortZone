import 'dart:math';
import 'package:flutter/material.dart';

class SunSineChart extends StatelessWidget {
  final DateTime sunrise;
  final DateTime sunset;
  final double size;

  SunSineChart({
    Key? key,
    required this.sunrise,
    required this.sunset,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double sunriseX = _timeToX(sunrise, size);
    double sunsetX = _timeToX(sunset, size);
    String hours;
    String minutes;
    String title;
    if (sunrise.hour<12)
      hours = '0'+sunrise.hour.toString();
    else
      hours = sunrise.hour.toString();

    if (sunrise.minute<10)
      minutes ='0'+sunrise.minute.toString();
    else
      minutes =sunrise.minute.toString();

    title = hours+':'+minutes;

    return SizedBox(
      width: size * 0.9,
      height: size * 0.5,
      child: CustomPaint(
        painter: SineWavePainter(
          sunriseX: sunriseX,
          sunsetX: sunsetX,
          chartHeight: size * 0.5,
          title: title,
        ),
      ),
    );
  }

  double _timeToX(DateTime time, double size) {
    return (time.hour + time.minute / 60.0) / 24 * (size * 0.9);
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    return DateTime(2023, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
  }
}

class SineWavePainter extends CustomPainter {
  final double sunriseX;
  final double sunsetX;
  final double chartHeight;
  final String title;

  SineWavePainter({
    required this.sunriseX,
    required this.sunsetX,
    required this.chartHeight,
    required this.title,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white30
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    Paint axisPaint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Рисуем ось OX
    canvas.drawLine(Offset(0, chartHeight / 2), Offset(size.width, chartHeight / 2), axisPaint);

    Path path = Path();


    double amplitude = chartHeight / 4;

    path.moveTo(sunriseX, chartHeight / 2); // Начинаем с оси OX

    // Генерируем точки для синусоиды
    for (double x = sunriseX; x <= sunsetX; x += 1) {
      // Используем синус для Y, чтобы линия была выше линии OX
      double amplitude = chartHeight / 4; // Амплитуда синусоиды
      double y = (-amplitude * sin((x - sunriseX) * (pi / (sunsetX - sunriseX))) + (chartHeight / 2 + amplitude)) - amplitude;

      path.lineTo(x, y);
    }

    // Закрываем путь и рисуем
    canvas.drawPath(path, paint);

    // Рисуем точки и маркировки восхода и заката
    paint.color = Colors.white30; // Цвет для восхода и заката
    canvas.drawCircle(Offset(sunriseX, chartHeight / 2), 6, paint);
    canvas.drawCircle(Offset(sunsetX, chartHeight / 2), 6, paint);

    // Рисуем заголовок над графиком
    _drawTitle(canvas, size);
  }

  void _drawTitle(Canvas canvas, Size size) {
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    double x = (size.width - textPainter.width) / 2;
    textPainter.paint(canvas, Offset(x, -30)); // Подняли заголовок выше
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}