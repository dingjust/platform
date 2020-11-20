import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'color_size_entry_table.dart';

///颜色尺码表(AbstractOrderNoteEntryModel值版本)
class ColorSizeNoteEntryTable extends StatelessWidget {
  final List<AbstractOrderNoteEntryModel> data;

  //过滤后数据
  List<AbstractOrderNoteEntryModel> filterData;

  ///排序函数
  final CompareFunction compareFunction;

  ColorSizeNoteEntryTable({Key key, this.data, this.compareFunction}) {
    //过滤数量为0
    filterData = data.where((element) => element.needQuantity > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    ///按颜色分组
    Map<String, List<AbstractOrderNoteEntryModel>> colorRowList =
        Map<String, List<AbstractOrderNoteEntryModel>>();

    List<TableRow> dataRowList = [];
    List<TableRow> tableRowList = [
      //表头
      TableRow(children: <Widget>[
        TableCell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            color: Color.fromRGBO(238, 238, 238, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('颜色'),
              ],
            ),
          ),
        ),
        TableCell(
          child: Table(
            border: TableBorder.all(
                color: Colors.grey, width: 0.5, style: BorderStyle.solid),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(children: [
                TableCell(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Color.fromRGBO(238, 238, 238, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('尺码'),
                      ],
                    ),
                  ),
                ),
                TableCell(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    color: Color.fromRGBO(238, 238, 238, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('数量'),
                      ],
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ])
    ];

    filterData.forEach((entry) {
      if (colorRowList[entry.color] == null) {
        colorRowList[entry.color] = [];
      }
      colorRowList[entry.color].add(entry);
    });

    colorRowList.forEach((color, entries) {
      //排序
      if (compareFunction != null) {
        entries.sort((o1, o2) => compareFunction(o1.size, o2.size));
      }

      //构建尺码数量列
      List<TableRow> _sizeRowList = entries
          .map((entry) => TableRow(
                children: <Widget>[
                  TableCell(
                      child: Container(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    alignment: Alignment.center,
                    child: Text(
                      '${entry.size}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                    ),
                    height: 40.0,
                  )),
                  TableCell(
                      child: Container(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    alignment: Alignment.center,
                    child: Text(
                      '${entry.quantity}/${entry.needQuantity}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                    ),
                    height: 40.0,
                  )),
                ],
              ))
          .toList();

      dataRowList.add(TableRow(children: <Widget>[
        TableCell(
          child: Container(
            color: Color.fromRGBO(250, 250, 250, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(entries[0].color),
              ],
            ),
          ),
        ),
        TableCell(
          child: Table(
            border: TableBorder.all(
                color: Colors.grey, width: 0.5, style: BorderStyle.solid),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: _sizeRowList,
          ),
        ),
      ]));
    });

    tableRowList.addAll(dataRowList);

    return Container(
      color: Color.fromRGBO(250, 250, 250, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Table(
            // columnWidths: <int, TableColumnWidth>{
            //   0: FixedColumnWidth(85),
            //   1: FixedColumnWidth(255),
            // },
            columnWidths: <int, TableColumnWidth>{
              0: FlexColumnWidth(0.3),
              1: FlexColumnWidth(0.7),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(
                color: Colors.grey, width: 0.5, style: BorderStyle.solid),
            children: tableRowList,
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        IterableProperty<AbstractOrderNoteEntryModel>('entries', filterData));
  }
}
