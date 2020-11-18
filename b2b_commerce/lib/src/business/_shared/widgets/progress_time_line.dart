import 'package:bot_toast/bot_toast.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

enum ProgressState{
  BEFORE,
  CURRENT,
  AFTER
}

///进度工单显示
class ProgressTimeLine extends StatefulWidget {
  final ProgressWorkSheetModel model;

  //是否可操作
  final bool enableEdit;

  //刷新生产工单
  final VoidCallback onRefreshOrderData;

  const ProgressTimeLine({Key key, this.model,this.enableEdit = false,this.onRefreshOrderData}) : super(key: key);

  @override
  State createState() => _ProgressTimeLineState();

}

class _ProgressTimeLineState extends State<ProgressTimeLine>{
  Map<ProgressState,Color> _colorStateMap = {
    ProgressState.BEFORE:Colors.green,
    ProgressState.CURRENT:Colors.black,
    ProgressState.AFTER:Colors.grey,
  };

  bool _enableEdit = false;

  ProgressWorkSheetModel _model;


  @override
  void initState() {
    _enableEdit = widget.enableEdit;
    _model = ProgressWorkSheetModel.fromJson(ProgressWorkSheetModel.toJson(widget.model));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String companyCode = UserBLoC.instance.currentUser.companyCode;
    String belongToUid = _model.belongTo?.uid;
    if(belongToUid == null){
      belongToUid = _model.partyBCompany?.uid;
    }
    print(_model.productionTaskOrder);
    if(companyCode == belongToUid && _model.productionTaskOrder?.state == ProductionTaskOrderState.PRODUCING){
      _enableEdit = true;
    }

    return _buildPurchaseProductionProgresse(context);
  }


//构建生产进度UI
  Widget _buildPurchaseProductionProgresse(BuildContext context) {
    int _index = 0;
    return _model.progresses == null
        ? Container()
        : Container(
      padding: EdgeInsets.only(top:20, right: 15),
      child: Column(
        children: _model.progresses.map((e) {
          ProgressState _currentStatus = ProgressState.AFTER;
          if(ProgressWorkSheetStatus.COMPLETED == _model.status){
            _currentStatus = ProgressState.BEFORE;
          }else {
            if (_model.currentPhase != null && e.progressPhase != null) {
              if (_model.currentPhase.sequence > e.progressPhase.sequence) {
                _currentStatus = ProgressState.BEFORE;
              } else if (_model.currentPhase.sequence == e.progressPhase.sequence) {
                _currentStatus = ProgressState.CURRENT;
              }
            }
          }

          return _buildProductionProgress(context, _index++, _currentStatus);
        }).toList(),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //TimeLineUI
  Widget _buildProductionProgress(BuildContext context,
      int index, ProgressState currentStatus) {
    return Stack(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: _buildProgressTimeLine(
                context, index, currentStatus),
        ),
        Positioned(
          top: 3.0,
          bottom: 0.0,
          left: 17.5,
          child: Container(
            height: double.infinity,
            width: 1.3,
            color: _colorStateMap[currentStatus],
          ),
        ),
        Positioned(
          top: 0.0,
          left: 3.0,
          child:  ProgressState.BEFORE == currentStatus?
          Container(
            width: 30,
            decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(width: 2,color: Colors.green)),color: Colors.white),
            child: Center(child: Icon(Icons.done,size: 18,color: Colors.green,)),
          ): Container(
            width: 30,
            decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(width: 2,color: _colorStateMap[currentStatus])),color: Colors.white),
            child: Center(child: Text('${index+1}',style: TextStyle(color: _colorStateMap[currentStatus]),)),
          ),
        )
      ],
    );
  }

//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(BuildContext context,
      int index, ProgressState currentStatus) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
//            margin: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
//                _model.currentPhase.sequence > _model.progresses[index].sequence?
//                  Container(
//                    padding: EdgeInsets.symmetric(horizontal: 5),
//                    margin: EdgeInsets.symmetric(horizontal: 10),
//                    decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(width: 2,color: Colors.green)),color: Colors.white),
//                    child: Icon(Icons.done,size: 18,color: Colors.green,),
//                  ):
//                  Container(
//                    padding: EdgeInsets.symmetric(horizontal: 5),
//                    margin: EdgeInsets.symmetric(horizontal: 10),
//                    decoration: ShapeDecoration(shape: CircleBorder(side: BorderSide(width: 2)),color: Colors.white),
//                    child: Text('${index+1}'),
//                  ),
                Expanded(
                  child: Text(_model.progresses[index].progressPhase.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _colorStateMap[currentStatus],
                          fontSize: 18)),
                ),
                Opacity(
                  opacity: currentStatus != ProgressState.BEFORE ? 1 : 0,
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      '${_model.progresses[index].delayedDays > 0 ? '已延期${_model.progresses[index].delayedDays}天' : _model.progresses[index].delayedDays < 0 ? '倒计时${-_model.progresses[index].delayedDays}天' : ''}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
//              Container(
//                padding: const EdgeInsets.only(left: 10),
//                margin: EdgeInsets.symmetric(horizontal: 10),
//                child: Container(height:100,child: VerticalDivider(color: Colors.black,indent: 0,)),
//              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    _buildEstimatedDate(
                        context, _model.progresses[index], currentStatus),
                    _buildFinishDate(
                        context, _model.progresses[index], currentStatus),
