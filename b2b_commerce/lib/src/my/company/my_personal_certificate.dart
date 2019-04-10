import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

class MyPersonalCertificatePage extends StatefulWidget{
  CompanyModel company;
  bool onlyRead;
  MyPersonalCertificatePage(this.company,{this.onlyRead = false,});
  MyPersonalCertificatePageState createState() => MyPersonalCertificatePageState();
}

class MyPersonalCertificatePageState extends State<MyPersonalCertificatePage>{
  TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _certificateOfLegalController = TextEditingController();
  FocusNode _certificateOfLegalFocusNode = FocusNode();
  TextEditingController _contactPhoneController = TextEditingController();
  FocusNode _contactPhoneFocusNode = FocusNode();

  @override
  void initState() {
    _nameController.text = widget.company.name;
    _certificateOfLegalController.text = widget.company.certificateOfLegal;
    _contactPhoneController.text = widget.company.contactPhone;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人认证'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: ListView(
        children: <Widget>[
          Card(
            elevation: 0,
            margin: EdgeInsets.only(top: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('姓名',style: TextStyle(color: Colors.grey,fontSize: 16),),
                  TextFieldComponent(
                    focusNode: _nameFocusNode,
                    controller: _nameController,
                    padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
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
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('身份证号',style: TextStyle(color: Colors.grey,fontSize: 16),),
                  TextFieldComponent(
                    focusNode: _certificateOfLegalFocusNode,
                    controller: _certificateOfLegalController,
                    padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
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
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('手机号',style: TextStyle(color: Colors.grey,fontSize: 16),),
                  TextFieldComponent(
                    focusNode: _contactPhoneFocusNode,
                    controller: _contactPhoneController,
                    padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
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
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('认证证件',style: TextStyle(color: Colors.grey,fontSize: 16),),
                  EditableAttachments(list: widget.company.certificates,
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
                  widget.company.type = CompanyType.INDIVIDUAL_HOUSEHOLD;
                  widget.company.name = _nameController.text;
                  widget.company.certificateOfLegal = _certificateOfLegalController.text;
                  widget.company.contactPhone = _contactPhoneController.text;
//                  await UserRepositoryImpl().applyCertification(widget.company);
                  UserRepositoryImpl().applyCertification(widget.company).then((a){
                    Navigator.pop(context);
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}