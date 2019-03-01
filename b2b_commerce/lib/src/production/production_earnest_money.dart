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
  FocusNode _expectedPriceFocusNode = FocusNode();
  String earnestMoney;
  String tailMoney;
  bool isEarnestPayment = false;
  String estimatePaymentDate;
  bool isTailPayment = false;
  String tailPaymentDate;
  ApparelProductModel _product;

  @override
  void initState() {
    _product = widget.product;
    super.initState();
  }

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
          _neverEarnestMoney(context);
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
          _neverTailMoney(context);
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



  //定金金额
  Future<void> _neverEarnestMoney(BuildContext context) async {
    TextEditingController inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入定金金额'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFieldComponent(
                  controller: inputNumber,
                  focusNode: _expectedPriceFocusNode,
                  autofocus: true,
                  inputType: TextInputType.number,
                  hintText: '请输入定金金额',
                  padding: EdgeInsets.all(0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (inputNumber.text != null) {
                  print(inputNumber.text);
                  setState(() {
                    earnestMoney = inputNumber.text;
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

  //尾款金额
  Future<void> _neverTailMoney(BuildContext context) async {
    TextEditingController inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入尾款金额'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFieldComponent(
                  controller: inputNumber,
                  focusNode: _expectedPriceFocusNode,
                  autofocus: true,
                  inputType: TextInputType.number,
                  hintText: '请输入生产单价',
                  padding: EdgeInsets.all(0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (inputNumber.text != null) {
                  print(inputNumber.text);
                  setState(() {
                    tailMoney = inputNumber.text;
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