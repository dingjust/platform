import 'package:flutter/material.dart';
//星级
class Stars extends StatelessWidget {
  const Stars({Key key, this.starLevel = 1, this.color = Colors.orange})
      : super(key: key);

  final int starLevel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int i = 0; i < starLevel; i++) {
      stars.add(Container(
        padding: EdgeInsets.fromLTRB(1, 2, 1, 2),
        child: Icon(
          Icons.star,
          color: color,
        ),
      ));
    }

    return Container(
      child: Row(
        children: stars,
      ),
    );
  }
}
