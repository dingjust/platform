import 'package:b2b_commerce/src/business/search/purchase_order_search_result.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/my/contract/contract_temp_page.dart';
import 'package:b2b_commerce/src/my/contract/contract_seal_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ContractWTSCHTFrom extends StatefulWidget {
  _ContractWTSCHTFromState createState() => _ContractWTSCHTFromState();
}

class _ContractWTSCHTFromState extends State<ContractWTSCHTFrom> {
  PurchaseOrderModel orderModel ;
  bool isA = false;
  bool isB = false;
  List<ContractTemplateModel> tempList;
  ContractTemplateModel temp;

  @override
  void initState() {
    initSeal();
    super.initState();
  }

  initSeal() async{
    tempList = await ContractRepository().getContractTemplateList({'type':'WTSCHT'}, {'page':'0','size':'100'});
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
        )
    );
  }

  saveContract() async{
    String role = '';
    if(!isA && !isB){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择甲乙方',
              callbackResult: false,
            );
          }
      );
    }
    else if(orderModel == null || orderModel.code ==null || orderModel.code == ''){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择订单',
              callbackResult: false,
            );
          }
      );
    }
    else if(temp == null || temp.code ==null || temp.code == ''){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择模板',
              callbackResult: false,
            );
          }
      );
    }else {
      if(isA){
        role = 'PARTYA';
      }else if(isB){
        role = 'PARTYB';
      }
      Map data = {
        'userTempCode': temp.code,
        'userSignCode': '',
        'role': role,
        'title': '00000',
        'orderCode': orderModel.code,
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
        MyContractBLoC().refreshData('ALL','');
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                failTips: '${value != null && value.msg != null
                    ? value.msg
                    : '创建合同失败'}',
                successTips: '创建合同成功',
                callbackResult: result,
                confirmAction: () {
                  if(result) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }else{
                    Navigator.of(context).pop();
                  }
                },
              );
            });
      });
    }
  }

  Widget _buildMain(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        '签订方式',
                      style: TextStyle(
                        fontSize: 18
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                      '新签电子合同',
                    style: TextStyle(
                        fontSize: 18
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
          Divider(
              height: 2, color: Color.fromRGBO(245, 245, 245, 30)),
          GestureDetector(
            onTap: (){
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
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '选择订单',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${orderModel != null? orderModel.code:''}',
                      style: TextStyle(
                          fontSize: 18
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
          Divider(
              height: 2, color: Color.fromRGBO(245, 245, 245, 30)),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ContractTempSelectPage(list: tempList,title: '委托生产合同模板',)
                  )
              ).then((value) {
                temp = value;
              });
            },
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '选择模板',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${temp == null ? '':temp.title}',
                      style: TextStyle(
                          fontSize: 18
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
          Divider(
              height: 2, color: Color.fromRGBO(245, 245, 245, 30)
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isA = !isA;
                      isB = false;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width / 2.1,
                    height: 60,
                    child: Center(child: Text('我是甲方')),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54,width: 1),
                      borderRadius: BorderRadius.circular(8),
                      color: isA?Color.fromRGBO(255, 214, 12, 1):Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isB = !isB;
                      isA = false;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width / 2.1,
                    height: 60,
                    child: Center(child: Text('我是乙方')),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54,width: 1),
                      borderRadius: BorderRadius.circular(8),
                      color: isB?Color.fromRGBO(255, 214, 12, 1):Colors.white,
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


}