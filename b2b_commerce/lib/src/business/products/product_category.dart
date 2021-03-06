import 'package:b2b_commerce/src/home/factory/factory_page.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../home/product/order_product.dart';
import '../../home/requirement/fast_publish_requirement.dart';
import '../../home/requirement/requirement_date_pick.dart';

/// 产品分类选择页
class CategorySelectPage extends StatefulWidget {
  CategorySelectPage({
    this.minCategorySelect,
    this.fastRequirementForm,
    this.categories,
    this.hasNextPage = false,
    this.multiple = false,
    this.categoryActionType = CategoryActionType.none,
    this.max = 99,
  });

  final FastRequirementForm fastRequirementForm;
  final List<CategoryModel> minCategorySelect;
  final List<CategoryModel> categories;
  final bool hasNextPage;
  final bool multiple;

  ///分类选择动作类型
  final CategoryActionType categoryActionType;

  final int max;

  CategorySelectPageState createState() => CategorySelectPageState();
}

class CategorySelectPageState extends State<CategorySelectPage> {
  List<CategoryModel> _categorySelects = [];
  GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    _categorySelects.addAll(widget.minCategorySelect);
    super.initState();
  }

  void _jumpToFactories(CategoryModel category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FactoryPage(
          FactoryCondition(
              starLevel: 0,
              adeptAtCategories: [category],
              labels: [],
              cooperationModes: []),
        ),
      ),
    );
  }

  void _jumpToProducts(CategoryModel category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CategorySelect categorySelect;

    switch (widget.categoryActionType) {
      case CategoryActionType.TO_FACTORIES:
        categorySelect = CategorySelect(
          categories: widget.categories,
          categorySelect: _categorySelects,
          multiple: false,
          hasButton: false,
          categoryActionType: widget.categoryActionType,
          onJumpToFactories: _jumpToFactories,
        );
        break;
      case CategoryActionType.TO_PRODUCTS:
        categorySelect = CategorySelect(
          categories: widget.categories,
          categorySelect: _categorySelects,
          multiple: false,
          hasButton: false,
          categoryActionType: widget.categoryActionType,
          onJumpToProducts: _jumpToProducts,
        );
        break;
      case CategoryActionType.TO_POP:
        categorySelect = CategorySelect(
          categories: widget.categories,
          categorySelect: _categorySelects,
          multiple: false,
          hasButton: false,
          categoryActionType: widget.categoryActionType,
        );
        break;
      default:
        categorySelect = CategorySelect(
            categories: widget.categories,
            categorySelect: _categorySelects,
            multiple: widget.multiple,
            hasButton: false,
            max: widget.max);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: widget.hasNextPage ? 0 : 0.5,
        centerTitle: true,
        title: Text('选择分类'),
        leading: IconButton(
          icon: Text(
            '取消',
            style: TextStyle(color: Colors.grey),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          widget.hasNextPage
              ? FlatButton(
                  onPressed: () {
                    if (widget.fastRequirementForm.categories.isEmpty) {
                      (_scaffoldKey.currentState as ScaffoldState).showSnackBar(
                        SnackBar(
                          content: Text('请选择品类'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              RequirementDatePick(
                                fastRequirementForm: widget.fastRequirementForm,
                                nowTime: DateTime.now(),
                              ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    '下一步',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : Offstage(
            offstage: !widget.multiple,
            child: IconButton(
              icon: Text(
                '确定',
                // style: TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
              ),
              onPressed: () {
                Navigator.pop(context, _categorySelects);
              },
            ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: categorySelect,
          ),
        ],
      ),
    );
  }
}
