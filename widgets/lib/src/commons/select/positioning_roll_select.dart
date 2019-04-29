import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

class PositioningRollPage extends StatefulWidget {
  List<Attribute> attributes;
  double valueItemHeight;
  String title;

  PositioningRollPage({
    this.attributes,
    this.valueItemHeight = 40,
    this.title,
  });
  _PositioningRollPageState createState() => _PositioningRollPageState();
}

class _PositioningRollPageState extends State<PositioningRollPage> {
  ScrollController _valueController = ScrollController();
  Map<String, dynamic> map = {};
  String _keySelect;


  @override
  void initState() {
    if(widget.attributes != null && widget.attributes.length > 0) _keySelect = widget.attributes[0].code;
    double offset = 0.0;
    widget.attributes.forEach((attr){
      int colCount = attr.values.length % 3 == 0 ? (attr.values.length/3).toInt() : (attr.values.length/3 + 1).toInt();
      attr.offset = offset;
      offset += (colCount * (widget.valueItemHeight + 10)).toDouble() + 36;
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '定位滚动选择组件'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
              icon: Text('确定'),
              onPressed: () {
                widget.attributes.forEach((attribute) {
                  map[attribute.code] = attribute.valueSelects;
                });
                Navigator.pop(context,map);
              })
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.height - 75,
              child: ListView(
                shrinkWrap: true,
                children: widget.attributes.map((attribute) {
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _keySelect = attribute.code;
                        _valueController.animateTo(attribute.offset,duration: Duration(milliseconds: 500),curve: Curves.ease);
                      });
                    },
                    child: Container(
                      height: 40,
                      color:  _keySelect == attribute.code ? Colors.white : Colors.grey[200],
                      child: Center(child: Text(attribute.name)),
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height - 75,
              child: ListView(
                shrinkWrap: true,
                controller: _valueController,
                children: widget.attributes.map((item) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10,bottom: 10,),
                        child: Center(
                          child: Text(
                            item.name,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      Wrap(
                        children: item.values.map((valueItem) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (item.valueSelects
                                    .contains(valueItem.code)) {
                                  item.valueSelects.remove(valueItem.code);
                                } else {
                                  if(!item.multiple){
                                    item.valueSelects.clear();
                                  }
                                  item.valueSelects.add(valueItem.code);
                                }
                              });

                              print(item.valueSelects);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5,right: 5,bottom: 10,),
                              child: Container(
                                height: widget.valueItemHeight,
                                width: MediaQuery.of(context).size.width * 0.8/3 - 10,
                                decoration: BoxDecoration(
//                                  border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        item.valueSelects.contains(valueItem.code)
                                            ? Color.fromRGBO(255, 214, 12, 1)
                                            : Colors.grey[250]),
                                child: Center(child: Text(valueItem.name),),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Attribute {
  String code;
  String name;
  List<EnumModel> values;
  List<String> valueSelects;
  double offset;
  bool multiple;

  Attribute(this.code, this.name, this.values, {this.valueSelects,this.offset = 0.0,this.multiple = false,}) {
    this.valueSelects = [];
  }
}
