import 'package:flutter/material.dart';
import 'package:models/models.dart';

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

  //页面title
  final String title;
  //全部枚举的集合
  final List<dynamic> items;
  //是否多选
  final bool multiple;
  //被选中的枚举的code
  List<String> codes;
  //一行显示多少个
  final int count;
  //被选中的枚举model
  List<dynamic> models;

  EnumSelectPageState createState() => EnumSelectPageState();
}

class EnumSelectPageState extends State<EnumSelectPage> {
  List<String> _beforeModifyCodes = [];
  List<dynamic> _beforModifyModels;

  @override
  void initState() {
//    widget.models.forEach((model){
//      print(model.code+'==='+model.name);
//    });
    if(widget.models != null){
//      widget.codes = widget.models.map((model) => model.code).toList();
      _beforModifyModels = [];
      _beforModifyModels.addAll(widget.models);
    }
      if(widget.codes != null) _beforeModifyCodes.addAll(widget.codes);
      // TODO: implement initState
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //当有键盘的状态进来时，widget.codes会被清空，所以在build的时候重新赋值
    if(widget.models != null) widget.codes = widget.models.map<String>((model) {
      if(model is LabelModel){
        return model.name;
      }else{
        return model.code;
      }
    }).toList();
    final List<dynamic> _items = widget.items.map((item) {
//      print(widget.codes.toString() + '-----'+ item.code);
      return Container(
        width: MediaQuery.of(context).size.width / widget.count,
        child: ChoiceChip(
          selectedColor: Color.fromRGBO(255,214,12, 1),
          label: Text(item.name,style: TextStyle(color: Colors.black),),
          selected: _isContains(item),
          onSelected: (value) {
            setState(() {
              if (value) {
                if(!widget.multiple){
                  widget.codes.clear();
                  if(widget.models != null) widget.models.clear();
                }
                //是否是标签对象
                if(item is LabelModel){
                  widget.codes.add(item.name);
                }else{
                  widget.codes.add(item.code);
                }
                if(widget.models != null) widget.models.add(item);
                print(widget.models);
              } else {
                //是否是标签对象
                if(item is LabelModel){
                  widget.codes.remove(item.name);
                }else{
                  widget.codes.remove(item.code);
                }
                if(widget.models != null) widget.models.removeWhere((model){
                  //是否是标签对象
                  if(model is LabelModel){
                    return item.name == model.name;
                  }else{
                    return item.code == model.code;
                  }
                });
              }
            });
          },
        ),
      );
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
          title: Text(widget.title ?? ''),
          leading: IconButton(icon: Text('取消',style: TextStyle(color: Colors.grey,),), onPressed: () {
            if(widget.models != null){
              Navigator.pop(context,_beforModifyModels);
            }else{
              Navigator.pop(context,_beforeModifyCodes);
            }
          }),
          actions: <Widget>[
            IconButton(
              icon: Text('确定',style: TextStyle(),),
              onPressed: () {
                print(widget.models);
                print(widget.codes);
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

  bool _isContains(item) {
    if(item is LabelModel){
      return widget.codes.contains(item.name);
    }else{
      return widget.codes.contains(item.code);
    }
  }
}
