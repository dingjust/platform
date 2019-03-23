import 'package:b2b_commerce/src/my/company/my_company_certificate.dart';
import 'package:b2b_commerce/src/my/company/my_personal_certificate.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class MyCompanyCertificateSelectPage extends StatefulWidget {
  CompanyModel company;

  MyCompanyCertificateSelectPage(this.company);

  MyCompanyCertificateSelectPageState createState() => MyCompanyCertificateSelectPageState();
}

class MyCompanyCertificateSelectPageState extends State<MyCompanyCertificateSelectPage> {
  //是否是个人认证
  bool _isPersonal = false;
  bool _isCompany = false;
  Text _statusText;
  bool _onlyRead = true;

  @override
  void initState() {
    if(widget.company.approvalStatus == null) _onlyRead = false;
    if(widget.company.type == null){
      _isPersonal = true;
      _isCompany = true;
    }else if (widget.company.type == CompanyType.INDIVIDUAL_HOUSEHOLD) {
      _isPersonal = true;
    } else {
      _isCompany = true;
    }

    if (widget.company.approvalStatus == null)
      _statusText = Text(
        '未认证',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
    if (widget.company.approvalStatus == ArticleApprovalStatus.CHECK)
      _statusText = Text(
        '认证中',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
    if (widget.company.approvalStatus == ArticleApprovalStatus.APPROVED)
      _statusText = Text(
        '认证通过',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );
    if (widget.company.approvalStatus == ArticleApprovalStatus.UNAPPROVED)
      _statusText = Text(
        '认证失败',
        style: TextStyle(
          color: Color.fromRGBO(255, 214, 12, 1),
        ),
      );

    // TODO: implement initState
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
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            _isCompany
                ? InkWell(
                    onTap: () async {
                      print(_onlyRead);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyCompanyCertificatePage(
                                    widget.company,onlyRead: _onlyRead,
                                  )));
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '企业认证',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Offstage(
                              offstage: widget.company.type != CompanyType.BRAND,
                              child: Container(
                                  padding: EdgeInsets.only(right: 15),
                                  child: _statusText)),
                          Offstage(
                              offstage: widget.company.type != CompanyType.FACTORY && widget.company.approvalStatus != null,
                              child: Container(
                                  padding: EdgeInsets.only(right: 15),
                                  child: _statusText)),
                          Text(
                            '企业四要素认证',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  )
                : Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '企业认证',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Text(
                          '企业四要素认证',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(Icons.chevron_right,color: Colors.grey),
                      ],
                    ),
                  ),
            Offstage(
              offstage: UserBLoC.instance.currentUser.type == UserType.FACTORY,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  _isPersonal
                      ? InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyPersonalCertificatePage(widget.company,onlyRead: _onlyRead,)));
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Text(
                                '个人认证',
                                style: TextStyle(fontSize: 17),
                              )),
                          Offstage(
                            offstage: widget.company.type != CompanyType.INDIVIDUAL_HOUSEHOLD && widget.company.type != null,
                            child: Container(
                              padding: EdgeInsets.only(right: 15),
                              child: _statusText,
                            ),
                          ),
                          Text(
                            '个人三要素认证',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Icon(Icons.chevron_right,),
                        ],
                      ),
                    ),
                  )
                      : Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                              '个人认证',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            )),
                        Text(
                          '个人三要素认证',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Icon(Icons.chevron_right,color: Colors.grey),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: !_onlyRead,
              child: Container(
                padding: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width - 16,
                child: ActionChip(
                  labelPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3.5,
                      vertical: 8),
                  backgroundColor: Colors.red,
                  label: Text(
                    '重新认证',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () async {
                    setState(() {
                      _isPersonal = true;
                      _isCompany = true;
                      _onlyRead = false;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
