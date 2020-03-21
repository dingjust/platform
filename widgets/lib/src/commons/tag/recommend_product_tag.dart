import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;

class RecommendProductTag extends StatelessWidget {
  final Text text;

  final double width;

  final double height;

  final Color color;

  const RecommendProductTag(this.text, {
    Key key,
    this.width = 60,
    this.height = 60,
    this.color = const Color.fromRGBO(255, 214, 12, 1),
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // decoration: BoxDecoration(
      //     color: Colors.green, borderRadius: BorderRadius.circular(5)),
      child: CustomPaint(
          painter: _RecommendProductTagPainter(color),
          child: Align(
            child: Transform.rotate(
              angle: math.atan(width / height) - math.pi / 2,
              child: Padding(
                padding: EdgeInsets.only(bottom: text.style.fontSize + 3),
                child: text,
              ),
            ),
          )),
    );
  }
}

class _RecommendProductTagPainter extends CustomPainter {
  final Color color;

  final double radius;

  _RecommendProductTagPainter(this.color, {this.radius = 5});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.strokeWidth = 1;

    final Rect arcRect =
    Rect.fromCircle(center: Offset(radius, radius), radius: radius);
    canvas.drawArc(arcRect, -pi / 2, pi * radius / 2, true, paint);

    var path = Path();
    path.moveTo(0, radius);
    path.lineTo(0, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(radius, 0);
    path.close();

    paint.style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
