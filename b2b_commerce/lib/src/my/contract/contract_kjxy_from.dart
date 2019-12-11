import 'dart:async';

import 'package:b2b_commerce/src/_shared/cooperator/cooperator_select.dart';
import 'package:b2b_commerce/src/_shared/cooperator/cooperator_single_select.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/my/contract/contract_suppliers.dart';
import 'package:b2b_commerce/src/my/contract/contract_temp_page.dart';
import 'package:b2b_commerce/src/my/contract/contract_temp_select_page.dart';
import 'package:b2b_commerce/src/my/contract/pdf_reader.dart';
import 'package:b2b_commerce/src/my/my_contract.dart';
import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ContractKJXYFrom extends StatefulWidget {
  _ContractKJXYFromState createState() => _ContractKJXYFromState();
}

class _ContractKJXYFromState extends State<ContractKJXYFrom> {
  final StreamController _streamController = StreamController<double>.broadcast();
  PurchaseOrderModel orderModel;
  bool isA = false;
  bool isB = false;
  List<ContractTemplateModel> kjxyTempList;
  ContractTemplateModel kjxyTemp;
  DateTime validityStart;
  DateTime validityEnd;
  CooperatorModel _cooperatorModel;

  @override
  void initState() {
    if(UserBLoC.instance.currentUser.type == UserType.BRAND){
      isA = true;
    }else if(UserBLoC.instance.currentUser.type == UserType.FACTORY){
      isB = true;
    }
//    initSeal();
    super.initState();
  }

  initSeal() async {
    kjxyTempList = await ContractRepository().getContractTemplateList(
        {'type': 'KJXY'}, {'page': '0', 'size': '100'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('框架协议合同'),
          elevation: 0.5,
          centerTitle: true,
        ),
        body: _buildMain(),
        bottomNavigationBar: Container(
          color: Colors.white10,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '生成合同',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: () {
              saveContract();
            },
          ),
        ));
  }

  saveContract() async {
    if (!isA && !isB) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择甲乙方',
              callbackResult: false,
            );
          });
      return;
    }

    if (_cooperatorModel == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择签署对象',
              callbackResult: false,
            );
          });
      return;
    }

    if (validityEnd == null || validityStart == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择合同有效期',
              callbackResult: false,
            );
          });
      return;
    }

    if (kjxyTemp == null ||
        kjxyTemp.code == null ||
        kjxyTemp.code == '') {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择模板',
              callbackResult: false,
            );
          });
      return;
    }

    ShowDialogUtil.showChoseDiglog(context, '是否确认创建框架协议合同', (){
      Navigator.pop(context);
      String role = '';
      if (isA) {
        role = 'PARTYA';
      } else if (isB) {
        role = 'PARTYB';
      }
      Map data = {
        'userTempCode': kjxyTemp.code,
        'userSignCode': '',
        'role': role,
        'title': '00000',
        'validityEnd': DateFormatUtil.formatYMD(validityEnd),
        'validityStart': DateFormatUtil.formatYMD(validityStart),
        'isFrame': true,
//        'orderCode': orderModel.code,
        'partnerCompanyCode': _cooperatorModel.id,
      };
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return RequestDataLoading(
              requestCallBack: ContractRepository().SignaContract(data),
              outsideDismiss: false,
              loadingText: '保存中。。。',
            );
          }).then((value) {
        bool result = false;
        if (value != null && value.code == 1) {
          result = true;
        }
        MyContractBLoC().refreshData('ALL', '');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                failTips:
                '${value != null && value.msg != null ? value.msg : '创建合同失败'}',
                successTips: '创建合同成功',
                callbackResult: result,
                confirmAction: () {
                  if (result) {
                    //创建成功跳转到合同详情
                    _previewFile(value.data);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              );
            });
      });
    });

  }

  Widget _buildMain() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '签订方式',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '新签电子合同',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 2, color: Color.fromRGBO(245, 245, 245, 30)),
          GestureDetector(
            onTap: ()async {
              dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CooperatorSingleSelectPage(model: this._cooperatorModel,)));

              if(result != null){
                this._cooperatorModel = result;
              }
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '签署对象',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${_cooperatorModel == null ? '' : _cooperatorModel.partner?.name}',
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 2, color: Color.fromRGBO(245, 245, 245, 30)),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    '合同有效期',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showDatePicker(1);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      validityStart != null
                          ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${DateFormatUtil.formatYMD(validityStart)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.date_range,
                          size: 30,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '－',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showDatePicker(2);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      validityEnd != null
                          ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${DateFormatUtil.formatYMD(validityEnd)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.date_range,
                          size: 30,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 2, color: Color.fromRGBO(245, 245, 245, 30)),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ContractTempSelectPage(
                            title: '框架协议合同模板',
                            contractTempModel: kjxyTemp,
                            type: 'KJXY',
                          ))).then((value) {
                            if(value != null){
                              kjxyTemp = value;
                            }
              });
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '选择模板',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${kjxyTemp == null ? '' : kjxyTemp.title}',
                        style: TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 2, color: Color.fromRGBO(245, 245, 245, 30)),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isA = !isA;
                        isB = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('我是甲方')),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        color: isA
                            ? Color.fromRGBO(255, 214, 12, 1)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isB = !isB;
                        isA = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: Text('我是乙方')),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54, width: 1),
                        borderRadius: BorderRadius.circular(8),
                        color: isB
                            ? Color.fromRGBO(255, 214, 12, 1)
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //文件下载打开
  _previewFile(String contractCode) async {
    if(contractCode == null || contractCode == ''){
      return;
    }
    var contractModel = await ContractRepository().getContract(contractCode);
    SearchResultModel resultModel = await ContractRepository().getContractPdfMedia(contractCode);
    MediaModel pdf = resultModel.data;
//    final url = "http://africau.edu/images/default/sample.pdf";
    //获取应用目录路径
    String dir = (await getApplicationDocumentsDirectory()).path;
    print(pdf.name);
    String fileName = pdf.name;
    String filePath = "$dir/$fileName";
    var dio = new Dio();

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.idleTimeout = new Duration(seconds: 0);
    };

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            dio.download(pdf.actualUrl, filePath,
                onReceiveProgress: (received, total) {
                  print((received / total * 100).toStringAsFixed(0) + "%");
                  _streamController.sink.add(received / total);
                }),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((_){
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) =>
              PdfReaderWidget(pathPDF: filePath,contractModel: contractModel.data,route: MaterialPageRoute(builder: (context) => MyContractPage()))),
          ModalRoute.withName(AppRoutes.ROUTE_MY_CONTRACT));
    });
  }

  //打开日期选择器
  void _showDatePicker(int index) {
    _selectDate(context, index);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context, int index) async {
    DateTime nowTime = DateTime.now();
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: nowTime,
        firstDate: nowTime,
        lastDate: DateTime(2999));

    if (_picked != null) {
      setState(() {
        if (index == 1) {
          validityStart = _picked;
        }
        if (index == 2) {
          validityEnd = _picked;
        }
      });
    }
  }
}
