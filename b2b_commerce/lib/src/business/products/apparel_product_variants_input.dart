import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductVariantsInputPage extends StatelessWidget {
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
              children: <Widget>[
                ColorItem(ColorModel(code: 'C01', name: '红色')),
                ColorItem(ColorModel(code: 'C02', name: '黄色')),
                ColorItem(ColorModel(code: 'C03', name: '蓝色')),
                ColorItem(ColorModel(code: 'C04', name: '绿色')),
                ColorItem(ColorModel(code: 'C05', name: '紫色')),
                ColorItem(ColorModel(code: 'C06', name: '粉红色')),
                ColorItem(ColorModel(code: 'C07', name: '藏青色')),
                ColorItem(ColorModel(code: 'C08', name: '黑色')),
                ColorItem(ColorModel(code: 'C09', name: '白色')),
                ColorItem(ColorModel(code: 'C10', name: '淡绿色')),
              ],
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
