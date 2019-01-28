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

  @override
  void initState() {
    _enumModels = widget.enumModels;
    _multiple = widget.multiple;
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
          selected: widget.enumSelect.contains(style),
          onSelected: (select){
            if(select){
              setState(() {
                if(!_multiple){
                  widget.enumSelect.clear();
                }
                widget.enumSelect.add(style);
              });
            }else{
              setState(() {
                widget.enumSelect.remove(style);
              });
            }
          },
        ),
      );
    }).toList();

    return Wrap(
      spacing: 5,
      children: _chips,
    );
  }
}
