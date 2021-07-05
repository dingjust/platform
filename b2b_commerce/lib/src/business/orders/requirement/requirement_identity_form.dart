import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'requirement_form_factory.dart';

class RequirementIdentityForm extends StatefulWidget {
  const RequirementIdentityForm({Key key}) : super(key: key);

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
      appBar: AppBar(
        brightness: Brightness.light,
        centerTitle: true,
        elevation: 0.5,
        title: Text(
          '需求发布-找工厂',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [Text('我的身份：')],
                )),
            Container(
              height: 300,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, //每行三列
                      childAspectRatio: 3, //显示区域宽高相等
                      mainAxisSpacing: 40,
                      crossAxisSpacing: 30),
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    return OutlineButton(
                      onPressed: () {
                        toForm(types[index]);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(
                        child: Text('${types[index]}'),
                      ),
                    );
                  }),
            ),
            Container(
              child: Row(
                children: [
                  Text('自定义'),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: TextFieldBorderComponent(
                      padding: EdgeInsets.all(0),
                      hideDivider: false,
                      isRequired: true,
                      textAlign: TextAlign.left,
                      hintText: '请输入内容',
                      controller: controller,
                      focusNode: node,
                      autofocus: true,
                    ),
                  )),
                  TextButton(onPressed: onSubmit, child: Text('确定'))
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
              create: (_) => RequirementOrderFormStateV2(),
            ),
          ],
          child: Consumer(
            builder: (context, RequirementOrderFormStateV2 state, _) =>
                RequirementFormFactory(
              formState: state,
            ),
          ),
        ),
      ),
    );
  }
}
