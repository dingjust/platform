import 'package:flutter/material.dart';

class B2BIcons {
  static const IconData bool =
      const IconData(0xe656, fontFamily: 'b2bIcons', matchTextDirection: true);
  static const IconData eye_not_see =
      const IconData(0xe652, fontFamily: 'b2bIcons', matchTextDirection: true);
  static const IconData publish_requirement_success =
      const IconData(0xe69e, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData factory_map =
      const IconData(0xe69b, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData industrial_cluster =
      const IconData(0xe698, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData factory_brand =
      const IconData(0xe699, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData free_proofing =
      const IconData(0xe69c, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData factory_all =
      const IconData(0xe69a, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData message =
      const IconData(0xe653, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData left_quotation =
      const IconData(0xe6a5, fontFamily: 'b2bIcons2', matchTextDirection: true);
  static const IconData right_quotation =
      const IconData(0xe6a6, fontFamily: 'b2bIcons2', matchTextDirection: true);
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

  static Image excel({double width, double height}) {
    return Image.asset(
      'temp/excel.png',
      package: _package,
      width: width,
      height: height,
    );
  }
}
