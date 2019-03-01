import 'package:flutter/material.dart';
import 'package:models/models.dart';

class EnumSelection extends StatefulWidget {
  final bool multiple;
  final bool hasButton;
  List<EnumModel> enumModels;
  List<EnumModel> enumSelect;
  final int count;

  EnumSelection({this.multiple = false,this.hasButton = false,@required this.enumSelect,this.enumModels,this.count = 4,});

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
    if(widget.enumSelect.isNotEmpty){
      _enumCodeSelect = widget.enumSelect?.map((enumModel) => enumModel.code)?.toList();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _chips = _enumModels.map((style) {
      return Container(
        width: MediaQuery.of(context).size.width / widget.count,
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

    return ListView(
      children: <Widget>[
        Offstage(
          offstage: !widget.hasButton,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Text('清除'),
                  onPressed: () {
                    setState(() {
                      widget.enumSelect.clear();
                      _enumCodeSelect.clear();
                    });
                  },
                ),
              ),
//              IconButton(
//                icon: Text('确定',style: TextStyle(color: Color(0xffFF9516)),),
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//              ),
            ],
          ),
        ),
        Container(
//          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 0,
            children: _chips,
          ),
        ),
      ],
    );
  }
}
