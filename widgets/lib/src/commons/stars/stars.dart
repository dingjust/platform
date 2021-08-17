import 'package:flutter/material.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';

//星级
class Stars extends StatelessWidget {
  const Stars(
      {Key? key,
      this.starLevel = 1,
      this.color = const Color.fromRGBO(255, 214, 12, 1),
      this.highlightOnly = true,
      this.size = 20})
      : super(key: key);

  final int starLevel;
  final Color color;
  final double size;

  //是否只显示亮的星
  final bool highlightOnly;

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int i = 0; i < starLevel; i++) {
      stars.add(Container(
        padding: EdgeInsets.fromLTRB(3, 2, 3, 2),
        child: Icon(
          B2BIcons.star,
          color: color,
          size: size,
        ),
      ));
    }

    if (!highlightOnly) {
      for (int i = 0; i < 5 - starLevel; i++) {
        stars.add(Container(
          padding: EdgeInsets.fromLTRB(3, 2, 3, 2),
          child: Icon(
            B2BIcons.star,
            color: Colors.grey[300],
            size: size,
          ),
        ));
      }
    }

    return Container(
      child: Row(
        children: stars,
      ),
    );
  }
}

class StarsRating extends StatefulWidget {
  int starRate;

  int maxRate;

  final Color color;
  final double size;

  final ValueChanged<int>? onChanged;

  StarsRating(
      {this.starRate = 1,
      this.maxRate = 5,
      this.color = const Color.fromRGBO(255, 214, 12, 1),
      this.size = 20,
      this.onChanged});

  @override
  _StarsRatingState createState() => _StarsRatingState();
}

class _StarsRatingState extends State<StarsRating> {
  void _handleTap(int value) {
    widget.onChanged!(value);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];

    for (int i = 0; i < widget.maxRate; i++) {
      stars.add(GestureDetector(
        onTap: () {
          _handleTap(i + 1);
          setState(() {
            widget.starRate = i + 1;
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
          child: Icon(
            B2BIcons.star,
            color: i + 1 <= widget.starRate ? widget.color : Colors.grey[300],
            size: widget.size,
          ),
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
