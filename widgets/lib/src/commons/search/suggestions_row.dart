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
        margin: EdgeInsets.only(left: 45),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(width: 1, color: Color(0xffE7E7E7)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$value',
                      style: TextStyle(
                          color: Color(0xff222222),
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$address',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff666666),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
