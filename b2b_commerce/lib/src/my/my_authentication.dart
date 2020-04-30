import 'package:b2b_commerce/src/my/authentication/authentication_business_from.dart';
import 'package:b2b_commerce/src/my/authentication/authentication_enterprise_from.dart';
import 'package:b2b_commerce/src/my/authentication/authentication_person_from.dart';
import 'package:b2b_commerce/src/my/authentication/my_authentication_enterprise_result.dart';
import 'package:b2b_commerce/src/my/authentication/my_authentication_result.dart';
import 'package:b2b_commerce/src/my/contract/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
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

  var _futureBuilderFuture;

  @override
  void initState() {
    //埋点>>>我要认证
    FlutterUmplus.event(
      "my_authentication",
    );
    _futureBuilderFuture = _getData();

    super.initState();
  }

  Widget setAuthenticationStateText(AuthenticationModel model) {
    if (model.companyState == AuthenticationState.UNCERTIFIED)
      return Text(
        '未认证',
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    if (model.companyState == AuthenticationState.CHECK)
      return Text(
        '认证中',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
    if (model.companyState == AuthenticationState.SUCCESS)
      return Text(
        '认证通过',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
    if (model.companyState == AuthenticationState.FAILED)
      return Text(
        '认证失败',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
  }

  Widget setPersonalAuthenticationStateText(AuthenticationModel model) {
    if (model.personalState == AuthenticationState.UNCERTIFIED)
      return Text(
        '未认证',
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    if (model.personalState == AuthenticationState.CHECK)
      return Text(
        '认证中',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
    if (model.personalState == AuthenticationState.SUCCESS)
      return Text(
        '认证通过',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
    if (model.personalState == AuthenticationState.FAILED)
      return Text(
        '认证失败',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
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
    print(_isCompany);
    return model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我要认证'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: FutureBuilder<CertificationState>(
        builder:
            (BuildContext context, AsyncSnapshot<CertificationState> snapshot) {
          if (snapshot.data != null) {
            return Column(
              children: <Widget>[
                _buildEnterpriseItem(snapshot.data.data),
                _buildIndividualBusinessItem(snapshot.data.data),
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
        future: _futureBuilderFuture,
      ),
    );
  }

  Widget _buildEnterpriseItem(AuthenticationModel model) {
    return GestureDetector(
      onTap: () async {
        // 个体户认证且认证中 || 个人认证
        if ((!_isCompany && model.companyState == AuthenticationState.CHECK) ||
            model.personalState == AuthenticationState.CHECK) {
          promptingDialog();
        } else if (_isCompany || model.companyType == null) {
          if (model.companyState == AuthenticationState.UNCERTIFIED) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AuthenticationEnterpriseFromPage()),
            );
          }
          if (model.companyState == AuthenticationState.SUCCESS) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyAuthenticationEnterpriseResult(
                        isCompany: _isCompany,
                        authenticationModel: model,
                      )),
            );
          }
          if (model.companyState == AuthenticationState.FAILED) {}
          if (model.companyState == AuthenticationState.CHECK) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyAuthenticationEnterpriseResult(
                        isCompany: _isCompany,
                        authenticationModel: model,
                      )),
            );
          }
        } else {
          null;
        }
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                '企业认证',
                style: TextStyle(
                    fontSize: 20,
                    // color: model.companyState == AuthenticationState.UNCERTIFIED
                    //     ? Colors.black
                    //     : Colors.grey),
                    color: (model.companyState ==
                        AuthenticationState.UNCERTIFIED &&
                        model.personalState == AuthenticationState.UNCERTIFIED)
                        || (_isCompany &&
                            (model.companyState == AuthenticationState.CHECK ||
                                model.companyState ==
                                    AuthenticationState.SUCCESS))
                        ? Colors.black
                        : Colors.grey),
              ),
            ),
            Expanded(
              child: _isCompany || model.companyType == null
                  ? setAuthenticationStateText(model)
                  : Container(),
              flex: 2,
            ),
            Container(
              child: Text(
                '对公账户打款认证',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndividualBusinessItem(AuthenticationModel model) {
    return GestureDetector(
      onTap: () {
        // 企业认证且认证中 || 个人认证中
        if ((_isCompany && model.companyState == AuthenticationState.CHECK) ||
            model.personalState == AuthenticationState.CHECK) {
          promptingDialog();
        } else if (!_isCompany || model.companyType == null) {
          if (model.companyState == AuthenticationState.UNCERTIFIED) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AuthenticationBusinessFromPage()),
            );
          }
          if (model.companyState == AuthenticationState.CHECK ||
              model.companyState == AuthenticationState.SUCCESS) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyAuthenticationEnterpriseResult(
                        isCompany: _isCompany,
                      )),
            );
          }
          if (model.companyState == AuthenticationState.FAILED) {}
        } else {
          null;
        }
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                '个体户认证',
                style: TextStyle(
                    fontSize: 20,
                    // color: model.companyState == AuthenticationState.UNCERTIFIED
                    //     ? Colors.black
                    //     : Colors.grey),
                    color: (model.companyState ==
                        AuthenticationState.UNCERTIFIED &&
                        model.personalState == AuthenticationState.UNCERTIFIED)
                        || (!_isCompany &&
                            (model.companyState == AuthenticationState.CHECK ||
                                model.companyState ==
                                    AuthenticationState.SUCCESS))
                        ? Colors.black
                        : Colors.grey),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: !_isCompany || model.companyType == null
                    ? setAuthenticationStateText(model)
                    : Container(),
              ),
              flex: 2,
            ),
            Container(
              child: Text(
                '线上申请，线下认证',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              child: Icon(
                Icons.keyboard_arrow_right,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalItem(AuthenticationModel model) {
    final UserBLoC bloc = BLoCProvider.of<UserBLoC>(context);

    return GestureDetector(
      onTap: () async {
        if (model.companyState == AuthenticationState.CHECK) {
          promptingDialog();
        } else if (bloc.isBrandUser &&
            model.companyState != AuthenticationState.SUCCESS) {
          if (model.personalState == AuthenticationState.UNCERTIFIED) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AuthenticationPersonFromPage()),
            );
          }
          if (model.personalState == AuthenticationState.CHECK ||
              model.personalState == AuthenticationState.SUCCESS) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyAuthenticationResult()),
            );
          }
          if (model.personalState == AuthenticationState.FAILED) {}
        }
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                '个人认证',
                style: TextStyle(
                    fontSize: 20,
                    // color:
                    // model.personalState == AuthenticationState.UNCERTIFIED
                    //     ? Colors.black
                    //     : Colors.grey),
                    color: (model.companyState ==
                        AuthenticationState.UNCERTIFIED &&
                        model.personalState == AuthenticationState.UNCERTIFIED)
                        || model.personalState == AuthenticationState.CHECK ||
                        model.personalState == AuthenticationState.SUCCESS
                        ? Colors.black
                        : Colors.grey),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: model.companyState == AuthenticationState.UNCERTIFIED
                    ? setPersonalAuthenticationStateText(model)
                    : Container(),
              ),
              flex: 2,
            ),
            Container(
              child: Text(
                '人脸识别',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              child: Icon(Icons.keyboard_arrow_right,
                  size: 28,
                  color: widget.company.approvalStatus == null
                      ? Colors.black
                      : Colors.grey),
            ),
          ],
        ),
      ),
    );
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
                builder: (context) =>
                    WebView111Page(urlString: certification.data)),
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
                builder: (context) =>
                    WebView111Page(urlString: certification.data)),
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
                builder: (context) =>
                    WebView111Page(urlString: certification.data)),
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
