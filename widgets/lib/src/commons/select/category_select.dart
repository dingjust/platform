import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CategorySelect extends StatefulWidget {
  final List<Map<CategoryModel, List<CategoryModel>>> categorys;
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
  List<Widget> _valueItem = <Widget>[];
  String _selectLeft;
  Color _color;
  List<String> _selectRights = [];

//  List<CategoryModel> _selectRights;

  @override
  void initState() {
    _verticalDivider = widget.verticalDividerOpacity;
    _multiple = widget.multiple;
    if(widget.categorySelect != null && widget.categorySelect.length>0){
      _selectLeft = widget.categorySelect[0].parent?.code;
      _selectRights = widget.categorySelect.map((category) => category.code).toList();
    }else {
      _selectLeft = widget.categorys[0].keys.toList()[0].code;
    }

    _color = Colors.black;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.categorys.forEach((category) {
      _keyItem = category.keys.map((key) {
        if (_selectLeft == key.code) {
          _color = Colors.orange;
        } else {
          _color = Colors.black;
        }
        return GestureDetector(
          onTap: () {
            if (!(_selectLeft == key.code)) {
              setState(() {
//                widget.categorySelect.clear();
                _selectLeft = key.code;
              });
            }
          },
          child: Container(
            width: 60,
            color: Colors.white10,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              height: 40,
              child: Text(
                key.name,
                style: TextStyle(color: _color),
              ),
            ),
          ),
        );
      }).toList();
    });

    widget.categorys.forEach((map) {
      final entry = map.entries.toList().firstWhere(
          (entry) => _selectLeft == entry.key.code,
          orElse: () => null);
      if (entry != null) {
        _valueItem = entry.value.map((value) {
          return ChoiceChip(
            selectedColor: Colors.orange,
            label: Text(
              value.name,
              style: TextStyle(color: Colors.black),
            ),
            selected: _selectRights.contains(value.code),
            onSelected: (select) {
              if (select) {
                setState(() {
                  if (!_multiple) {
                    widget.categorySelect.clear();
                    _selectRights.clear();
                  }
                  widget.categorySelect.add(value);
                  _selectRights.add(value.code);
                });
              } else {
                setState(() {
                  widget.categorySelect.removeWhere((category) => category.code == value.code);
                  _selectRights.remove(value.code);
                  print(widget.categorySelect);
                  print(_selectRights);
                });
              }
            },
          );
        }).toList();
      }
    });

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(
                  spacing: 5,
                  children: _valueItem,
                ),
                Offstage(
                  offstage: widget.hasButton ? false:true,
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
                        icon: Text('确定'),
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
