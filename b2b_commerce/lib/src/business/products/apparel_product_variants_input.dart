import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductVariantsInputPage extends StatefulWidget {
  List<ColorModel> colorFilters;
  List<SizeModel> sizeFilters;

  ApparelProductVariantsInputPage({this.colorFilters, this.sizeFilters});

  ApparelProductVariantsInputState createState() =>
      ApparelProductVariantsInputState();
}

class ApparelProductVariantsInputState
    extends State<ApparelProductVariantsInputPage> {
  List<String> _colorCodes = [];
  List<String> _sizeCodes = [];
  List<ColorModel> _beforeColors = [];
  List<SizeModel> _beforeSizes = [];

  final List<ColorModel> _colors = <ColorModel>[
    ColorModel(code: 'C01', name: '红色', colorCode: 'FF0033'),
    ColorModel(code: 'C02', name: '黄色', colorCode: 'FFCC00'),
    ColorModel(code: 'C03', name: '粉红', colorCode: 'FF9999'),
    ColorModel(code: 'C04', name: '海军蓝', colorCode: '0066FF'),
    ColorModel(code: 'C05', name: '浅紫', colorCode: 'CC99CC'),
    ColorModel(code: 'C06', name: '藏青', colorCode: '000033'),
  ];
  final List<SizeModel> _sizes = <SizeModel>[
    SizeModel(code: 'S01', name: 'XXXL'),
    SizeModel(code: 'S02', name: 'XXL'),
    SizeModel(code: 'S03', name: 'XL'),
    SizeModel(code: 'S04', name: 'L'),
    SizeModel(code: 'S05', name: 'M'),
    SizeModel(code: 'S06', name: 'S'),
    SizeModel(code: 'S07', name: 'XS')
  ];

  @override
  void initState() {
    _colorCodes = widget.colorFilters.map((color) => color.code).toList();
    _sizeCodes = widget.sizeFilters.map((size) => size.code).toList();
    _beforeColors.addAll(widget.colorFilters);
    _beforeSizes.addAll(widget.sizeFilters);


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> colorFilterChips = _colors.map((ColorModel color) {
      return ChoiceChip(
        avatar: _colorCodes.contains(color.code)
            ? Icon(
                Icons.done,
                size: 18,
                color: Colors.white,
              )
            : null,
        labelPadding: _colorCodes.contains(color)
            ? EdgeInsets.only(right: 10)
            : null,
        backgroundColor: Color(int.parse('0xFF' + color.colorCode)),
        selectedColor: Color(int.parse('0xFF' + color.colorCode)),
        key: ValueKey<String>(color.code),
        label: Text(
          color.name,
          style: TextStyle(color: Colors.white),
        ),
        selected: _colorCodes.contains(color.code),
        onSelected: (value) {
          setState(() {
            if (value) {
              widget.colorFilters.add(color);
              _colorCodes.add(color.code);
            } else {
              widget.colorFilters.removeWhere((model) => model.code == color.code);
              _colorCodes.remove(color.code);
            }
          });
        },
      );
    }).toList();

    List<Widget> sizeFilterChips = _sizes.map((SizeModel size) {
      return FilterChip(
        labelPadding: _sizeCodes.contains(size.code)
            ? EdgeInsets.only(right: 10)
            : null,
        selectedColor: Colors.red,
        key: ValueKey<String>(size.code),
        label: Text(size.name),
        selected: _sizeCodes.contains(size.code),
        onSelected: (value) {
          setState(() {
            if (value) {
              widget.sizeFilters.add(size);
              _sizeCodes.add(size.code);
            } else {
              widget.sizeFilters.removeWhere((model) => model.code == size.code);
              _sizeCodes.remove(size.code);
            }
          });
        },
      );
    }).toList();

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context,[_beforeColors,_beforeSizes]);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          title: Text('颜色/尺码'),
          leading: IconButton(icon: Text('取消'), onPressed: () => Navigator.pop(context,[_beforeColors,_beforeSizes])),
          actions: <Widget>[
            IconButton(
              icon: Text('确定'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Text('选择颜色'),
              GridView.count(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 5,
                padding: const EdgeInsets.all(5),
                children: colorFilterChips,
              ),
              Text('选择尺码'),
              GridView.count(
                primary: false,
                shrinkWrap: true,
                crossAxisCount: 5,
                padding: const EdgeInsets.all(5),
                children: sizeFilterChips,
              ),
            ],
          ),
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
