import 'dart:async';

import 'package:b2b_commerce/src/_shared/cooperator/cooperator_select.dart';
import 'package:b2b_commerce/src/business/orders/form/contact_way_field.dart';
import 'package:b2b_commerce/src/business/orders/form/expected_delivery_date_field.dart';
import 'package:b2b_commerce/src/business/orders/form/machining_type_field.dart';
import 'package:b2b_commerce/src/business/orders/form/pictures_field.dart';
import 'package:b2b_commerce/src/business/orders/form/production_areas_field.dart';
import 'package:b2b_commerce/src/business/orders/form/remarks_field.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_publish_success.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'RequirementFormMixins.dart';

/// 需求发布选择发布对象
class RequirementOrderSelectPublishTargetForm extends StatefulWidget {
  RequirementOrderSelectPublishTargetForm({
    this.formState,
  });

  final RequirementOrderFormState formState;

  _RequirementOrderSelectPublishTargetFormState createState() =>
      _RequirementOrderSelectPublishTargetFormState();
}

class _RequirementOrderSelectPublishTargetFormState
    extends State<RequirementOrderSelectPublishTargetForm>
    with RequirementFormMixin {
  GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('选择发布对象'),
        actions: <Widget>[],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        height: 50,
        child: RaisedButton(
            color: Color.fromRGBO(255, 214, 12, 1),
            child: Text(
              '确定',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
            onPressed: () async {
//              onPublish();
            }),
      ),
      body: Container(
        color: Colors.grey[100],
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 10, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RaisedButton(
                          color: Color(0xffffd60c),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CooperatorSelectPage()));
                          },
                          child: Text('选择我的合作商'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10, right: 15,bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: '已选择',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: '0',
                              style: TextStyle(color: Colors.red),
                            ),
                            TextSpan(
                              text: '家',
                              style: TextStyle(color: Colors.black),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: ShapeDecoration(
                      shape: Border.all(),
                      color: Colors.grey[300],
                    ),
                    child: Column(
                      children: <Widget>[

                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 发布
  void onPublish() async {}
}
