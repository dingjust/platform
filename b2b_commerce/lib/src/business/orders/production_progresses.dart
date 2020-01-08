import 'package:b2b_commerce/src/_shared/widgets/share_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';

import 'productionProgresses/production_progress_detail.dart';

class ProductionProgressesPage extends StatefulWidget {
  PurchaseOrderModel order;

  ProductionProgressesPage({Key key, @required this.order}) : super(key: key);

  _ProductionProgressesPageState createState() =>
      _ProductionProgressesPageState(order: order);
}

class _ProductionProgressesPageState extends State<ProductionProgressesPage> {
  DateTime _blDate;
  String _blNumber;
  TextEditingController dialogText;
  String userType;
  PurchaseOrderModel order;
  String phase;
  String remarks;
  DateTime nowTime;

  DateTime materialDate;
  DateTime cuttingDate;
  DateTime stitchingDate;
  DateTime afterDate;
  DateTime inspectionDate;

  _ProductionProgressesPageState({this.order});

  @override
  void initState() {
    nowTime = DateTime.now();
    final bloc = BLoCProvider.of<UserBLoC>(context);
    if (bloc.isBrandUser) {
      userType = 'brand';
    } else {
      userType = 'factory';
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setEstimatedDate(context));
    }
    super.initState();
  }

  setEstimatedDate(BuildContext context) async {
    if (order != null &&
        order.progresses != null &&
        order.status == PurchaseOrderStatus.IN_PRODUCTION) {
      for (int i = 0; i < order.progresses.length; i++) {
        if (order.progresses[i].phase ==
            ProductionProgressPhase.MATERIAL_PREPARATION) {
          materialDate = order.progresses[i].estimatedDate;
        } else if (order.progresses[i].phase ==
            ProductionProgressPhase.CUTTING) {
          cuttingDate = order.progresses[i].estimatedDate;
        } else if (order.progresses[i].phase ==
            ProductionProgressPhase.STITCHING) {
          stitchingDate = order.progresses[i].estimatedDate;
        } else if (order.progresses[i].phase ==
            ProductionProgressPhase.AFTER_FINISHING) {
          afterDate = order.progresses[i].estimatedDate;
        } else if (order.progresses[i].phase ==
            ProductionProgressPhase.INSPECTION) {
          inspectionDate = order.progresses[i].estimatedDate;
        }
      }

      if (materialDate == null ||
          cuttingDate == null ||
          stitchingDate == null ||
          afterDate == null ||
          inspectionDate == null) {
        int _index = 0;
        for (int i = 0; i < order.progresses.length; i++) {
          if (ProductionProgressPhaseLocalizedMap[order.progresses[i].phase] ==
              ProductionProgressPhaseLocalizedMap[order.currentPhase]) {
            _index = order.progresses[i].sequence;
          }
        }
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.ESTIMATED_DATE,
                orderModel: order,
                estimatedDate1: materialDate,
                estimatedDate2: cuttingDate,
                estimatedDate3: stitchingDate,
                estimatedDate4: afterDate,
                estimatedDate5: inspectionDate,
                expectedDeliveryDate: widget.order.expectedDeliveryDate,
                currentNode: _index,
              );
            }).then((value) {
          if (value != null) {
            setState(() {
              order = value;
            });
          } else {
            Navigator.of(context).pop();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text('生产进度明细'),
        actions: <Widget>[
          InkWell(
              onTap: () => onShare(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Icon(
                      B2BIcons.share,
                    ),
                    Text('分享')
                  ],
                ),
              )),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 0),
        child: _buildProgresses(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      bottomNavigationBar: UserBLoC().isBrandUser
          ? Container(
        padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
        child: RaisedButton(
            color: Color.fromRGBO(15, 213, 30, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                Text(
                  '一键核实',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () async {
//              setEstimatedDate(context);
              if (order.salesApplication == SalesApplication.ONLINE) {
                _selectActionButton(order.belongTo.contactPhone);
              } else {
                _selectActionButton(order.contactOfSeller);
              }
            }),
      )
          : null,
    );
  }

  Widget _buildProgresses(BuildContext context) {
    return Container(
      color: Color.fromRGBO(245, 245, 245, 30),
      padding: EdgeInsets.only(bottom: 5),
      child: ListView(
        children: _buildPurchaseProductionProgresses(context),
      ),
    );
  }

  List<Widget> _buildPurchaseProductionProgresses(BuildContext context) {
    List<Widget> _list = new List();
    int _index = 0;
    for (int i = 0; i < order.progresses.length; i++) {
      if (ProductionProgressPhaseLocalizedMap[order.progresses[i].phase] ==
          ProductionProgressPhaseLocalizedMap[order.currentPhase]) {
        _index = order.progresses[i].sequence;
      }
    }
    for (int i = 0; i < order.progresses.length; i++) {
      _list.add(GestureDetector(
        onTap: () {
          final state = Provider.of<ProductionProgressState>(context);
          state.jumpToProgressDetail(
              context: context,
              materialPageRoute: MaterialPageRoute(
                  builder: (context) => ProductionProgressDetailPage()),
              progress: order.progresses[i],
              callBack: () {
                refreshData();
              });
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(10, 5, 10, 8),
          color: order.progresses[i].sequence == _index &&
              order.status == PurchaseOrderStatus.IN_PRODUCTION
              ? Color.fromARGB(255, 255, 214, 12)
              : Colors.white,
          elevation: 1.5,
          child: _buildProgressTimeLine(
              context,
              order.progresses[i],
              ProductionProgressPhaseLocalizedMap[order.currentPhase],
              order.progresses[i].sequence,
              _index),
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

  //生产状态
  Widget _buildPhaseText(BuildContext context, ProductionProgressModel progress,
      String currentPhase, int sequence, int _index, String phase) {
    if (sequence < _index &&
        order.status == PurchaseOrderStatus.IN_PRODUCTION) {
      return Text(
          '▼ ${ProductionProgressPhaseLocalizedMap[progress.phase]}（已完成）',
          style: TextStyle(color: Colors.black, fontSize: 18));
    } else if (sequence == _index) {
      if (phase == '验货') {
        return Text(
            '■ ${ProductionProgressPhaseLocalizedMap[progress.phase]}（当前进行中）',
            style: TextStyle(color: Colors.black, fontSize: 18));
      } else {
        return Text(
            '▼ ${ProductionProgressPhaseLocalizedMap[progress.phase]}（当前进行中）',
            style: TextStyle(color: Colors.black, fontSize: 18));
      }
    } else {
      if (phase == '验货') {
        return Text('■ ${ProductionProgressPhaseLocalizedMap[progress.phase]}',
            style: TextStyle(color: Colors.black, fontSize: 18));
      } else {
        return Text('▼ ${ProductionProgressPhaseLocalizedMap[progress.phase]}',
            style: TextStyle(color: Colors.black, fontSize: 18));
      }
    }
  }

//TimeLineUI右边的Card部分
  Widget _buildProgressTimeLine(BuildContext context,
      ProductionProgressModel progress,
      String currentPhase,
      int sequence,
      int _index) {
    phase = ProductionProgressPhaseLocalizedMap[progress.phase];
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: _buildPhaseText(context, progress, currentPhase,
                      sequence, _index, phase)),
              Container(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  '${progress.delayedDays != null && progress.delayedDays > 0 &&
                      sequence <= _index ? '已延期${progress.delayedDays}天' : ''}',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(progress.estimatedDate != null
                          ? '预计完成时间: ${DateFormatUtil.formatYMD(
                          progress.estimatedDate)}'
                          : ''),
                      Text('数量: ${progress.totalQuantity}'),
                      Text('备注: ${progress.remarks ?? ''}')
                    ],
                  ),
                ),
              ),
              progress.medias == null || progress.medias.isEmpty
                  ? Container(
                margin: EdgeInsets.fromLTRB(10, 15, 5, 0),
                padding: EdgeInsets.fromLTRB(5, 10, 15, 10),
                child: Center(
                  child: Icon(
                    B2BIcons.noPicture,
                    color: Color.fromRGBO(200, 200, 200, 1),
                    size: 60,
                  ),
                ),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromRGBO(243, 243, 243, 1)),
              )
                  : Container(
                  margin: EdgeInsets.fromLTRB(20, 15, 15, 0),
                  width: 80,
                  height: 80,
                  child: CachedNetworkImage(
                      imageUrl: '${progress.medias[0].previewUrl()}',
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                      placeholder: (context, url) =>
                          SpinKitRing(
                            color: Colors.black12,
                            lineWidth: 2,
                            size: 30.0,
                          ),
                      errorWidget: (context, url, error) =>
                          SpinKitRing(
                            color: Colors.black12,
                            lineWidth: 2,
                            size: 30,
                          )),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ))
            ],
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: RaisedButton(
                color: Colors.white,
                child: Text(
                  '查看详情',
                  style: TextStyle(color: Colors.black),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                onPressed: () {
                  final state = Provider.of<ProductionProgressState>(context);
                  state.jumpToProgressDetail(
                      context: context,
                      materialPageRoute: MaterialPageRoute(
                          builder: (context) => ProductionProgressDetailPage()),
                      progress: progress,
                      callBack: () {
                        refreshData();
                      });
                },
              )),
        ],
      ),
    );
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context,
      ProductionProgressModel model) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: nowTime,
        firstDate: nowTime,
        lastDate: DateTime(2999));

    if (_picked != null) {
      model.estimatedDate = _picked;
      try {
        model.updateOnly = true;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return RequestDataLoading(
                requestCallBack: PurchaseOrderRepository()
                    .productionProgressUpload(
                    order.code, model.id.toString(), model),
                outsideDismiss: false,
                loadingText: '保存中。。。',
                entrance: '',
              );
            });
      } catch (e) {
        print(e);
      }
      setState(() {
        _blDate = _picked;
      });
    }
  }

  //确认完成按钮方法
  Future<void> _neverComplete(BuildContext context,
      ProductionProgressModel model) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '确定完成当前生产进度吗？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              submit(model);
            },
          );
        });
  }

  void submit(ProductionProgressModel model) {
    model.updateOnly = false;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: PurchaseOrderRepository().productionProgressUpload(
                order.code, model.id.toString(), model),
            outsideDismiss: false,
            loadingText: '保存中。。。',
            entrance: 'createPurchaseOrder',
          );
        }).then((value) {
      refreshData();
    });
  }

  Future<void> refreshData() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            PurchaseOrderRepository().getPurchaseOrderDetail(order.code),
            outsideDismiss: false,
            loadingText: '正在刷新。。。',
            entrance: '',
          );
        }).then((value) {
      if (value != null) {
        order = value;
        widget.order = order;
        setState(() {
          phase = ProductionProgressPhaseLocalizedMap[order.currentPhase];
        });
      }
    });
    // order = await PurchaseOrderRepository().getPurchaseOrderDetail(order.code);
    // widget.order = order;
    // setState(() {
    //   phase = ProductionProgressPhaseLocalizedMap[order.currentPhase];
    // });
    // Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(
    //         builder: (context) => ProductionProgressesPage(order: order)),
    //     ModalRoute.withName('/'));
  }

