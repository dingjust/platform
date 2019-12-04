import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class SingleCategorySelect extends StatefulWidget {
  SingleCategorySelect({
    @required this.categories,
    this.categorySelect,
    this.onItemTap,
    this.selectLeft,
  });

  final List<CategoryModel> categories;
  CategoryModel categorySelect;
  Function onItemTap;
  String selectLeft;

  SingleCategorySelectState createState() => SingleCategorySelectState();
}

class SingleCategorySelectState extends State<SingleCategorySelect> {
  List<Widget> _keyItem;
  List<CategoryModel> _valueItem = [];
  String _selectLeft;
  Color _color;
  String _selectRights;

  @override
  void initState() {
    if (widget.categorySelect != null) {
      _selectLeft = widget.categorySelect.parent?.code;
      _selectRights = widget.categorySelect?.code;
      if(widget.categorySelect.parent != null){
        _valueItem = widget.categories.firstWhere((category) => category.code == widget.categorySelect.parent.code,orElse: ()=>null).children;
      }else{
        _valueItem = widget.categories[0].children;
      }

    } else {
      _selectLeft = widget.categories[0].code;
      _valueItem = widget.categories[0].children;
    }
    _color = Colors.black;
    if(widget.selectLeft != null){
      _selectLeft = widget.selectLeft;
      _valueItem = widget.categories.firstWhere((category) => category.code == widget.selectLeft,orElse: ()=>null).children;
    }

    super.initState();
  }

  Widget buildValueItem(CategoryModel category) {
    return GestureDetector(
      onTap: () {
//        if (_selectRights == category.code) {
//          setState(() {
//            _selectRights = null;
//            widget.onItemTap(null);
//          });
//        } else {
          setState(() {
            _selectRights = category.code;
            widget.onItemTap(category);
          });
//        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: _selectRights == category.code
                    ? Color.fromRGBO(255, 219, 0, 1)
                    : Colors.white)),
        child: Column(
          children: <Widget>[
            category.thumbnail != null
                ? Container(
                    padding: EdgeInsets.all(10),
                    child: Image.network(
                      '${category.thumbnail.actualUrl}',
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(right: 10),
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(243, 243, 243, 1)),
                    child: Icon(
                      B2BIcons.noPicture,
                      color: Color.fromRGBO(200, 200, 200, 1),
                      size: 40,
                    ),
                  ),
            Text(
              '${category.name}',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14,color: _selectRights == category.code
                  ? Color.fromRGBO(255, 219, 0, 1)
                  : Colors.black),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _keyItem = widget.categories.map((category) {
      if (_selectLeft == category.code) {
        _color = Color.fromRGBO(255, 214, 12, 1);
      } else {
        _color = Colors.black;
      }
      return GestureDetector(
        onTap: () {
          if (_selectLeft != category.code) {
            setState(() {
              _selectLeft = category.code;
            });
          }

          _valueItem = category.children;
        },
        child: Container(
          width: 60,
          color: _selectLeft == category.code
              ? Colors.white
              : Color.fromRGBO(245, 244, 243, 1),
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            height: 60,
            child: Center(
              child: Text(
                category.name,
                style: TextStyle(color: _color),
              ),
            ),
          ),
        ),
      );
    }).toList();

    return Row(
      children: <Widget>[
        Container(
          width: 70,
          color: Color.fromRGBO(245, 244, 243, 1),
          child: ListView(
            children: _keyItem,
          ),
        ),
        Expanded(
          child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    sliver: SliverGrid(
                      //Grid
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //Grid按两列显示
                        mainAxisSpacing: 5.0,
                        crossAxisSpacing: 30.0,
                        childAspectRatio: 0.6,
                      ),
                      delegate: new SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          //创建子widget
                          return buildValueItem(_valueItem[index]);
                        },
                        childCount: _valueItem.length,
                      ),
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }
}
