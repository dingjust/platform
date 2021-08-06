import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';

class HomeBroadcast extends StatefulWidget {
  const HomeBroadcast({Key key}) : super(key: key);

  @override
  _HomeBroadcastState createState() => _HomeBroadcastState();
}

class _HomeBroadcastState extends State<HomeBroadcast> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 12),
            child: B2BV2Image.notice(width: 18, height: 16),
          ),
          Expanded(
              child: Text(
            '钉单看款做货，原创版衣快速生产就在钉单',
            style: TextStyle(
                color: Color(0xff666666),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ))
        ],
      ),
    );
  }
}
