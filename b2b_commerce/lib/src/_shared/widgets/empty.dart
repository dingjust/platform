import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child: Column(
          children: [
            Image.asset(
              'temp/empty-image-search.png',
              package: 'assets',
              fit: BoxFit.fitWidth,
            ),
            Text(
              '没找到相关内容',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )
          ],
        )));
  }
}
