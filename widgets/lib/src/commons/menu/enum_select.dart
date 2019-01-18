import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 枚举选择器
class EnumSelectPage extends StatefulWidget {
  EnumSelectPage({
    this.title,
    this.items,
    this.code,
    this.codes,
    this.multiple = false,
  });

  final String title;
  final List<EnumModel> items;
  final bool multiple;
  final String code;
  final List<String> codes;

  EnumSelectPageState createState() => EnumSelectPageState();
}

class EnumSelectPageState extends State<EnumSelectPage> {
  List<EnumModel> _selects;
  EnumModel _singleSelect;

  @override
  void initState() {
    widget.items.firstWhere((item) => item.code == 'a', orElse: () => null);
    if (widget.codes != null && widget.codes.length > 0) {
      _selects = widget.codes.map((code) {
        return widget.items
            .firstWhere((select) => select.code == code, orElse: () => null);
      }).toList();
    } else {
      _selects = <EnumModel>[];
    }

    _singleSelect = widget.items
        .firstWhere((select) => select.code == widget.code, orElse: () => null);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> _items = widget.items.map((item) {
      return widget.multiple
          ? CheckboxListTile(
              selected: _selects.contains(item),
              title: Text(item.name),
              value: _selects.contains(item),
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _selects.add(item);
                  } else {
                    _selects.removeWhere((select) {
                      return item.code == select.code;
                    });
                  }
                });
              },
            )
          : RadioListTile(
              selected: _singleSelect?.code == item.code,
              title: Text(item.name),
              value: item.code,
              groupValue: _singleSelect?.code,
              onChanged: (T) {
                setState(() {
                  _singleSelect = item;
                });
              },
            );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              if (widget.multiple) {
                Navigator.pop(context, _selects);
              } else {
                Navigator.pop(context, _singleSelect);
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: _items,
      ),
    );
  }
}
