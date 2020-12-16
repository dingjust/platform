import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///印章生成器
class SealGenerator {
  TextPainter _textPainter = TextPainter(textDirection: ui.TextDirection.ltr);

  ///公章尺寸
  final double kCanvasSize;

  ///个人章尺寸
  final double pCanvasSize;

  ///边粗
  final double stroke;

  ///文字边距
  final double fontPadding;

  ///名称文字大小
  final double fontSize;

  ///防伪文字大小
  final double numFontSize;

  double radius;

  double numRadius;

  SealGenerator(
      {this.kCanvasSize = 200.0,
      this.pCanvasSize = 120.0,
      this.stroke = 4.0,
      this.fontPadding = 8.0,
      this.fontSize = 18.0,
      this.numFontSize = 10.0}) {
    radius = kCanvasSize / 2 - fontSize - stroke - fontPadding;
    numRadius = kCanvasSize / 2 - numFontSize - stroke - fontPadding;
  }

  ///生成个人章
  Future<ByteData> generatePersonalSealImage(
      {Color color = Colors.red,
      double strokeWidth = 2,
      double pFontSize = 40.0,
      String text = ''}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromPoints(Offset(0.0, 0.0), Offset(pCanvasSize, pCanvasSize)));

    final stroke = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    //处理文字
    if (text.length == 2) {
      text = '$text之印';
    } else if (text.length == 3) {
      text = '$text印';
    }

    //适配5，6个字
    if (text.length == 5) {
      pFontSize = 20;
    } else if (text.length == 6) {
      pFontSize = 18;
    }

