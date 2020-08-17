import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'authentication_enterprise_from.dart';

class MyAuthenticationEnterpriseResult extends StatefulWidget {
  bool isCompany;
  AuthenticationModel authenticationModel;

  MyAuthenticationEnterpriseResult({this.isCompany: false, this.authenticationModel});

  @override
  _MyAuthenticationEnterpriseResultState createState() =>
      _MyAuthenticationEnterpriseResultState();
}

class _MyAuthenticationEnterpriseResultState
    extends State<MyAuthenticationEnterpriseResult> {
  var _futureBuilderFuture;

  CertificationInfo certificationInfo;

  @override
  void initState() {
    _futureBuilderFuture = _getData();

    super.initState();
  }

  Future<CertificationInfo> _getData() async {
    // 查询明细
    CertificationInfo model =
    await ContractRepository().getAuthenticationInfoEnterprise();
    certificationInfo = model;
    return model;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('企业认证'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: FutureBuilder<CertificationInfo>(
          builder: (BuildContext context,
              AsyncSnapshot<CertificationInfo> snapshot) {
            if (snapshot.data != null) {
              return Container(
                  child: Stack(
                    children: [
                      _buildEnterprise(snapshot.data.data),
                      Positioned(right: 20, top: 10, child: _getAuthStateIcon())
                    ],
                  ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          initialData: null,
          future: _futureBuilderFuture,
        ),
        bottomNavigationBar: _buildButton());
  }

  Widget _getAuthStateIcon() {
    if (widget.authenticationModel.companyState ==
        AuthenticationState.SUCCESS) {
      return B2BImage.auth_success(width: 150, height: 150);
    } else if (widget.authenticationModel.companyState ==
        AuthenticationState.FAILED) {
      return B2BImage.auth_fail(width: 150, height: 150);
    } else {
      return Container();
    }
  }

  Widget _buildButton() {
    if (widget.authenticationModel.companyState ==
        AuthenticationState.SUCCESS) {
      return Container(
        color: Colors.white10,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 50,
        child: RaisedButton(
          color: Colors.red,
          child: Text(
            '重新认证',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AuthenticationEnterpriseFromPage()),
            );
          },
        ),
      );
    } else if (widget.authenticationModel.companyState ==
        AuthenticationState.CHECK) {
      return Container(
        color: Colors.white10,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 50,
        child: RaisedButton(
          color: Colors.red,
          child: Text(
            '继续认证',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          onPressed: () {
            keepOnAuthentication(certificationInfo.data);
          },
        ),
      );
    } else {
      Container();
    }
//    if(authenticationModel.companyState == AuthenticationState.CHECK){
//      return Container(
//        color: Colors.white10,
//        margin: EdgeInsets.all(10),
//        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//        height: 50,
//        child: RaisedButton(
//          color: Colors.red,
//          child: Text(
//            '继续认证',
//            style: TextStyle(
//              color: Colors.white,
//              fontSize: 18,
//            ),
//          ),
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.all(Radius.circular(5))),
//          onPressed: (){
//            keepOnAuthentication(certificationInfo.data);
//          },
//        ),
//      );
//    }
  }

  keepOnAuthentication(AuthenticationInfoModel model) {
    Map map = {
      'companyName': '${model.name}',
      'organization': model.organization,
    };
    enterprise(map);
  }

  enterprise(Map map) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack: ContractRepository().enterpriseAuthentication(map),
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

  Widget _buildEnterprise(AuthenticationInfoModel model) {
    return ListView(
      children: <Widget>[
        _buildInfo('企业名称', '${model.name}'),
        _buildInfo('社会信用代码', '${model.organization}'),
        _buildInfo(
            '法定代表人', '${model?.legal?.name == null ? '' : model.legal.name}'),
      ],
    );
  }

  Widget _buildInfo(String left, String right) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Text(
                '${left}',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Container(
            child: Text(
              '${right}',
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
