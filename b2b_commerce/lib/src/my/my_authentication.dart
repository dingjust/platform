import 'package:b2b_commerce/src/my/contract/webview_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets/widgets.dart';
import 'package:b2b_commerce/src/my/contract/contract_webview_page.dart';

class MyAuthentication extends StatefulWidget {
  CompanyModel company;

  MyAuthentication({this.company});

  @override
  _MyAuthenticationState createState() => _MyAuthenticationState();
}

class _MyAuthenticationState extends State<MyAuthentication> {
  //选的是否是个人认证
  bool _isPersonal = false;

  //选的是否是企业认证
  bool _isCompany = false;
  Text _statusText;

  //是否只读
  bool _onlyRead = true;

  @override
  void initState() {
    if (widget.company.approvalStatus == null) _onlyRead = false;
    if (widget.company.type == null) {
      _isPersonal = true;
      _isCompany = true;
    } else if (widget.company.type == CompanyType.INDIVIDUAL_HOUSEHOLD) {
      _isPersonal = true;
    } else {
      _isCompany = true;
    }

    if (widget.company.approvalStatus == null)
      _statusText = Text(
        '未认证',
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    if (widget.company.approvalStatus == ArticleApprovalStatus.check)
      _statusText = Text(
        '认证中',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
    if (widget.company.approvalStatus == ArticleApprovalStatus.approved)
      _statusText = Text(
        '认证通过',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
    if (widget.company.approvalStatus == ArticleApprovalStatus.unapproved)
      _statusText = Text(
        '认证失败',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('我要认证'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              _buildEnterpriseItem(),
              _buildIndividualBusinessItem(),
              _buildPersonalItem(),
            ],
          ),
        )
    );
  }

  Widget _buildEnterpriseItem(){
    return GestureDetector(
      onTap: () async {
        enterprise();
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                child: Text(
                  '企业认证',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: _statusText,
              ),
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

  Widget _buildIndividualBusinessItem(){
    return GestureDetector(
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                '个体户认证',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: _statusText,
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

  Widget _buildPersonalItem(){
    return GestureDetector(
      onTap: () async {
        personal();
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 5),
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                '个人认证',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: _statusText,
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

  enterprise(){
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
        if(certification.data !=  null){
//          _launchURL(certification.data);
          Navigator.push(
            context,MaterialPageRoute(builder: (context) => WebView111Page(urlString :certification.data)),
          );
        }else{
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
      }else{
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

  personal(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return RequestDataLoading(
            requestCallBack:
            PurchaseOrderRepository().personalCertification(),
            outsideDismiss: false,
            loadingText: '请稍候。。。',
            entrance: '',
          );
        }).then((value) {
      Certification certification = value;
      if (certification != null) {
        if(certification.data !=  null){
//          _launchURL(certification.data);
          Navigator.push(
            context,MaterialPageRoute(builder: (context) => WebView111Page(urlString:certification.data)),
          );
        }else{
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
      }else{
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
