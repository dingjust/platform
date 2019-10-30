import 'package:b2b_commerce/src/my/contract/contract_suppliers.dart';
import 'package:b2b_commerce/src/my/contract/contract_temp_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:core/core.dart';

class ContractKJXYFrom extends StatefulWidget {
  _ContractKJXYFromState createState() => _ContractKJXYFromState();
}

class _ContractKJXYFromState extends State<ContractKJXYFrom> {
  PurchaseOrderModel orderModel ;
  bool isA = false;
  bool isB = false;
  List<ContractTemplateModel> kjxyTempList;
  ContractTemplateModel kjxyTemp;
  DateTime validityStart;
  DateTime validityEnd;
  FactoryModel supplierModel;

  @override
  void initState() {
    initSeal();
    super.initState();
  }

  initSeal() async{
    kjxyTempList = await ContractRepository().getContractTemplateList({'type':'KJXY'}, {'page':'0','size':'100'});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('采购订单合同'),
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
    else if(supplierModel == null || supplierModel.uid ==null || supplierModel.uid == ''){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择签署对象',
              callbackResult: false,
            );
          }
      );
    }else if(validityEnd == null || validityStart == null){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialog(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '请选择合同有效期',
              callbackResult: false,
            );
          }
      );
    }else if(kjxyTemp == null || kjxyTemp.code ==null || kjxyTemp.code == ''){
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
        'userTempCode': kjxyTemp.code,
        'userSignCode': '',
        'role': role,
        'title': '00000',
        'validityEnd': DateFormatUtil.formatYMD(validityEnd),
        'validityStart': DateFormatUtil.formatYMD(validityStart),
        'isFrame' : true,
//        'orderCode': orderModel.code,
        'partnerCompanyCode':supplierModel.id,
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ContractSuppliersPage(
                          )
                  )
              ).then((value){
                setState(() {
                  supplierModel = value;
                });
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
                        '签署对象',
                        style: TextStyle(
                            fontSize: 18
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${supplierModel!=null? supplierModel.name:''}',
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
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Text(
                    '合同有效期',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _showDatePicker(1);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      validityStart != null?
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${DateFormatUtil.formatYMD(validityStart)}',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ):
                      Container(
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
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
              ),
                GestureDetector(
                  onTap: (){
                    _showDatePicker(2);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      validityEnd != null?
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${DateFormatUtil.formatYMD(validityEnd)}',
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                      ):
                      Container(
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
          Divider(
              height: 2, color: Color.fromRGBO(245, 245, 245, 30)),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ContractTempSelectPage(list: kjxyTempList,title: '框架协议合同模板',)
                  )
              ).then((value) {
                kjxyTemp = value;
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
                      '${kjxyTemp == null? '':kjxyTemp.title}',
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


  //打开日期选择器
  void _showDatePicker(int index) {
    _selectDate(context,index);
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context,int index) async {
    DateTime nowTime = DateTime.now();
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: nowTime,
        firstDate: nowTime,
        lastDate: DateTime(2999));

    if (_picked != null) {
      setState(() {
        if(index == 1) {
          validityStart = _picked;
        }
        if(index == 2){
          validityEnd = _picked;
        }
      });
    }
  }

}