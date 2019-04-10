import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProductionProgressesPage extends StatefulWidget{
  PurchaseOrderModel order;

  ProductionProgressesPage({Key key, @required this.order}) : super(key: key);

  _ProductionProgressesPageState createState() =>
      _ProductionProgressesPageState(order: order);
}

class _ProductionProgressesPageState extends State<ProductionProgressesPage> {
  DateTime _blDate;
  String _blNumber;
  TextEditingController dialogText;
  FocusNode _dialogFocusNode;
  String userType;
  PurchaseOrderModel order;
  String phase;
  String remarks;
  DateTime nowTime;

  _ProductionProgressesPageState({this.order});

  @override
  void initState() {
    nowTime = DateTime.now();
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
//        actions: <Widget>[
//          Container(
//            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
//            child: Center(
//              child: Text(
//                '${ProductionProgressPhaseLocalizedMap[order.currentPhase]}',
//                style: TextStyle(
//                  color: Color(0xFFFFD600),
//                  fontWeight: FontWeight.w500,
//                ),
//              ),
//            ),
//          ),
//        ],
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: _buildProgresses(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildProgresses(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: ListView(
        children:
      _buildPurchaseProductionProgresses(context),
      ),
    );
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
    _list.add(Container(
      padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
      child: Center(
        child: Text(
          "(￢_￢)已经到底了",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    ));
    return _list;
  }

  //TimeLineUI
  Widget _buildProductionProgress(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index) {
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
            color: sequence == _index ? Color(0xFFFFD600) : Colors.black45,
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
                  color: sequence == _index ? Color(0xFFFFD600) : Colors.black
              ),
            ),
          ),
        )
      ],
    );
  }

