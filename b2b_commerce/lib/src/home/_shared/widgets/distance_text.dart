import 'package:flutter/material.dart';

///距离显示
class DistanceText extends StatelessWidget {
  final double val;

  const DistanceText({Key key, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '${getStr()}',
        style: TextStyle(color: Colors.orange),
      ),
    );
  }

  ///
  String getStr() {
    if (val == null || val < 0) {
      return '';
    }

    if (val < 1000) {
      return '${val.toStringAsFixed(0)}米';
    }

    if (val < 10000000) {
      double kM = val / 1000;
      return '${kM.toStringAsFixed(2)}公里';
    }

    double mKM = val / 10000000;
    return '${mKM.toStringAsFixed(2)}万公里';
  }
}
