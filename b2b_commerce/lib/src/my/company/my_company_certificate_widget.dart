import 'package:b2b_commerce/src/my/my_company_certificate_select.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

class MyCompanyCertificateWidget extends StatefulWidget {
  CompanyModel company;
  bool onlyRead;

  MyCompanyCertificateWidget(
    this.company, {
    this.onlyRead = false,
        Key key,
  }):super(key:key);

  MyCompanyCertificateWidgetState createState() =>
      MyCompanyCertificateWidgetState();
}

class MyCompanyCertificateWidgetState extends State<MyCompanyCertificateWidget> {
  TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _businessRegistrationNoController =
      TextEditingController();
  FocusNode _businessRegistrationNoFocusNode = FocusNode();
  TextEditingController _legalRepresentativeController =
      TextEditingController();
  FocusNode _legalRepresentativeFocusNode = FocusNode();
  TextEditingController _certificateOfLegalController = TextEditingController();
  FocusNode _certificateOfLegalFocusNode = FocusNode();

  @override
  void initState() {
    _nameController.text = widget.company.name;
    _businessRegistrationNoController.text =
        widget.company.businessRegistrationNo;
    _legalRepresentativeController.text = widget.company.legalRepresentative;
    _certificateOfLegalController.text = widget.company.certificateOfLegal;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '企业名称',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  TextFieldComponent(
                    focusNode: _nameFocusNode,
                    controller: _nameController,
                    padding: EdgeInsets.symmetric(),
                    dividerPadding: EdgeInsets.only(),
                    textAlign: TextAlign.left,
                    enabled: !widget.onlyRead,
                  )
                ],
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.only(top: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '工商注册号或统一社会信用代码',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextFieldComponent(
                      focusNode: _businessRegistrationNoFocusNode,
                      controller: _businessRegistrationNoController,
                      padding: EdgeInsets.symmetric(),
                      dividerPadding: EdgeInsets.only(),
                      textAlign: TextAlign.left,
                      enabled: !widget.onlyRead,
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.only(top: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '法定代表人',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextFieldComponent(
                      focusNode: _legalRepresentativeFocusNode,
                      controller: _legalRepresentativeController,
                      padding: EdgeInsets.symmetric(),
                      dividerPadding: EdgeInsets.only(),
                      textAlign: TextAlign.left,
                      enabled: !widget.onlyRead,
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.only(top: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '法定代表人证件',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextFieldComponent(
                      focusNode: _certificateOfLegalFocusNode,
                      controller: _certificateOfLegalController,
                      padding: EdgeInsets.symmetric(),
                      dividerPadding: EdgeInsets.only(),
                      textAlign: TextAlign.left,
                      enabled: !widget.onlyRead,
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0,
              margin: EdgeInsets.only(top: 10),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '认证证件',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    EditableAttachments(
                      list: widget.company.certificates,
                      maxNum: widget.onlyRead
                          ? widget.company.certificates.length
                          : 5,
                      editable: !widget.onlyRead,
                    ),
                  ],
                ),
              ),
            ),
            Offstage(
              offstage: widget.onlyRead,
              child: Container(
                padding: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width - 16,
                child: ActionChip(
                  labelPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 3.5,
                      vertical: 8),
                  backgroundColor: Color.fromRGBO(255, 214, 12, 1),
                  label: Text(
                    '提交认证',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  onPressed: () async {
                    if (UserBLoC.instance.currentUser.type == UserType.BRAND)
                      widget.company.type = CompanyType.BRAND;
                    if (UserBLoC.instance.currentUser.type == UserType.FACTORY)
                      widget.company.type = CompanyType.FACTORY;
                    widget.company.name = _nameController.text;
                    widget.company.businessRegistrationNo =
                        _businessRegistrationNoController.text;
                    widget.company.certificateOfLegal =
                        _certificateOfLegalController.text;
                    widget.company.legalRepresentative =
                        _legalRepresentativeController.text;
                    UserRepositoryImpl()
                        .applyCertification(widget.company)
                        .then((a) {
                      if (UserBLoC.instance.currentUser.type == UserType.BRAND)
                        UserRepositoryImpl()
                            .getBrand(widget.company.uid)
                            .then((brand){
                          Navigator.pop(context, brand);
                        });
                      if (UserBLoC.instance.currentUser.type == UserType.FACTORY)
                        UserRepositoryImpl()
                            .getFactory(widget.company.uid)
                            .then((factory){
                          Navigator.pop(context, factory);
                        });
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
