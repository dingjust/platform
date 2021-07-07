import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  const Empty({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView(
          children: [
            Image.asset(
              'temp/empty-image-search.png',
              package: 'assets',
              width: 200,
              height: 200,
            ),
            Text(
              '没找到相关内容',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}
