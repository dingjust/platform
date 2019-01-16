import 'package:flutter/material.dart';

class B2BIcons {
  static const IconData bool =
      const IconData(0xe656, fontFamily: 'b2bIcons', matchTextDirection: true);
  static const IconData eye_not_see =
      const IconData(0xe652, fontFamily: 'b2bIcons', matchTextDirection: true);
}

class CommonImage {
  static String _package = 'assets';

  static Image pdf({double width, double height}) {
    return Image.asset(
      'temp/pdf.png',
      package: _package,
      width: width,
      height: height,
    );
  }

  static Image word({double width, double height}) {
    return Image.asset(
      'temp/word.png',
      package: _package,
      width: width,
      height: height,
    );
  }
}
