import 'package:flutter/material.dart';

class InfoTitle extends StatelessWidget {
  final String val;

  final Color color;

  const InfoTitle(this.val, {this.color = const Color(0xFF222222)});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Text(
          '$val',
          style: TextStyle(
              color: color, fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }
}

class InfoRow extends StatelessWidget {
  final String label;

  final String val;

  final TextAlign textAlign;

  final double labelWidth;

  final TextStyle style;

  const InfoRow(
      {Key key,
      this.label,
      this.val,
      this.textAlign = TextAlign.left,
      this.style = const TextStyle(color: Color(0xFF222222), fontSize: 14),
      this.labelWidth = 80})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: labelWidth,
            child: Text(
              label ?? '',
              style: TextStyle(color: Color(0xFF999999), fontSize: 14),
            ),
          ),
          Expanded(
              child: Text(
            (val != null && val != '') ? val : '-',
            style: style,
            textAlign: textAlign,
          ))
        ],
      ),
    );
  }
}

class InfoDivider extends StatelessWidget {
  final double height;

  const InfoDivider({
    Key key,
    this.height = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Color(0xFFE7E7E7),
      height: height,
      thickness: 0.5,
    );
  }
}

class InfoCard extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;

  const InfoCard(
      {Key key,
      this.child,
      this.padding = const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      this.margin = EdgeInsets.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
