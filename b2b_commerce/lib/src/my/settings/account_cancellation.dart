import 'package:b2b_commerce/src/helper/dialog_helper.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';

///账号注销
class AccountCancellationPage extends StatefulWidget {
  const AccountCancellationPage({Key key}) : super(key: key);

  @override
  _AccountCancellationPageState createState() =>
      _AccountCancellationPageState();
}

class _AccountCancellationPageState extends State<AccountCancellationPage> {
  BaseResponse stateResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text('申请注销钉单账号'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListView(
        children: [
          _Important(),
          _Title1(),
          _Title2('账号安全'),
          _Info('账号没有被盗，被封等风险。'),
          _Title2('账号状态'),
          _Info('申请注销的账号应为正常使用中的状态，未被封禁、冻结等'),
          _Title2('账号交易状态'),
          _Info('该账号上没有正在进行的交易订单，没有资金问题待结算。'),
          FutureBuilder(
            future: _getData(),
            builder:
                (BuildContext context, AsyncSnapshot<BaseResponse> snapshot) {
              if (stateResponse != null) {
                if (stateResponse.code == 1) {
                  return _stateInfo();
                } else {
                  return _submitBtn();
                }
              }
              return Container();
            },
          ),
        ],
      ),
    );
  }

  Widget _submitBtn() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            DialogHelper.showConfirm(
                confirm: _submit,
                title: '是否确定注销？',
                content: '账号一经注销将不可恢复，请谨慎操作');
          },
          color: Color(0xff7dc2f9),
          child: Text(
            '申请注销',
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _stateInfo() {
    return Container(
      margin: EdgeInsets.only(top: 50),
      color: Colors.orange[300],
      child: Text(
        '您已提交注销申请，请等待处理',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Future<BaseResponse> _getData() async {
    if (stateResponse == null) {
      stateResponse = await UserRepositoryImpl.cancellationState();
    }
    return stateResponse;
  }

  void _submit() async {
    //获取详情
    Function cancelFunc =
        BotToast.showLoading(crossPage: false, clickClose: false);
    BaseResponse response = await UserRepositoryImpl.accountCancellation();
    cancelFunc.call();
    if (response != null) {
      if (response.code == 1) {
        BotToast.showText(text: '申请成功');
      } else {
        BotToast.showText(text: '${response.msg}');
      }
    } else {
      BotToast.showText(text: '操作失败');
    }
  }
}

class _Important extends StatelessWidget {
  const _Important({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Icon(
            Icons.info,
            color: Color(0xff868fa5),
            size: 80,
          ),
        ),
        Row(
          children: [
            Expanded(
                child: RichText(
                    text: TextSpan(
                        text: '重要提示:',
                        style: TextStyle(
                            color: Color(0xff868fa5),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        children: [
                  TextSpan(
                      text:
                          '钉单账号可以申请注销。为了避免被盗号或非本人操作所带来的损失，注销前需要确认账号所属，以及可能涉及的交易结算。',
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 14))
                ])))
          ],
        )
      ]),
    );
  }
}

class _Title1 extends StatelessWidget {
  const _Title1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Expanded(
              child: Text('申请注销前，您的账号需要满足以下条件:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}

class _Title2 extends StatelessWidget {
  final String text;

  const _Title2(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          Container(width: 20, child: Text('·')),
          Expanded(
              child: Text('$text:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  final String text;

  const _Info(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 20,
          ),
          Expanded(
              child: Text('$text',
                  style: TextStyle(fontSize: 16, color: Colors.grey)))
        ],
      ),
    );
  }
}
