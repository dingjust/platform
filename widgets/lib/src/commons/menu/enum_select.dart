import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 枚举选择器
class EnumSelectPage extends StatelessWidget {
  EnumSelectPage(this.title, this.items, [this.multiple = false]);

  final String title;
  final List<EnumModel> items;
  final bool multiple;

  @override
  Widget build(BuildContext context) {
    final List<dynamic> _items = items.map((item) {
      return multiple
          ? CheckboxListTile(
              title: Text(item.name),
              value: false,
              onChanged: (T) {},
            )
          : RadioListTile(
              title: Text(item.name),
              value: item.code,
              groupValue: '',
              onChanged: (T) {
                Navigator.pop(context,item.name);
              },
            );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, null);
            },
          )
        ],
      ),
      body: ListView(
        children: _items,
      ),
    );
  }
}
