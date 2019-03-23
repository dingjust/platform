import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:b2b_commerce/src/home/requirement/fast_publish_requirement.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_date_pick.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class CategorySelectPage extends StatefulWidget {
  FastRequirementForm fastRequirementForm;
  List<CategoryModel> minCategorySelect;
  List<CategoryModel> categorys;
  bool hasNextPage;

  ///分类选择动作类型
  final CategoryActionType categoryActionType;

  CategorySelectPage({
    this.minCategorySelect,
    this.fastRequirementForm,
    this.categorys,
    this.hasNextPage = false,
    this.categoryActionType = CategoryActionType.none,
  });

  CategorySelectPageState createState() => CategorySelectPageState();
}

class CategorySelectPageState extends State<CategorySelectPage> {
  List<CategoryModel> _beforeMinCategorySelect = [];

  @override
  void initState() {
    _beforeMinCategorySelect.addAll(widget.minCategorySelect);
    super.initState();
  }

  void _jumpToFactories(CategoryModel category) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => FactoryPage()));
  }

  void _jumpToProducts(CategoryModel category) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProductsPage()));
  }

  @override
  Widget build(BuildContext context) {
    CategorySelect categorySelect;

    switch (widget.categoryActionType) {
      case CategoryActionType.TO_FACTORIES:
        categorySelect = CategorySelect(
            categorys: widget.categorys,
            categorySelect: widget.minCategorySelect,
            multiple: false,
            hasButton: false,
            categoryActionType: widget.categoryActionType,
            onJumpToFactories: _jumpToFactories);
        break;
      case CategoryActionType.TO_PRODUCTS:
        categorySelect = CategorySelect(
            categorys: widget.categorys,
            categorySelect: widget.minCategorySelect,
            multiple: false,
            hasButton: false,
            categoryActionType: widget.categoryActionType,
            onJumpToProducts: _jumpToProducts);
        break;
      default:
        categorySelect = CategorySelect(
          categorys: widget.categorys,
          categorySelect: widget.minCategorySelect,
          multiple: false,
          hasButton: false,
        );
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _beforeMinCategorySelect);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: widget.hasNextPage ? 0 : 0.5,
          centerTitle: true,
          title: Text('选择分类'),
          leading: IconButton(
              icon: Text(
                '取消',
                style: TextStyle(
                    color: widget.hasNextPage
                        ? Color.fromRGBO(255, 214, 12, 1)
                        : Colors.grey),
              ),
              onPressed: () {
                Navigator.pop(context, _beforeMinCategorySelect);
              }),
          actions: <Widget>[
            widget.hasNextPage
                ? FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RequirementDatePick(
                                fastRequirementForm: widget.fastRequirementForm,
                              )));
                    },
                    child: Text(
                      '下一步',
                      style: TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
                    ),
                  )
                : IconButton(
                    icon: Text(
                      '确定',
                      // style: TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
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
