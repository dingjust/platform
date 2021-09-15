import 'package:flutter/material.dart';

class InfoTitle extends StatelessWidget {
  final String val;

  const InfoTitle(this.val);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [
        Text(
          '$val',
          style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
      ],
    ));
  }
}

class InfoRow extends StatelessWidget {
  final String label;

  final String val;

  const InfoRow({Key key, this.label, this.val}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            child: Text(
              label ?? '',
              style: TextStyle(color: Color(0xFF999999), fontSize: 14),
            ),
          ),
          Expanded(
              child: Text(
            (val != null && val != '') ? val : '-',
            style: TextStyle(color: Color(0xFF222222), fontSize: 14),
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
