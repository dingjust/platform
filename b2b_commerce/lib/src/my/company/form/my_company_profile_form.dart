import 'package:b2b_commerce/src/my/company/company_profile_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyCompanyProfileFormPage extends StatefulWidget {
  CompanyModel company;

  MyCompanyProfileFormPage(this.company);

  MyCompanyProfileFormPageState createState() =>
      MyCompanyProfileFormPageState();
}

class MyCompanyProfileFormPageState extends State<MyCompanyProfileFormPage> {
  CompanyProfileModel _oneCompanyProfileModel = CompanyProfileModel();
  CompanyProfileModel _twoCompanyProfileModel = CompanyProfileModel();
  CompanyProfileModel _threeCompanyProfileModel = CompanyProfileModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('图文详情'),
        elevation: 0.5,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Text(
              '确定',
              style: TextStyle(
                color: Color.fromRGBO(255, 214, 12, 1),
              ),
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          CompanyProfileItem(_oneCompanyProfileModel),
          CompanyProfileItem(_twoCompanyProfileModel),
          CompanyProfileItem(_threeCompanyProfileModel),
        ],
      ),
    );
  }
}
