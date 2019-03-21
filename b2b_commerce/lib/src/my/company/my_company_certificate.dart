import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

class MyCompanyCertificatePage extends StatefulWidget{
  CompanyModel company;
  bool enabled;
  MyCompanyCertificatePage(this.company,{this.enabled = false});
  MyCompanyCertificatePageState createState() => MyCompanyCertificatePageState();
}

class MyCompanyCertificatePageState extends State<MyCompanyCertificatePage>{
  TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _businessRegistrationNoController = TextEditingController();
  FocusNode _businessRegistrationNoFocusNode = FocusNode();
  TextEditingController _legalRepresentativeController = TextEditingController();
  FocusNode _legalRepresentativeFocusNode = FocusNode();
  TextEditingController _certificateOfLegalController = TextEditingController();
  FocusNode _certificateOfLegalFocusNode = FocusNode();
  List<MediaModel> medias = [];

  @override
  void initState() {
    _nameController.text = widget.company.name;
    _businessRegistrationNoController.text = widget.company.businessRegistrationNo;
    _legalRepresentativeController.text = widget.company.legalRepresentative;
    _certificateOfLegalController.text = widget.company.certificateOfLegal;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('认证资料'),
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
                  Text('企业名称',style: TextStyle(color: Colors.grey,fontSize: 16),),
                  TextFieldComponent(
                    focusNode: _nameFocusNode,
                    controller: _nameController,
                    padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                    textAlign: TextAlign.left,
                    enabled: widget.enabled,
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
                  Text('工商注册号或统一社会信用代码',style: TextStyle(color: Colors.grey,fontSize: 16),),
                  TextFieldComponent(
                    focusNode: _businessRegistrationNoFocusNode,
                    controller: _businessRegistrationNoController,
                    padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                    textAlign: TextAlign.left,
                    enabled: widget.enabled,
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
                  Text('法定代表人',style: TextStyle(color: Colors.grey,fontSize: 16),),
                  TextFieldComponent(
                    focusNode: _legalRepresentativeFocusNode,
                    controller: _legalRepresentativeController,
                    padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                    textAlign: TextAlign.left,
                    enabled: widget.enabled,
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
                  Text('法定代表人证件',style: TextStyle(color: Colors.grey,fontSize: 16),),
                  TextFieldComponent(
                    focusNode: _certificateOfLegalFocusNode,
                    controller: _certificateOfLegalController,
                    padding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                    textAlign: TextAlign.left,
                    enabled: widget.enabled,
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
                  EditableAttachments(list: medias,maxNum: medias.length,editable: false,),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}