//生成Dialog控件 输入数量
  Future<void> _neverSatisfied(BuildContext context,
      ProductionProgressModel model, String type) async {
    TextEditingController inputController = TextEditingController();
    inputController.text = model.quantity != null && model.quantity > 0
        ? model.quantity.toString()
        : '';
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
                      order.code, model.id.toString(), model),
                  outsideDismiss: false,
                  loadingText: '保存中。。。',
                  entrance: '',
                );
              });
        } catch (e) {
          print(e);
        }
        setState(() {
          _blNumber = value;
        });
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

  //输入备注
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
                      order.code, model.id.toString(), model),
                  outsideDismiss: false,
                  loadingText: '保存中。。。',
                  entrance: '',
                );
              });
        } catch (e) {
          print(e);
        }
        setState(() {
          _blNumber = value;
        });
      }
    });
  }

//打开日期选择器
  void _showDatePicker(ProductionProgressModel model) {
    _selectDate(context, model);
  }

//打开数量输入弹框
  void _showDialog(ProductionProgressModel model, String type) {
    _neverSatisfied(context, model, type);
  }

  void uploadPicture(ProductionProgressModel model) async {
    await PurchaseOrderRepository()
        .productionProgressUpload(order.code, model.id.toString(), model);
  }

  //备注输入框
  void _showRemarksDialog(ProductionProgressModel model, String type,
      String remakrs) {
    _neverRemarks(context, model, type, remakrs);
  }

  void _showMessage(BuildContext context, bool result) async {
    if (result) {
      _requestMessage(context, '操作成功');
    } else {
      _requestMessage(context, '操作失败');
    }
    ProductionBLoC.instance.refreshData('');
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

  Future<void> _requestMessage(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text(
            '提示',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          content: SingleChildScrollView(
              child: Text(
                '${message}',
                style: TextStyle(
                  fontSize: 16,
                ),
              )),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '确定',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () async {
                order = await PurchaseOrderRepository()
                    .getPurchaseOrderDetail(order.code);
                setState(() {
                  phase =
                  ProductionProgressPhaseLocalizedMap[order.currentPhase];
                });
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductionProgressesPage(order: order)),
                    ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }

  //打开修改尾款金额弹框
  void _showBalanceDialog(BuildContext context, PurchaseOrderModel model) {
    TextEditingController con = new TextEditingController();
    TextEditingController con1 = new TextEditingController();
    TextEditingController con2 = new TextEditingController();
    TextEditingController con3 = new TextEditingController();
    FocusNode node = new FocusNode();
    FocusNode node1 = new FocusNode();
    FocusNode node2 = new FocusNode();
    FocusNode node3 = new FocusNode();
    con.text = widget.order.totalPrice.toString();
    con1.text = widget.order.deposit.toString();
    con2.text = '${widget.order.totalPrice - widget.order.deposit}';
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.BALANCE_INPUT_DIALOG,
            outsideDismiss: false,
            inputController: con,
            inputController1: con1,
            inputController2: con2,
            inputController3: con3,
            focusNode: node,
            focusNode1: node1,
            focusNode2: node2,
            focusNode3: node3,
          );
        }).then((value) {
      if (value != null && value != '') {
        String str = value;
        _updateBalance(context, widget.order, str);
      }
    });
  }

  void _updateBalance(BuildContext context, PurchaseOrderModel model,
      String balanceText) async {
    bool result = false;
    Navigator.of(context).pop();
    if (balanceText != null && balanceText != '') {
      double balance = double.parse(balanceText.replaceAll('￥', ''));
      model.balance = balance;
      model.skipPayBalance = false;
      try {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return RequestDataLoading(
                requestCallBack: PurchaseOrderRepository()
                    .purchaseOrderBalanceUpdate(model.code, model),
                outsideDismiss: false,
                loadingText: '保存中。。。',
                entrance: 'purchaseOrders',
              );
            }).then((value) async {
          if (value) {
            if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
              try {
                for (int i = 0; i < order.progresses.length; i++) {
                  if (order.currentPhase == order.progresses[i].phase) {
                    await PurchaseOrderRepository().productionProgressUpload(
                        order.code,
                        order.progresses[i].id.toString(),
                        order.progresses[i]);
                  }
                }
              } catch (e) {
                print(e);
              }
            }
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  //修改金额按钮方法
  Future<void> _neverUpdateBalance(BuildContext context,
      PurchaseOrderModel model) async {
    TextEditingController dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text(
            '提示',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
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
                  '应付尾款：￥${model.totalPrice != null && model.deposit != null
                      ? model.totalPrice - model.deposit
                      : ''}',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller: dialogText,
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
                          fontSize: 18,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      onPressed: () async {
                        bool result = false;
                        Navigator.of(context).pop();
                        if (dialogText.text != null && dialogText.text != '') {
                          double balance = double.parse(dialogText.text);
                          model.balance = balance;
                          model.skipPayBalance = false;
                          try {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return RequestDataLoading(
                                    requestCallBack: PurchaseOrderRepository()
                                        .purchaseOrderBalanceUpdate(
                                        model.code, model),
                                    outsideDismiss: false,
                                    loadingText: '保存中。。。',
                                    entrance: 'purchaseOrders',
                                  );
                                });
                          } catch (e) {
                            print(e);
                          }
                          if (result) {
                            if (model.status ==
                                PurchaseOrderStatus.IN_PRODUCTION) {
                              try {
                                for (int i = 0;
                                i < order.progresses.length;
                                i++) {
                                  if (order.currentPhase ==
                                      order.progresses[i].phase) {
                                    result = await PurchaseOrderRepository()
                                        .productionProgressUpload(
                                        order.code,
                                        order.progresses[i].id.toString(),
                                        order.progresses[i]);
                                  }
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                          }
                        }
                      }),
                ),
                FlatButton(
                  child: Text(
                    '无需付款直接跳过>>',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showTips(context, model);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _selectActionButton(String tel) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('拨打电话'),
              onTap: () async {
                var url = 'tel:' + tel;
                await launch(url);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showTips(BuildContext context, PurchaseOrderModel model) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 210,
            contentText2: '是否无需付款直接跳过？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: () {
              Navigator.of(context).pop();
              _neverJump(context, widget.order);
            },
          );
        });
  }

  //确认跳过按钮
  Future<void> _neverJump(BuildContext context,
      PurchaseOrderModel model) async {
    model.balance = 0;
    model.skipPayBalance = true;
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: PurchaseOrderRepository()
                  .purchaseOrderBalanceUpdate(model.code, model),
              outsideDismiss: false,
              loadingText: '保存中。。。',
              entrance: 'purchaseOrders',
            );
          });
      if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
        try {
          for (int i = 0; i < order.progresses.length; i++) {
            if (order.currentPhase == order.progresses[i].phase) {
              await PurchaseOrderRepository().productionProgressUpload(
                  order.code,
                  order.progresses[i].id.toString(),
                  order.progresses[i]);
            }
          }
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  onMenuSelect(String value) async {
    switch (value) {
      case 'share':
        onShare();
        break;
      default:
    }
  }

  void onShare() {
    String description =
        " 当前进度：${ProductionProgressPhaseLocalizedMap[widget.order
        .currentPhase]}\n 最近更新时间：${DateFormatUtil.formatYMD(
        widget.order.modifiedTime)}";

    ShareDialog.showShareDialog(context,
        title: '${widget.order.product.name}',
        description: '$description',
        imageUrl: widget.order.product.thumbnail == null
            ? '${GlobalConfigs.LOGO_URL}'
            : '${widget.order.product.thumbnail.previewUrl()}',
        url: Apis.shareProductionProgress(widget.order.code));
  }
}
