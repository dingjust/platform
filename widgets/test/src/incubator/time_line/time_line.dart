import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  DateTime _blDate;
  String _blNumber;
  TextEditingController dialogText;
  File _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical:20.0,
      ),
      child: ListView(
        children: <Widget>[
          Divider(
          ),
          _buildTimeLine('备料'),
          _buildTimeLine('样衣确认'),
          _buildTimeLine('裁剪'),
          _buildTimeLine('车缝'),
          _buildTimeLine('验货'),
          _buildTimeLine('发货'),
        ],
      ),
    );
  }

  /// handle new date selected event
  void handleNewDate(date) {}

  Widget _buildTimeLine(String message) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Card(
            margin: EdgeInsets.all(5.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
              width: double.infinity,
              child: new Card(
                margin: EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text(
                            message,
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
                      new Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child:Row(
                              children: <Widget>[
                                Expanded(
                                  child: new Text(
                                      '预计完成时间' ,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  flex: 4,
                                ),
                                Expanded(
                                  child: Align(
                                    alignment : Alignment.centerRight,
                                    child: new Text(
                                        _blDate == null ? '' : _blDate.toString().substring(0,_blDate.toString().lastIndexOf('-')+3),
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child:  IconButton(
                                        icon: Icon(Icons.date_range),
                                        onPressed: _showDatePicker,
                                      ),
                                    )
                                ),
                              ],
                            ),)
                      ),
                      new Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 35,
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child:Row(
                          children: <Widget>[
                            Expanded(
                              child: new Text(
                                  message+'数量' ,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.w500)),
                              flex: 4,
                            ),
                            Expanded(
                              child: Align(
                                alignment : Alignment.centerRight,
                                child: new Text(
                                    _blNumber == null ? '' : _blNumber ,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w500)),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(Icons.keyboard_arrow_right),
                                    onPressed:
                                    _showDialog,
                                  ),)
                            ),
                          ],
                        ),)
                      ),
                      new Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 35,
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child:Row(
                              children: <Widget>[
                                Expanded(
                                  child: new Text(
                                      message+'凭证',
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w500)),
                                  flex: 4,
                                ),
                                Expanded(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                        icon: Icon(Icons.chevron_right),
                                        onPressed: _getImage,
                                      ),
                                    )
                                ),
                              ],
                            ),)
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
                          ],
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ),
        ),
//        Positioned(
//          left: 0.0,
//          child: Container(
//            height: 55,
//            width: 110.0,
//            child: Text(message),
//          ),
//        ),
        Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 20.5,
          child: Container(
            height: double.infinity,
            width: 2.0,
            color: Colors.black26,
          ),
        ),
        Positioned(
          top: 8.0,
          left: 10.0,
          child: Container(
            height: 26.0,
            width: 26.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            child: Container(
              margin: EdgeInsets.all(3.0),
              height: 26.0,
              width: 26.0,
              decoration:
              BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white
              ),
            ),
          ),
        )
      ],
    );
  }


  //生成日期选择器
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime(2999)
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