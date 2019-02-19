import 'dart:math';

import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductionCircleStep extends StatelessWidget {
  const ProductionCircleStep(
      {Key key,
      this.size = 30,
      @required this.currentPhase,
      this.fontSize = 15,
      this.thickness = 5,
      this.fontColor = const Color.fromRGBO(50, 50, 50, 1)})
      : super(key: key);

  final double size;

  final double fontSize;

  final double thickness;

  final Color fontColor;

  final ProductionProgressPhase currentPhase;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: _buildBody(),
      ),
    );
  }

  List<Widget> _buildBody() {
    List<Widget> body = [
      //底框
      CustomPaint(
        painter: CircleStepPainter(
            radius: size,
            thickness: thickness,
            color: Colors.grey[300],
            startAngle: -pi / 2,
            endAngle: -pi / 2 + 2 * pi),
      ),
    ];

    for (int i = 0; i < ProductionStepConstants.length; i++) {
      if (ProductionStepConstants[i]['phase'] == currentPhase) {
        body.add(CustomPaint(
          painter: CircleStepPainter(
              radius: size,
              thickness: thickness,
              color: ProductionStepConstants[i]['color'],
              startAngle: (i - 1.5) * 2 * pi / ProductionStepConstants.length,
              endAngle: (i - 1.5) * 2 * pi / ProductionStepConstants.length +
                  2 * pi / ProductionStepConstants.length),
        ));
        break;
      } else {
        body.add(CustomPaint(
          painter: CircleStepPainter(
              radius: size,
              thickness: thickness,
              color: ProductionStepConstants[i]['color'],
              startAngle: (i - 1.5) * 2 * pi / ProductionStepConstants.length,
              endAngle: (i - 1.5) * 2 * pi / ProductionStepConstants.length +
                  2 * pi / ProductionStepConstants.length),
        ));
      }
    }

    //当前步骤
    body.add(Text(
      '${ProductionProgressPhaseLocalizedMap[currentPhase]}',
      style: TextStyle(
          color: fontColor, fontSize: fontSize, fontWeight: FontWeight.bold),
    ));
    return body;
  }
}

class CircleStepPainter extends CustomPainter {
  final double radius;
  final double thickness;
  final Color color;
  final double startAngle;
  final double endAngle;

  final Paint activationPaint;

  CircleStepPainter(
      {this.radius, this.thickness, this.color, this.startAngle, this.endAngle})
      : activationPaint = Paint()
          ..color = color
          ..strokeWidth = thickness
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.drawArc(Rect.fromLTWH(-radius, -radius, radius * 2, radius * 2),
        startAngle, endAngle - startAngle, false, activationPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}

class CircleStepItem {
  CircleStepItem({@required this.phase, @required this.color});

  final ProductionProgressPhase phase;

  final Color color;
}

//带颜色区分进度，勿删除

// const ProductionStepConstants = [
//   {
//     "phase": ProductionProgressPhase.MATERIAL_PREPARATION,
//     "color": Color.fromRGBO(255, 108, 108, 1)
//   },
//   {
//     "phase": ProductionProgressPhase.CUTTING,
//     "color": Color.fromRGBO(255, 194, 108, 1)
//   },
//   {
//     "phase": ProductionProgressPhase.STITCHING,
//     "color": Color.fromRGBO(89, 205, 145, 1)
//   },
//   {
//     "phase": ProductionProgressPhase.AFTER_FINISHING,
//     "color": Color.fromRGBO(61, 171, 248, 1)
//   },
//   {
//     "phase": ProductionProgressPhase.INSPECTION,
//     "color": Color.fromRGBO(223, 122, 234, 1)
//   },
//   {
//     "phase": ProductionProgressPhase.DELIVERY,
//     "color": Color.fromRGBO(196, 213, 114, 1)
//   }
// ];

const ProductionStepConstants = [
  {
    "phase": ProductionProgressPhase.MATERIAL_PREPARATION,
    "color": Color.fromRGBO(255, 194, 108, 1)
  },
  {
    "phase": ProductionProgressPhase.CUTTING,
    "color": Color.fromRGBO(255, 194, 108, 1)
  },
  {
    "phase": ProductionProgressPhase.STITCHING,
    "color": Color.fromRGBO(255, 194, 108, 1)
  },
  {
    "phase": ProductionProgressPhase.AFTER_FINISHING,
    "color": Color.fromRGBO(255, 194, 108, 1)
  },
  {
    "phase": ProductionProgressPhase.INSPECTION,
    "color": Color.fromRGBO(255, 194, 108, 1)
  },
  {
    "phase": ProductionProgressPhase.DELIVERY,
    "color": Color.fromRGBO(255, 194, 108, 1)
  }
];
