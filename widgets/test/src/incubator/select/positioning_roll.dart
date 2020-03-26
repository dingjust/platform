import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ColorSizeSelectPage(),
    );
  }
}

class ColorSizeSelectPage extends StatefulWidget {
  ColorSizeSelectPageState createState() => ColorSizeSelectPageState();
}

class ColorSizeSelectPageState extends State<ColorSizeSelectPage> {
  ScrollController _valueController = ScrollController();
  ApparelProductAttributesModel attributesModel;

//  List<EnumModel> attributeKeys = [
//    EnumModel('styles','风格'),
//    EnumModel('fabricCompositions','面料成分'),
//    EnumModel('editionType','版型'),
//    EnumModel('pattern','款式'),
//    EnumModel('sleeveType','袖型'),
//    EnumModel('sleeveLength','袖长/裤腿'),
//    EnumModel('decorativePatterns','图案'),
//    EnumModel('popularElements','流行元素'),
//    EnumModel('filler','填充物'),
//    EnumModel('thickness','厚薄'),
//    EnumModel('season','季节'),
//    EnumModel('taggable','吊牌'),
//    EnumModel('placket','门襟'),
//  ];

  List<Attribute> attributes = [
    Attribute('styles', '风格', StyleEnum,multiple: true),
//    Attribute('fabricCompositions', '面料成分', FabricCompositionEnum,multiple: true),
    Attribute('editionType', '版型', EditionTypeEnum),
    Attribute('pattern', '款式', PatternEnum),
    Attribute('sleeveType', '袖型', SleeveTypeEnum),
    Attribute('sleeveLength', '袖长/裤腿', SleeveLengthEnum),
    Attribute('decorativePatterns', '图案', DecorativePatternEnum,multiple: true),
    Attribute('popularElements', '流行元素', PopularElementsEnum,multiple: true),
    Attribute('filler', '填充物', FillerEnum),
    Attribute('thickness', '厚薄', ThicknessEnum),
    Attribute('season', '季节', SeasonEnum),
    Attribute('taggable', '吊牌', TaggableEnum),
    Attribute('placket', '门襟', PlacketEnum),
  ];

  Map<String, dynamic> map = {};
  String _keySelect;

  @override
  void initState() {
    if(attributes != null && attributes.length > 0) _keySelect = attributes[0].code;
    double offset = 0.0;
    attributes.forEach((attr){
      int colCount = attr.values.length % 3 == 0 ? (attr.values.length/3).toInt() : (attr.values.length/3 + 1).toInt();
      attr.offset = offset;
      offset += (colCount * 50).toDouble() + 36;
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('选择属性'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          IconButton(
              icon: Text('确定'),
              onPressed: () {
                attributes.forEach((attribute) {
                  print(attribute.valueSelects);
                });
              })
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: <Widget>[
            Container(
              color: Colors.grey[300],
              width: MediaQuery.of(context).size.width / 5,
              height: MediaQuery.of(context).size.height - 75,
              child: ListView(
                shrinkWrap: true,
                children: attributes.map((attribute) {
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _keySelect = attribute.code;
                        _valueController.animateTo(attribute.offset,duration: Duration(milliseconds: 500),curve: Curves.ease);
                      });
                    },
                    child: Container(
                      height: 40,
                      color:  _keySelect == attribute.code ? Colors.white : Colors.grey[300],
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
                children: attributes.map((item) {
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
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.8/3 - 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color:
                                        item.valueSelects.contains(valueItem.code)
                                            ? Color.fromRGBO(255, 214, 12, 1)
                                            : Colors.grey[300]),
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
