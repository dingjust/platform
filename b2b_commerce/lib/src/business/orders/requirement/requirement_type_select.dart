import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'requirement_identity_form.dart';

class RequirementTypeSelectPage extends StatelessWidget {
  const RequirementTypeSelectPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          '需求发布',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 150),
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: OutlineButton(
                    onPressed: () =>
                        toNext(context, RequirementOrderType.FINDING_FACTORY),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      children: [
                        Image.asset(
                          'temp/index/find_factory.png',
                          package: 'assets',
                          fit: BoxFit.fitWidth,
                          width: 120,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text('我要找工厂'),
                        )
                      ],
                    ),
                  ),
                )),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: OutlineButton(
                    onPressed: () =>
                        toNext(context, RequirementOrderType.FINDING_ORDER),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      children: [
                        Image.asset(
                          'temp/index/find_order.png',
                          package: 'assets',
                          fit: BoxFit.fitWidth,
                          width: 120,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text('我要抢订单'),
                        )
                      ],
                    ),
                  ),
                )),
              ],
            ),
          )
        ],
      )),
    );
  }

  void toNext(BuildContext context, RequirementOrderType type) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RequirementIdentityForm(type)));
  }
}
