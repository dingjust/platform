import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ColorSizeTable extends StatefulWidget {
  final List<OrderNoteEntryModel> noteEntries;

  final List<PurchaseOrderEntryModel> orderEntries;

  final int rowHeith;

  ColorSizeTable(
      {Key key, this.noteEntries, this.rowHeith = 50, this.orderEntries})
      : super(key: key);

  @override
  _ColorSizeTableState createState() => _ColorSizeTableState();
}

class _ColorSizeTableState extends State<ColorSizeTable> {
  List<ColorModel> colors = [];
  List<SizeModel> sizes = [];
  List<_ColorSizeEntry> colorSizeEntries = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    // List<Tab> tabs = [];

    // List<List<OrderNoteEntryModel>> tabEntries = [];
    // //初始化按颜色分组
    // Map<String, List<OrderNoteEntryModel>> dataMap = {};
    // noteEntries.forEach((entry) {
    //   if (dataMap[entry.color] == null) {
    //     dataMap[entry.color] = [];
    //   }
    //   dataMap[entry.color].add(entry);
    // });

    // dataMap.forEach((key, list) {
    //   tabs.add(Tab(
    //     text: '$key',
    //   ));
    //   tabEntries.add(list);
    // });

    return Container(
        height: _getContainerHeight(sizes.length),
        child: DefaultTabController(
          length: colors.length,
          child: Scaffold(
              appBar: TabBar(
                  tabs: colors
                      .map((color) => Tab(text: '${color.name}'))
                      .toList()),
              body: TabBarView(
                children: colors
                    .map((color) => Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white,
                          child: Column(
                              children: sizes
                                  .map((size) => _buildEntryRow(color, size))
                                  .toList()),
                        ))
                    .toList(),
              )),
        ));
  }

  double _getContainerHeight(int length) {
    return (widget.rowHeith * length).toDouble() + 50;
  }

  ///数据初始化
  void init() {
    LinkedHashSet<ColorModel> colorsSet = LinkedHashSet<ColorModel>(
        equals: (o1, o2) => o1.code == o2.code, hashCode: (o) => o.id);

    LinkedHashSet<SizeModel> sizesSet = LinkedHashSet<SizeModel>(
        equals: (o1, o2) => o1.code == o2.code, hashCode: (o) => o.id);

    //采集颜色尺码数据
    widget.orderEntries.forEach((entry) {
      colorsSet.add(entry.product.color);
      sizesSet.add(entry.product.size);
    });

    //排序赋值
    colors = colorsSet.toList();
    colors.sort((o1, o2) => (o1.sequence - o2.sequence));
    sizes = sizesSet.toList();
    sizes.sort((o1, o2) => (o1.sequence - o2.sequence));

    colors.forEach((color) {
      sizes.forEach((size) {
        colorSizeEntries.add(
            _ColorSizeEntry(size.name, color.name, TextEditingController()));
      });
    });
  }

  Widget _buildEntryRow(ColorModel color, SizeModel size) {
    _ColorSizeEntry entry = getEntry(color.name, size.name);

    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '${size.name}',
            style: TextStyle(fontSize: 14),
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.remove_rect,
                  color: Colors.grey[300],
                ),
                onPressed: () {
                  if (int.parse(entry.controller.text) > 0) {
                    setState(() {
                      if (entry.controller.text == '1') {
                        entry.controller.text = '';
                      } else {
                        int i = int.parse(entry.controller.text);
                        i--;
                        entry.controller.text = '$i';
                      }
                    });
                  }
                },
              ),
              Container(
                width: 40,
                child: TextField(
                  controller: entry.controller,
                  decoration:
                      InputDecoration(border: InputBorder.none, hintText: '0'),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  //只能输入数字
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (val) {
                    if (val == '0') {
                      setState(() {
                        entry.controller.text = '';
                      });
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  B2BIcons.add_rect,
                  color: Colors.grey[300],
                ),
                onPressed: () {
                  setState(() {
                    if (entry.controller.text == '') {
                      entry.controller.text = '1';
                    } else {
                      int i = int.parse(entry.controller.text);
                      i++;
                      entry.controller.text = '$i';
                    }
                  });
                },
              )
            ],
          )
        ],
      ),
    );
  }

  _ColorSizeEntry getEntry(String color, String size) {
    return colorSizeEntries
        .firstWhere((entry) => entry.size == size && entry.color == color);
  }
}

class _ColorSizeEntry {
  final String size;

  final String color;

  final TextEditingController controller;

  _ColorSizeEntry(this.size, this.color, this.controller);
}
