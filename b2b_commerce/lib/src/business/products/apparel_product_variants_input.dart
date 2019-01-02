import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductVariantsInputPage extends StatelessWidget {
  final List<FilterChip> filterChips = <ColorModel>[
    ColorModel(code: 'C01', name: '红色'),
    ColorModel(code: 'C02', name: '黄色')
  ].map((ColorModel color) {
    return FilterChip(
      key: ValueKey<String>(color.code),
      label: Text(color.name),
      selected: false, // _tools.contains(name) ? _selectedTools.contains(name) : false,
      onSelected: null,
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('颜色/尺码'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text('选择颜色'),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              padding: const EdgeInsets.all(5),
              children: filterChips,
            ),
            Text('选择尺码'),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              padding: const EdgeInsets.all(5),
              children: <Widget>[
                SizeItem(SizeModel(code: 'S01', name: 'XXXL')),
                SizeItem(SizeModel(code: 'S02', name: 'XXL')),
                SizeItem(SizeModel(code: 'S03', name: 'XL')),
                SizeItem(SizeModel(code: 'S04', name: 'L')),
                SizeItem(SizeModel(code: 'S05', name: 'M')),
                SizeItem(SizeModel(code: 'S06', name: 'S')),
                SizeItem(SizeModel(code: 'S07', name: 'XS')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ColorItem extends StatelessWidget {
  ColorItem(this.item);

  final ColorModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 10,
      child: Text(item.name),
    );
  }
}

class SizeItem extends StatelessWidget {
  SizeItem(this.item);

  final SizeModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 10,
      child: Text(item.name),
    );
  }
}
