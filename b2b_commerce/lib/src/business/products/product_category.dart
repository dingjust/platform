import 'package:b2b_commerce/src/home/requirement/fast_publish_requirement.dart';
import 'package:b2b_commerce/src/home/requirement/requirement_date_pick.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ProductCategorySelectPage extends StatefulWidget {
  FastRequirementForm fastRequirementForm;
  List<CategoryModel> minCategorySelect;
  List<CategoryModel> categorys;

  ProductCategorySelectPage(
      {this.minCategorySelect, this.fastRequirementForm, this.categorys});

  ProductCategorySelectPageState createState() =>
      ProductCategorySelectPageState();
}

class ProductCategorySelectPageState extends State<ProductCategorySelectPage> {
  List<CategoryModel> _beforeMinCategorySelect = [];

  @override
  void initState() {
    _beforeMinCategorySelect.addAll(widget.minCategorySelect);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _beforeMinCategorySelect);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text('选择分类'),
          leading: IconButton(
              icon: Text(
                '取消',
                style: TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
              ),
              onPressed: () {
                Navigator.pop(context, _beforeMinCategorySelect);
              }),
          actions: <Widget>[
            FlatButton(
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
          ],
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: CategorySelect(
                categorys: widget.categorys,
                categorySelect: widget.minCategorySelect,
                multiple: false,
                hasButton: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
