import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

class ProductCategorySelectPage extends StatefulWidget {
  final List<Map<CategoryModel, List<CategoryModel>>> _minCategorys = [
    {
      CategoryModel(code: 'W01', name: '女装'): [
        CategoryModel(code: 'W0101', name: '女式毛衣', parent: 'W01'),
        CategoryModel(code: 'W0102', name: '女式马夹', parent: 'W01'),
        CategoryModel(code: 'W0103', name: '女式西服', parent: 'W01'),
        CategoryModel(code: 'W0104', name: '女式夹克', parent: 'W01'),
        CategoryModel(code: 'W0105', name: '女式风衣', parent: 'W01'),
        CategoryModel(code: 'W0106', name: '女式棉衣', parent: 'W01'),
        CategoryModel(code: 'W0107', name: '女式羽绒', parent: 'W01'),
      ],
      CategoryModel(code: 'M01', name: '男装'): [
        CategoryModel(code: 'M0101', name: '男式POLO衫', parent: 'M01'),
        CategoryModel(code: 'M0102', name: '男式衬衫', parent: 'M01'),
        CategoryModel(code: 'M0103', name: '男式卫衣', parent: 'M01'),
        CategoryModel(code: 'M0104', name: '男式线衫', parent: 'M01'),
        CategoryModel(code: 'M0105', name: '男式毛衣', parent: 'M01'),
        CategoryModel(code: 'M0106', name: '男式马夹', parent: 'M01'),
        CategoryModel(code: 'M0107', name: '男式西服', parent: 'M01'),
      ],
    }
  ];

  final List<CategoryModel> _maxCategorys = <CategoryModel>[
    CategoryModel(code: 'C1',name: '针织'),
    CategoryModel(code: 'C2',name: '梭织'),
    CategoryModel(code: 'C3',name: '皮草'),
    CategoryModel(code: 'C4',name: '牛仔'),
    CategoryModel(code: 'C5',name: '其他'),
  ];

  ProductCategorySelectPageState createState() =>
      ProductCategorySelectPageState();
}

class ProductCategorySelectPageState extends State<ProductCategorySelectPage> {
  List<CategoryModel> _minCategorySelect = [];
  List<EnumModel> _maxCategorySelect = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择分类'),
      ),
      body: Column(
        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.only(top: 20,bottom: 20,left: 20,right: 30),
//                child: Text('大类'),
//              ),
//              Expanded(
//                child: EnumSelection(
//                  enumModels: widget._maxCategorys.map((category) => EnumModel(category.code, category.name)).toList(),
//                  enumSelect: _maxCategorySelect,
//                ),
//              )
//            ],
//          ),
//          Divider(height: 0,),
          Flexible(
            child: CategorySelect(
              categorys: widget._minCategorys,
              categorySelect: _minCategorySelect,
            ),
          ),
        ],
      ),
    );
  }
}
