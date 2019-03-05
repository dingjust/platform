import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// 提现页面
class WithdrawCash extends StatefulWidget {
  _WithdrawCashState createState() => _WithdrawCashState();
}

class _WithdrawCashState extends State<WithdrawCash> {
  String cash ;
  double poundage ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ListView(
              children: <Widget>[
                _buildTopBackgroud(context),
                _buildOne(context),
              ],
            )
        )
    );
  }

  Widget _buildTopBackgroud(BuildContext context) {
    return Container(
      padding:EdgeInsets.fromLTRB(0,5,0,0),
      child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: IconButton(
                          icon:Icon(Icons.chevron_left),
                          color: Colors.white,
                          iconSize: 30,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ),
                      Expanded(
                          child:Center(
                            child: Container(
                              padding: EdgeInsets.only(right: 30),
                              child: Text(
                                '提现',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          )
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                margin:EdgeInsets.fromLTRB(0,50,0,0),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                          child: Text(
                            "￥",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          )
                      ),
                      Container(
                          child: Text(
                            "987652.00",
                            style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.w500,
                                color: Colors.white
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin:EdgeInsets.fromLTRB(0,0,0,50),
                child: Text(
                  '余额',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white
                  ),
                ),
              )
            ],
          )
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [ Color.fromRGBO(255, 80, 1, 1),Color.fromRGBO(255, 140, 0, 1)]),
      ),
    );
  }

  Widget _buildOne(BuildContext context){
    return Container(
      child: Column(
        children: <Widget>[
          _buildWithdrawCash(context),
          Divider(
            height: 1,
          ),
          _buildPoundage(context),
          Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: Text(
                '提现到银行卡',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          _buildBlankCard(context),
          _buildCommitButton(context),
        ],
      ),
    );
  }

  Widget _buildWithdrawCash(BuildContext context){
    return Container(
        color: Colors.white,
        child:GestureDetector(
            child: Container(
              child: ListTile(
                leading: Text(
                  '提现金额￥',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  cash == null ? '输入金额' : cash,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey
                  ),
                ),
              ),
            ),
            onTap: () {
              _neverInputCash(context);
            })
    );
  }

  Widget _buildPoundage(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Text(
          '手续费(自动计算)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Text(
          poundage == null ? '￥0.00' : poundage,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey
          ),
        ),
      ),
    );
  }

  Widget _buildBlankCard(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(20,0,20,20),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 15),
            child: Row(
              children: <Widget>[
                Container(
                  child: Image.network(
                    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1551089271298&di=e86274438d3c8ad92d09a82c412f7eb4&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01f2b45541ad67000001a64b30c1bf.jpg',
                    width: 80,
                    height: 80,
                  ),
                ),
                Expanded(
                    child: Align(
                        alignment:Alignment.centerLeft,
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment:MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 150,
                                child: Text(
                                  '工商银行',
                                ),
                              ),
                              Container(
                                child: Text(
                                    '6212***************4243'
                                ),
                              )
                            ],
                          ),
                        )
                    )
                ),
                Icon(
                    B2BIcons.del_blank_card
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                      child:
                      Text(
                        '＋ 添加银行卡',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFFFF9516),
                        ),
                      )
                  ),
                  Container(
                    child: Text(
                      '支持农行、工行、招行和建行',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black26, width: 0.5),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  //确认按钮
  Widget _buildCommitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: RaisedButton(
              color: Color(0xFFFF9516),
              child: Text(
                '提交申请',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              onPressed: () {
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: 200,
            child: Center(
              child: Text(
                '预计3天内到账',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


  Future<void> _neverInputCash(BuildContext context) async {
    TextEditingController inputNumber = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('请输入提现金额'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: inputNumber,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '请输入提现金额',
                  ),
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
                    cash = inputNumber.text;
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

}