//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index) {
    phase = ProductionProgressPhaseLocalizedMap[progress.phase];
    return Container(
//      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text('${ProductionProgressPhaseLocalizedMap[progress.phase]} ${sequence == _index   && order.status == PurchaseOrderStatus.IN_PRODUCTION ?'（当前进行中）':''}' ,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: sequence == _index ? Color(0xFFFFD600) : Colors.black54,
                          fontSize: 18)
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    '${progress.delayedDays >0 ? '已延期${progress.delayedDays}天': '' }',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      sequence < _index || (order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE &&
                          phase == currentPhase &&
                          currentPhase == ProductionProgressPhaseLocalizedMap[ProductionProgressPhase.INSPECTION])?
                      _buildFinishDate(context,progress,currentPhase,sequence,_index):
                      _buildEstimatedDate(context,progress,currentPhase,sequence,_index),
                      _buildQuantity(context,progress,currentPhase,sequence,_index),
                      _buildRemarks(context,progress,currentPhase,sequence,_index),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0,10,15,0),
                  padding: EdgeInsets.fromLTRB(0,10, 15,0),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image:  progress.medias == null || progress.medias.isEmpty?
                        AssetImage(
                          'temp/picture.png',
                          package: "assets",
                        ):
                        NetworkImage('${progress.medias[0].actualUrl}'),
                        fit: BoxFit.fill,
                      )),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PicturePickPreviewWidget(
                        medias: progress.medias,
                        isUpload: userType != null && userType == 'factory' && (sequence >= _index)  && order.status == PurchaseOrderStatus.IN_PRODUCTION? true : false,
                      ))
                  ).then((value){
                    if(value != null){
                      progress.medias = value;
                      progress.updateOnly = true;
                      uploadPicture(progress);
                    }
                  });
                },
              ),
            ],
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: phase == currentPhase && progress.finishDate == null && userType != null && userType == 'factory'
                  ? RaisedButton(
                color: Color(0xFFFFD600),
                child: Text('${ProductionProgressPhaseLocalizedMap[progress.phase]}完成',
                  style: TextStyle(color: Colors.black),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  if((phase == currentPhase) && (progress.phase == ProductionProgressPhase.INSPECTION) && order.salesApplication == SalesApplication.ONLINE){
                    _showBalanceDialog(context, order);
                  }else{
                    _showTipsDialog(progress);
                  }
                },
              )
                  : null)
        ],
      ),
    );
  }

  Widget _buildEstimatedDate(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index){
    return Container(
      height: 30,
      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
                child: Text('预计完成时间',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  userType != null && userType == 'factory' && (sequence >= _index)  && order.status == PurchaseOrderStatus.IN_PRODUCTION?
                  _showDatePicker(progress) : null;
                }),
          ),
          GestureDetector(
              child:Container(
                padding: EdgeInsets.only(right: 15),
                child: Align(
                  alignment: Alignment.centerRight,
                  child:
                  progress.estimatedDate == null? Container():
                  Text('${DateFormatUtil.formatYMD(
                      progress.estimatedDate)}',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
              ),
              onTap: () {
                userType != null && userType == 'factory' && (sequence >= _index)  && order.status == PurchaseOrderStatus.IN_PRODUCTION?
                _showDatePicker(progress) : null;
              }),
          progress.estimatedDate == null?
          Align(
            alignment: Alignment.centerRight,
            child: userType=='brand'?Container():IconButton(
                icon: Icon(Icons.date_range),
                onPressed: () {
                  userType != null && userType == 'factory' && (sequence >= _index)  && order.status == PurchaseOrderStatus.IN_PRODUCTION?
                  _showDatePicker(progress) : null;
                }
            ),
          ):Container()
        ],
      ),
    );
  }

  Widget _buildFinishDate(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index){
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text('实际完成时间', style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child:
            progress.finishDate == null ? Container() :
            Text('${DateFormatUtil.formatYMD(progress.finishDate)}',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantity(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index){
    return Container(
      child: Container(
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                      child: Text('数量',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      onTap: () {
                        userType != null && userType == 'factory' && (sequence >= _index )  && order.status == PurchaseOrderStatus.IN_PRODUCTION?
                        _showDialog(progress,'数量'): null;
                      }),
                ),
                GestureDetector(
                    child: Container(
                      padding:  EdgeInsets.only(right: 15),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('${progress.quantity}',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                    ),
                    onTap: () {
                      userType != null && userType == 'factory' && (sequence >= _index )  && order.status == PurchaseOrderStatus.IN_PRODUCTION?
                      _showDialog(progress,'数量')
                          : null;
                    }
                ),
                progress.quantity == null || progress.quantity ==''?
                Align(
                  alignment: Alignment.centerRight,
                  child: userType=='brand'?Container():IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: (){
                        userType != null && userType == 'factory' && (sequence >= _index )  && order.status == PurchaseOrderStatus.IN_PRODUCTION?
                        _showDialog(progress,'数量') : null;
                      }
                  ),
                ):Container()
              ],
            ),
          ),
    );
  }

  Widget _buildRemarks(BuildContext context,ProductionProgressModel progress,String currentPhase,int sequence,int _index){
    return Container(
      child: GestureDetector(
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Row(
                children: <Widget>[
                  Text('备注', style: TextStyle(fontWeight: FontWeight.w500)),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: progress.remarks == null?
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${userType=='brand'? '':'填写'}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ):
                          Container(
                            child: Text(
                              '${progress.remarks}',
                              softWrap: true,
                            ),
                          )
                      ),
                    ),
                  )
                ])
        ),
        onTap: () async {
          userType != null && userType == 'factory' && (sequence >= _index) && order.status == PurchaseOrderStatus.IN_PRODUCTION?
          _showRemarksDialog(progress,'备注','${progress.remarks}') : null;
        },
      )
    );
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context,ProductionProgressModel model) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: nowTime,
        lastDate: new DateTime(2999)
    );

    if(_picked != null){
      model.estimatedDate = _picked;
      try{
        model.updateOnly = true;
        await PurchaseOrderRepository().productionProgressUpload(order.code,model.id.toString(),model);
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
          title: Text('提示',
            style: TextStyle(
              fontSize: 16,
            ),),
          content: Text('当前阶段是否完成？'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                  '取消',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                  '确定',
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              onPressed: () async {
                bool result;
                try {
                  model.updateOnly = false;
                  result = await PurchaseOrderRepository().productionProgressUpload(
                  order.code, model.id.toString(), model);
                } catch (e) {
                print(e);
                }
                Navigator.of(context).pop();
                _showMessage(context,result);
              },
            ),
          ],
        );
      },
    );
  }


