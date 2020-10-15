import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:models/models.dart';

class MyFactoryServiceInfo extends StatefulWidget {
  MyFactoryServiceInfo(
    this.factory, {
    Key key,
    this.isSupplier,
  }) : super(key: key);

  final FactoryModel factory;
  final bool isSupplier;

  @override
  State createState() => MyFactoryServiceInfoState();
}

class MyFactoryServiceInfoState extends State<MyFactoryServiceInfo> {
  final double TITLE_WIDTH = 90;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    String _cooperationModes = '';

    widget.factory.cooperationModes.forEach((item){
      _cooperationModes += CooperationModesLocalizedMap[item];
      _cooperationModes += '、';
    });

    if(_cooperationModes.contains('、')){
      _cooperationModes = _cooperationModes.substring(0, _cooperationModes.length - 1);
    }

    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                children: <Widget>[
                  Text('工厂服务',style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: TITLE_WIDTH,
                    child: Text(
                      '免费打样',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Text(
                    enumMap(FactoryFreeProofingsEnum, widget.factory.freeProofing) ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: TITLE_WIDTH,
                    child: Text(
                      '合作方式',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Text(
                    _cooperationModes,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: TITLE_WIDTH,
                    child: Text(
                      '质量等级',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Text(
                    '${formatEnumSelectsText(widget.factory.qualityLevels,FactoryQualityLevelsEnum, FactoryQualityLevelsEnum.length) ?? ''}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  //格式化类别
  String formatCategoriesSelectText(List<CategoryModel> categories, int count) {
    String text = '';
    Map<String, List<String>> map = Map();
    if (categories != null) {
      text = '';
      for (int i = 0; i < categories.length; i++) {
        if (categories[i].parent == null) {
          return formatCategoriesSelectText2(categories, categories.length);
        }
        if (map[categories[i].parent.name] == null) {
          map[categories[i].parent.name] = [categories[i].name];
        } else {
          map[categories[i].parent.name].add(categories[i].name);
        }
      }

      map.forEach((key, value) {
        if (key != '大类') {
          text += key;
          text += '--';
        }
        for (int i = 0; i < value.length; i++) {
          if (i == value.length - 1) {
            text += value[i];
            if (map.keys.last != key) {
              text += '\n';
            }
          } else {
            text += value[i] + '、';
          }
        }
      });
    }

    return text;
  }

  //格式化类别
  String formatCategoriesSelectText2(List<CategoryModel> categories,
      int count) {
    String text = '';

    if (categories != null) {
      text = '';
      for (int i = 0; i < categories.length; i++) {
        if (i > count - 1) {
          text += '...';
          break;
        }

        if (i == categories.length - 1) {
          text += categories[i].name;
        } else {
          text += categories[i].name + '、';
        }
      }
    }

    return text;
  }

}
