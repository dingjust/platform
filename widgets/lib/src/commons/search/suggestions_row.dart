import 'package:flutter/material.dart';
import 'package:widgets/src/commons/icon/b2b_commerce_icons.dart';

class SuggestionsRow extends StatelessWidget {
  SuggestionsRow(
      {Key key,
      this.value,
      @required this.onIconPressed,
      @required this.onTap,
      this.address,
      this.location})
      : super(key: key);

  final String value;

  final String address;

  final String location;

  final VoidCallback onIconPressed;

  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${value}',
                      style: TextStyle(color: Colors.black, fontSize: 17),
                      // overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${address}',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(100, 100, 100, 1)),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
            IconButton(
              icon: Icon(
                B2BIcons.arrow_left_bottom,
                color: Color.fromRGBO(100, 100, 100, 1),
              ),
              onPressed: onIconPressed,
            )
          ],
        ),
      ),
    );
  }
}
