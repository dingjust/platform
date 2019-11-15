import 'package:flutter/material.dart';

class B2BFloatingActionButtonLocation extends FloatingActionButtonLocation {
  /// 屏幕高度占比
  final double heithScale;

  B2BFloatingActionButtonLocation(this.heithScale);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(_endOffset(scaffoldGeometry),
        _straddleAppBar(scaffoldGeometry, heithScale));
  }

  @override
  String toString() => 'FloatingActionButtonLocation.endTop';
}

double _endOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
    {double offset = 0.0}) {
  assert(scaffoldGeometry.textDirection != null);
  switch (scaffoldGeometry.textDirection) {
    case TextDirection.rtl:
      return _leftOffset(scaffoldGeometry, offset: offset);
    case TextDirection.ltr:
      return _rightOffset(scaffoldGeometry, offset: offset);
  }
  return null;
}

double _leftOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
    {double offset = 0.0}) {
  return kFloatingActionButtonMargin + scaffoldGeometry.minInsets.left - offset;
}

double _rightOffset(ScaffoldPrelayoutGeometry scaffoldGeometry,
    {double offset = 0.0}) {
  return scaffoldGeometry.scaffoldSize.width -
      kFloatingActionButtonMargin -
      scaffoldGeometry.minInsets.right -
      scaffoldGeometry.floatingActionButtonSize.width +
      offset;
}

double _straddleAppBar(
    ScaffoldPrelayoutGeometry scaffoldGeometry, double heithScale) {
  final double fabHalfHeight =
      scaffoldGeometry.floatingActionButtonSize.height * heithScale;
  return scaffoldGeometry.contentTop - fabHalfHeight;
}
