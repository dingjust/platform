import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:models/models.dart';

///生产进度数量统计缩略表
class ProgressAbbreviationTable extends StatelessWidget {
  final List<PurchaseOrderEntryModel> entries;

  final List<ProductionProgressOrderModel> productionProgressOrders;

  const ProgressAbbreviationTable(
      {Key key,
      @required this.entries,
      @required this.productionProgressOrders})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ColorModel> colors = [];
    List<SizeModel> sizes = [];

    LinkedHashSet<ColorModel> colorsSet = LinkedHashSet<ColorModel>(
        equals: (o1, o2) => o1.code == o2.code, hashCode: (o) => o.id);

    LinkedHashSet<SizeModel> sizesSet = LinkedHashSet<SizeModel>(
        equals: (o1, o2) => o1.code == o2.code, hashCode: (o) => o.id);

    //采集颜色尺码数据
    entries.forEach((entry) {
      colorsSet.add(entry.product.color);
      sizesSet.add(entry.product.size);
    });

    //排序赋值
    colors = colorsSet.toList();
    sizes = sizesSet.toList();

    //缩略裁剪
    colors = colors.sublist(0, colors.length > 3 ? 4 : colors.length);
    sizes = sizes.sublist(0, sizes.length > 2 ? 3 : sizes.length);
    //尺码排序
    sizes.sort((o1, o2) => (o1.sequence - o2.sequence));

    //表行
    List<TableRow> tableRowList = [];

    //表头行
    List<TableCell> headRow = [
      TableCell(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text('属性'),
            )),
      ),
    ];
    headRow.addAll(sizes.map((size) => TableCell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('${size.name}'),
              )),
        )));
    tableRowList.add(TableRow(children: headRow));

    ///数据行
    tableRowList.addAll(colors.map((color) {
      List<TableCell> dataRow = [
        TableCell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('${color.name}'),
              )),
        ),
      ];
      dataRow.addAll(sizes.map((size) {
        //字符处理
        int actualSum = getActualSum(color.name, size.name);
        int need = getNeed(color.name, size.name);
        String value = '';
        if (need < 1) {
          if (actualSum > 0) {
            value = '+$actualSum';
          }
        } else {
          value = '$actualSum/$need';
        }

        return TableCell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('$value'),
              )),
        );
      }));
      return TableRow(children: dataRow);
    }));

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
          color: Colors.grey, width: 0.5, style: BorderStyle.solid),
      children: tableRowList,
    );
  }

  int getNeed(String color, String size) {
    //空处理替代对象
    PurchaseOrderEntryModel emptyObj = PurchaseOrderEntryModel(quantity: 0);
    return entries
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
    productionProgressOrders
        .where((order) => order.status != ProductionProgressOrderStatus.CANCEL)
        .forEach((order) {
      result += order.entries
          .firstWhere((entry) => entry.color == color && entry.size == size,
              orElse: () => emptyObj)
          .quantity;
    });
    return result;
  }
}

///单个生产进度单据数量缩略表
class SingleProgressAbbreviationTable extends StatelessWidget {
  final List<PurchaseOrderEntryModel> entries;

  final ProductionProgressOrderModel order;

  const SingleProgressAbbreviationTable(
      {Key key, @required this.entries, @required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ColorModel> colors = [];
    List<SizeModel> sizes = [];

    LinkedHashSet<ColorModel> colorsSet = LinkedHashSet<ColorModel>(
        equals: (o1, o2) => o1.code == o2.code, hashCode: (o) => o.id);

    LinkedHashSet<SizeModel> sizesSet = LinkedHashSet<SizeModel>(
        equals: (o1, o2) => o1.code == o2.code, hashCode: (o) => o.id);

    //采集颜色尺码数据
    entries.forEach((entry) {
      colorsSet.add(entry.product.color);
      sizesSet.add(entry.product.size);
    });

    //排序赋值
    colors = colorsSet.toList();
    sizes = sizesSet.toList();

    //缩略裁剪
    colors = colors.sublist(0, colors.length > 3 ? 4 : colors.length);
    sizes = sizes.sublist(0, sizes.length > 2 ? 3 : sizes.length);
    //尺码排序
    sizes.sort((o1, o2) => (o1.sequence - o2.sequence));

    //表行
    List<TableRow> tableRowList = [];

    //表头行
    List<TableCell> headRow = [
      TableCell(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text('属性'),
            )),
      ),
    ];
    headRow.addAll(sizes.map((size) =>
        TableCell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('${size.name}'),
              )),
        )));
    tableRowList.add(TableRow(children: headRow));

    ///数据行
    tableRowList.addAll(colors.map((color) {
      List<TableCell> dataRow = [
        TableCell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('${color.name}'),
              )),
        ),
      ];
      dataRow.addAll(sizes.map((size) {
        return TableCell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text(
                    '${getActualNum(color.name, size.name) == 0
                        ? ''
                        : getActualNum(color.name, size.name)}'),
              )),
        );
      }));
      return TableRow(children: dataRow);
    }));

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
          color: Colors.grey, width: 0.5, style: BorderStyle.solid),
      children: tableRowList,
    );
  }

  int getActualNum(String color, String size) {
    //空处理替代对象
    OrderNoteEntryModel emptyObj = OrderNoteEntryModel(quantity: 0);

    return order.entries
        .firstWhere((entry) => entry.color == color && entry.size == size,
        orElse: () => emptyObj)
        .quantity;
  }
}
