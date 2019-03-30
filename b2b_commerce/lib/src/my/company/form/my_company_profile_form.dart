import 'package:b2b_commerce/src/my/company/company_profile_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class MyCompanyProfileFormPage extends StatefulWidget {
  CompanyModel company;

  MyCompanyProfileFormPage(this.company);

  MyCompanyProfileFormPageState createState() =>
      MyCompanyProfileFormPageState();
}

class MyCompanyProfileFormPageState extends State<MyCompanyProfileFormPage> {
  List<CompanyProfileModel> _companyProfiles = [];

  @override
  void initState() {
   if(widget.company.profiles != null) _companyProfiles.addAll(widget.company.profiles);
    if(widget.company.profiles.length < 3){
      for(int i = widget.company.profiles.length;i<3-widget.company.profiles.length;i++){
        _companyProfiles.add(CompanyProfileModel(
          medias: [],
          description: '',
        ));
      }
    }

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
              ),
            ),
            onPressed: () {
              print(widget.company.profiles);
              widget.company.profiles = _companyProfiles;
              widget.company.profiles.forEach((profile){
                print(CompanyProfileModel.toJson(profile));
              });

              UserRepositoryImpl().factoryUpdate(widget.company).then((a)=>Navigator.pop(context));
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
