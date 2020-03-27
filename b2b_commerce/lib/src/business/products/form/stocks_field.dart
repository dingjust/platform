import 'dart:async';

import 'package:b2b_commerce/src/common/order_payment.dart';
import 'package:b2b_commerce/src/home/product/order_confirm_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:toast/toast.dart';
import 'package:widgets/widgets.dart';

class StocksField extends StatefulWidget {
  StocksField(this.product, {this.enabled = false});

  final ApparelProductModel product;
  final bool enabled;

  @override
  _StocksFieldState createState() => _StocksFieldState();
}

class _StocksFieldState extends State<StocksField>
    with SingleTickerProviderStateMixin {
  List<Widget> tabs = [];

  TabController _tabController;

  //储存颜色尺码行的输入框
  Map<String, TextEditingController> _colorSizeTextControllerMap = {};

  //储存颜色的批量输入框
  Map<String, TextEditingController> _colorTextControllerMap = {};

  List<ColorSizeModel> _colorSizes;

  @override
  void initState() {
    _colorSizes = widget.product.colorSizes
        .map((colorSize) =>
            ColorSizeModel.fromJson(ColorSizeModel.toJson(colorSize)))
        .toList();

    _colorSizes.forEach((colorSize) {
      _colorTextControllerMap[colorSize.colorName] = TextEditingController();
      colorSize.sizes.forEach((size) {
        _colorSizeTextControllerMap['${colorSize.colorName}${size.name}'] =
            TextEditingController(text: size.quality?.toString() ?? '');
      });
    });
    //初始化tabController
    _tabController = TabController(length: _colorSizes.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.enabled ? '库存设置' : '库存明细'),
        elevation: 0.5,
        centerTitle: true,
        actions: <Widget>[
          widget.enabled
              ? IconButton(
                  icon: Text('确定'),
                  onPressed: () {
                    widget.product.colorSizes = _colorSizes;
                    Navigator.pop(context);
                  })
              : Container()
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: TabBar(
        unselectedLabelColor: Colors.black26,
        labelColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: _buildTabs(),
        controller: _tabController,
        labelStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
        isScrollable: true,
        indicatorColor: Color.fromRGBO(255, 214, 12, 1),
      ),
      body: TabBarView(
        children:
            _colorSizes.map((colorSize) => _buildViewBody(colorSize)).toList(),
        controller: _tabController,
      ),
    );
  }

  Widget _buildViewBody(ColorSizeModel colorSize) {
    List<Widget> widgets = [
      Container(
        padding: EdgeInsets.only(
          left: 15,
          right: 60,
          top: 15,
          bottom: 15,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('规格'),
            Text('可售数量'),
          ],
        ),
      ),
    ];
    colorSize.sizes.forEach((entry) {
      widgets.add(_buildSizeEntryRow(entry, colorSize.colorName));
    });

    if(widget.enabled){
      widgets.add(_buildTotal(colorSize.sizes, colorSize.colorName));
    }


    return ListView(
      children: widgets,
    );
  }

  Widget _buildSizeEntryRow(ColorSizeEntryModel entry, String colorName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 0.5, color: Colors.grey[300]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('${entry.name}',
              style: TextStyle(color: Colors.black87, fontSize: 14)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Opacity(
                opacity: widget.enabled ? 1 : 0,
                child: IconButton(
                  icon: Icon(
                    B2BIcons.remove_rect,
                    color: Colors.grey[300],
                  ),
                  onPressed: () {
                    if(!widget.enabled){
                      return;
                    }
                    if (_colorSizeTextControllerMap['${colorName}${entry.name}']
                            .text !=
                        '') {
                      int quality = int.parse(
                          _colorSizeTextControllerMap['${colorName}${entry.name}']
                              .text);
                      if (quality > 0) {
                        quality--;
                        _colorSizeTextControllerMap['${colorName}${entry.name}']
                            .text = quality.toString();
                        entry.quality = quality;
                      }
                    }
                  },
                ),
              ),
              Container(
                width: 40,
                child: TextField(
                  controller:
                      _colorSizeTextControllerMap['${colorName}${entry.name}'],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(fontSize: 15),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                  //只能输入数字
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  enabled: widget.enabled,
                  onChanged: (val) {
                    print(val);
                    if (val != '') {
                      entry.quality = int.parse(val);
                    } else {
                      entry.quality = 0;
                    }
                  },
                ),
              ),
              Opacity(
                opacity: widget.enabled ? 1 : 0,
                child: IconButton(
                  icon: Icon(
                    B2BIcons.add_rect,
                    color: Colors.grey[300],
                  ),
                  onPressed: () {
                    if(!widget.enabled){
                      return;
                    }
                    if (_colorSizeTextControllerMap['${colorName}${entry.name}']
                            .text !=
                        '') {
                      int quality = int.parse(
                          _colorSizeTextControllerMap['${colorName}${entry.name}']
                              .text);
                      if (quality >= 0) {
                        quality++;
                        _colorSizeTextControllerMap['${colorName}${entry.name}']
                            .text = quality.toString();
                        entry.quality = quality;
                      }
                    } else {
                      _colorSizeTextControllerMap['${colorName}${entry.name}']
                          .text = '1';
                      entry.quality = 1;
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotal(List<ColorSizeEntryModel> entries, String colorName) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '批量修改数量',
                style: TextStyle(fontSize: 14),
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      B2BIcons.remove_rect,
                      color: Color.fromRGBO(255, 214, 12, 1),
                    ),
                    onPressed: () {
                      int quality = 0;
                      if (_colorTextControllerMap[colorName].text != '') {
                        quality =
                            int.parse(_colorTextControllerMap[colorName].text);
                      }
                      if (quality > 0) {
                        quality--;
                      }
                      _colorTextControllerMap[colorName].text =
                          quality.toString();
                      entries.forEach((entry) {
                        _colorSizeTextControllerMap['${colorName}${entry.name}']
                            .text = quality.toString();
                        entry.quality = quality;
                      });
                    },
                  ),
                  Container(
                    width: 40,
                    child: TextField(
                      controller: _colorTextControllerMap[colorName],
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '0',
                          hintStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                      //只能输入数字
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (val) {
                        int quality = 0;
                        if (val != '') {
                          quality = int.parse(val);
                        }
                        entries.forEach((entry) {
                          _colorSizeTextControllerMap[
                                  '${colorName}${entry.name}']
                              .text = quality.toString();
                          entry.quality = quality;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      B2BIcons.add_rect,
                      color: Color.fromRGBO(255, 214, 12, 1),
                    ),
                    onPressed: () {
                      setState(() {
                        int quality = 0;
                        if (_colorTextControllerMap[colorName].text != '') {
                          quality = int.parse(
                              _colorTextControllerMap[colorName].text);
                        }
                        quality++;
                        _colorTextControllerMap[colorName].text =
                            quality.toString();
                        entries.forEach((entry) {
                          _colorSizeTextControllerMap[
                                  '${colorName}${entry.name}']
                              .text = quality.toString();
                          entry.quality = quality;
                        });
                      });
                    },
                  )
                ],
              )
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(width: 0.5, color: Colors.grey[300]))),
    );
  }

  List<Widget> _buildTabs() {
    List<Widget> result = [];
    _colorSizes.forEach((colorSize) {
      result.add(_buildTab(colorSize));
    });
    return result;
  }

  Widget _buildTab(ColorSizeModel colorSize) {
    return Tab(
      child: Container(
        width: 60,
        height: 30,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Text(
                '${colorSize.colorName}',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
