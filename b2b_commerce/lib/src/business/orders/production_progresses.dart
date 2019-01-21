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
          i
        ),
      ));
    }
    return _list;
  }

  //TimeLineUI
  Widget _buildProductionProgress(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence) {
    int _index = 0;
    String phase = progress.phase.toString();
    if (phase == currentPhase) {
      _index = progress.sequence;
    }
    return Stack(
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(left: 30.0), child: _buildProgressTimeLine(context,progress,currentPhase,sequence)),
        Positioned(
          top: 30.0,
          bottom: 0.0,
          left: 17.5,
          child: Container(
            height: double.infinity,
            width: 1.3,
            color: sequence <= _index ? Colors.orangeAccent : Colors.black45,
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
                  shape: BoxShape.circle,
                  color: sequence <= _index ? Colors.orange : Colors.black
              ),
            ),
          ),
        )
      ],
    );
  }

//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence) {
    String phase = progress.phase.toString();
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
                    color: sequence <= _index ? Colors.orange : Colors.black54,
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
                        child: GestureDetector(
                            child: Text('预计完成时间',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            onTap: () {
                              sequence > _index || phase == currentPhase ? _showDatePicker() : null;
                            }),
                      ),
                      GestureDetector(
                          child:Align(
                            alignment: Alignment.centerRight,
                            child:
                            Text('${DateFormatUtil.format(
                                progress.estimatedDate)}',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          onTap: () {
                            sequence > _index || phase == currentPhase ? _showDatePicker() : null;
                          }),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.date_range),
                            onPressed: sequence > _index || phase == currentPhase ? _showDatePicker:null
                        ),
                      )
                    ],
                  ),
                  sequence > _index || phase == currentPhase ?
                  Container() :
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
                      child: GestureDetector(
                          child: Text('数量',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          onTap: () {
                            sequence > _index || phase == currentPhase ? _showDialog(): null;
                          }),
                    ),
                    GestureDetector(
                        child:Align(
                          alignment: Alignment.centerRight,
                          child: Text('${progress.quantity}',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        onTap: () {
                          sequence > _index || phase == currentPhase ? _showDialog() : null;
                        }),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: sequence > _index || phase == currentPhase ? _showDialog : null,
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
                      child:GestureDetector(
                          child: Text('凭证',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          onTap: () {
                            sequence > _index || phase == currentPhase ? _selectPapersImages() : null;
                          }),
                      flex: 4,
                    ),
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
              child: phase == currentPhase &&
              (progress.phase == ProductionProgressPhase.SAMPLE_CONFIRM ||
                  progress.phase == ProductionProgressPhase.INSPECTION)
                  ? RaisedButton(
                color: Colors.orange,
                child: Text(
                  progress.phase == ProductionProgressPhase.SAMPLE_CONFIRM?
                  '样衣确认':'验货完成',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  progress.phase == ProductionProgressPhase.SAMPLE_CONFIRM?
                  _showTipsDialog('样衣确认'):_showTipsDialog('验货');
                },
              )
                  : null)
        ],
      ),
    );
  }

  void _selectPapersImages() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('相机'),
              onTap: () async {
                var image =
                await ImagePicker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  setState(() {
//                    widget.images.add(image);
                    Navigator.pop(context);
                  });
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('相册'),
              onTap: () async {
                var image =
                await ImagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
//                    widget.images.add(image);
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        );
      },
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


  //确认完成按钮方法
  Future<void> _neverComplete(BuildContext context,String progresses) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('是否'+progresses+'完成？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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

//打开日期选择器
  void _showDatePicker() {
    _selectDate(context);
  }
//打开数量输入弹框
  void _showDialog(){
    _neverSatisfied(context);
  }
//确认是否完成动作
  void _showTipsDialog(String progresses){
    _neverComplete(context,progresses);
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
