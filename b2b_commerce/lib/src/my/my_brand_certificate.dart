import 'package:b2b_commerce/src/my/company/my_company_certificate.dart';
import 'package:b2b_commerce/src/my/company/my_personal_certificate.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

class MyBrandCertificatePage extends StatelessWidget {
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
            InkWell(
              onTap: () async {
                BrandModel brand = await UserRepositoryImpl()
                    .getBrand(UserBLoC.instance.currentUser.companyCode);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyCompanyCertificatePage(
                              brand,
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
                    Text(
                      '企业四要素认证',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () async {
                BrandModel brand = await UserRepositoryImpl()
                    .getBrand(UserBLoC.instance.currentUser.companyCode);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyPersonalCertificatePage(brand)));
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
                    Text(
                      '个人三要素认证',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
