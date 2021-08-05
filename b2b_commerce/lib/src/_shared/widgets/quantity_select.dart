import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class SalesMarketSelectPage extends StatefulWidget {
  final List<String> values;

  const SalesMarketSelectPage({Key key, this.values}) : super(key: key);

  @override
  _SalesMarketSelectPageState createState() => _SalesMarketSelectPageState();
}

class _SalesMarketSelectPageState extends State<SalesMarketSelectPage> {
  List<String> values = [];

  @override
  void initState() {
    super.initState();
    if (widget.values != null) {
      values.addAll(widget.values);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('选择质量等级'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
                child: ListView(
                    children:
                        FactoryQualityLevelsEnum.map((e) => CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(e.name),
                              onChanged: (v) {
                                setState(() {
                                  if (v) {
                                    values.add(e.code);
                                  } else {
                                    values.remove(e.code);
                                  }
                                });
                              },
                              activeColor: Constants.THEME_COLOR_MAIN,
                              value: values.contains(e.code),
                            )).toList())),
            Container(
              child: Row(
                children: [
                  Expanded(
                      child: FlatButton(
                          height: 50,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '取消',
                            style: TextStyle(color: Colors.grey),
                          ))),
                  Expanded(
                      child: FlatButton(
                          height: 50,
                          onPressed: () {
                            Navigator.of(context).pop(values);
                          },
                          color: Constants.THEME_COLOR_MAIN,
                          child: Text('确定',
                              style: TextStyle(color: Colors.white))))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
