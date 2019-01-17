import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';

final String defaultPicUrl =
    "https://gss0.baidu.com/7Po3dSag_xI4khGko9WTAnF6hhy/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg";

class ProductionProgressesPage extends StatefulWidget{
  final PurchaseOrderModel order;

  ProductionProgressesPage({Key key, @required this.order}) : super(key: key);

  _ProductionProgressesPageState createState() =>
      _ProductionProgressesPageState(order: order);
}

class _ProductionProgressesPageState extends State<ProductionProgressesPage> {
  DateTime _blDate;
  String _blNumber;
  TextEditingController dialogText;
  File _image;

  final PurchaseOrderModel order;

  _ProductionProgressesPageState({this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生产进度明细'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: _buildProgresses(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildProgresses(BuildContext context) {
    return ListView(children: _buildPurchaseProductionProgresses(context));
  }

  List<Widget> _buildPurchaseProductionProgresses(BuildContext context) {
    List<Widget> _list = new List();
    for (int i = 0; i < order.productionProgresses.length; i++) {
      _list.add(Container(
        child: _buildProductionProgress(context,
          order.productionProgresses[i],
          order.currentPhase.toString(),
        ),
      ));
    }
    return _list;
  }

  //TimeLineUI
  Widget _buildProductionProgress(BuildContext context,ProductionProgressModel progress,String currentPhase) {
    int _index = 0;
    String phase = '${progress.phase}';
    if (phase == currentPhase) {
      _index = progress.sequence;
    }
    return Stack(
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(left: 30.0), child: _buildProgressTimeLine(context,progress,currentPhase)),
        Positioned(
          top: 30.0,
          bottom: 0.0,
          left: 17.5,
          child: Container(
            height: double.infinity,
            width: 1.3,
            color: progress.sequence <= _index ? Colors.orangeAccent : Colors.black45,
          ),
        ),
        Positioned(
          top: 26.0,
          left: 10.0,
          child: Container(
            height: 16.0,
            width: 16.0,
            child: Container(
              margin: EdgeInsets.all(3.0),
              height: 16.0,
              width: 16.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: progress.sequence <= _index ? Colors.orange : Colors.black),
            ),
          ),
        )
      ],
    );
  }

//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(BuildContext context,ProductionProgressModel progress,String currentPhase) {
    String phase = '${progress.phase}';
    int _index = 0;
    if (phase == currentPhase) {
      _index = progress.sequence;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(ProductionProgressPhaseLocalizedMap[progress.phase],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: progress.sequence <= _index ? Colors.orange : Colors.black54,
                    fontSize: 18)),
            trailing: Text(
              '已延期2天',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: new Text('预计完成时间', style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child:
                        Text('${DateFormatUtil.format(progress.estimatedDate)}', style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.date_range),
                            onPressed: _showDatePicker
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text('实际完成时间', style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text('${DateFormatUtil.format(progress.finishDate)}', style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 48,
                          ))
                    ],
                  ),
                ],
              )),
          Align(
              alignment: Alignment.center,
              child: Container(
                height: 35,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('数量', style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('${progress.quantity}', style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: progress.sequence <= _index ? _showDialog : null,
                      ),
                    )
                  ],
                ),
              )),
          Align(
              alignment: Alignment.center,
              child: Container(
                height: 35,
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text('凭证', style: TextStyle(fontWeight: FontWeight.w500)),
                      flex: 4,
                    ),
                    Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.chevron_right),
                            onPressed: progress.sequence <= _index ? _getImage : null,
                          ),
                        )),
                  ],
                ),
              )),
          Container(padding: EdgeInsets.fromLTRB(20, 10, 10, 10), child: Attachments(
            list: progress.medias,
          )),
          Container(
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: Column(children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("备注"),
                ),
                Align(alignment: Alignment.centerLeft, child: Text(progress.remarks))
              ])),
          Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: phase == currentPhase
                  ? RaisedButton(
                color: Colors.orange,
                child: Text(
                  '验货完成',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              )
                  : null)
        ],
      ),
    );
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


class PurchaseVoucherPic extends StatelessWidget {
  final ProductionProgressModel progressModel;

  @override
  PurchaseVoucherPic(this.progressModel);

  @override
  Widget build(BuildContext context) {
    return _buildPicRow(context);
  }

  Widget _buildPicRow(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                '附件',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ],
          ),
          Attachments(
            list: progressModel.medias,
          )
        ],
      ),
    );
  }

//构造凭证横向图片UI
//  List<Widget> _buildPicList(BuildContext context) {
//    List<Widget> _listPic = new List();
//    int mediasNumber = 4;
//    if (progressModel.medias.length < 4) {
//      mediasNumber = progressModel.medias.length;
//    }
//    for (int i = 0; i < mediasNumber; i++) {
//      _listPic.add(Expanded(
//        child: Image.network(
//          progressModel.medias[i] == null ? defaultPicUrl : progressModel.medias[i],
//          width: 50,
//          height: 50,
//          fit: BoxFit.scaleDown,
//        ),
//      ));
//    }
//    if (_listPic.length < 4) {
//      for (int i = 0; i <= 4 - _listPic.length; i++) {
//        _listPic.add(Expanded(
//          child: Image.network(
//            defaultPicUrl,
//            width: 50,
//            height: 50,
//            fit: BoxFit.scaleDown,
//          ),
//        ));
//      }
//    }
//    return _listPic;
//  }
}
