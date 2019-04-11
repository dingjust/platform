import 'package:flutter/material.dart';

class BroadcastFactory {
  static Widget buildBroadcast(String tips) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
      color: Color.fromRGBO(246, 247, 249, 1),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.volume_up,
              color: Color.fromRGBO(150, 150, 150, 1),
            ),
          ),
          Text(
            tips,
            style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
          ),
        ],
      ),
    );
  }
}
