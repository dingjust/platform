import 'package:flutter/material.dart';
import 'package:models/models.dart';

class EnumSelection extends StatefulWidget {
  final bool multiple;
  List<EnumModel> enumModels;
  List<EnumModel> enumSelect;

  EnumSelection({this.multiple = false,@required this.enumSelect,this.enumModels});

  EnumSelectionState createState() => EnumSelectionState();
}

class EnumSelectionState extends State<EnumSelection> {
  bool _multiple;
  List<EnumModel> _enumModels;
  List<String> _enumCodeSelect = [];

  @override
  void initState() {
    _enumModels = widget.enumModels;
    _multiple = widget.multiple;
    if(widget.enumSelect != null && widget.enumSelect.length>0){
      _enumCodeSelect = widget.enumSelect?.map((enumModel) => enumModel.code)?.toList();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _chips = _enumModels.map((style) {
      return Container(
//        width: 65,
        child: ChoiceChip(
          selectedColor: Colors.orange,
          label: Text(style.name,style: TextStyle(color: Colors.black),),
          selected: _enumCodeSelect.contains(style.code),
          onSelected: (select){
            if(select){
              setState(() {
                if(!_multiple){
                  widget.enumSelect.clear();
                  _enumCodeSelect.clear();
                }
                widget.enumSelect.add(style);
                _enumCodeSelect.add(style.code);
              });
            }else{
              setState(() {
                widget.enumSelect.removeWhere((enumModel) => enumModel.code == style.code);
                _enumCodeSelect.remove(style.code);
              });
            }
          },
        ),
      );
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Wrap(
          spacing: 5,
          children: _chips,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Text('取消'),
              onPressed: () {
                setState(() {
                  widget.enumSelect.clear();
                  _enumCodeSelect.clear();
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
      ],
    );
  }
}
