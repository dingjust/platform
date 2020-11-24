import 'dart:async';

import 'package:b2b_commerce/src/my/contract/contract_seal_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'pdf_reader.dart';

///合同详情页
class ContractDetailPage extends StatefulWidget {
  Route route;
  ContractModel contractModel;
  String pathPDF = '';

  ContractDetailPage({
    this.pathPDF,
    this.contractModel,
    this.route,
  });

  @override
  _ContractDetailPageState createState() => new _ContractDetailPageState();
}

class _ContractDetailPageState extends State<ContractDetailPage> {
  List<SealModel> sealList;
  double bottomHeight = 150.0;
  bool _showPdf = true;

  @override
  void initState() {
    initSeal();
    super.initState();
  }

  initSeal() async {
    sealList = await ContractRepository()
        .getSealList({'type': ''}, {'page': '0', 'size': '100'});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.contractModel);
    return WillPopScope(
      onWillPop: () {
        if (widget.route != null) {
          Navigator.pushReplacement(context, widget.route);
        } else {
          Navigator.pop(context);
        }

        return Future.value(false);
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            // height: 500,
            child: _showPdf
                ? PDFReader(
                    appBar: AppBar(
                      title: Text("合同详情"),
                      centerTitle: true,
                    ),
                    path: widget.pathPDF,
                    bottomHeight: bottomHeight,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          bottomNavigationBar: Container(
            child: _buildButton(),
          )),
    );
  }

