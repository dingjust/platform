import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'enum_select.dart';
import 'category_select.dart';

class SelectEnum2Page extends StatelessWidget{
  List<EnumModel> enumSelect;
  bool multiple;
  List<CategoryModel> categorySelect = [];
  List<Map<CategoryModel, List<CategoryModel>>> categorys;
  List<CategoryModel> maxCategorys = <CategoryModel>[
    CategoryModel(code: 'C1',name: '针织'),
    CategoryModel(code: 'C2',name: '针织'),
    CategoryModel(code: 'C3',name: '针织'),
    CategoryModel(code: 'C4',name: '针织'),
    CategoryModel(code: 'C5',name: '其他'),
  ];

  SelectEnum2Page({this.multiple,this.enumSelect,this.categorySelect,this.categorys});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择枚举'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('大类'),
              ),
              EnumSelectPage(enumSelect: enumSelect,multiple: false,enumModels: maxCategorys.map((category) => EnumModel(category.code, category.name)).toList(),)
            ],
          ),
          Divider(),
          Expanded(child: CategorySelectPage(categorys: categorys,multiple: true,categorySelect: categorySelect,verticalDividerOpacity: 0.5,)),
        ],
      )
    );
  }
}