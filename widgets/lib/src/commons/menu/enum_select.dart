import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 枚举选择器
class EnumSelectPage extends StatefulWidget {
  EnumSelectPage({
    this.title,
    this.items,
    this.codes,
    this.multiple = false,
    this.count = 4,
    this.models,
  }){
   if(this.codes == null) this.codes = [];
  }

  final String title;
  final List<EnumModel> items;
  final bool multiple;
  List<String> codes;
  final int count;
  List<EnumModel> models;

  EnumSelectPageState createState() => EnumSelectPageState();
}

class EnumSelectPageState extends State<EnumSelectPage> {
  List<String> _beforeModifyCodes = [];
  List<EnumModel> _beforModifyModels;

  @override
  void initState() {
    if(widget.models != null){
      widget.codes = widget.models.map((model) => model.code).toList();
      _beforModifyModels = [];
      _beforModifyModels.addAll(widget.models);
    }
      if(widget.codes != null) _beforeModifyCodes.addAll(widget.codes);

      // TODO: implement initState
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> _items = widget.items.map((item) {
      return Container(
        width: MediaQuery.of(context).size.width / widget.count,
        child: ChoiceChip(
          selectedColor: Colors.orange,
          label: Text(item.name,style: TextStyle(color: Colors.black),),
          selected: widget.codes.contains(item.code),
          onSelected: (value) {
            setState(() {
              if (value) {
                if(!widget.multiple){
                  widget.codes.clear();
                  if(widget.models != null) widget.models.clear();
                }
                widget.codes.add(item.code);
                if(widget.models != null) widget.models.add(item);
              } else {
                widget.codes.remove(item.code);
                if(widget.models != null) widget.models.removeWhere((model)=> item.code == model.code);
              }
            });
          },
        ),
      );
//      return CheckboxListTile(
//              selected: widget.codes.contains(item.code),
//              title: Text(item.name),
//              value: widget.codes.contains(item.code),
//              onChanged: (value) {
//                setState(() {
//                  if (value) {
//                    if(!widget.multiple){
//                      widget.codes.clear();
//                    }
//                    widget.codes.add(item.code);
//                  } else {
//                    widget.codes.remove(item.code);
//                  }
//                });
//              },
//            );
    }).toList();

    return WillPopScope(
      onWillPop: () {
        if(widget.models != null){
          Navigator.pop(context,_beforModifyModels);
        }else{
          Navigator.pop(context,_beforeModifyCodes);
        }
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text(widget.title),
          leading: IconButton(icon: Text('取消'), onPressed: () {
            if(widget.models != null){
              Navigator.pop(context,_beforModifyModels);
            }else{
              Navigator.pop(context,_beforeModifyCodes);
            }
          }),
          actions: <Widget>[
            IconButton(
              icon: Text('确定',style: TextStyle(color: Color(0xffFF9516)),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
//              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 0,
                children: _items,
              ),
            ),
          ],
        )
      ),
    );
  }
}
