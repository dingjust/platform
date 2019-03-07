import 'package:b2b_commerce/src/production/offline_order_input_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ProductionEarnestMoney extends StatefulWidget {
  final ApparelProductModel product;

  ProductionEarnestMoney({this.product});
  _ProductionEarnestMoneyState createState() => _ProductionEarnestMoneyState();
}

class _ProductionEarnestMoneyState extends State<ProductionEarnestMoney> {
  String earnestMoney;
  String tailMoney;
  bool isEarnestPayment = false;
  String estimatePaymentDate;
  bool isTailPayment = false;
  String tailPaymentDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('定金尾款'),
            elevation: 0.5,
            brightness: Brightness.light,
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Center(
                      child: Text(
                        '确定',
                        style: TextStyle(
                            color: Color.fromRGBO(255, 149, 22, 1)),
                      ),
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop(earnestMoney);
                  }
              )
            ]
        ),
        body: Container(
            child: ListView(
              children: <Widget>[
                _buildTop(context),
                _buildBottom(context),
              ],
            ))
    );
  }

  Widget _buildTop(BuildContext context) {
    return Container(
      color: Colors.white,
      child:  Column(
          children: <Widget>[
            _buildEarnestMoney(context),
            Divider(
              height: 0,
            ),
            _buildPaymentSelection(context),
            Divider(
              height: 0,
            ),
            _buildEstimatePaymentDate(context),
          ],
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildTailMoney(context),
          Divider(
            height: 0,
          ),
          _buildTailPaymentSelection(context),
          Divider(
            height: 0,
          ),
          _buildTaliPaymentDate(context),
        ],
      ),
    );
  }

  Widget _buildEarnestMoney(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '定金金额',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: earnestMoney == null || earnestMoney == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Text(earnestMoney,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OfflineOrderInputPage(fieldText: '定金金额',inputType: TextInputType.number)),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              earnestMoney = value;
            });
          });
        });
  }

  Widget _buildPaymentSelection(BuildContext context) {
    return CheckboxListTile(
        value: isEarnestPayment,
        title: new Text(
          '是否已付',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        controlAffinity: ListTileControlAffinity.platform,
        onChanged: (bool) {
          setState(() {
            isEarnestPayment = bool;
          });
        });
  }

  //预计支付日期
  Widget _buildEstimatePaymentDate(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '预计支付日期',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: estimatePaymentDate == null || estimatePaymentDate == ''
                  ? Icon(Icons.keyboard_arrow_right)
                  : Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(estimatePaymentDate,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey
                        ),
                        overflow: TextOverflow.ellipsis
                    ),
                  )
              )),
        ),
        onTap: () {
          _showDatePicker('estimate');
        });
  }

  //尾款金额
  Widget _buildTailMoney(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
            leading: Text(
              '定金金额',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: tailMoney == null || tailMoney == ''
                ? Icon(Icons.keyboard_arrow_right)
                : Text(tailMoney,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OfflineOrderInputPage(fieldText: '定金金额',inputType: TextInputType.number)),
            //接收返回数据并处理
          ).then((value) {
            setState(() {
              tailMoney = value;
            });
          });
        });
  }

  Widget _buildTailPaymentSelection(BuildContext context) {
    return CheckboxListTile(
        value: isTailPayment,
        title: new Text(
          '是否已付',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        controlAffinity: ListTileControlAffinity.platform,
        onChanged: (bool) {
          setState(() {
            isTailPayment = bool;
          });
        });
  }

  //预计支付日期
  Widget _buildTaliPaymentDate(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: ListTile(
              leading: Text(
                '预计支付日期',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: tailPaymentDate == null || tailPaymentDate == ''
                  ? Icon(Icons.keyboard_arrow_right)
                  : Container(
                  width: 150,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(tailPaymentDate,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey
                        ),
                        overflow: TextOverflow.ellipsis
                    ),
                  )
              )),
        ),
        onTap: () {
          _showDatePicker('tail');
        });
  }




  //打开日期选择器
  void _showDatePicker(String type) {
    if(type == 'tail'){
      _selectTailDate(context);
    }else{
      _selectDate(context);
    }
  }

  //生成日期选择器
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999));

    if (_picked != null) {
      print(_picked);
      setState(() {
        estimatePaymentDate = DateFormatUtil.formatYMD(_picked);
      });
    }
  }

  //生成日期选择器
  Future<Null> _selectTailDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: new DateTime(1990),
        lastDate: new DateTime(2999));

    if (_picked != null) {
      print(_picked);
      setState(() {
        tailPaymentDate = DateFormatUtil.formatYMD(_picked);
      });
    }
  }

}