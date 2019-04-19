import 'dart:async';

import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../home/factory/factory_list.dart';
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
  });

  final FastRequirementForm fastRequirementForm;
  final List<CategoryModel> minCategorySelect;
  final List<CategoryModel> categories;
  final bool hasNextPage;
  final bool multiple;

  ///分类选择动作类型
  final CategoryActionType categoryActionType;

  CategorySelectPageState createState() => CategorySelectPageState();
}

class CategorySelectPageState extends State<CategorySelectPage> {
  List<CategoryModel> _beforeMinCategorySelect = [];
  GlobalKey _scaffoldKey = GlobalKey();

  @override
  void initState() {
    _beforeMinCategorySelect.addAll(widget.minCategorySelect);
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
        builder: (context) => ProductsPage(
              categories: [category],
            ),
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
          categorySelect: widget.minCategorySelect,
          multiple: false,
          hasButton: false,
          categoryActionType: widget.categoryActionType,
          onJumpToFactories: _jumpToFactories,
        );
        break;
      case CategoryActionType.TO_PRODUCTS:
        categorySelect = CategorySelect(
          categories: widget.categories,
          categorySelect: widget.minCategorySelect,
          multiple: false,
          hasButton: false,
          categoryActionType: widget.categoryActionType,
          onJumpToProducts: _jumpToProducts,
        );
        break;
      default:
        categorySelect = CategorySelect(
          categories: widget.categories,
          categorySelect: widget.minCategorySelect,
          multiple: widget.multiple,
          hasButton: false,
        );
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _beforeMinCategorySelect);
        return Future.value(false);
      },
      child: Scaffold(
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
              Navigator.pop(context, _beforeMinCategorySelect);
            },
          ),
          actions: <Widget>[
            widget.hasNextPage
                ? FlatButton(
                    onPressed: () {
                      if (widget.fastRequirementForm.categories.isEmpty) {
                        (_scaffoldKey.currentState as ScaffoldState)
                            .showSnackBar(
                          SnackBar(
                            content: Text('请选择品类'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RequirementDatePick(
                                  fastRequirementForm:
                                      widget.fastRequirementForm,
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
                : IconButton(
                    icon: Text(
                      '确定',
                      // style: TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: categorySelect,
            ),
          ],
        ),
      ),
    );
  }
}
