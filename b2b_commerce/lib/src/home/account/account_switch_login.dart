import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

///账号选择登录(切换登录)
class AccountSwitchLogin extends StatefulWidget {
  const AccountSwitchLogin({Key key}) : super(key: key);

  @override
  _AccountSwitchLoginState createState() => _AccountSwitchLoginState();
}

class _AccountSwitchLoginState extends State<AccountSwitchLogin> {
  List<B2BCustomerModel> accounts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('账号切换'),
        ),
        body: Container(
          // color: Colors.white,
          child: FutureBuilder(
            future: _getData(),
            builder: (context, AsyncSnapshot<List<B2BCustomerModel>> snapshot) {
              if (snapshot.hasData && accounts != null) {
                return ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('请选择登录账号')],
                      ),
                    ),
                    ...accounts
                        ?.map((e) => Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
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
                                                  style: TextStyle(
                                                      color: Colors.grey),
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
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  Future<List<B2BCustomerModel>> _getData() async {
    if (accounts == null) {
      BaseResponse baseResponse =
          await UserRepositoryImpl.getRelationAccounts();
      if (baseResponse != null) {
        if (baseResponse.code == 1) {
          List<B2BCustomerModel> models = (baseResponse.data as List)
              ?.map((e) => e == null
                  ? null
                  : B2BCustomerModel.fromJson(e as Map<String, dynamic>))
              ?.toList();
          accounts = models;
        } else if (baseResponse.code == 0) {
          BotToast.showText(text: baseResponse.msg);
        }
      } else {
        BotToast.showText(text: '获取关联账号失败');
      }
    }

    return accounts;
  }

  void _onTap(String uid) async {
    Function cancelFunc = BotToast.showLoading(crossPage: false);
    BaseResponse response = await UserRepositoryImpl.switchAccount(uid);
    if (response == null) {
      BotToast.showText(text: '未知错误');
    } else {
      if (response.code == 0) {
        BotToast.showText(text: '${response.msg}');
      } else if (response.code == 1 && response.data != null) {
        LoginResult result = await UserBLoC.instance
            .loginByAuthorizationCode(code: response.data, remember: true);
        cancelFunc.call();
        if (result == LoginResult.SUCCESS) {
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
        } else {
          BotToast.showText(text: '登录失败');
        }
      }
    }
    cancelFunc.call();
  }
}
