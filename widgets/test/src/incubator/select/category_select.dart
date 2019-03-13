import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CategorySelectPage extends StatefulWidget {
  final List<Map<CategoryModel, List<CategoryModel>>> categorys;
  final bool multiple;
  final double verticalDividerOpacity;
  List<CategoryModel> categorySelect;

  CategorySelectPage({@required this.categorys,this.multiple = false,this.verticalDividerOpacity = 1,this.categorySelect});

  CategorySelectPageState createState() => CategorySelectPageState();
}

class CategorySelectPageState extends State<CategorySelectPage> {

  //透明度0到1
  double _verticalDivider;
  //是否多选
  bool _multiple;
  List<Widget> _keyItem;
  List<Widget> _valueItem = <Widget>[];
  String _selectLeft;
  Color _color;


  @override
  void initState() {
    _verticalDivider = widget.verticalDividerOpacity;
    _multiple = widget.multiple;
    _selectLeft = widget?.categorys?.length > 0 ? widget.categorys[0].keys.toList()[0].code : null;
    _color = Colors.black;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.categorys.forEach((category) {
      _keyItem = category.keys.map((key) {
        print(key.name);
        if(_selectLeft == key.code){
          _color = Color.fromRGBO(255,214,12, 1);
        }else{
          _color = Colors.black;
        }
        return Container(
          padding: EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () {
              if(!(_selectLeft == key.code)){
                setState(() {
                  widget.categorySelect.clear();
                  _selectLeft = key.code;
                });
              }
            },
            child: Text(key.name,style: TextStyle(color: _color),),
          ),
        );
      }).toList();
    });

    widget.categorys.forEach((map) {
      final entry = map.entries
          .toList()
          .firstWhere((entry) => _selectLeft == entry.key.code,
          orElse: () => null);
      if(entry != null){
        _valueItem =
            entry.value
                .map((value) {
              return Container(
                width: 65,
                child: ChoiceChip(
                  selectedColor: Color.fromRGBO(255,214,12, 1),
                  label: Text(value.name,style: TextStyle(color: Colors.black),),
                  selected: widget.categorySelect.contains(value),
                  onSelected: (select){
                    if(select){
                      setState(() {
                        if(!_multiple){
                          widget.categorySelect.clear();
                        }
                        widget.categorySelect.add(value);
                      });
                    }else{
                      setState(() {
                        widget.categorySelect.remove(value);
                      });
                    }
                  },
                ),
              );
            }).toList();
      }
    });

    return Row(
      children: <Widget>[
        Container(
          width: 70,
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
        Flexible(
          child: Padding(
            padding:
            const EdgeInsets.only(left: 10, top: 5),
            child: ListView(
              children: <Widget>[
                Wrap(
                  spacing: 5,
                  children: _valueItem,
                ),
              ],
            ),
          ),
        )
      ],
    );

  }
}
