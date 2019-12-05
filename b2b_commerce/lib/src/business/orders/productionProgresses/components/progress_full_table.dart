import 'dart:collection';

import 'package:b2b_commerce/src/business/orders/productionProgresses/components/color_size_report_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:orientation/orientation.dart';
import 'package:widgets/widgets.dart';

class ProgressFullTable extends StatefulWidget {
  final List<PurchaseOrderEntryModel> entries;

  final List<ProductionProgressOrderModel> productionProgressOrders;

  const ProgressFullTable(
      {Key key, this.entries, this.productionProgressOrders})
      : super(key: key);

  @override
  _ProgressFullTableState createState() => _ProgressFullTableState();
}

class _ProgressFullTableState extends State<ProgressFullTable> {
  @override
  void initState() {
    OrientationPlugin.forceOrientation(DeviceOrientation.landscapeLeft);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<ColorModel> colors = [];
    List<SizeModel> sizes = [];

    LinkedHashSet<ColorModel> colorsSet = LinkedHashSet<ColorModel>(
        equals: (o1, o2) => o1.code == o2.code, hashCode: (o) => o.id);

    LinkedHashSet<SizeModel> sizesSet = LinkedHashSet<SizeModel>(
        equals: (o1, o2) => o1.code == o2.code, hashCode: (o) => o.id);

    //采集颜色尺码数据
    widget.entries.forEach((entry) {
      colorsSet.add(entry.product.color);
      sizesSet.add(entry.product.size);
    });

    //排序赋值
    colors = colorsSet.toList();
    sizes = sizesSet.toList();

    //尺码排序
    sizes.sort((o1, o2) => (o1.sequence - o2.sequence));

    return Material(
      child: Container(
          padding: EdgeInsets.only(top: 10),
          constraints: BoxConstraints.expand(),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: Icon(Icons.arrow_back),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ColorSizeReportDataTable(
                        '属性',
                        colors: colors,
                        sizes: sizes,
                      )))
            ],
          )),
    );
  }

  List<Map<dynamic, dynamic>> generateTableData() {}

  @override
  void dispose() {
    OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    super.dispose();
  }
}
