import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';
import 'package:models/models.dart';

class ProductCategorySelectPage extends StatefulWidget {
  List<CategoryModel> minCategorySelect;
  ProductCategorySelectPage({this.minCategorySelect});

  ProductCategorySelectPageState createState() =>
      ProductCategorySelectPageState();
}

class ProductCategorySelectPageState extends State<ProductCategorySelectPage> {
  final List<Map<CategoryModel, List<CategoryModel>>> _minCategorys = [
    {
      CategoryModel(code: 'W01', name: '女装'): [
        CategoryModel(code: 'W0101', name: '女式毛衣',parent: CategoryModel(code: 'W01',name: '女装')),
        CategoryModel(code: 'W0102', name: '女式马夹',parent: CategoryModel(code: 'W01',name: '女装')),
        CategoryModel(code: 'W0103', name: '女式西服',parent: CategoryModel(code: 'W01',name: '女装')),
        CategoryModel(code: 'W0104', name: '女式夹克',parent: CategoryModel(code: 'W01',name: '女装')),
        CategoryModel(code: 'W0105', name: '女式风衣',parent: CategoryModel(code: 'W01',name: '女装')),
        CategoryModel(code: 'W0106', name: '女式棉衣',parent: CategoryModel(code: 'W01',name: '女装')),
        CategoryModel(code: 'W0107', name: '女式羽绒',parent: CategoryModel(code: 'W01',name: '女装')),
      ],
      CategoryModel(code: 'M01', name: '男装'): [
        CategoryModel(code: 'M0101', name: '男式POLO衫',parent: CategoryModel(code: 'M01',name: '男装')),
        CategoryModel(code: 'M0102', name: '男式衬衫',parent: CategoryModel(code: 'M01',name: '男装')),
        CategoryModel(code: 'M0103', name: '男式卫衣',parent: CategoryModel(code: 'M01',name: '男装')),
        CategoryModel(code: 'M0104', name: '男式线衫',parent: CategoryModel(code: 'M01',name: '男装')),
        CategoryModel(code: 'M0105', name: '男式毛衣',parent: CategoryModel(code: 'M01',name: '男装')),
        CategoryModel(code: 'M0106', name: '男式马夹',parent: CategoryModel(code: 'M01',name: '男装')),
        CategoryModel(code: 'M0107', name: '男式西服',parent: CategoryModel(code: 'M01',name: '男装')),
      ],
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        title: Text('选择分类'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: CategorySelect(
              categorys: _minCategorys,
              categorySelect: widget.minCategorySelect,
              multiple: false,
              hasButton: false,
            ),
          ),
        ],
      ),
    );
  }
}
