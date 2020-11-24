import 'dart:async';

import 'package:b2b_commerce/src/_shared/contract/contract_purchase_order_select.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:b2b_commerce/src/my/contract/contract_temp_select_page.dart';
import 'package:b2b_commerce/src/my/my_contract.dart';
import 'package:core/core.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'contract_detail_page.dart';

class ContractWTSCHTFrom extends StatefulWidget {
  _ContractWTSCHTFromState createState() => _ContractWTSCHTFromState();
}

class _ContractWTSCHTFromState extends State<ContractWTSCHTFrom> {
  final StreamController _streamController =
      StreamController<double>.broadcast();
  bool isA = false;
  bool isB = false;
  List<ContractTemplateModel> tempList;
  ContractTemplateModel temp;
  List<PurchaseOrderModel> _orderModels;

  @override
  void initState() {
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      isA = true;
    } else if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      isB = true;
    }
//    initSeal();
    super.initState();
  }

  initSeal() async {
    // 延时1s执行返回
    Future.delayed(Duration(seconds: 5), () {
//      Navigator.of(context).pop();
      print('延时1s执行');
    });
    tempList = await ContractRepository().getContractTemplateList(
        {'type': 'WTSCHT'}, {'page': '0', 'size': '100'});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('委托生产合同'),
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
    String role = '';
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
    } else if (_orderModels == null || _orderModels.length == 0) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择订单',
              callbackResult: false,
            );
          });
    } else if (temp == null || temp.code == null || temp.code == '') {
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
    } else {
      ShowDialogUtil.showChoseDiglog(context, '是否确认创建委托生产合同', () {
        Navigator.pop(context);
        if (isA) {
          role = 'PARTYA';
        } else if (isB) {
          role = 'PARTYB';
        }

        Map data = {
          'userTempCode': temp.code,
          'userSignCode': '',
          'role': role,
          'title': '00000',
          'orderCodes': _orderModels.map((model) => model.code).toList()
//        'orderCode':'TPO00079001'
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
                  '${value != null && value.msg != null
                      ? value.msg
                      : '创建合同失败'}',
                  successTips: '创建合同成功',
                  callbackResult: result,
                  confirmAction: () {
                    if (result) {
                      print(value.data);
                      print(value.msg);
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
            onTap: () async {
              dynamic result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ContractPurchaseOrderSelectPage(
                            models: _orderModels,
                          )));

              if (result != null) {
                print(result);
                _orderModels = result;
              }
              print(_orderModels);
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '选择订单',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${_orderModels == null || _orderModels.length == 0
                            ? ''
                            : _orderModels.map((model) => model.code).join(
                            ',')}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
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
                            title: '委托生产合同模板',
                            contractTempModel: temp,
                            type: 'WTSCHT',
                          ))).then((value) {
                if (value != null) {
                  setState(() {
                    temp = value;
                  });
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
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${temp == null ? '' : temp.title}',
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
    if (contractCode == null || contractCode == '') {
      return;
    }
    var contractModel = await ContractRepository().getContract(contractCode);
    SearchResultModel resultModel =
    await ContractRepository().getContractPdfMedia(contractCode);
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
            requestCallBack: dio.download(pdf.actualUrl, filePath,
                onReceiveProgress: (received, total) {
                  print((received / total * 100).toStringAsFixed(0) + "%");
                  _streamController.sink.add(received / total);
                }),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ContractDetailPage(
                      pathPDF: filePath,
                      contractModel: contractModel.data,
                      route: MaterialPageRoute(
                          builder: (context) => MyContractPage()))),
          ModalRoute.withName(AppRoutes.ROUTE_MY_CONTRACT));
    });
  }
}
