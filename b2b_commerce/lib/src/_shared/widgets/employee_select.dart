import 'package:flutter/material.dart';

///员工选择
class EmployeeSelectPage extends StatefulWidget {
  ///多选
  bool multi;

  EmployeeSelectPage({Key key, this.multi = false}) : super(key: key);

  @override
  _EmployeeSelectPageState createState() => _EmployeeSelectPageState();
}

class _EmployeeSelectPageState extends State<EmployeeSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('人员选择'),
        elevation: 0.5,
      ),
      body: Column(children: [_buildHeader(), _buildBody()]),
      bottomSheet: _buildBottom(),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        children: [Text('公司')],
      ),
    );
  }

  Widget _buildBody() {
    return Expanded(
        child: Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 10),
      child: ListView(),
    ));
  }

  Widget _buildBottom() {
    return widget.multi
        ? Container(
            height: 45,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey[300], width: 0.5))),
          )
        : Container(
            height: 0,
          );
  }
}
