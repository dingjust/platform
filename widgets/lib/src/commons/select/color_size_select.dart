import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ColorSizeSelectPage extends StatefulWidget {
  List<ColorModel> colors;
  List<SizeModel> sizes;
  List<ColorModel> colorFilters;
  List<SizeModel> sizeFilters;

  ColorSizeSelectPage(
      {@required this.colorFilters,
      @required this.sizeFilters,
      this.colors,
      this.sizes});

  ColorSizeSelectPageState createState() => ColorSizeSelectPageState();
}

class ColorSizeSelectPageState extends State<ColorSizeSelectPage> {
  List<String> _colorCodes = [];
  List<String> _sizeCodes = [];
  List<ColorModel> _beforeColors = [];
  List<SizeModel> _beforeSizes = [];

  @override
  void initState() {
    _colorCodes = widget.colorFilters.map((color) => color.code).toList();
    _sizeCodes = widget.sizeFilters.map((size) => size.code).toList();
    _beforeColors.addAll(widget.colorFilters);
    _beforeSizes.addAll(widget.sizeFilters);

    // TODO: implement initState
    super.initState();
  }

  //判断是否是浅色
  bool isLightColor(int color) {
    double darkness = 1 -
        (0.299 * Color(color).red +
                0.587 * Color(color).green +
                0.114 * Color(color).blue) /
            255;
    if (darkness < 0.63) {
      return true; // It's a light color
    } else {
      return false; // It's a dark color
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> colorFilterChips = widget.colors.map((ColorModel color) {
      return ChoiceChip(
        avatar: _colorCodes.contains(color.code)
            ? Icon(
                Icons.done,
                size: 18,
                color: Colors.white,
              )
            : null,
        labelPadding:
            _colorCodes.contains(color) ? EdgeInsets.only(right: 10) : null,
        backgroundColor: Color(int.parse(
            '0xFF${color.colorCode == null ? '000000' : color.colorCode.substring(1)}')),
        selectedColor: Color(int.parse(
            '0xFF${color.colorCode == null ? '000000' : color.colorCode.substring(1)}')),
        key: ValueKey<String>(color.code),
        label: Text(
          color.name,
          style: TextStyle(
            color: isLightColor(
              int.parse(
                '0xFF${color.colorCode == null ? '000000' : color.colorCode.substring(1)}',
              ),
            )
                ? Colors.black
                : Colors.white,
          ),
        ),
        selected: _colorCodes.contains(color.code),
        onSelected: (value) {
          setState(() {
            if (value) {
              widget.colorFilters.add(color);
              _colorCodes.add(color.code);
            } else {
              widget.colorFilters
                  .removeWhere((model) => model.code == color.code);
              _colorCodes.remove(color.code);
            }
          });
        },
      );
    }).toList();

    List<Widget> sizeFilterChips = widget.sizes.map((SizeModel size) {
      return FilterChip(
        labelPadding:
            _sizeCodes.contains(size.code) ? EdgeInsets.only(right: 10) : null,
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
              widget.sizeFilters
                  .removeWhere((model) => model.code == size.code);
              _sizeCodes.remove(size.code);
            }
          });
        },
      );
    }).toList();

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, [_beforeColors, _beforeSizes]);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          title: Text('颜色/尺码'),
          leading: IconButton(
            icon: Text('取消'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
                icon: Text('确定'),
                onPressed: () => Navigator.pop(
                    context, [widget.colorFilters, widget.sizeFilters]))
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
