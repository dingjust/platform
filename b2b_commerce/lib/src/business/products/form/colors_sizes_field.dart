import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ColorsSizesField extends StatefulWidget {
  ColorsSizesField(this.item, {this.colors, this.sizes});

  List<ColorSizeModel> colors;
  List<ColorSizeEntryModel> sizes;
  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _ColorsSizesFieldState();
}

class _ColorsSizesFieldState extends State<ColorsSizesField> {
  List<ColorSizeModel> _colors;
  List<ColorSizeEntryModel> _sizes;
  List<ColorSizeModel> _selectColors = [];
  List<ColorSizeEntryModel> _selectSizes = [];
  List<String> _selectColorNames = [];
  List<String> _selectSizeNames = [];
  //是否显示自定义颜色输入框
  bool _showCustomColorInput = false;
  //是否显示自定义尺码输入框
  bool _showCustomSizeInput = false;
  TextEditingController _customColorController = TextEditingController();
  TextEditingController _customSizeController = TextEditingController();

  @override
  void initState() {
    _colors = List.from(widget.colors);
    _sizes = List.from(widget.sizes);
    if (widget.item.colorSizes != null && widget.item.colorSizes.length > 0) {
      _selectColors = widget.item.colorSizes.map((color) {
        print('${color.colorName}--${color.customize}');
        if (color.customize != null && color.customize) {
          if (_colors
                  .indexWhere((color1) => color1.colorName == color.colorName) <
              0) {
            _colors.add(color);
          }
        }
        if (color.sizes != null &&
            color.sizes.length > 0 &&
            _selectSizes.length <= 0) {
          _selectSizes = List.from(color.sizes);
          _selectSizeNames = _selectSizes.map((size) {
            if (size.customize != null && size.customize) {
              if (_sizes.indexWhere((size1) => size1.name == size.name) < 0) {
                _sizes.add(size);
              }
            }
            return size.name;
          }).toList();
        }
        return color;
      }).toList();
      print('initState----------------');
      _selectColorNames =
          _selectColors.map((color) => color.colorName).toList();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('颜色/尺码'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Text('确定'),
                onPressed: () {
                  if (_selectColors == null || _selectColors.isEmpty) {
                    BotToast.showText(text: '请选择颜色');
                    return;
                  }
                  if (_selectSizes == null || _selectSizes.isEmpty) {
                    BotToast.showText(text: '请选择尺码');
                    return;
                  }
                  widget.item.colorSizes = _selectColors;
                  widget.item.colorSizes.forEach((colorSize) {
                    colorSize.sizes = _selectSizes
                        .map((size) =>
                        ColorSizeEntryModel.fromJson(
                            ColorSizeEntryModel.toJson(size)))
                        .toList();
                  });
                  Navigator.pop(context, widget.item);
                })
          ],
          elevation: 0.5,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: Text('颜色')),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _selectColorNames.clear();
                          _selectColors.clear();
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.restore_from_trash,
                            size: 17,
                          ),
                          Text('清空已选项'),
                        ],
                      ))
                ],
              ),
            ),
            _buildCheckColorWidget(),
            Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _showCustomColorInput = true;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            size: 17,
                            color: Colors.red,
                          ),
                          Text(
                            '自定义',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            _buildCustomColorInput(context),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: Text('尺码')),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _selectSizeNames.clear();
                          _selectSizes.clear();
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.restore_from_trash,
                            size: 17,
                          ),
                          Text('清空已选项'),
                        ],
                      ))
                ],
              ),
            ),
            _buildCheckSizeWidget(),
            Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          _showCustomSizeInput = true;
                        });
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.add,
                            size: 17,
                            color: Colors.red,
                          ),
                          Text(
                            '自定义',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            _buildCustomSizeInput(context),
          ],
        ),
      ),
    );
  }

  Container _buildCheckSizeWidget() {
    return _sizes == null
        ? Container(
      child: SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
      color: Colors.white,
    )
        : Container(
      padding: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 5,
        childAspectRatio: 2,
        crossAxisSpacing: 0,
        mainAxisSpacing: 10,
        padding: EdgeInsets.zero,
        children: List.generate(_sizes.length, (index) {
          return Container(
            child: ChoiceChip(
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                    color: _selectSizeNames.contains(_sizes[index].name)
                        ? Colors.white
                        : Colors.grey),
              ),
              backgroundColor: Colors.white,
              avatar: null,
              selectedColor: Color(0xffffd60c),
//                                      key: ValueKey<String>(snapshot.data[index].name),
              label: Container(
                width: 55,
                child: Center(
                  child: Text(
                    _sizes[index].name,
                  ),
                ),
              ),
              selected: _selectSizeNames.contains(_sizes[index].name),
              onSelected: (value) {
                setState(() {
                  if (value) {
                    _selectSizeNames.add(_sizes[index].name);
                    _selectSizes.add(ColorSizeEntryModel(
                        code: _sizes[index].code,
                        name: _sizes[index].name));
                  } else {
                    _selectSizeNames.remove(_sizes[index].name);
                    _selectSizes.removeWhere(
                            (size) => _sizes[index].name == size.name);
                  }
                });
              },
            ),
          );
        }),
      ),
    );
  }

  Offstage _buildCustomColorInput(BuildContext context) {
    return Offstage(
      offstage: !_showCustomColorInput,
      child: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 35, maxWidth: 200),
                  child: TextField(
//                        autofocus: true,
                    controller: _customColorController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          )),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: '请输入',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            FlatButton(
                onPressed: () {
                  if (_customColorController.text != '') {
                    if (_colors.any((element) =>
                    element.colorName == _customColorController.text)) {
                      BotToast.showText(text: '颜色重复');
                    } else {
                      setState(() {
                        ColorSizeModel color = ColorSizeModel(
                            colorName: _customColorController.text,
                            customize: true);
                        _selectColors.add(color);
                        _selectColorNames.add(_customColorController.text);
                        _colors.add(color);
                        _showCustomColorInput = false;
                        _customColorController.text = '';
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  }
                },
                child: Text(
                  '添加',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Offstage _buildCustomSizeInput(BuildContext context) {
    return Offstage(
      offstage: !_showCustomSizeInput,
      child: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 35, maxWidth: 200),
                  child: TextField(
//                        autofocus: true,
                    controller: _customSizeController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          )),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: '请输入',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            FlatButton(
                onPressed: () {
                  if (_customColorController.text != '') {
                    if (_colors.any((element) =>
                    element.colorName == _customColorController.text)) {
                      BotToast.showText(text: '颜色重复');
                    } else {
                      setState(() {
                        ColorSizeModel color = ColorSizeModel(
                            colorName: _customColorController.text,
                            customize: true);
                        _selectColors.add(color);
                        _selectColorNames.add(_customColorController.text);
                        _colors.add(color);
                        _showCustomColorInput = false;
                        _customColorController.text = '';
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  }

                  if (_customSizeController.text != '') {
                    if (_sizes.any((element) =>
                    element.name == _customSizeController.text)) {
                      BotToast.showText(text: '尺码重复');
                    } else {
                      setState(() {
                        ColorSizeEntryModel size = ColorSizeEntryModel(
                            name: _customSizeController.text, customize: true);
                        _selectSizes.add(size);
                        _selectSizeNames.add(size.name);
                        _sizes.add(size);
                        _showCustomSizeInput = false;
                        _customSizeController.text = '';
                      });
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                  }
                },
                child: Text(
                  '添加',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Container _buildCheckColorWidget() {
    return _colors == null
        ? Container(
      child: SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
      color: Colors.white,
    )
        : Container(
      padding: EdgeInsets.only(top: 10),
      color: Colors.white,
      child: Container(
        color: Colors.white,
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 5,
          childAspectRatio: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          padding: EdgeInsets.zero,
          children: List.generate(_colors.length, (index) {
            return ChoiceChip(
              padding: EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(
                    color: _selectColorNames
                        .contains(_colors[index].colorName)
                        ? Colors.white
                        : Colors.grey),
              ),
              backgroundColor: Colors.white,
              avatar: null,
              selectedColor: Color(0xffffd60c),
//                                    key: ValueKey<String>(_colors[index].name),
              label: Container(
                width: 55,
                child: Center(
                  child: Text(
                    _colors[index].colorName,
                  ),
                ),
              ),
              selected:
              _selectColorNames.contains(_colors[index].colorName),
              onSelected: (value) {
                setState(() {
                  if (value) {
                    _selectColorNames.add(_colors[index].colorName);
                    _selectColors.add(ColorSizeModel(
                        colorName: _colors[index].colorName,
                        colorCode: _colors[index].colorCode));
                  } else {
                    _selectColorNames.remove(_colors[index].colorName);
                    _selectColors.removeWhere((color) =>
                    _colors[index].colorName == color.colorName);
                  }
                });
              },
            );
          }),
              ),
            ),
          );
  }
}
