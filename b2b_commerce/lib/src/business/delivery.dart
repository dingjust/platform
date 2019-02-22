import 'package:flutter/material.dart';
import 'delivery/delivery_add.dart';

class DeliveryPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('运费模板'),
      ),
      body: Container(
        color: Color(0xFFF5F5F5),
        child: Column(
          children: <Widget>[
            _buildAddress(context),
            _buildMain(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAddress(BuildContext context) {
    return Container(
      color: Color(0xFFFAFAFA),
      child: ListTile(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryAddPage(),
            ),
          );
        },
        title: Text(
          '新建模板',
          style: TextStyle(fontSize: 17.0),
        ),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildMain(BuildContext context) {
    return Container(
      color: Color(0xFFFAFAFA),
      margin: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
      child: Column(
        children: <Widget>[
          Text(
            '已有模板',
            style: TextStyle(fontSize: 16.0,color: Color(0xFFFF9516),),
          ),
          Container(
            height: 20.0,
          ),
          _buildListItem(context)
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Table(
          border: TableBorder.all(width: 1.0,color: Colors.transparent),
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                TableCell(child: Container(
                  color: Color(0xFFEEEEEE),
                  alignment: Alignment.center,
                  child: Text(
                    '地区',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                  ),
                  height: 40.0,
                )),
                TableCell(child: Container(
                  color: Color(0xFFEEEEEE),
                  alignment: Alignment.center,
                  child: Text(
                    '起步价(元)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                  ),
                  height: 40.0,
                )),
                TableCell(child: Container(
                  color: Color(0xFFEEEEEE),
                  alignment: Alignment.center,
                  child: Text(
                    '首重(kg)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                  ),
                  height: 40.0,
                )),
                TableCell(child: Container(
                  color: Color(0xFFEEEEEE),
                  alignment: Alignment.center,
                  child: Text(
                    '续重价(元/kg)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                  ),
                  height: 40.0,
                )),
              ],
            ),
            TableRow(
              children: <Widget>[
                TableCell(child: Container(
                  color: Color(0xFFFAFAFA),
                  alignment: Alignment.center,
                  child: Text(
                    '广东',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                  ),
                  height: 40.0,
                )),
                TableCell(child: Container(
                  color: Color(0xFFFAFAFA),
                  alignment: Alignment.center,
                  child: Text(
                    '5',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                  ),
                  height: 40.0,
                )),
                TableCell(child: Container(
                  color: Color(0xFFFAFAFA),
                  alignment: Alignment.center,
                  child: Text(
                    '3',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                  ),
                  height: 40.0,
                )),
                TableCell(child: Container(
                  color: Color(0xFFFAFAFA),
                  alignment: Alignment.center,
                  child: Text(
                    '2',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                  ),
                  height: 40.0,
                )),
              ],
            ),
          ],
        ),
      ],
    );
  }
}