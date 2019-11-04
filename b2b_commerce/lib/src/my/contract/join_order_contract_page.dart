import 'package:b2b_commerce/src/business/search/purchase_order_search_result.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/my/contract/float_select_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'contract_select_widget.dart';

class JoinOrderContractPage extends StatefulWidget{
  String role;
  JoinOrderContractPage({this.role});
  _JoinOrderContractPageState createState() => _JoinOrderContractPageState();
}

class _JoinOrderContractPageState extends State<JoinOrderContractPage>{
  PurchaseOrderModel orderModel  = PurchaseOrderModel();
  ContractTemplateModel templateModel = ContractTemplateModel();
  SealModel sealModel = SealModel();
  List<ContractTemplateModel> tempList;


  initTemplate() async {
    tempList = await ContractRepository().getContractTemplateList({'type':''}, {'page':'0','size':'100'});
  }

  @override
  void initState() {
    super.initState();
    initTemplate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('关联订单合同'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              _buildSelectOrderItem(),
              _buildSelectContractItem(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white10,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          height: 50,
          child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '创建',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            onPressed: (){
              openSelectButton(context);
            },
          ),
        )
    );
  }

  openSelectButton(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return FloatSelectPage(
            buttonText1: '我是甲方',
            buttonText2: '我是乙方',
            action1: () async {
              Map data = {
                'userTempCode' : templateModel.code,
                'userSignCode' : sealModel.code,
                'role':'PARTYA',
                'title':'00000',
                'orderCode':orderModel.code,
              };
              saveContract(data);
            },
            action2: () async {
              Map data = {
                'userTempCode' : templateModel.code,
                'userSignCode' : sealModel.code,
                'role':'PARTYB',
                'title':'00000',
                'orderCode':orderModel.code,
              };
              saveContract(data);
            },
          );
        }
    );
  }

  saveContract(Map data) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:ContractRepository().SignaContract(data),
            outsideDismiss: false,
            loadingText: '保存中。。。',
          );
        }).then((value) {
      bool result = false;
      if (value != null && value.code == 1) {
        result = true;
      }
      MyContractBLoC().refreshData('ALL','');
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '${value != null && value.msg != null ? value.msg : '创建合同失败'}',
              successTips: '创建合同成功',
              callbackResult: result,
              confirmAction: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            );
          });
    });
  }

  Widget _buildSelectOrderItem(){
    return GestureDetector(
      onTap: () {
        SearchModel searchModel = SearchModel(keyword: '');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PurchaseOrderSearchResultPage(
                      searchModel: searchModel,
                      isContractSelect: true,
                    )
            )
        ).then((value) {
          if(value != null) {
            orderModel = value;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: 80,
              height: 80,
              child: Image.asset(
                'temp/select_order.png',
                package: 'assets',
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: RichText(
                text: TextSpan(
                    text: orderModel.code != null ? '生产订单：${orderModel.code}':'选择关联订单',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          )),
                    ]),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 3, color: Colors.black38)
        ),
      ),
    );
  }

  Widget _buildSelectContractItem(){
    return GestureDetector(
      onTap: (){
        ContractSelectWidget(cacel: () {
          Navigator.pop(context);
        }, rightData: tempList).showPicker(
          context,
          selectTemplate: (template) {
            setState(() {
              templateModel = template;
              print(templateModel.code);
            });
          },
        );
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              width: 80,
              height: 80,
              child: Image.asset(
                'temp/select_contract.png',
                package: 'assets',
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: Column(
                children: <Widget>[
                  Container(
                    child: RichText(
                      text: TextSpan(
                          text: templateModel != null &&
                              templateModel.title != null ? '${templateModel
                              .title}' : '选择合同模板',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                )),
                          ]),
                    ),
                  ),
                  Container(
                    child: Text(
                      '上传纸质合同仅支持电脑端',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 3,color: Colors.black38)
        ),
      ),
    );
  }

}