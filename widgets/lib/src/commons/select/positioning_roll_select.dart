import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'dart:ui';

class PositioningRollPage extends StatefulWidget {
  List<Attribute> attributes;
  String title;
  double childAspectRatio;
  double mainAxisSpacing;
  double crossAxisSpacing;
  int crossAxisCount;
  bool enabled;

  PositioningRollPage({
    this.attributes,
    this.title,
    this.childAspectRatio = 1.8,
    this.mainAxisSpacing = 5.0,
    this.crossAxisSpacing = 5.0,
    this.crossAxisCount = 3,
    this.enabled = true,
  });

  _PositioningRollPageState createState() => _PositioningRollPageState();
}

class _PositioningRollPageState extends State<PositioningRollPage> {
  ScrollController _valueController = ScrollController();
  Map<String, dynamic> map = {};
  String _keySelect;
  List<Attribute> _attributes;

  @override
  void initState() {
    _attributes = widget.attributes.map((attr) => Attribute(
      attr.code,attr.name,attr.values,valueSelects: attr.valueSelects?.map((val) => val)?.toList(),multiple: attr.multiple,offset: attr.offset
    )).toList();
    widget.attributes.forEach((attr) => print(attr.valueSelects));
    if (_attributes != null && _attributes.length > 0)
      _keySelect = _attributes[0].code;
    double offset = 0.0;
    _attributes.forEach((attr) {
      int colCount = attr.values.length % widget.crossAxisCount == 0
          ? (attr.values.length / widget.crossAxisCount).toInt()
          : (attr.values.length / widget.crossAxisCount + 1).toInt();
      attr.offset = offset;
      offset += getItemHeight(colCount);
    });

    // TODO: implement initState
    super.initState();
  }

  double getItemHeight(int colCount) {
    return ((
        MediaQueryData.fromWindow(window).size.width * 0.8 - 20 -
            (widget.crossAxisCount - 1) * widget.mainAxisSpacing) /
        widget.crossAxisCount / widget.childAspectRatio + widget.crossAxisSpacing)*colCount + 32.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '定位滚动选择组件'),
        centerTitle: true,
        elevation: 0.5,
        actions: <Widget>[
          Offstage(
            offstage: !widget.enabled,
            child: IconButton(
                icon: Text('确定'),
                onPressed: () {
                  _attributes.forEach((attribute) {
                    map[attribute.code] = attribute.valueSelects;
                  });
                  Navigator.pop(context, map);
                }),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              color: Colors.grey[200],
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 5,
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 75,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (BuildContext context,
                          int index,) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _keySelect = _attributes[index].code;
                              _valueController.animateTo(
                                  _attributes[index].offset,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            });
                          },
                          child: Container(
                            height: 40,
                            color: _keySelect == _attributes[index].code
                                ? Colors.white
                                : Colors.grey[200],
                            child: Center(
                                child: Text(_attributes[index].name)),
                          ),
                        );
                      },
                      childCount: _attributes.length,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: CustomScrollView(
                  controller: _valueController,
                  slivers: buildSlivers(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildSlivers() {
    List<Widget> _slivers = [];

    _attributes.forEach((item) {
      Widget sliverTitle = SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 10),
        sliver: SliverToBoxAdapter(
          child: Center(
            child: Text(item.name, style: TextStyle(color: Colors.grey),),
          ),
        ),
      );
      Widget sliverItem = SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        sliver: SliverGrid.count(
          mainAxisSpacing: widget.mainAxisSpacing,
          crossAxisSpacing: widget.crossAxisSpacing,
          childAspectRatio: widget.childAspectRatio,
          crossAxisCount: widget.crossAxisCount,
          children: item.values.map((valueItem) {
            return GestureDetector(
              onTap: !widget.enabled ? null : () {
                setState(() {
                  if (item.valueSelects.contains(valueItem.code)) {
                    item.valueSelects.remove(valueItem.code);
                  } else {
                    if (!item.multiple) {
                      item.valueSelects.clear();
                    }
                    item.valueSelects.add(valueItem.code);
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: item.valueSelects.contains(valueItem.code)
                        ? Color.fromRGBO(255, 214, 12, 1)
                        : Colors.grey[250]),
                child: Center(
                  child: Text(valueItem.name),
                ),
              ),
            );
          }).toList(),
        ),
      );
      _slivers.add(sliverTitle);
      _slivers.add(sliverItem);
    });

    return _slivers;
  }
}

class Attribute {
  String code;
  String name;
  List<EnumModel> values;
  List<String> valueSelects;
  double offset;
  bool multiple;

  Attribute(this.code,
      this.name,
      this.values, {
        this.valueSelects,
        this.offset = 0.0,
        this.multiple = false,
      }) {
    if(this.valueSelects == null){
      this.valueSelects = [];
    }
  }
}
