import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:b2b_commerce/src/my/authentication/authentication_enterprise_from.dart';
import 'package:b2b_commerce/src/my/authentication/authentication_person_from.dart';
import 'package:b2b_commerce/src/my/authentication/my_authentication_enterprise_result.dart';
import 'package:b2b_commerce/src/my/authentication/my_authentication_result.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyAuthentication extends StatefulWidget {
  CompanyModel company;

  MyAuthentication({this.company});

  @override
  _MyAuthenticationState createState() => _MyAuthenticationState();
}

class _MyAuthenticationState extends State<MyAuthentication> {
  //选的是否是企业认证
  bool _isCompany = false;

  @override
  void initState() {
    //埋点>>>我要认证
    UmengPlugin.onEvent('my_authentication');
    //权限预获取
    // PermissionHelper.check();

    super.initState();
  }

  Future<CertificationState> _getData() async {
    // 查询明细
    CertificationState model =
    await ContractRepository().getAuthenticationState();
    AuthenticationModel authenticationModel = model.data;

    if (authenticationModel.companyType != null &&
        authenticationModel.companyType == CompanyTypeState.ENTERPRISE) {
      _isCompany = true;
    }
    return model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.buildDefaultAppBar('我要认证'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
        child: FutureBuilder<CertificationState>(
          builder: (BuildContext context,
              AsyncSnapshot<CertificationState> snapshot) {
            if (snapshot.data != null) {
              return Column(
                children: <Widget>[
                  _buildEnterpriseItem(snapshot.data.data),
                  // _buildIndividualBusinessItem(snapshot.data.data),
                  _buildPersonalItem(snapshot.data.data),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          initialData: null,
          future: _getData(),
        ),
      ),
    );
  }

  Widget _buildEnterpriseItem(AuthenticationModel model) {
    return GestureDetector(
      onTap: () => _onEnterprise(model),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          margin: EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Text(
                          '企业认证',
                          style:
                              TextStyle(color: Color(0xFFAA6E15), fontSize: 16),
                        ),
                        _Tag(
                          state: model.companyState,
                        )
                      ],
                    ),
                  ),
                  Container(
                      child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        '申请企业认证后，不可以再申请个人认证',
                        style:
                            TextStyle(color: Color(0xFF666666), fontSize: 12),
                      ))
                    ],
                  ))
                ],
              )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.chevron_right,
                    color: Color(0xFF999999),
                  ))
            ],
          )),
    );
  }

  Widget _buildPersonalItem(AuthenticationModel model) {
    return GestureDetector(
      onTap: () => _onPersonal(model),
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          margin: EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              '个人认证',
                              style:
                              TextStyle(color: Color(0xFFAA6E15), fontSize: 16),
                            ),
                            _Tag(
                              state: model.personalState,
                            )
                          ],
                        ),
                      ),
                      Container(
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                    '申请个人实名认证后，还可以申请企业认证',
                                    style:
                                    TextStyle(
                                        color: Color(0xFF666666), fontSize: 12),
                                  ))
                            ],
                          ))
                    ],
                  )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    Icons.chevron_right,
                    color: Color(0xFF999999),
                  ))
            ],
          )),
    );
  }

  void _onEnterprise(AuthenticationModel model) async {
    if ((!_isCompany && model.companyState == AuthenticationState.CHECK) ||
        model.personalState == AuthenticationState.CHECK) {
      promptingDialog();
    } else if (_isCompany || model.companyType == null) {
      Widget _target;

      if (model.companyState == AuthenticationState.UNCERTIFIED) {
        _target = AuthenticationEnterpriseFromPage();
      } else if (model.companyState == AuthenticationState.SUCCESS) {
        _target = MyAuthenticationEnterpriseResult(
          isCompany: _isCompany,
          authenticationModel: model,
        );
      } else if (model.companyState == AuthenticationState.FAILED ||
          model.companyState == AuthenticationState.FAIL) {
        _target = AuthenticationEnterpriseFromPage();
      } else if (model.companyState == AuthenticationState.CHECK) {
        _target = MyAuthenticationEnterpriseResult(
          isCompany: _isCompany,
          authenticationModel: model,
        );
      }
      if (_target != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _target),
        ).then((value) {
          setState(() {});
        });
      }
    }
  }

  void _onPersonal(AuthenticationModel model) async {
    if (model.companyState == AuthenticationState.CHECK) {
      promptingDialog();
    } else if (model.companyState != AuthenticationState.SUCCESS) {
      Widget _target;

      if (model.personalState == AuthenticationState.CHECK ||
          model.personalState == AuthenticationState.SUCCESS) {
        _target = MyAuthenticationResult(
          state: model.personalState,
        );
      } else {
        _target = AuthenticationPersonFromPage();
      }
      if (_target != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => _target),
        ).then((value) {
          setState(() {});
        });
      }
    }
  }

  enterprise() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            PurchaseOrderRepository().enterpriseCertification(),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((value) {
      Certification certification = value;
      if (certification != null) {
        if (certification.data != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebviewPage(url: certification.data)),
          );
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CustomizeDialog(
                  dialogType: DialogType.RESULT_DIALOG,
                  failTips: certification.msg,
                  callbackResult: false,
                  confirmAction: () {
                    Navigator.of(context).pop();
                  },
                );
              });
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                failTips: '认证失败',
                callbackResult: false,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
      }
    });
  }

  individualBusiness() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            PurchaseOrderRepository().individualBusiness('1', '2'),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((value) {
      Certification certification = value;
      if (certification != null) {
        if (certification.data != null) {
//          _launchURL(certification.data);
          print(certification.data);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebviewPage(url: certification.data)),
          );
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CustomizeDialog(
                  dialogType: DialogType.RESULT_DIALOG,
                  failTips: certification.msg,
                  callbackResult: false,
                  confirmAction: () {
                    Navigator.of(context).pop();
                  },
                );
              });
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                failTips: '认证失败',
                callbackResult: false,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
      }
    });
  }

  personal() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ContractRepository().personalAuthentication({}),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((value) {
      Certification certification = value;
      print(certification.msg);
      if (certification != null) {
        if (certification.data != null) {
//          _launchURL(certification.data);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebviewPage(url: certification.data)),
          );
        } else {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return CustomizeDialog(
                  dialogType: DialogType.RESULT_DIALOG,
                  failTips: certification.msg,
                  callbackResult: false,
                  confirmAction: () {
                    Navigator.of(context).pop();
                  },
                );
              });
        }
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return CustomizeDialog(
                dialogType: DialogType.RESULT_DIALOG,
                failTips: '认证失败',
                callbackResult: false,
                confirmAction: () {
                  Navigator.of(context).pop();
                },
              );
            });
      }
    });
  }

  promptingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '正在进行其他认证，请等待认证流程完成后再进行操作',
            callbackResult: false,
            confirmAction: () {
              Navigator.of(context).pop();
            },
          );
        });
  }
}

class _Tag extends StatelessWidget {
  final AuthenticationState state;

  const _Tag({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state == null || (!AuthenticationState.values.contains(state))) {
      return Container();
    }

    return Container(
        margin: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
            color: _AuthenticationStateColorMap[state],
            borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.fromLTRB(9, 0, 9, 2),
        child: Text(
          '${AuthenticationStateLocalizedMap[state]}',
          style: TextStyle(
              fontSize: 10,
              color: state == AuthenticationState.UNCERTIFIED
                  ? Color(0xFF222222)
                  : Colors.white),
        ));
  }
}

const _AuthenticationStateColorMap = {
  AuthenticationState.UNCERTIFIED: Color(0xFFD8D8D8),
  AuthenticationState.CHECK: Color.fromRGBO(255, 214, 12, 1),
  AuthenticationState.SUCCESS: Colors.green,
  AuthenticationState.FAILED: Color(0xFFFF4D4F),
  AuthenticationState.FAIL: Color(0xFFFF4D4F),
};