  Widget _buildButton() {
    if (widget.contractModel.state != ContractStatus.COMPLETE &&
        widget.contractModel.state != ContractStatus.INVALID &&
        !widget.contractModel.isCreator) {
      if (widget.contractModel.isSigned) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.white10,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: 50,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 100),
                color: Color.fromRGBO(255, 214, 12, 1),
                child: Text(
                  '拒签',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 150,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                height: 30,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Icon(
                                        Icons.error,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          '注意',
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text('是否要拒签该合同'),
                                      ),
                                    ],
                                  )),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                          child: FlatButton(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 80),
                                              child: Text(
                                                '取消',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })),
                                    ),
                                    Center(
                                      child: Container(
                                        child: FlatButton(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 80),
                                            child: Text(
                                              '确定',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (_) {
                                                    return RequestDataLoading(
                                                      requestCallBack:
                                                          ContractRepository()
                                                              .rejectContract(widget
                                                                  .contractModel
                                                                  .code),
                                                      outsideDismiss: false,
                                                      loadingText: '撤回中。。。',
                                                      entrance: '',
                                                    );
                                                  }).then((value) {
                                                MyContractBLoC()
                                                    .refreshData('ALL', '');
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (_) {
                                                      return CustomizeDialog(
                                                        dialogType: DialogType
                                                            .RESULT_DIALOG,
                                                        successTips:
                                                            '${value.msg}',
                                                        callbackResult: true,
                                                      );
                                                    });
                                              });
                                            }),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.5))),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.grey, width: 0.5))),
                              )
                            ]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white10,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                height: 50,
                child: RaisedButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text(
                    '拒签',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 150,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  height: 30,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Icon(
                                          Icons.error,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            '注意',
                                            style: TextStyle(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 50,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text('是否要拒签该合同'),
                                        ),
                                      ],
                                    )),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                            child: FlatButton(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 80),
                                                child: Text(
                                                  '取消',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                })),
                                      ),
                                      Center(
                                        child: Container(
                                          child: FlatButton(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 80),
                                              child: Text(
                                                '确定',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (_) {
                                                      return RequestDataLoading(
                                                        requestCallBack:
                                                            ContractRepository()
                                                                .rejectContract(
                                                                    widget
                                                                        .contractModel
                                                                        .code),
                                                        outsideDismiss: false,
                                                        loadingText: '撤回中。。。',
                                                        entrance: '',
                                                      );
                                                    }).then((value) {
                                                  MyContractBLoC()
                                                      .refreshData('ALL', '');
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (_) {
                                                        return CustomizeDialog(
                                                          dialogType: DialogType
                                                              .RESULT_DIALOG,
                                                          successTips:
                                                              '${value.msg}',
                                                          callbackResult: true,
                                                        );
                                                      });
                                                });
                                              }),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.5))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 0.5))),
                                )
                              ]),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              width: 20,
              height: 50,
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white10,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                height: 50,
                child: RaisedButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text(
                    '去签署',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  onPressed: () {
                    setState(() {
                      _showPdf = false;
                    });
//                  Navigator.pop(context);
                    print(widget.contractModel.state);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContractSealPage(
                                sealList: sealList,
                                model: widget.contractModel,
                              )),
                    ).then((v) {
                      setState(() {
                        _showPdf = true;
                      });
                    });
                  },
                ),
              ),
            )
          ],
        );
      }
    } else if (widget.contractModel.state != ContractStatus.COMPLETE &&
        widget.contractModel.state != ContractStatus.INVALID &&
        widget.contractModel.isCreator) {
      if (widget.contractModel?.isSigned ?? false) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              color: Colors.white10,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: 50,
              child: RaisedButton(
                padding: EdgeInsets.symmetric(horizontal: 100),
                color: Color.fromRGBO(255, 214, 12, 1),
                child: Text(
                  '撤回',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 150,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                height: 30,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Icon(
                                        Icons.error,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          '注意',
                                          style: TextStyle(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 5),
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Text('是否要撤回该合同'),
                                      ),
                                    ],
                                  )),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                          child: FlatButton(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 80),
                                              child: Text(
                                                '取消',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })),
                                    ),
                                    Center(
                                      child: Container(
                                        child: FlatButton(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 80),
                                            child: Text(
                                              '确定',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15))),
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (_) {
                                                    return RequestDataLoading(
                                                      requestCallBack:
                                                          ContractRepository()
                                                              .revokeContract(widget
                                                                  .contractModel
                                                                  .code),
                                                      outsideDismiss: false,
                                                      loadingText: '撤回中。。。',
                                                      entrance: '',
                                                    );
                                                  }).then((value) {
                                                MyContractBLoC()
                                                    .refreshData('ALL', '');
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (_) {
                                                      return CustomizeDialog(
                                                        dialogType: DialogType
                                                            .RESULT_DIALOG,
                                                        successTips:
                                                            '${value.msg}',
                                                        callbackResult: true,
                                                      );
                                                    });
                                              });
                                            }),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: Colors.grey,
                                                    width: 0.5))),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.grey, width: 0.5))),
                              )
                            ]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white10,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                height: 50,
                child: RaisedButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text(
                    '撤回',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 150,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  height: 30,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Icon(
                                          Icons.error,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            '注意',
                                            style: TextStyle(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 50,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text('是否要撤回该合同'),
                                        ),
                                      ],
                                    )),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                            child: FlatButton(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 80),
                                                child: Text(
                                                  '取消',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                })),
                                      ),
                                      Center(
                                        child: Container(
                                          child: FlatButton(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 80),
                                              child: Text(
                                                '确定',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (_) {
                                                      return RequestDataLoading(
                                                        requestCallBack:
                                                            ContractRepository()
                                                                .revokeContract(
                                                                    widget
                                                                        .contractModel
                                                                        .code),
                                                        outsideDismiss: false,
                                                        loadingText: '撤回中。。。',
                                                        entrance: '',
                                                      );
                                                    }).then((value) {
                                                  MyContractBLoC()
                                                      .refreshData('ALL', '');
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (_) {
                                                        return CustomizeDialog(
                                                          dialogType: DialogType
                                                              .RESULT_DIALOG,
                                                          successTips:
                                                              '${value.msg}',
                                                          callbackResult: true,
                                                        );
                                                      });
                                                });
                                              }),
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      color: Colors.grey,
                                                      width: 0.5))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          top: BorderSide(
                                              color: Colors.grey, width: 0.5))),
                                )
                              ]),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              width: 20,
              height: 50,
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white10,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                height: 50,
                child: RaisedButton(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  child: Text(
                    '去签署',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  onPressed: () async {
                    setState(() {
                      _showPdf = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContractSealPage(
                                sealList: sealList,
                                model: widget.contractModel,
                              )),
                    ).then((val) {
                      setState(() {
                        _showPdf = true;
                      });
                    });
                  },
                ),
              ),
            ),
          ],
        );
      }
    } else if (widget.contractModel.state == ContractStatus.COMPLETE) {
      return Container(
        height: 1,
      );
      // return Container(
      //   color: Colors.white10,
      //   margin: EdgeInsets.all(10),
      //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      //   height: 50,
      //   child: RaisedButton(
      //     color: Color.fromRGBO(255, 214, 12, 1),
      //     child: Text(
      //       '增加补充协议',
      //       style: TextStyle(
      //         color: Colors.black,
      //         fontSize: 18,
      //       ),
      //     ),
      //     shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.all(Radius.circular(5))),
      //     onPressed: () {},
      //   ),
      // );
    } else if (widget.contractModel.state == ContractStatus.INVALID) {
      return Container(
        height: 50,
      );
    } else {
      return Container(
        height: 50,
      );
    }
  }
}
