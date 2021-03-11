import 'package:b2b_commerce/src/home/account/login_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'integral_exchange_success.dart';

class IntegralExchangePage extends StatefulWidget {
  @override
  _IntegralExchangePageState createState() => _IntegralExchangePageState();
}

class _IntegralExchangePageState extends State<IntegralExchangePage> {
  UserIntegralInfo info;
  IntegralExchangeRule rule;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('福利红包'),
      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (info != null && rule != null) {
            return Container(
              child: ListView(
                children: [
                  _RuleCard(
                    rule: rule,
                  ),
                  _buildFormCard(),
                  _buildSubmitBtn()
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<bool> _getData() async {
    if (info == null || rule == null) {
      info = await IntegralRepository.getIntegralInfo();
      rule = await IntegralRepository.getIntegraExchangeRule();
      return true;
    }
    return false;
  }

  Widget _buildFormCard() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [Text('可兑换积分：'), Text('${info.availablePoints}')],
          ),
          InputRow(
              leading: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(
                  B2BIcons.integral,
                  color: Color(0xFFff952f),
                ),
              ),
              surfix: GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.text = info.availablePoints.toString();
                  });
                },
                child: Text(
                  '全部',
                  style: TextStyle(color: Color(0xFFff952f)),
                ),
              ),
              field: TextField(
                autofocus: true,
                onChanged: onChange,
                controller: _controller,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _InputFormat(info.availablePoints)
                ],
                autocorrect: true,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: '请输入兑换分数'),
              )),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Text('可获：'),
                Text('￥${getExchangeAmount()}',
                    style: TextStyle(
                      color: Colors.red,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFFff952f))),
                onPressed: onSubmit,
                child: Text('兑换')),
          )
        ],
      ),
    );
  }

  void onSubmit() async {
    //校验
    int point = int.parse(_controller.text, onError: (val) => 0);
    if (point > 0 && point <= info.availablePoints) {
      _submit(point);
    } else {
      BotToast.showText(text: '请输入正确积分数');
    }
  }

  void _submit(int val) async {
    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: false);
    BaseResponse response = await IntegralRepository.integraExchange({
      'points': val,
      'exchangeType': 'MONEY',
    });
    cancelFunc.call();
    if (response != null) {
      BotToast.showText(text: '${response.msg}');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => IntegralExchangeSuccessPage()),
          result: true);
    } else {
      BotToast.showText(text: '申请失败');
    }
  }

  void onChange(String val) {
    setState(() {});
  }

  String getExchangeAmount() {
    int point = int.parse(_controller.text, onError: (val) => 0);
    int amount = (point * (rule.amount / rule.points)).toInt();
    return amount.toStringAsFixed(2);
  }
}

class _RuleCard extends StatelessWidget {
  final IntegralExchangeRule rule;

  final TextStyle textStyle;

  const _RuleCard({
    Key key,
    this.rule,
    this.textStyle = const TextStyle(
        color: Colors.white, fontSize: 38, fontWeight: FontWeight.bold),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFFff952f),
                  Color(0xFFffdc97),
                ]),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                child: Icon(
              B2BIcons.integral,
              color: Color.fromRGBO(255, 149, 47, 0.2),
              size: 100,
            )),
            Positioned(
                left: 10,
                top: 10,
                child: Text(
                  '兑换比例',
                  style: TextStyle(color: Colors.white),
                )),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Icon(
                            B2BIcons.integral,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        Text(
                          rule.points?.toString() ?? '0',
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      B2BIcons.swap,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Row(
                      children: [
                        Text(
                          '￥',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Text(
                          rule.amount?.toString() ?? '0',
                          style: textStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}

class _InputFormat extends TextInputFormatter {
  final int max;

  _InputFormat(this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int point = int.parse(newValue.text, onError: (str) => 0);
    String result = point.toString();
    if (point > max) {
      result = max.toString();
    } else if (point < 0) {
      result = '0';
    }

    return new TextEditingValue(
      text: result,
      selection: new TextSelection.collapsed(offset: result.length),
    );
  }
}