//                    _buildQuantity(
//                        context, productionProgress, isCurrentStatus),
//                    _buildProgressRemarks(
//                        context, productionProgress, isCurrentStatus),
                  ],
                ),
              ),
              Opacity(
                opacity: _enableEdit && currentStatus == ProgressState.CURRENT ? 1 : 0,
                child: FlatButton(
                  onPressed: () async{
                    showConfirmDialog(false, message: '是否确认完成节点？', confirm: ()async {
                      BaseMsg msg = await ProgressOrderRepository().finishProgress(_model.code, _model.progresses[index].id);
                      if(msg != null ){
                          BotToast.showText(text: msg.msg);
                          //刷新进度工单数据
                          ProgressWorkSheetModel model = await ProgressWorkSheetRepository().detail(_model.code);
                          if(model != null){
                            setState((){
                              _model = model;
                              if(_model.status == ProgressWorkSheetStatus.COMPLETED){
                                widget.onRefreshOrderData();
                              }
                            });
                          }
                      }else{
                        BotToast.showText(text: "系统错误");
                      }
                    });

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('完成',style: TextStyle(color: Colors.white),),
                  ),
                  shape: CircleBorder(side: BorderSide(color: Colors.white)),
                  color: Color(0xffffd60c),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void uploadPicture(ProductionProgressModel model) async {
//    await PurchaseOrderRepository()
//        .productionProgressUpload(model.code, model.id.toString(), model);
  }

  Widget _buildEstimatedDate(BuildContext context,
      ProductionProgressModel progress, ProgressState currentStatus) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          GestureDetector(
              child: Text('预计完成时间：', style: TextStyle(color: _colorStateMap[currentStatus])),
              onTap: () {
//                    currentStatus == true &&
//                    _model.status == ProgressWorkSheetStatus.IN_PRODUCTION
//                    ? _showDatePicker(progress,context)
//                    : null;
              }),
          GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Text(
                    '${DateFormatUtil.formatYMD(progress.estimatedDate)}',
                    style: TextStyle(color: _colorStateMap[currentStatus])),
              ),
              onTap: () {
//                _enableEdit &&
//                    currentStatus == true &&
//                    _model.status == ProgressWorkSheetStatus.IN_PRODUCTION
//                    ? _showDatePicker(progress,context)
//                    : null;
              }),
        ],
      ),
    );
  }

  Widget _buildFinishDate(BuildContext context,
      ProductionProgressModel progress, ProgressState currentStatus) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Text('实际完成时间：', style: TextStyle(color: _colorStateMap[currentStatus])),
          Container(
            margin: EdgeInsets.only(left: 15),
            child: progress.finishDate == null
                ? Container()
                : Text('${DateFormatUtil.formatYMD(progress.finishDate)}',
                style: TextStyle(color: _colorStateMap[currentStatus])),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantity(BuildContext context, ProductionProgressModel progress,
      ProgressState currentStatus) {
    TextEditingController inputController = TextEditingController();
    inputController.text = progress.quantity.toString();

    return Container(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            GestureDetector(
                child: Text('数量', style: TextStyle()),
                onTap: () {
                  if(_enableEdit &&
                      _model.status == ProgressWorkSheetStatus.IN_PRODUCTION){
                    _showEditDialog(title: "填写数量",onConfirm: (){
                      setState(() {
                        ProductionProgressModel model = _model.progresses.firstWhere((element) => element.id == progress.id,orElse: ()=>null);
                        if(model != null){
                          model.quantity = int.parse(inputController.text == ''
                              ? '0'
                              : inputController.text);
                        }
                      });
                    });
                  }
                }),
            GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: progress.quantity == 0 || progress.quantity == null
                        ? Text('${_enableEdit ? '填写' : ''}',
                        style: TextStyle(
                          color: Colors.grey,
                        ))
                        : Text('${progress.quantity}', style: TextStyle()),
                  ),
                ),
                onTap: () {
                  _enableEdit &&
                      _model.status == ProgressWorkSheetStatus.IN_PRODUCTION
                      ? _showDialog(progress,context)
                      : null;
                }),
            progress.quantity == null || progress.quantity == ''
                ? Align(
              alignment: Alignment.centerRight,
              child: !_enableEdit
                  ? Container()
                  : IconButton(
                  icon: Icon(Icons.keyboard_arrow_right),
                  onPressed: () {
                    _enableEdit &&
                        _model.status ==
                            ProgressWorkSheetStatus.IN_PRODUCTION
                        ? _showDialog(progress,context)
                        : null;
                  }),
            )
                : Container()
          ],
        ),
      ),
    );
  }

  CancelFunc _showEditDialog({String title,Function onConfirm}) {
    return BotToast.showWidget(
                      toastBuilder: (cancelFunc) =>  Center(
                        child: AlertDialog(
                          title: Text(title ?? ''),
                          content: Theme(
                            data: ThemeData(primaryColor: Color(0xffffd60c)),
                            child: TextField(
                              textAlign: TextAlign.left,
                              controller: TextEditingController(),
                              autofocus: true,
                              maxLength: 120,
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: cancelFunc,
                              child: Text(
                                "取消",
                                style: TextStyle(color: Color(0xff707070)),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                onConfirm();
                                cancelFunc();
                              },
                              child: Text(
                                "确定",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                      ),
                      );
  }

  Widget _buildProgressRemarks(BuildContext context,
      ProductionProgressModel progress, ProgressState currentStatus) {
    return Container(
        child: GestureDetector(
          child: Container(
              padding: EdgeInsets.all(8),
              child: Row(children: <Widget>[
                Text('备注', style: TextStyle()),
                Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                    child: progress.remarks == null || progress.remarks == ''
                        ? Text(
                      '${_enableEdit ? '填写' : ''}',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                        : Container(
                      width: 140,
                      child: Text(
                        '${progress.remarks}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
              ])),
          onTap: () async {
            _enableEdit &&
                _model.status == ProgressWorkSheetStatus.IN_PRODUCTION
                ? _showRemarksDialog(progress, '备注', progress.remarks)
                : __neverShowMsg(
                '${progress.remarks == null ? '' : progress.remarks}');
          },
        ));
  }

  //打开日期选择器
  void _showDatePicker(ProductionProgressModel model,BuildContext context,) {
    _selectDate(context, model);
  }

  //生成日期选择器
  Future<Null> _selectDate(
      BuildContext context, ProductionProgressModel model) async {
    DateTime nowDate = DateTime.now();
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: nowDate,
        firstDate: nowDate,
        lastDate: DateTime(2999));

    if (_picked != null) {
      setState(() {
        model.estimatedDate = _picked;
      });

      try {
        model.updateOnly = true;
//        showDialog(
//            context: context,
//            barrierDismissible: false,
//            builder: (_) {
//              return RequestDataLoading(
//                requestCallBack: PurchaseOrderRepository()
//                    .productionProgressUpload(
//                    model.code, model.id.toString(), model),
//                outsideDismiss: false,
//                loadingText: '保存中。。。',
//                entrance: '0',
//              );
//            });
      } catch (e) {
        print(e);
      }
    }
  }


//打开数量输入弹框
  Future<void> _showDialog(ProductionProgressModel model,BuildContext context,) {
    TextEditingController inputController = TextEditingController();
    inputController.text = model.quantity.toString();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.INPUTS_DIALOG,
            inputController1: inputController,
            inputType1: TextInputType.number,
            focusNode1: FocusNode(),
          );
        }).then((value) {
      if (value != null && value != '') {
        model.quantity = int.parse(value);
        try {
          model.updateOnly = true;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return RequestDataLoading(
                  requestCallBack: PurchaseOrderRepository()
                      .productionProgressUpload(
                      _model.code, model.id.toString(), model),
                  outsideDismiss: false,
                  loadingText: '保存中。。。',
                  entrance: '',
                );
              });
        } catch (e) {
          print(e);
        }
      }
    });
  }

  //备注输入框
  void _showRemarksDialog(
      ProductionProgressModel model, String type, String remarks) {
    _neverRemarks(context, model, type, remarks);
  }

  Future<void> _neverRemarks(BuildContext context,
      ProductionProgressModel model, String type, String remarks) async {
    TextEditingController inputController = TextEditingController();
    inputController.text = model.remarks;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.INPUTS_DIALOG,
            inputController1: inputController,
            focusNode1: FocusNode(),
          );
        }).then((value) {
      if (value != null && value != '') {
        model.remarks = value;
        try {
          model.updateOnly = true;
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return RequestDataLoading(
                  requestCallBack: PurchaseOrderRepository()
                      .productionProgressUpload(
                      _model.code, model.id.toString(), model),
                  outsideDismiss: false,
                  loadingText: '保存中。。。',
                  entrance: '',
                );
              });
        } catch (e) {
          print(e);
        }
      }
    });
  }

  __neverShowMsg(String text) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            '备注',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('${text}'),
            ),
          ],
        );
      },
    );
  }
}
