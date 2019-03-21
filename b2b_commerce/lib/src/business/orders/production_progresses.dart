import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

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
  String userType;
  final PurchaseOrderModel order;

  _ProductionProgressesPageState({this.order});

  @override
  void initState() {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    if(bloc.isBrandUser){
      userType = 'brand';
    }else{
      userType = 'factory';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
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
    int _index = 0;
    for(int i =0; i< order.progresses.length; i++){
      if (ProductionProgressPhaseLocalizedMap[order.progresses[i].phase] == ProductionProgressPhaseLocalizedMap[order.currentPhase]) {
        _index = order.progresses[i].sequence;
      }
    }
    for (int i = 0; i < order.progresses.length; i++) {
      _list.add(Container(
        child: _buildProductionProgress(context,
          order.progresses[i],
            ProductionProgressPhaseLocalizedMap[order.currentPhase],
            order.progresses[i].sequence,_index
        ),
      ));
    }
    return _list;
  }

  //TimeLineUI
  Widget _buildProductionProgress(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index) {
//    String phase = progress.phase.toString();
//    if (phase == currentPhase) {
//      _index = progress.sequence;
//    }
    return Stack(
      children: <Widget>[
        Padding(padding: const EdgeInsets.only(left: 30.0),
            child: _buildProgressTimeLine(context,progress,currentPhase,sequence,_index)),
        Positioned(
          top: 30.0,
          bottom: 0.0,
          left: 17.5,
          child: Container(
            height: double.infinity,
            width: 1.3,
            color: sequence <= _index ? Color(0xFFFFD600) : Colors.black45,
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
                  color: sequence <= _index ? Color(0xFFFFD600) : Colors.black
              ),
            ),
          ),
        )
      ],
    );
  }

//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index) {
    String phase = ProductionProgressPhaseLocalizedMap[progress.phase];
//    int _index = 0;
//    if (phase == currentPhase) {
//      _index = progress.sequence;
//    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(ProductionProgressPhaseLocalizedMap[progress.phase],
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: sequence <= _index ? Color(0xFFFFD600) : Colors.black54,
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
                              userType != null && userType == 'factory' && (sequence > _index || phase == currentPhase) ?
                              _showDatePicker(progress) : null;
                            }),
                      ),
                      GestureDetector(
                          child:Align(
                            alignment: Alignment.centerRight,
                            child:
                            progress.estimatedDate == null? Container():
                            Text('${DateFormatUtil.formatYMD(
                                progress.estimatedDate)}',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ),
                          onTap: () {
                            userType != null && userType == 'factory' && (sequence > _index || phase == currentPhase) ?
                            _showDatePicker(progress) : null;
                          }),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () {
                              userType != null && userType == 'factory' && (sequence > _index || phase == currentPhase) ?
                              _showDatePicker(progress) : null;
                            }
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
                        child:
                        progress.finishDate == null ? Container() :
                        Text('${DateFormatUtil.formatYMD(progress.finishDate)}',
                            style: TextStyle(fontWeight: FontWeight.w500)),
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
                            userType != null && userType == 'factory' && (sequence > _index || phase == currentPhase) ?
                            _showDialog(progress): null;
                          }),
                    ),
                    GestureDetector(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('${progress.quantity}',
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ),
                        onTap: () {
                          userType != null && userType == 'factory' && (sequence > _index || phase == currentPhase) ?
                              _showDialog(progress)
                              : null;
                        }
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: (){
                          userType != null && userType == 'factory' && (sequence > _index || phase == currentPhase) ?
                          _showDialog(progress) : null;
                        }
                      ),
                    )
                  ],
                ),
              )),
          Align(
              alignment: Alignment.center,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          '凭证',
                        )
                      ],
                    ),
                    userType == 'factory' ?
                    EditableAttachments(list: progress.medias)
                        : Attachments(list: progress.medias)
                  ],
                ),
              )
          ),
          Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: phase == currentPhase && progress.finishDate == null
                  ? RaisedButton(
                color: Color(0xFFFFD600),
                child: Text(progress.phase == ProductionProgressPhase.INSPECTION ?'验货完成' : '完成',
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  progress.phase == ProductionProgressPhase.INSPECTION?
                  _showTipsDialog(progress):null;
                },
              )
                  : null)
        ],
      ),
    );
  }


  //生成日期选择器
  Future<Null> _selectDate(BuildContext context,ProductionProgressModel model) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999)
    );

    if(_picked != null){
      model.estimatedDate = _picked;
      try{
        await PurchaseOrderRepository().productionProgressUpload(widget.order.code,model.id.toString(),model);
      }catch(e){
        print(e);
      }
      setState(() {
        _blDate = _picked;
      });
    }
  }


  //确认完成按钮方法
  Future<void> _neverComplete(BuildContext context,ProductionProgressModel model) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('当前阶段是否完成？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                try {
                  await PurchaseOrderRepository().productionProgressUpload(
                  widget.order.code, model.id.toString(), model);
                } catch (e) {
                print(e);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


//生成Dialog控件
  Future<void> _neverSatisfied(BuildContext context,ProductionProgressModel model) async {
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
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                if(dialogText.text != null){
                  print(dialogText.text);
                  if(dialogText != null && dialogText.text != '') {
                    model.quantity = int.parse(dialogText.text);
                  }
                  try {
                    await PurchaseOrderRepository().productionProgressUpload(
                        widget.order.code, model.id.toString(), model);
                  } catch (e) {
                    print(e);
                  }
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
  void _showDatePicker(ProductionProgressModel model) {
    _selectDate(context,model);
  }
//打开数量输入弹框
  void _showDialog(ProductionProgressModel model){
    _neverSatisfied(context,model);
  }

  Future<void> _neverRemarksSatisfied(BuildContext context,ProductionProgressModel model) async {
    dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入备注'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller:dialogText,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                if(dialogText.text != null){
                  print(dialogText.text);
                  if(dialogText != null && dialogText.text != '') {
                    model.remarks = dialogText.text;
                  }
                  try {
                    await PurchaseOrderRepository().productionProgressUpload(
                        widget.order.code, model.id.toString(), model);
                  } catch (e) {
                    print(e);
                  }
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

//确认是否完成动作
  void _showTipsDialog(ProductionProgressModel model){
    _neverComplete(context,model);
  }

  void _showRemarksDialog(ProductionProgressModel model){
    _neverRemarksSatisfied(context,model);
  }

}

