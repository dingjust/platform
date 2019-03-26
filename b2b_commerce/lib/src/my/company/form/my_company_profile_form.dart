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
  List<CompanyProfileModel> _companyProfiles = List(3);

  @override
  void initState() {
    for (int i = 0; i < widget.company.companyProfiles.length; i++) {
      _companyProfiles[i] = widget.company.companyProfiles[i];
    }
    _companyProfiles.fillRange(
        widget.company.companyProfiles.length,
        3,
        CompanyProfileModel(
          medias: [],
          description: '',
        ));
    print(_companyProfiles);

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
        children: _companyProfiles.map((companyProfile) {
          return Container(
            padding: EdgeInsets.only(bottom: 30),
            child: CompanyProfileItem(companyProfile),
          );
        }).toList(),
      ),
    );
  }
}
