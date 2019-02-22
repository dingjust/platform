import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 枚举选择器
class EnumSelectPage extends StatefulWidget {
  EnumSelectPage({
    this.title,
    this.items,
    this.codes,
    this.multiple = false,
  });

  final String title;
  final List<EnumModel> items;
  final bool multiple;
  final List<String> codes;

  EnumSelectPageState createState() => EnumSelectPageState();
}

class EnumSelectPageState extends State<EnumSelectPage> {
  List<String> _beforeModifyCodes = [];

  @override
  void initState() {
    if(widget.codes != null) _beforeModifyCodes.addAll(widget.codes);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> _items = widget.items.map((item) {
      return CheckboxListTile(
              selected: widget.codes.contains(item.code),
              title: Text(item.name),
              value: widget.codes.contains(item.code),
              onChanged: (value) {
                setState(() {
                  if (value) {
                    if(!widget.multiple){
                      widget.codes.clear();
                    }
                    widget.codes.add(item.code);
                  } else {
                    widget.codes.remove(item.code);
                  }
                });
              },
            );
    }).toList();

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context,_beforeModifyCodes);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text(widget.title),
          leading: IconButton(icon: Text('取消'), onPressed: () => Navigator.pop(context,_beforeModifyCodes),),
          actions: <Widget>[
            IconButton(
              icon: Text('确定'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: ListView(
          children: _items,
        ),
      ),
    );
  }
}
