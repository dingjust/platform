import 'package:flutter/material.dart';

class SaleOrderInputRow extends StatelessWidget {
  final String label;

  final Widget child;

  final Widget suffix;

  final double labelWidth;

  final double height;

  final EdgeInsetsGeometry padding;

  const SaleOrderInputRow(
      {Key key,
      this.label,
      this.child,
      this.suffix,
      this.labelWidth = 100,
      this.height = 70,
      this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: labelWidth,
              child: Text(
                '$label',
                style: TextStyle(fontSize: 18),
              ),
            ),
            child != null ? Expanded(flex: 1, child: child) : Container(),
            suffix != null ? suffix : Container()
          ],
        ));
  }
}
