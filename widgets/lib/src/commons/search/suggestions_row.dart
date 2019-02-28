import 'package:flutter/material.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';

class SuggestionsRow extends StatelessWidget {
  SuggestionsRow(
      {Key key, this.value, @required this.onIconPressed, @required this.onTap})
      : super(key: key);

  final String value;

  final VoidCallback onIconPressed;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                value,
                style: TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              B2BIcons.arrow_left_bottom,
              color: Color.fromRGBO(100, 100, 100, 1),
            ),
            onPressed: onIconPressed,
          )
        ],
      ),
    );
  }
}
