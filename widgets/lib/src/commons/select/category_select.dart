import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CategorySelect extends StatefulWidget {
  List<CategoryModel> categorys;
  final bool multiple;
  final double verticalDividerOpacity;
  final bool hasButton;
  List<CategoryModel> categorySelect;

  CategorySelect({
    @required this.categorys,
    this.multiple = true,
    this.verticalDividerOpacity = 1,
    this.categorySelect,
    this.hasButton = false,
  });

  CategorySelectState createState() => CategorySelectState();
}

class CategorySelectState extends State<CategorySelect> {
  //透明度0到1
  double _verticalDivider;

  //是否多选
  bool _multiple;
  List<Widget> _keyItem;
  List<CategoryModel> _valueItem = [];
  String _selectLeft;
  Color _color;
  List<String> _selectRights = [];

//  List<CategoryModel> _selectRights;

  @override
  void initState() {
    _verticalDivider = widget.verticalDividerOpacity;
    _multiple = widget.multiple;
    if(widget.categorySelect.isNotEmpty){
      _selectLeft = widget.categorySelect[0].parent?.code;
      _selectRights = widget.categorySelect.map((category) => category.code).toList();
//      _valueItem = widget.categorySelect[0].parent.children;
      _valueItem = widget.categorys[0].children;
    }else {
      _selectLeft = widget.categorys[0].code;
      _valueItem = widget.categorys[0].children;
    }
    _color = Colors.black;
    // TODO: implement initState
    super.initState();
  }

  Widget buildValueItem(CategoryModel category){
      return ChoiceChip(
        selectedColor: Colors.orange,
        label: Text(
          category.name,
          style: TextStyle(color: Colors.black),
        ),
        selected: _selectRights.contains(category.code),
        onSelected: (select) {
          if (select) {
            setState(() {
              if (!_multiple) {
                widget.categorySelect.clear();
                _selectRights.clear();
              }
              widget.categorySelect.add(category);
              _selectRights.add(category.code);
            });
          } else {
            setState(() {
              widget.categorySelect.removeWhere((category) => category.code == category.code);
              _selectRights.remove(category.code);
              print(widget.categorySelect);
              print(_selectRights);
            });
          }
        },
      );
  }

  @override
  Widget build(BuildContext context) {
      _keyItem = widget.categorys.map((category) {
        if (_selectLeft == category.code) {
          _color = Colors.orange;
        } else {
          _color = Colors.black;
        }
        return GestureDetector(
          onTap: () {
            if (_selectLeft != category.code) {
              setState(() {
//                widget.categorySelect.clear();
                _selectLeft = category.code;
              });
            }

            _valueItem = category.children;
          },
          child: Container(
            width: 60,
            color: Colors.white10,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              height: 40,
              child: Text(
                category.name,
                style: TextStyle(color: _color),
              ),
            ),
          ),
        );
      }).toList();

    return Row(
      children: <Widget>[
        Container(
          width: 70,
          color: Colors.white,
          child: ListView(
            children: _keyItem,
          ),
        ),
        Opacity(
          opacity: _verticalDivider,
          child: VerticalDivider(
            width: 0,
            color: Colors.grey[500],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5),
            child: ListView(
              children: <Widget>[
                Wrap(
                  spacing: 5,
                  children: _valueItem.map((category)=>buildValueItem(category)).toList(),
                ),
                Offstage(
                  offstage: !widget.hasButton,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Text('取消'),
                        onPressed: () {
                          setState(() {
                            widget.categorySelect.clear();
                            Navigator.pop(context);
                          });
                        },
                      ),
                      IconButton(
                        icon: Text('确定',style: TextStyle(color: Color(0xffFF9516)),),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
