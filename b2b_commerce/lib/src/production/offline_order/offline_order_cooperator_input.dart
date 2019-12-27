import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class OfflineOrderCooperatorInput extends StatefulWidget {
  CooperatorModel model;

  OfflineOrderCooperatorInput({
    this.model,
  });

  _OfflineOrderCooperatorInputState createState() =>
      _OfflineOrderCooperatorInputState();
}

class _OfflineOrderCooperatorInputState
    extends State<OfflineOrderCooperatorInput> {
  CooperatorModel currentModel;

  @override
  void initState() {
    if (widget.model != null) {
      currentModel = widget.model;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('合作商'),
            elevation: 0.5,
            brightness: Brightness.light,
            centerTitle: true,
            actions: <Widget>[
              GestureDetector(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Center(
                      child: Text(
                        '确定',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  onTap: () async {
                    // 带值返回上一页
                    Navigator.of(context).pop(currentModel);
                  })
            ]),
        body: Container(
            child: ListView(
              children: <Widget>[
                CooperatorInfoRow(
                  label: '我的合作商',
                  value: '${getCooperatorInfo().name}',
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 25),
                ),
                CooperatorInfoRow(
                  label: '联系人',
                  value: '${getCooperatorInfo().contactPerson}',
                  margin: EdgeInsets.only(bottom: 2),
                ),
                CooperatorInfoRow(
                  label: '联系方式',
                  value: '${getCooperatorInfo().contactPhone}',
                )
              ],
            )),
        bottomNavigationBar: Container(
          height: 50,
          child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '选择我的合作商',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              onPressed: () async {
                onCooperatorSelect();
              }),
        ));
  }

  _Cooperator getCooperatorInfo() {
    _Cooperator result = _Cooperator();
    if (currentModel != null && currentModel.type == CooperatorType.ONLINE) {
      result.name = currentModel.partner.name ?? '';
      result.contactPerson = currentModel.partner.contactPerson ?? '';
      result.contactPhone = currentModel.partner.contactPhone ?? '';
    } else {
      result.name = currentModel?.name ?? '';
      result.contactPerson = currentModel?.contactPerson ?? '';
      result.contactPhone = currentModel?.contactPhone ?? '';
    }
    return result;
  }

  void onCooperatorSelect() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                CooperatorSelectOnPage(
                  model: currentModel,
                ))).then((val) {
      setState(() {
        currentModel = val;
      });
    });
  }

  void _handlecurrentModelChanged(CooperatorModel newValue) {
    setState(() {
      currentModel = newValue;
      Navigator.of(context).pop();
    });
  }
}

class CooperatorInfoRow extends StatelessWidget {
  String label;

  String value;

  final EdgeInsetsGeometry margin;

  final EdgeInsetsGeometry padding;

  CooperatorInfoRow({this.label,
    this.value,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.fromLTRB(10, 20, 10, 20)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$label',
            style: TextStyle(),
          ),
          Text(
            '$value',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _Cooperator {
  String name;
  String contactPerson;
  String contactPhone;

  _Cooperator({this.name, this.contactPerson, this.contactPhone});
}
