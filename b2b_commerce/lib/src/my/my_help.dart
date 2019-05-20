import 'package:b2b_commerce/src/my/my_help_detail.dart';
import 'package:flutter/material.dart';

class MyHelpPage extends StatefulWidget {
  @override
  _MyHelpPageState createState() => _MyHelpPageState();
}

class _MyHelpPageState extends State<MyHelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: const Text('问题与帮助'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            HelpItem(
              value: '如何创建订单？',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyHelpDetailPage()));
              },
            ),
            HelpItem(
              value: '如何创建订单？',
              onPressed: () {},
            ),
            HelpItem(
              value: '如何创建订单？',
              onPressed: () {},
            ),
            HelpItem(
              value: '如何创建订单？',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class HelpItem extends StatelessWidget {
  final String value;

  final VoidCallback onPressed;

  const HelpItem({Key key, this.value, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: FlatButton(
        onPressed: onPressed,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${value}',
              style: TextStyle(fontSize: 16),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
