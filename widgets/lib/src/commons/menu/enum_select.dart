import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 枚举选择器
class EnumSelectPage extends StatefulWidget {
  EnumSelectPage(this.title, this.items, [this.multiple = false]);

  final String title;
  final List<EnumModel> items;
  final bool multiple;

  EnumSelectPageState createState() => EnumSelectPageState();
}

class EnumSelectPageState extends State<EnumSelectPage>{
  List<String> selects = <String>[];

  @override
  Widget build(BuildContext context) {
    final List<dynamic> _items = widget.items.map((item) {
      return widget.multiple
          ? CheckboxListTile(
              title: Text(item.name),
              value: selects.contains(item.code),
              onChanged: (value) {
                setState(() {
                  if(value){
                    selects.add(item.code);
                  }else{
                    selects.removeWhere((code){
                      return item.code == code;
                    });
                  }
                });
              },
            )
          : RadioListTile(
              title: Text(item.name),
              value: item.code,
              groupValue: '',
              onChanged: (T) {
                Navigator.pop(context,item.code);
              },
            );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          Offstage(
            offstage: widget.multiple ? false : true,
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, selects);
              },
            ),
          )
        ],
      ),
      body: ListView(
        children: _items,
      ),
    );
  }
}
