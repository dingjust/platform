import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ProductCategorySelectPage extends StatefulWidget {
  List<CategoryModel> minCategorySelect;
  List<CategoryModel> categorys;
  ProductCategorySelectPage({this.minCategorySelect,this.categorys});

  ProductCategorySelectPageState createState() =>
      ProductCategorySelectPageState();
}

class ProductCategorySelectPageState extends State<ProductCategorySelectPage> {
  List<CategoryModel> _beforeMinCategorySelect = [];

  @override
  void initState() {
    _beforeMinCategorySelect.addAll(widget.minCategorySelect);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,_beforeMinCategorySelect);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('选择分类'),
          leading: IconButton(icon: Text('取消'), onPressed: () => Navigator.pop(context,_beforeMinCategorySelect)),
          actions: <Widget>[
            IconButton(
              icon: Text('确定'),
              onPressed: () => Navigator.pop(context),
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
