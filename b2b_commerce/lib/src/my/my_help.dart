import 'package:b2b_commerce/src/my/my_help_detail.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class MyHelpPage extends StatefulWidget {
  @override
  _MyHelpPageState createState() => _MyHelpPageState();
}

class _MyHelpPageState extends State<MyHelpPage> {
  final GlobalKey _globalKey = GlobalKey<_MyHelpPageState>();

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
          title: const Text('问题与帮助'),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              StreamBuilder<List<UserGuidelineModel>>(
                stream: MyHelpBLoC.instance.stream,
                // initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<UserGuidelineModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getData();
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((model) {
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
                    );
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

class HelpItem extends StatelessWidget {
  final String value;

  final VoidCallback onPressed;

  const HelpItem({Key key, this.value, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2),
      child: FlatButton(
        onPressed: onPressed,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '${value}',
              style: TextStyle(fontSize: 16),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
