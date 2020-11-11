import 'package:flutter/material.dart';

///生产进度工单
class ProductionProgressPage extends StatefulWidget {
  @override
  _ProductionProgressPageState createState() => _ProductionProgressPageState();
}

class _ProductionProgressPageState extends State<ProductionProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生产进度'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
