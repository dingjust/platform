import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductVariantsInputPage extends StatefulWidget {
  ApparelProductVariantsInputState createState() =>
      ApparelProductVariantsInputState();
}

class ApparelProductVariantsInputState
    extends State<ApparelProductVariantsInputPage> {
  List<String> _colorFilters = <String>[];
  List<String> _sizeFilters = <String>[];

  List<Widget> get colorFilterChips {
    return <ColorModel>[
      ColorModel(code: 'C01', name: '红色',colorCode: 'FF0033'),
      ColorModel(code: 'C02', name: '黄色',colorCode: 'FFCC00'),
      ColorModel(code: 'C03', name: '粉红',colorCode: 'FF9999'),
      ColorModel(code: 'C04', name: '海军蓝',colorCode: '0066FF'),
      ColorModel(code: 'C05', name: '浅紫',colorCode: 'CC99CC'),
      ColorModel(code: 'C06', name: '藏青',colorCode: '000033'),
    ].map((ColorModel color) {
      return ChoiceChip(
        avatar: _colorFilters.contains(color.code)?Icon(Icons.done,size: 18,color: Colors.white,):null,
        labelPadding: _colorFilters.contains(color.code)
            ? EdgeInsets.only(right: 10)
            : null,
        backgroundColor: Color(int.parse('0xFF'+color.colorCode)),
        selectedColor:  Color(int.parse('0xFF'+color.colorCode)),
        key: ValueKey<String>(color.code),
        label: Text(color.name,style: TextStyle(color: Colors.white),),
        selected: _colorFilters.contains(color.code),
        onSelected: (value) {
          setState(() {
            if (value) {
              _colorFilters.add(color.code);
            } else {
              _colorFilters.removeWhere((String code) {
                return code == color.code;
              });
            }
          });
        },
      );
    }).toList();
  }

  List<Widget> get sizeFilterChips {
    return <SizeModel>[
      SizeModel(code: 'S01', name: 'XXXL'),
      SizeModel(code: 'S02', name: 'XXL'),
      SizeModel(code: 'S03', name: 'XL'),
      SizeModel(code: 'S04', name: 'L'),
      SizeModel(code: 'S05', name: 'M'),
      SizeModel(code: 'S06', name: 'S'),
      SizeModel(code: 'S07', name: 'XS')
    ].map((SizeModel size) {
      return FilterChip(
        labelPadding: _sizeFilters.contains(size.code)
            ? EdgeInsets.only(right: 10)
            : null,
        selectedColor: Colors.red,
        key: ValueKey<String>(size.code),
        label: Text(size.name),
        selected: _sizeFilters.contains(size.code),
        onSelected: (value) {
          setState(() {
            if (value) {
              _sizeFilters.add(size.code);
            } else {
              _sizeFilters.removeWhere((String code) {
                return code == size.code;
              });
            }
          });
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('颜色/尺码'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
            ),
            onPressed: () {
              Map<String,List<String>> map = Map();
              map['colors'] = _colorFilters;
              map['sizes'] = _sizeFilters;
              Navigator.pop(context,map);
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
              children: colorFilterChips,
            ),
            Text('选择尺码'),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 5,
              padding: const EdgeInsets.all(5),
              children: sizeFilterChips,
            ),
          ],
        ),
      ),
    );
  }
}

/*class ColorItem extends StatelessWidget {
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
}*/
