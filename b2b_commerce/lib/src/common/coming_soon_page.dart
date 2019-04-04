import 'package:flutter/material.dart';

class ComingSoonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('敬请期待'),
      ),
      body: Container(
        child: Center(
          child: Text(
            '功能完善中，敬请期待',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
