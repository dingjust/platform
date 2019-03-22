import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

class MyPersonalCertificatePage extends StatefulWidget{
  CompanyModel company;
  bool enabled;
  MyPersonalCertificatePage(this.company,{this.enabled = false});
  MyPersonalCertificatePageState createState() => MyPersonalCertificatePageState();
}

class MyPersonalCertificatePageState extends State<MyPersonalCertificatePage>{
  TextEditingController _nameController = TextEditingController();
  FocusNode _nameFocusNode = FocusNode();
  TextEditingController _certificateOfLegalController = TextEditingController();
  FocusNode _certificateOfLegalFocusNode = FocusNode();
  TextEditingController _contactPhoneController = TextEditingController();
  FocusNode _contactPhoneFocusNode = FocusNode();
  List<MediaModel> medias = [];

  @override
  void initState() {
    _nameController.text = widget.company.name;
    _certificateOfLegalController.text = widget.company.businessRegistrationNo;
    _contactPhoneController.text = widget.company.contactPhone;

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
                  Text('姓名',style: TextStyle(color: Colors.grey,fontSize: 16),),
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
                  Text('身份证号',style: TextStyle(color: Colors.grey,fontSize: 16),),
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
                  Text('手机号',style: TextStyle(color: Colors.grey,fontSize: 16),),
                  TextFieldComponent(
                    focusNode: _contactPhoneFocusNode,
                    controller: _contactPhoneController,
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