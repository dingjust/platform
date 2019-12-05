import 'package:flutter/material.dart';

class ReportDataTable extends StatefulWidget {
  final List<Map> data;

  final String index;

  final double cellWidthScale;

  final TextStyle textStyle;

  ValueChanged<dynamic> onChanged;

  ReportDataTable(this.data, this.index,
      {Key key, this.cellWidthScale = 12, this.textStyle, this.onChanged})
      : super(key: key);

  @override
  _ReportDataTableState createState() => _ReportDataTableState();
}

class _ReportDataTableState extends State<ReportDataTable> {
  ScrollController headerScrollController;
  ScrollController bodyScrollController;

  List<String> columnsHeaderKeys;
  List<DataColumn> columnsHeaders = [];

  @override
  void initState() {
    headerScrollController = ScrollController();
    bodyScrollController = ScrollController();

    ////同步滑动
    bodyScrollController.addListener(() {
      headerScrollController.jumpTo(bodyScrollController.offset);
    });

    initColumnHeader();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Table(
          border: TableBorder.all(color: Colors.grey, width: 0.5),
          columnWidths: <int, TableColumnWidth>{
            0: FlexColumnWidth(0.1),
            1: FlexColumnWidth(0.9),
          },
          children: [
            TableRow(children: [
              DataTable(
                columns: [
                  DataColumn(
                      label: Center(
                        child: Text(
                          '${widget.index}',
                          style: widget.textStyle,
                        ),
                      ))
                ],
                rows: [],
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // dragStartBehavior: widget.dragStartBehavior,
                  controller: headerScrollController,
                  child: DataTable(
                    columns: columnsHeaders,
                    rows: [],
                  )),
            ])
          ],
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
              child: Table(
            border: TableBorder.all(color: Colors.grey, width: 0.5),
            columnWidths: <int, TableColumnWidth>{
              0: FlexColumnWidth(0.1),
              1: FlexColumnWidth(0.9),
            },
            children: [
              TableRow(children: [
                DataTable(
                  columns: [getR1C1()],
                  rows: getC1(),
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    // dragStartBehavior: widget.dragStartBehavior,
                    controller: bodyScrollController,
                    child: DataTable(
                      columns: generateDataColumn(),
                      rows: generateDataRow(),
                    )),
              ])
            ],
          )),
        )
      ],
    );
  }

  void _handleTap(dynamic value) {
    widget.onChanged(value);
  }

  void initColumnHeader() {
    columnsHeaderKeys = [];
    columnsHeaders = [];
    widget.data[0].forEach((key, val) {
      if (key != widget.index) {
        columnsHeaderKeys.add(key);
        columnsHeaders.add(DataColumn(
            label: Container(
                width: generateColumnWidth(key),
                child: Center(
                  child: Text(
                    '$key',
                    style: widget.textStyle,
                  ),
                ))));
      }
    });
  }

  List<DataColumn> generateDataColumn() {
    var firstItem = widget.data[0];
    return columnsHeaderKeys
        .map((key) => DataColumn(
                label: GestureDetector(
              onTap: () {
                _handleTap(firstItem[widget.index]);
              },
              child: Container(
                width: generateColumnWidth(key),
                child: Center(
                  child: Text(
                    '${firstItem[key]}',
                    style: widget.textStyle,
                  ),
                ),
              ),
            )))
        .toList();
  }

  List<DataRow> generateDataRow() {
    List<DataRow> result = [];
    for (int i = 1; i < widget.data.length; i++) {
      var item = widget.data[i];
      List<DataCell> cells = [];
      columnsHeaderKeys.forEach((key) {
        cells.add(DataCell(GestureDetector(
          onTap: () {
            _handleTap(item[widget.index]);
          },
          child: Container(
            width: generateColumnWidth(key),
            child: Center(
                child: Text(
              '${item[key]}',
              style: widget.textStyle,
            )),
          ),
        )));
      });
      result.add(DataRow(
        cells: cells,
        // onSelectChanged: (val) {
        //   _handleTap(item[widget.index]);
        // }
      ));
    }
    return result;
  }

  ///获取第一行第一列数据
  DataColumn getR1C1() {
    var firstItem = widget.data[0];
    return DataColumn(
        label: GestureDetector(
      onTap: () {
        _handleTap(firstItem[widget.index]);
      },
      child: Container(
        child: Center(
          child: Text(
            '${firstItem[widget.index]}',
            style: widget.textStyle,
          ),
        ),
      ),
    ));
  }

  ///获取第一列第一行之后
  List<DataRow> getC1() {
    List<DataRow> result = [];
    for (int i = 1; i < widget.data.length; i++) {
      var item = widget.data[i];
      result.add(DataRow(cells: [
        DataCell(GestureDetector(
          onTap: () {
            _handleTap(item[widget.index]);
          },
          child: Container(
            child: Text(
              '${item[widget.index]}',
              style: widget.textStyle,
            ),
          ),
        ))
      ]));
    }
    return result;
  }

  ///计算格子宽度
  double generateColumnWidth(String key) {
    if (key.length < 4) {
      return 50;
    } else {
      return key.toString().length * widget.cellWidthScale;
    }
  }
}
