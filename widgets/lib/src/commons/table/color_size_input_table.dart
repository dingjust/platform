import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_size_entry_table.dart';

///颜色尺码输入表（文本类型）
class ColorSizeInputTable extends StatefulWidget {
  final List<String> colors;

  final List<String> sizes;

  final List<ColorSizeInputEntry>? entries;

  final ValueChanged<List<ColorSizeInputEntry>?>? onChanged;

  ///排序函数
  final CompareFunction? compareFunction;

  ///
  /// 示例：
  ///
  /// ```dart preamble
  /// ColorSizeInputTable(
  ///   ['蓝色', '绿色', '红色'],
  ///   ['S', 'M', 'L', 'XL', 'XXL'],
  ///   compareFunction: Provider.of<SizeState>(context, listen: false).compareByName,
  ///   entries: [
  ///     ColorSizeInputEntry(color: '红色', size: 'L', quantity: 12)
  ///   ],
  ///   onChanged: (data) {
  ///     print('sadasd');
  ///     data.forEach((entry) {
  ///       print('${entry.color}-${entry.size}:${entry.quantity}');
  ///     });
  ///   },
  /// ),
  /// ```
  const ColorSizeInputTable(this.colors, this.sizes,
      {Key? key, this.compareFunction, this.entries, this.onChanged})
      : super(key: key);

  @override
  _ColorSizeInputTableState createState() => _ColorSizeInputTableState();
}

class _ColorSizeInputTableState extends State<ColorSizeInputTable> {
  late List<String> colors;
  late List<String> sizes;

  ///颜色分组数据维护
  late Map<String, List<ColorSizeInputEntry>> colorSizeEntriesMap;

  ///数据维护
  List<ColorSizeInputEntry>? data;

  @override
  void initState() {
    sizes = widget.sizes;
    colors = widget.colors;
    data = [];
    //尺码排序
    if (widget.compareFunction != null) {
      sizes.sort((o1, o2) => widget.compareFunction!(o1, o2));
    }

    //颜色分组
    colorSizeEntriesMap = Map<String, List<ColorSizeInputEntry>>();
    colors.forEach((color) {
      colorSizeEntriesMap[color] = [];
      sizes.forEach((size) {
        ColorSizeInputEntry? entry =
            _getEntry(widget.entries ?? [], color, size);
        if (entry == null) {
          entry = ColorSizeInputEntry(color: color, size: size);
        }
        colorSizeEntriesMap[color]!.add(entry);
        data!.add(entry);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            children: _tableRows,
          ),
        ],
      ),
    );
  }

  /////构建尺码数量列
  List<TableRow> _getSizeTableRows(List<ColorSizeInputEntry> entries) {
    return entries
        .map((entry) => TableRow(
              children: <Widget>[
                TableCell(
                    child: Container(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  alignment: Alignment.center,
                  child: Text(
                    '${entry.size}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF30424D)),
                  ),
                  height: 40.0,
                )),
                TableCell(
                    child: Container(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: entry.controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration.collapsed(hintText: ''),
                    textAlign: TextAlign.center,
                    onChanged: (val) => _onNumChange(val, entry),
                  ),
                  height: 40.0,
                )),
              ],
            ))
        .toList();
  }

  void _onNumChange(String val, ColorSizeInputEntry entry) {
    var number;

    if (val == '') {
      number=0;
    } else{
      number = int.tryParse(val);
    }

    if (number != null) {
      entry.quantity = number;
      if (widget.onChanged != null) {
        widget.onChanged!.call(data);
      }
    }
  }

  List<TableRow> get _tableRows {
    List<TableRow> dataRowList = [];
    colorSizeEntriesMap.forEach((color, entries) {
      dataRowList.add(TableRow(children: <Widget>[
        TableCell(
          child: Text(
            color,
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: Table(
            border: TableBorder.all(
                color: Colors.grey, width: 0.5, style: BorderStyle.solid),
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: _getSizeTableRows(entries),
          ),
        ),
      ]));
    });
    return [colorSizeInputTableHeadRow$, ...dataRowList];
  }

  ColorSizeInputEntry? _getEntry(
      List<ColorSizeInputEntry> entries, String color, String size) {
    ColorSizeInputEntry? entry = entries.firstWhereOrNull(
        (element) => element.color == color && element.size == size);
    if (entry != null) {
      entry.controller!.text = entry.quantity?.toString() ?? '';
    }
    return entry;
  }
}

///实体
class ColorSizeInputEntry {
  final String? color;

  final String? size;

  int? quantity;

  TextEditingController? controller;

  ColorSizeInputEntry({this.color, this.size, this.quantity}) {
    controller = TextEditingController(
        text: this.quantity != null ? this.quantity.toString() : '');
  }
}

///表头
var colorSizeInputTableHeadRow$ = TableRow(children: <Widget>[
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
]);
