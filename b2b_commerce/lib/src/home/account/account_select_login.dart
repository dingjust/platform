import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

///账号选择登录
class AccountSelectLogin extends StatefulWidget {
  final String phone;

  final String code;

  final List<B2BCustomerModel> data;

  const AccountSelectLogin({Key key, this.phone, this.code, this.data})
      : super(key: key);

  @override
  _AccountSelectLoginState createState() => _AccountSelectLoginState();
}

class _AccountSelectLoginState extends State<AccountSelectLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('账号登录'),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('请选择登录账号')],
            ),
          ),
          ...widget.data
              ?.map((e) => Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => _onTap(e.uid),
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '公司：${e?.groups?.first?.name ?? ''}'),
                                      Text('名称：${e.name}'),
                                      Text(
                                        'UID：${e.uid}',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey,
                                )
                              ],
                            )),
                      ),
                    ),
                  ))
              ?.toList()
        ],
      ),
    );
  }

  void _onTap(String uid) async {
    Function cancelFunc = BotToast.showLoading(crossPage: false);
    BaseResponse response = await UserRepositoryImpl.selectLoginAccount(
        widget.phone, uid, widget.code);
    if (response == null) {
      BotToast.showText(text: '未知错误');
    } else {
      if (response.code == 0) {
        BotToast.showText(text: '${response.msg}');
      } else {
        LoginResult result = await UserBLoC.instance
            .loginByAuthorizationCode(code: widget.code, remember: true);
        cancelFunc.call();
        if (result == LoginResult.SUCCESS) {
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
        } else {
          BotToast.showText(text: '登录失败');
        }
      }
    }
  }
}
