import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

class ColorSizeNumTable extends StatelessWidget {
  const ColorSizeNumTable({Key key, @required this.data}) : super(key: key);

  final List<ApparelSizeVariantProductEntry> data;

  @override
  Widget build(BuildContext context) {
    ///按颜色分组
    Map<String, List<ApparelSizeVariantProductEntry>> colorRowList =
        Map<String, List<ApparelSizeVariantProductEntry>>();

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

    data.forEach((entry) {
      if (colorRowList[entry.model.color.code] == null) {
        colorRowList[entry.model.color.code] = [];
      }
      colorRowList[entry.model.color.code].add(entry);
    });

    colorRowList.forEach((color, entries) {
      //构建尺码数量列
      List<TableRow> _sizeRowList = entries
          .map((entry) => TableRow(
                children: <Widget>[
                  TableCell(
                      child: Container(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    alignment: Alignment.center,
                    child: Text(
                      '${entry.model.size.name}',
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
                      '${entry.quantity}',
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
                Container(
                  width: 20,
                  decoration: BoxDecoration(
                    color: Color(int.parse(
                        '${entries[0].model.color.colorCode.replaceAll}')),
                    shape: BoxShape.circle,
                  ),
                  child: Text(''),
                ),
                Text(entries[0].model.color.name),
              ],
            ),
          ),
        ),
        TableCell(
          child: Table(
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
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(width: 1.0, color: Colors.transparent),
            children: tableRowList,
          ),
        ],
      ),
    );
  }
}

///颜色尺码产品
class ApparelSizeVariantProductEntry {
  ApparelSizeVariantProductModel model;

  ///数量
  int quantity;

  ApparelSizeVariantProductEntry({this.model, this.quantity});
}

class EditApparelSizeVariantProductEntry {
  final ApparelSizeVariantProductModel model;

  final TextEditingController controller;

  EditApparelSizeVariantProductEntry({this.model, this.controller});
}

class EditColorSizeNumTable extends StatelessWidget {
  const EditColorSizeNumTable({Key key, @required this.data}) : super(key: key);

  final List<EditApparelSizeVariantProductEntry> data;

  @override
  Widget build(BuildContext context) {
    ///按颜色分组
    Map<String, List<EditApparelSizeVariantProductEntry>> colorRowList =
        Map<String, List<EditApparelSizeVariantProductEntry>>();

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

    data.forEach((entry) {
      if (colorRowList[entry.model.color.code] == null) {
        colorRowList[entry.model.color.code] = [];
      }
      colorRowList[entry.model.color.code].add(entry);
    });

    colorRowList.forEach((color, entries) {
      //构建尺码数量列
      List<TableRow> _sizeRowList = entries
          .map((entry) => TableRow(
                children: <Widget>[
                  TableCell(
                      child: Container(
                    color: Color.fromRGBO(250, 250, 250, 1),
                    alignment: Alignment.center,
                    child: Text(
                      '${entry.model.size.name}',
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
                    child: TextField(
                      controller: entry.controller,
                      decoration: InputDecoration(border: InputBorder.none),
                      keyboardType: TextInputType.number,
                      //只能输入数字
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                      ],
                    ),
                    height: 40.0,
                  )),
                ],
              ))
          .toList();

      String colorCode =
          entries[0].model.color.colorCode.replaceAll(RegExp('#'), '');

      dataRowList.add(TableRow(children: <Widget>[
        TableCell(
          child: Container(
            color: Color.fromRGBO(250, 250, 250, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 20,
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xFF${colorCode}')),
                    shape: BoxShape.circle,
                  ),
                  child: Text(''),
                ),
                Text(entries[0].model.color.name),
              ],
            ),
          ),
        ),
        TableCell(
          child: Table(
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
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(width: 1.0, color: Colors.transparent),
            children: tableRowList,
          ),
        ],
      ),
    );
  }
}
