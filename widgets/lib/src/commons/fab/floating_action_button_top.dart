import 'package:flutter/material.dart';

class B2BFloatingActionButtonLocation_Offset
    extends FloatingActionButtonLocation {
  final double top;

  B2BFloatingActionButtonLocation_Offset(this.top);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
        scaffoldGeometry.scaffoldSize.width -
            scaffoldGeometry.floatingActionButtonSize.width,
        top);
  }

  @override
  String toString() => 'FloatingActionButtonLocation.endDocked';
}
