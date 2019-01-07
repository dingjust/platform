import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductionDetailPage extends StatefulWidget {
  @override
  _ProductionDetailPage createState() => _ProductionDetailPage();
}

class _ProductionDetailPage extends State<ProductionDetailPage> {
  DateTime _blDate;
  String _blNumber;
  TextEditingController dialogText;
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: new Container(
                  width: 250,
                  height: 80,
                  child:
                  new Card(
                    child: new ListTile(
                      title: new Text('张三   13123456789',
                          style: new TextStyle(fontSize: 12)),
                      subtitle: new Text(
                        '广州市海珠区广州大道南401号',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  )),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.network(
                    'http://www.pptok.com/wp-content/uploads/2012/08/xunguang-4.jpg',
                    fit: BoxFit.cover,
                    height: 300,
                  ),
                  // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Card(
                  child: new Column(children: [
                    new Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text('订单编号：S20181224102141000007001',
                                style: new TextStyle(fontWeight: FontWeight.w500)),
                            flex: 5,
                          ),
                          Expanded(
                            child: new Text(
                                '待出库',
                                style: TextStyle(color: Colors.amber)
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text('生产单号：S20181224102141000007001',
                                style: new TextStyle(fontWeight: FontWeight.w500)),
                            flex: 5,
                          ),
                          Expanded(
                            child: new Text(
                                '裁剪中',
                                style: TextStyle(color: Colors.amber)
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child:
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text('创建订单时间  2019-01-03 11:48',
                                style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14
                                )
                            ),
                            flex: 5,
                          ),
                          Expanded(
                            child: new Text(
                                '已延期',
                                style: TextStyle(color: Colors.red)
                            ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    new Divider(),
                    new ListTile(
                      title: new Text('面包服摸摸摸摸董赛娇十分骄傲司法局阿松放假啊',
                          style: new TextStyle(fontWeight: FontWeight.w500)),
                      leading: new Image.network(
                        "http://img.duoziwang.com/2018/06/2018010144149418.jpg",
                        width: 80,
                      ),
                      subtitle: new Text('供应商编号：8MD13GO10096'),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductionDetailPage(),
                          ),
                        );
                      },
                    ),
                    new Divider(),
                    new ListTile(trailing: new Text("共24件商品")),
                  ]
                  )
              ),
              Card(
                  margin: EdgeInsets.symmetric(horizontal: 0,vertical: 5),
                  child: new Column(children: [
                    new ListTile(
                      title: new Text('生产进度',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                            fontSize: 16
                          )),
                    ),
                    new Divider(),
                    Card(
                        child: new Column(
                            children: [
                              new ListTile(
                                title: new Text('备料',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold
                                    )),
                                trailing: new Text(
                                  '已延期',
                                  style: new TextStyle(
                                    color: Colors.red
                                  ),
                                ),
                              ),
                              new Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(
                                          '预计完成时间',
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: new Text(
                                          _blDate == null ? '' : _blDate.toString().substring(0,_blDate.toString().lastIndexOf('-')+3),
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 4,
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.date_range),
                                        onPressed: _showDatePicker,
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(
                                          '备料数量' ,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: new Text(
                                          _blNumber == null ? '' : _blNumber ,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 4,
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.mode_edit),
                                        onPressed:
                                        _showDialog,
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(
                                          '备料凭证',
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 7,
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.add_photo_alternate),
                                        onPressed: _getImage,
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Image.network(
                                        "https://photo.16pic.com/00/08/36/16pic_836042_b.jpg",
                                        height: 50,
                                        width: 50,
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Image.network(
                                        "https://photo.16pic.com/00/08/36/16pic_836042_b.jpg",
                                        height: 50,
                                        width: 50,
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Image.network(
                                        "https://photo.16pic.com/00/08/36/16pic_836042_b.jpg",
                                        height: 50,
                                        width: 50,
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Image.network(
                                        "https://photo.16pic.com/00/08/36/16pic_836042_b.jpg",
                                        height: 50,
                                        width: 50,
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Image.network(
                                        "",
                                        height: 50,
                                        width: 50,
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        )
                    ),
                    Card(
                        child: new Column(
                            children: [
                              new ListTile(
                                title: new Text('产前样衣确认',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold
                                    )),
                                trailing: new Text(
                                  '',
                                  style: new TextStyle(
                                      color: Colors.red
                                  ),
                                ),
                              ),
                              new Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(
                                          '预计完成时间',
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: new Text(
                                          _blDate == null ? '' : _blDate.toString().substring(0,_blDate.toString().lastIndexOf('-')+3),
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 4,
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.date_range),
                                        onPressed: _showDatePicker,
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(
                                          '产前样衣确认数量' ,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: new Text(
                                          _blNumber == null ? '' : _blNumber ,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 4,
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.mode_edit),
                                        onPressed:
                                        _showDialog,
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(
                                          '产前样衣确认凭证',
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 7,
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.add_photo_alternate),
                                        onPressed: _showDatePicker,
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Image.network(
                                        "https://photo.16pic.com/00/08/36/16pic_836042_b.jpg",
                                        height: 50,
                                        width: 50,
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Image.network(
                                        "https://photo.16pic.com/00/08/36/16pic_836042_b.jpg",
                                        height: 50,
                                        width: 50,
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Image.network(
                                        "https://photo.16pic.com/00/08/36/16pic_836042_b.jpg",
                                        height: 50,
                                        width: 50,
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Image.network(
                                        "https://photo.16pic.com/00/08/36/16pic_836042_b.jpg",
                                        height: 50,
                                        width: 50,
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Image.network(
                                        "",
                                        height: 50,
                                        width: 50,
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        )
                    ),
                    Card(
                        child: new Column(
                            children: [
                              new ListTile(
                                title: new Text('订单信息',
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold
                                    )),
                                trailing: new Text(
                                  '',
                                  style: new TextStyle(
                                      color: Colors.red
                                  ),
                                ),
                              ),
                              new Container(
                                height: 20,
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(
                                          '订单编号',
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: new Text(
                                          "12346574897987897",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 4,
                                    ),
                                  ],
                                ),
                              ),
                              new Container(
                                height: 30,
                                padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(
                                          '创建时间' ,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 3,
                                    ),
                                    Expanded(
                                      child: new Text(
                                          "2019-01-03 16:00",
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      flex: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ]
                        )
                    ),
                  ]
                  )
              ),
            ]),
          ),
        ],
      ),
    );
  }

Widget _createRowView(){

}


//生成日期选择器
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999)
    );

    if(_picked != null){
      print(_picked);
      setState(() {
        _blDate = _picked;
      });
    }
  }

//生成Dialog控件
  Future<void> _neverSatisfied(BuildContext context) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入数量'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller:dialogText,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入数量',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if(dialogText.text != null){
                  print(dialogText.text);
                  setState(() {
                    _blNumber = dialogText.text;
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
//打开相册同步照片到页面上
  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }
//打开日期选择器
  void _showDatePicker() {
    _selectDate(context);
  }
//打开数量输入弹框
  void _showDialog(){
    _neverSatisfied(context);
  }

}
