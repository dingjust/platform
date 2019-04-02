import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import './company/my_company_certificate.dart';
import './company/my_personal_certificate.dart';

class MyCompanyCertificateSelectPage extends StatefulWidget {
  MyCompanyCertificateSelectPage(this.company);

  CompanyModel company;

  MyCompanyCertificateSelectPageState createState() => MyCompanyCertificateSelectPageState();
}

class MyCompanyCertificateSelectPageState extends State<MyCompanyCertificateSelectPage> {
  //选的是否是个人认证
  bool _isPersonal = false;

  //选的是否是企业认证
  bool _isCompany = false;
  Text _statusText;

  //是否只读
  bool _onlyRead = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          color: Color.fromRGBO(255, 214, 12, 1),
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
                      CompanyModel result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyCompanyCertificatePage(
                                widget.company,
                                onlyRead: _onlyRead,
                              ),
                        ),
                      );

                      if (result != null) {
                        setState(
                          () {
                            _onlyRead = true;
                            widget.company = result;
                          },
                        );
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '企业认证',
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                          Container(padding: const EdgeInsets.only(right: 15), child: _statusText),
                          Text(
                            '企业四要素认证',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  )
                : Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: const Text(
                            '企业认证',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Text(
                          '企业四要素认证',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
            Offstage(
              offstage: UserBLoC.instance.currentUser.type == UserType.FACTORY,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 5),
                  _isPersonal
                      ? InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyPersonalCertificatePage(
                                      widget.company,
                                      onlyRead: _onlyRead,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: const Text(
                                  '个人认证',
                                  style: const TextStyle(fontSize: 17),
                                )),
                                Offstage(
                                  offstage: widget.company.type != CompanyType.INDIVIDUAL_HOUSEHOLD &&
                                      widget.company.type != null,
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: _statusText,
                                  ),
                                ),
                                Text(
                                  '个人三要素认证',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: const Text(
                                '个人认证',
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                ),
                              )),
                              const Text(
                                '个人三要素认证',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            Offstage(
              offstage: !_onlyRead || widget.company.approvalStatus == ArticleApprovalStatus.check,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width - 16,
                child: ActionChip(
                  labelPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3.5, vertical: 8),
                  backgroundColor: Colors.red,
                  label: const Text(
                    '重新认证',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
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
