import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';

typedef CompareFunction = int Function(String code1, String code2);

///颜色尺码表(v2版本)
///
/// 示例：
///
/// ```dart preamble
/// ColorSizeEntryTable(
/// data: order.colorSizeEntries,
/// compareFunction: Provider.of<SizeState>(context).compare,
/// ),
/// ```
class ColorSizeEntryTable extends StatelessWidget {
  final List<ColorSizeEntryV2Model> data;

  //过滤后数据
  List<ColorSizeEntryV2Model> filterData;

  ///排序函数
  final CompareFunction compareFunction;

  ColorSizeEntryTable({Key key, this.data, this.compareFunction}) {
    //过滤数量为0
    filterData = data.where((element) => element.quantity > 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    ///按颜色分组
    Map<String, List<ColorSizeEntryV2Model>> colorRowList =
        Map<String, List<ColorSizeEntryV2Model>>();

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
      if (colorRowList[entry.color.code] == null) {
        colorRowList[entry.color.code] = [];
      }
      colorRowList[entry.color.code].add(entry);
    });

    colorRowList.forEach((color, entries) {
      //排序
      if (compareFunction != null) {
        entries.sort((o1, o2) => compareFunction(o1.size.code, o2.size.code));
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
                      '${entry.size.name}',
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
                    color: Color(int.parse('0xff' +
                        '${entries[0].color.colorCode == null || entries[0].color.colorCode == '' ? 'fffff' : entries[0].color.colorCode.substring(1)}')),
                    shape: BoxShape.circle,
                  ),
                  child: Text(''),
                ),
                Text(entries[0].color.name),
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
    properties
        .add(IterableProperty<ColorSizeEntryV2Model>('entries', filterData));
  }
}

///颜色尺码輸入表(v2版本)
///
/// 示例：
///
/// ```dart preamble
/// ColorSizeEntryInputTable(
/// data: order.colorSizeEntries,
/// compareFunction: Provider.of<SizeState>(context).compare,
/// ),
/// ```
class ColorSizeEntryInputTable extends StatelessWidget {
  final List<ColorSizeEntryV2Model> data;

  ///排序函数
  final CompareFunction compareFunction;

  final ValueChanged<List<ColorSizeEntryV2Model>> onChanged;

  final Map controllerMap;
  final Map nodeMap;

  const ColorSizeEntryInputTable(
      {Key key,
      this.data,
      this.compareFunction,
      this.onChanged,
      this.controllerMap,
      this.nodeMap})
      : super(key: key);

  // ColorSizeEntryInputTable(
  //     {Key key, this.data, this.compareFunction, this.onChanged}) {

  // }

  @override
  Widget build(BuildContext context) {
    ///按颜色分组
    Map<String, List<ColorSizeEntryV2Model>> colorRowList =
        Map<String, List<ColorSizeEntryV2Model>>();

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

    data.forEach((entry) {
      if (colorRowList[entry.color.code] == null) {
        colorRowList[entry.color.code] = [];
      }
      colorRowList[entry.color.code].add(entry);
    });

    colorRowList.forEach((color, entries) {
      //排序
      if (compareFunction != null) {
        entries.sort((o1, o2) => compareFunction(o1.size.code, o2.size.code));
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
                      '${entry.size.name}',
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
                      controller: controllerMap[entry.color.code]
                          [entry.size.code],
                      focusNode: nodeMap[entry.color.code][entry.size.code],
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration.collapsed(hintText: ''),
                      textAlign: TextAlign.center,
                      autofocus: false,
                      onChanged: (val) {
                        entry.quantity = int.tryParse(val) ?? 0;
                        onChanged?.call(data);
                      },
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
                    color: Color(int.parse('0xff' +
                        '${entries[0].color.colorCode == null || entries[0].color.colorCode == '' ? 'fffff' : entries[0].color.colorCode.substring(1)}')),
                    shape: BoxShape.circle,
                  ),
                  child: Text(''),
                ),
                Text(entries[0].color.name),
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
}
