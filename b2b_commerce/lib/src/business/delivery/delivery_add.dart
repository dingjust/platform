import 'package:flutter/material.dart';

class DeliveryAddPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('新建运费'),
      ),
      body: _buildMain(context),
    );
  }

  Widget _buildAddress(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60.0,
      decoration: new BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(color: Color(0xFFC8C8C8), width: 1.0)
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1.0),
            ),
            labelText: '地区',
            labelStyle: TextStyle(
                color: Colors.black,
                fontSize: 17.0
            ),
            suffixIcon: Icon(Icons.chevron_right,color: Color(0xFFC8C8C8),)
        ),
      ),
    );
  }

  Widget _buildMain(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        children: <Widget>[
          _buildAddress(context),
          Container(
            alignment: Alignment.center,
            height: 60.0,
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Color(0xFFC8C8C8), width: 1.0)
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1.0),
                ),
                labelText: '起步价',
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 60.0,
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Color(0xFFC8C8C8), width: 1.0)
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1.0),
                ),
                labelText: '首重',
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 60.0,
            decoration: new BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Color(0xFFC8C8C8), width: 1.0)
              ),
            ),
            child: TextField(
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC8C8C8), width: 1.0),
                ),
                labelText: '续重价',
                labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15.0, 60.0, 15.0, 0),
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '确认',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xFFFF9516),
              borderRadius: BorderRadius.all(
                Radius.circular(40.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}