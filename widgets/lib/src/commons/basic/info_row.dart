import 'package:flutter/material.dart';

class B2BInfoRow extends StatelessWidget {
  const B2BInfoRow(
      {Key? key, this.label, this.value, this.hasBottomBorder = true})
      : super(key: key);

  final String? label;
  final Widget? value;
  final bool hasBottomBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      decoration: BoxDecoration(
          border: Border(
        bottom: hasBottomBorder
            ? BorderSide(color: Colors.grey[300]!, width: 0.5)
            : BorderSide.none,
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label!,
            style: TextStyle(fontSize: 16),
          ),
          value ?? Container()
        ],
      ),
    );
  }
}
