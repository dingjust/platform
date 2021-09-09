import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'my_help.dart';
import 'my_help_detail.dart';

///反馈页面
class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final GlobalKey _globalKey = GlobalKey<_FeedbackPageState>();
  FocusNode focusNode;
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    MyHelpBLoC bloc = MyHelpBLoC.instance;

    return BLoCProvider<MyHelpBLoC>(
      key: _globalKey,
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: const Text('意见反馈'),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              StreamBuilder<List<UserGuidelineModel>>(
                stream: MyHelpBLoC.instance.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<UserGuidelineModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getData();
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Column(children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text('常见问题'),
                      ),
                      ...snapshot.data.getRange(0, 5).map((model) {
                        return HelpItem(
                          value: '${model.name}',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyHelpDetailPage(
                                      userGuidelineModel: model,
                                    )));
                          },
                        );
                      }).toList(),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: TextFieldComponent(
                          padding: EdgeInsets.symmetric(vertical: 0),
                          dividerPadding: EdgeInsets.only(),
                          focusNode: focusNode,
                          hintText: '您填写的信息越全,问题越容易解决...',
                          style:
                              TextStyle(color: Color(0xFF222222), fontSize: 14),
                          autofocus: false,
                          inputType: TextInputType.text,
                          textAlign: TextAlign.left,
                          hideDivider: true,
                          maxLines: null,
                          maxLength: 500,
                          controller: controller,
                          onChanged: (v) {},
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 18),
                          child: Row(children: [
                            Expanded(
                              child: FlatButton(
                                  color: Color.fromRGBO(255, 214, 12, 1),
                                  padding: EdgeInsets.symmetric(vertical: 13),
                                  child: Text(
                                    '提交反馈',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  onPressed: () {
                                    if (controller.text.length > 0) {
                                      BotToast.showText(
                                          text: '反馈提交成功，请耐心等待答复',
                                          align: Alignment.center,
                                          duration: Duration(seconds: 3));
                                      Future.delayed(Duration(seconds: 3))
                                          .then((value) {
                                        Navigator.of(context).pop();
                                      });
                                    } else {
                                      BotToast.showText(
                                        text: '请填写有效信息',
                                        align: Alignment.center,
                                      );
                                    }
                                  }),
                            )
                          ]))
                    ]);
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
