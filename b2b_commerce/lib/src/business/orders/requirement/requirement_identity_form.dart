import 'package:b2b_commerce/src/_shared/widgets/app_bar_factory.dart';
import 'package:b2b_commerce/src/business/services/text_field_border_component_V2.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

import 'requirement_form_factory.dart';
import 'requirement_form_order.dart';

class RequirementIdentityForm extends StatefulWidget {
  final RequirementOrderType type;

  const RequirementIdentityForm(
    this.type, {
    Key key,
  }) : super(key: key);

  @override
  _RequirementIdentityFormState createState() =>
      _RequirementIdentityFormState();
}

class _RequirementIdentityFormState extends State<RequirementIdentityForm> {
  TextEditingController controller;
  FocusNode node;

  final List<String> types = [
    '实体批发',
    '网络批发',
    '品牌公司',
    '网络直播',
    '电商平台',
    '服装工厂',
    '微商创业'
  ];

  @override
  void initState() {
    controller = TextEditingController();
    node = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarFactory.buildDefaultAppBar('需求发布-找工厂'),
      body: Container(
        padding: EdgeInsets.all(12),
        color: Color(0xFFF7F7F7),
        child: ListView(
          children: [
            Container(
                height: 210,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    Text(
                      '我的身份',
                      style: TextStyle(
                          color: Color(0xff222222),
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: 6,
                      width: 64,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          color: Color(0xFFFED800),
                          borderRadius: BorderRadiusDirectional.circular(3)),
                    ),
                    Expanded(
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, //每行三列
                                  childAspectRatio: 3, //显示区域宽高相等
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 20),
                          itemCount: types.length,
                          itemBuilder: (context, index) {
                            return OutlineButton(
                              onPressed: () {
                                toForm(types[index]);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Center(
                                child: Text(
                                  '${types[index]}',
                                  style: TextStyle(
                                      color: Color(0xff000000), fontSize: 13),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                )),
            Container(
              margin: EdgeInsets.only(top: 12),
              padding: EdgeInsets.symmetric(vertical: 9, horizontal: 24),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Text(
                    '自定义',
                    style: TextStyle(color: Color(0xff000000), fontSize: 14),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: TextFieldBorderComponentV2(
                      padding: EdgeInsets.all(0),
                      hideDivider: false,
                      isRequired: true,
                      textAlign: TextAlign.left,
                      hintText: '以上都不是请输入...',
                      controller: controller,
                      focusNode: node,
                      autofocus: false,
                    ),
                  )),
                  TextButton(
                    onPressed: onSubmit,
                    child: Text(
                      '确定',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18))),
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFFFED800))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit() {
    if (controller.text == '') {
      BotToast.showText(text: '身份不能为空', align: Alignment.center);
    } else {
      toForm(controller.text);
    }
  }

  void toForm(String val) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => RequirementOrderFormStateV2(identityTypeStr: val),
            ),
          ],
          child: Consumer(
            builder: (context, RequirementOrderFormStateV2 state, _) =>
            widget.type == RequirementOrderType.FINDING_ORDER
                ? RequirementFormOrder(
              formState: state,
            )
                : RequirementFormFactory(
              formState: state,
            ),
          ),
        ),
      ),
    );
  }
}