//生成Dialog控件
  Future<void> _neverSatisfied(BuildContext context,ProductionProgressModel model,String type) async {
    dialogText = TextEditingController();
    _dialogFocusNode = FocusNode();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入${type}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFieldComponent(
                  textAlign: TextAlign.left,
                  focusNode: _dialogFocusNode,
                  controller: dialogText,
                  autofocus: true,
                  inputType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                  '取消',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                  '确定',
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              onPressed: () async {
                bool result = false;
                if(dialogText.text != null){
                  print(dialogText.text);
                  if(dialogText != null && dialogText.text != '') {
                    model.quantity = int.parse(dialogText.text);
                  }
                  try {
                    model.updateOnly = true;
                   result =  await PurchaseOrderRepository().productionProgressUpload(
                        order.code, model.id.toString(), model);
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

  Future<void> _neverRemarks(BuildContext context,ProductionProgressModel model,String type,String remarks) async {
    dialogText = TextEditingController();
    print(remarks);
    _dialogFocusNode = FocusNode();
    if(remarks!= null){
      dialogText.text = remarks;
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入${type}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFieldComponent(
                  textAlign: TextAlign.left,
                  focusNode: _dialogFocusNode,
                  controller: dialogText,
                  autofocus: true,
                  inputType: TextInputType.text,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '取消',
                style: TextStyle(
                    color: Colors.grey
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                  '确定',
                style: TextStyle(
                    color: Colors.black
                ),
              ),
              onPressed: () async {
                bool result = false;
                if(dialogText.text != null){
                  model.remarks = dialogText.text;
                  try {
                    model.updateOnly = true;
                    result =  await PurchaseOrderRepository().productionProgressUpload(
                        order.code, model.id.toString(), model);
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
  void _showDialog(ProductionProgressModel model,String type){
    _neverSatisfied(context,model,type);
  }

  void uploadPicture(ProductionProgressModel model) async{
    await PurchaseOrderRepository().productionProgressUpload(order.code,model.id.toString(),model);
  }

  //备注输入框
  void _showRemarksDialog(ProductionProgressModel model,String type,String remakrs){
    _neverRemarks(context,model,type,remakrs);
  }

//确认是否完成动作
  void _showTipsDialog(ProductionProgressModel model){
    _neverComplete(context,model);
  }

  void _showMessage(BuildContext context,bool result) async{
    if(result){
      _requestMessage(context,'操作成功');
    }else{
      _requestMessage(context,'操作失败');
    }
    ProductionBLoC.instance.refreshData();
  }

//  Future<void> _requestMessage(BuildContext context,String message) async {
//    return showDialog<void>(
//      context: context,
//      barrierDismissible: true, // user must tap button!
//      builder: (context) {
//        return SimpleDialog(
//          title: const Text('提示'),
//          children: <Widget>[
//            SimpleDialogOption(
//              child: Text('${message}'),
//            ),
//          ],
//        );
//      },
//    );
//  }

  Future<void> _requestMessage(BuildContext context,String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示',
            style: TextStyle(
              fontSize: 16,
            ),),
          content: SingleChildScrollView(
              child: Text(
                '${message}',
                style: TextStyle(
                  fontSize: 16,
                ),
              )
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('确定',style: TextStyle(color: Colors.black),),
              onPressed: () async {
                order = await PurchaseOrderRepository().getPurchaseOrderDetail(order.code);
                setState(() {
                  phase = ProductionProgressPhaseLocalizedMap[order.currentPhase];
                });
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        ProductionProgressesPage(order: order)
                    ), ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }

  //打开修改尾款金额弹框
  void _showBalanceDialog(BuildContext context,PurchaseOrderModel model){
    _neverUpdateBalance(context,model);
  }

  //修改金额按钮方法
  Future<void> _neverUpdateBalance(BuildContext context,PurchaseOrderModel model) async {
    TextEditingController dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示',
            style: TextStyle(
              fontSize: 16,
            ),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '订单总额：￥${model.totalPrice}',
                ),
                Text(
                  '已付定金：￥${model.deposit}',
                ),
                Text(
                  '应付尾款：￥${model.totalPrice != null && model.deposit != null ? model.totalPrice-model.deposit : ''}',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller:dialogText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '请输入尾款',
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(right: 30),
                  width: 230,
                  child: FlatButton(
                      color: Color(0xFFFFD600),
                      child: Text(
                        '确定',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(20))),
                      onPressed: () async {
                        bool result = false;
                        print(dialogText.text);
                        if (dialogText.text != null && dialogText.text != '') {
                          double balance = double.parse(dialogText.text);
                          model.balance = balance;
                          model.skipPayBalance = false;
                          try {
                            result =  await PurchaseOrderRepository()
                                .purchaseOrderBalanceUpdate(model.code, model);
                          } catch (e) {
                            print(e);
                          }
                          if(result) {
                            if (model.status ==
                                PurchaseOrderStatus.IN_PRODUCTION) {
                              try {
                                for (int i = 0; i < order.progresses.length; i++) {
                                  if (order.currentPhase == order.progresses[i].phase) {
                                    result = await PurchaseOrderRepository() .productionProgressUpload(order.code,
                                        order.progresses[i].id.toString(),
                                        order.progresses[i]);
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                          }
                          Navigator.of(context).pop();
                          _showMessage(context, result);
                        }

                      }
                  ),
                ),
                FlatButton(
                  child: Text(
                    '无需付款直接跳过>>',
                    style: TextStyle(
                        color: Colors.grey
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showTips(context,model);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _showTips(BuildContext context,PurchaseOrderModel model){
    _neverJump(context,model);
  }

  //确认跳过按钮
  Future<void> _neverJump(BuildContext context,PurchaseOrderModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('提示',
            style: TextStyle(
              fontSize: 16,
            ),),
          content: Text('是否无需付款直接跳过？'),
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
                bool result = false;
                model.balance = 0;
                model.skipPayBalance = true;
                try {
                  await PurchaseOrderRepository().purchaseOrderBalanceUpdate(model.code , model);
                  if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
                    try {
                      for(int i=0;i<order.progresses.length;i++){
                        if(order.currentPhase == order.progresses[i].phase){
                          result = await PurchaseOrderRepository().productionProgressUpload(order.code,order.progresses[i].id.toString(),order.progresses[i]);
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                } catch (e) {
                  print(e);
                }
                Navigator.of(context).pop();
                _showMessage(context,result);
              },
            ),
          ],
        );
      },
    );
  }

}

