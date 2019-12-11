import 'dart:collection';

import 'package:b2b_commerce/src/business/orders/form/purchase/ColorSizeEntry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

class ProgressColorSizeTabTable extends StatefulWidget {
  final List<OrderNoteEntryModel> noteEntries;

  final List<PurchaseOrderEntryModel> orderEntries;

  final List<ColorSizeEntry> colorSizeEntries;

  final List<ProductionProgressOrderModel> productionProgressOrders;

  final int rowHeith;

  ProgressColorSizeTabTable(
      {Key key,
      this.noteEntries,
      this.rowHeith = 60,
      @required this.orderEntries,
      @required this.colorSizeEntries,
      this.productionProgressOrders})
      : super(key: key);

  @override
  _ProgressColorSizeTabTableState createState() =>
      _ProgressColorSizeTabTableState();
}

class _ProgressColorSizeTabTableState extends State<ProgressColorSizeTabTable> {
  List<ColorModel> colors = [];
  List<SizeModel> sizes = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: _getContainerHeight(sizes.length),
        child: DefaultTabController(
          length: colors.length,
          child: Scaffold(
              appBar: TabBar(
                  isScrollable: true,
                  tabs: colors.map((color) => _buildTab(color)).toList()),
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

  Widget _buildTab(ColorModel color) {
    String colorCode = color.colorCode?.replaceAll(RegExp('#'), '');
    int sum = getColorTotalNum(color);
    return Tab(
      child: Container(
        width: 60,
        height: 30,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            color.colorCode != null
                ? Positioned(
                    left: 0,
                    top: 12,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: Color(int.parse('0xFF${colorCode}')),
                          border:
                              Border.all(width: 0.5, color: Colors.grey[300])),
                      child: Text(''),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Text(
                '${color.name}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            sum > 0
                ? Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Center(
                          child: Text(
                            getColorTotalNum(color) > 99 ? '···' : '$sum',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )))
                : Container()
          ],
        ),
      ),
    );
  }

  int getColorTotalNum(ColorModel color) {
    int sum = 0;
    widget.colorSizeEntries
        .where((entry) => entry.color == color.name)
        .forEach((colorEntry) {
      if (colorEntry.controller.text != '') {
        sum += int.parse(colorEntry.controller.text);
      }
    });
    return sum;
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
    sizes = sizesSet.toList();
    sizes.sort((o1, o2) => (o1.sequence - o2.sequence));

    colors.forEach((color) {
      sizes.forEach((size) {
        widget.colorSizeEntries.add(
            ColorSizeEntry(size.name, color.name, TextEditingController()));
      });
    });

    //更新
    if (widget.noteEntries != null && widget.noteEntries.isNotEmpty) {
      widget.noteEntries.forEach((entry) {
        getEntry(entry.color, entry.size)
          ..controller.text = entry.quantity.toString()
          ..id = entry.id;
      });
    }
  }

  Widget _buildEntryRow(ColorModel color, SizeModel size) {
    ColorSizeEntry entry = getEntry(color.name, size.name);

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
              Container(
                width: 150,
                margin: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300], width: 0.5)),
                child: TextField(
                  controller: entry.controller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '${getRemindStr(color.name, size.name)}'),
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
            ],
          )
        ],
      ),
    );
  }

  ColorSizeEntry getEntry(String color, String size) {
    return widget.colorSizeEntries
        .firstWhere((entry) => entry.size == size && entry.color == color);
  }

  int getNeed(String color, String size) {
    //空处理替代对象
    PurchaseOrderEntryModel emptyObj = PurchaseOrderEntryModel(quantity: 0);
    return widget.orderEntries
        .firstWhere(
            (entry) =>
                entry.product.color.name == color &&
                entry.product.size.name == size,
            orElse: () => emptyObj)
        .quantity;
  }

  int getActualSum(String color, String size) {
    //空处理替代对象
    OrderNoteEntryModel emptyObj = OrderNoteEntryModel(quantity: 0);

    int result = 0;
    widget.productionProgressOrders
        .where((order) => order.status != ProductionProgressOrderStatus.CANCEL)
        .forEach((order) {
      result += order.entries
          .firstWhere((entry) => entry.color == color && entry.size == size,
              orElse: () => emptyObj)
          .quantity;
    });
    return result;
  }

  String getRemindStr(String color, String size) {
    int result = getNeed(color, size) - getActualSum(color, size);
    if (result > 0) {
      return '剩余未报$result';
    } else {
      return '0';
    }
  }
}