    if (text.length == 4) {
      // 竖排，逆序
      text = '${text[2]}${text[0]}${text[3]}${text[1]}';
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(pCanvasSize / 2, pCanvasSize / 2),
              width: pCanvasSize - 2 * strokeWidth,
              height: pCanvasSize - 2 * strokeWidth),
          stroke);
    } else {
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(pCanvasSize / 2, pCanvasSize / 2),
              width: pCanvasSize - 2 * strokeWidth,
              height: pCanvasSize - 2 * strokeWidth - 80),
          stroke);
    }

    ///绘制名称
    ParagraphBuilder pb = ParagraphBuilder(ParagraphStyle(
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.rtl,
      fontWeight: FontWeight.w500,
      fontSize: pFontSize,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.red))
      ..addText(text);

    ParagraphConstraints pc =
        ParagraphConstraints(width: pCanvasSize - 2 * strokeWidth);
    Paragraph paragraph = pb.build()..layout(pc);
    if (text.length == 4) {
      canvas.drawParagraph(paragraph, Offset(strokeWidth, strokeWidth));
    } else {
      canvas.drawParagraph(paragraph,
          Offset(strokeWidth, (pCanvasSize - pFontSize - 2 * strokeWidth) / 2));
    }

    Picture picture = recorder.endRecording();

    ui.Image img =
        await picture.toImage(pCanvasSize.toInt(), pCanvasSize.toInt());

    ByteData pngBytes = await img.toByteData(format: ImageByteFormat.png);

    return pngBytes;
  }

  ///生成公章
  Future<ByteData> generateOfficalSealImage(
      {Color color = Colors.red,
      double strokeWidth = 4,
      String textNum = '',
      String title = '',
      String text = ''}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromPoints(Offset(0.0, 0.0), Offset(kCanvasSize, kCanvasSize)));

    final stroke = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(kCanvasSize / 2, kCanvasSize / 2),
        (kCanvasSize / 2) - strokeWidth, stroke);

    ///绘制名称
    _drawName(canvas, text);

    _drawNum(canvas, textNum);

    _drawStar(canvas);

    _drawTitle(canvas, title);

    Picture picture = recorder.endRecording();

    ui.Image img =
        await picture.toImage(kCanvasSize.toInt(), kCanvasSize.toInt());

    ByteData pngBytes = await img.toByteData(format: ImageByteFormat.png);

    return pngBytes;
  }

  void _drawName(Canvas canvas, String text) {
    canvas.save();

    canvas.translate(kCanvasSize / 2, kCanvasSize / 2 - radius);

    final double initialAngle = -asin(fontSize / (2 * radius)) * text.length;

    final d = 2 * radius * sin(initialAngle / 2);
    final rotationAngle = _calculateRotationAngle(0, initialAngle);
    canvas.rotate(rotationAngle);
    canvas.translate(d, 0);

    double angle = initialAngle;
    for (int i = 0; i < text.length; i++) {
      angle = _drawNameLetter(canvas, text[i], angle);
    }

    canvas.restore();
  }

  ///绘制名称文字
  double _drawNameLetter(Canvas canvas, String letter, double prevAngle) {
    _textPainter.text = TextSpan(
        text: letter, style: TextStyle(color: Colors.red, fontSize: fontSize));
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );

    final double d = _textPainter.width;
    final double alpha = 2 * asin(d / (2 * radius));

    final newAngle = _calculateRotationAngle(prevAngle, alpha);
    canvas.rotate(newAngle);

    _textPainter.paint(canvas, Offset(0, -_textPainter.height));
    canvas.translate(d, 0);

    return alpha;
  }

  ///防伪号码
  void _drawNum(Canvas canvas, String text) {
    canvas.save();

    //反序
    text = text.split('').reversed.join();

    canvas.translate(kCanvasSize / 2, kCanvasSize / 2 - numRadius);

    //获取实际文字宽度
    _textPainter.text =
        TextSpan(text: '1', style: TextStyle(fontSize: numFontSize));
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    double textWidth = _textPainter.width;

    //初始偏转弧度(反)
    final double initialAngle =
        -asin(textWidth / (2 * numRadius)) * text.length;

    final d = 2 * numRadius * sin(initialAngle / 2);
    final rotationAngle = _calculateRotationAngle(0, initialAngle);
    canvas.rotate(rotationAngle);
    canvas.translate(d, 0);

    double angle = initialAngle;
    for (int i = 0; i < text.length; i++) {
      angle = _drawNumLetter(canvas, text[i], angle);
    }

    canvas.restore();
  }

  ///绘制防伪码文字
  double _drawNumLetter(Canvas canvas, String letter, double prevAngle) {
    _textPainter.text = TextSpan(
        text: letter,
        style: TextStyle(color: Colors.red, fontSize: numFontSize));
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );

    final double d = _textPainter.width;
    final double alpha = 2 * asin(d / (2 * numRadius));

    final newAngle = _calculateRotationAngle(prevAngle, alpha);
    canvas.rotate(newAngle);

    _textPainter.paint(canvas, Offset(0, 2 * numRadius));
    canvas.translate(d, 0);

    return alpha;
  }

  ///绘制五角星
  void _drawStar(Canvas canvas, {Color color = Colors.red, double size = 25}) {
    canvas.save();

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.translate(kCanvasSize / 2, kCanvasSize / 2);
    canvas.rotate(pi);

    Path path = Path();
    var dig = pi / 5 * 4;
    for (var i = 0; i < 5; i++) {
      var x = sin(i * dig);
      var y = cos(i * dig);
      if (i == 0) {
        path.moveTo(x * size, y * size);
      } else {
        path.lineTo(x * size, y * size);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    canvas.restore();
  }

  void _drawTitle(Canvas canvas, String title,
      {Color color = Colors.red,
      double bottomMargin = 55,
      double tFontSize = 16.0}) {
    // 适配5个字以上
    if (title.length > 5) {
      tFontSize = 13;
    }

    _textPainter.text = TextSpan(
        text: title,
        style: TextStyle(
            color: color, fontSize: tFontSize, fontWeight: FontWeight.bold));
    _textPainter.textAlign = TextAlign.center;
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );

    _textPainter.paint(
        canvas,
        Offset(kCanvasSize / 2 - _textPainter.width / 2,
            kCanvasSize - bottomMargin));
  }

  double _calculateRotationAngle(double prevAngle, double alpha) =>
      (alpha + prevAngle) / 2;
}
