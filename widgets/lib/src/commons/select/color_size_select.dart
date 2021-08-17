import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ColorSizeSelectPage extends StatefulWidget {
  List<ColorModel>? colors;
  List<SizeModel>? sizes;
  List<ColorModel> colorFilters;
  List<SizeModel> sizeFilters;

  ColorSizeSelectPage(
      {required this.colorFilters,
      required this.sizeFilters,
      this.colors,
      this.sizes});

  ColorSizeSelectPageState createState() => ColorSizeSelectPageState();
}

class ColorSizeSelectPageState extends State<ColorSizeSelectPage> {
  List<String> _colorCodes = [];
  List<String> _sizeCodes = [];
  List<ColorModel> _colorsTemp = [];
  List<SizeModel> _sizesTemp = [];

  bool _isOpen = false;

  @override
  void initState() {
    widget.colorFilters.forEach((color){
      _colorCodes.add(color.code);
      _colorsTemp.add(color);
    });
    widget.sizeFilters.forEach((size){
      _sizeCodes.add(size.code);
      _sizesTemp.add(size);
    });

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
    List<ColorModel>? _colors;

    if (_isOpen) {
      _colors = widget.colors;
    } else {
      _colors = widget.colors!.sublist(0, 25);
    }

    List<Widget> colorFilterChips = _colors!.map((ColorModel color) {
      return Container(
        child: ChoiceChip(
          avatar: _colorCodes.contains(color.code)
              ? Icon(
                  Icons.done,
                  size: 18,
                  color: isLightColor(
                    int.parse(
                      '0xFF${color.colorCode == null ? '000000' : color.colorCode.substring(1)}',
                    ),
                  )
                      ? Colors.black
                      : Colors.white,
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
                _colorsTemp.add(color);
                _colorCodes.add(color.code);
              } else {
                _colorsTemp
                    .removeWhere((model) => model.code == color.code);
                _colorCodes.remove(color.code);
              }
            });
          },
        ),
      );
    }).toList();

    List<Widget> sizeFilterChips = widget.sizes!.map((SizeModel size) {
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
              _sizesTemp.add(size);
              _sizeCodes.add(size.code);
            } else {
              _sizesTemp
                  .removeWhere((model) => model.code == size.code);
              _sizeCodes.remove(size.code);
            }
          });
        },
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text('颜色/尺码'),
        leading: IconButton(icon: Text('取消',style: TextStyle(color: Colors.grey,),), onPressed: () => Navigator.pop(context,[_colorsTemp,_sizesTemp])),
        actions: <Widget>[
          IconButton(
            icon: Text('确定'),
            onPressed: () {
              if(_colorsTemp.length <= 0 && _sizesTemp.length <= 0){
                showDialog(
                    context: (context),
                    builder: (context) => AlertDialog(
                      content: Text('颜色和尺码不能为空'),
                    ));
                return;
              }

              if(_colorsTemp.length <= 0){
                showDialog(
                    context: (context),
                    builder: (context) => AlertDialog(
                      content: Text('颜色不能为空'),
                    ));
                return;
              }

              if(_sizesTemp.length <= 0){
                showDialog(
                    context: (context),
                    builder: (context) => AlertDialog(
                      content: Text('尺码不能为空'),
                    ));
                return;
              }

              Navigator.pop(context,[_colorsTemp,_sizesTemp]);
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
              mainAxisSpacing: 0.5,
            ),
            GestureDetector(
              child: _isOpen ?
              Center(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_up),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30,),
                      child: Text('收起',style: TextStyle(color: Colors.grey,fontSize: 18,),),
                    ),
                  ],
                ),
              ):
              Center(
                child: Column(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_down),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30,),
                      child: Text('显示全部颜色',style: TextStyle(color: Colors.grey,fontSize: 18,),),
                    ),
                  ],
                ),
              ),
              onTap: (){
                setState(() {
                  _isOpen = !_isOpen;
                });
              },
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
    );
  }
}
