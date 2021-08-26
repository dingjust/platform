import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'requirement_identity_form.dart';

class RequirementTypeSelectPage extends StatelessWidget {
  const RequirementTypeSelectPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          '需求发布',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Row(
        children: [
          Expanded(
              child: Container(
            color: Colors.white,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () =>
                      toNext(context, RequirementOrderType.FINDING_FACTORY),
                  child: Container(
                    margin: EdgeInsets.only(top: 52, bottom: 84),
                    child: Column(
                      children: [
                        Image.asset(
                          'temp/index/find_factory.png',
                          package: 'assets',
                          fit: BoxFit.fitWidth,
                          width: 148,
                          height: 148,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 12),
                            width: 160,
                            height: 48,
                            decoration: BoxDecoration(
                                color: Color(0xFFFED800),
                                borderRadius: BorderRadius.circular(24)),
                            child: Center(
                              child: Text(
                                '我要找工厂',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      toNext(context, RequirementOrderType.FINDING_ORDER),
                  child: Container(
                    child: Column(
                      children: [
                        Image.asset(
                          'temp/index/find_order.png',
                          package: 'assets',
                          fit: BoxFit.fitWidth,
                          width: 148,
                          height: 148,
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 12),
                            width: 160,
                            height: 48,
                            decoration: BoxDecoration(
                                color: Color(0xFFFED800),
                                borderRadius: BorderRadius.circular(24)),
                            child: Center(
                              child: Text(
                                '我要抢订单',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  void toNext(BuildContext context, RequirementOrderType type) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RequirementIdentityForm(type)));
  }
}
