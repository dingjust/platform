import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:models/models.dart';

class MyFactoryAbilityInfo extends StatefulWidget {
  MyFactoryAbilityInfo(
    this.factory, {
    Key key,
    this.isSupplier,
  }) : super(key: key);

  final FactoryModel factory;
  final bool isSupplier;

  @override
  State createState() => MyFactoryAbilityInfoState();
}

class MyFactoryAbilityInfoState extends State<MyFactoryAbilityInfo> {
  final double TITLE_WIDTH = 90;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                children: <Widget>[
                  Text('工厂能力',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
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
                      '设计',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Text(
                    '${enumMap(FactoryDesignsEnum, widget.factory.design) ?? ''}',
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
                      '打板',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Text(
                    '${enumMap(FactoryPatternsEnum, widget.factory.pattern) ?? ''}',
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
                      '合作商',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${widget.factory?.cooperativeBrand ?? ''}',
                      style: TextStyle(
                        fontSize: 16,
                      ),
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
                      '覆盖范围',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${widget.factory.coverageArea ?? ''}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: TITLE_WIDTH,
                    child: Text(
                      '优势品类',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      formatCategoriesSelectText(
                          widget.factory.adeptAtCategories,
                          widget.factory.adeptAtCategories.length),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: TITLE_WIDTH,
                    child: Text(
                      '自营产品',
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${widget.factory.proprietaryProducts == null ? '0' : widget.factory.proprietaryProducts.toString()} SKU",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  )
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
