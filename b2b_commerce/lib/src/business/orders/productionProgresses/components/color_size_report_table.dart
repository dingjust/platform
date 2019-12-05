import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ColorSizeReportDataTable extends StatefulWidget {
  final List<SizeModel> sizes;

  final List<ColorModel> colors;

  final List<PurchaseOrderEntryModel> entries;

  final List<ProductionProgressOrderModel> productionProgressOrders;

  final String index;

  final double cellWidthScale;

  final TextStyle textStyle;

  ValueChanged<dynamic> onChanged;

  ColorSizeReportDataTable(this.index,
      {Key key,
        this.cellWidthScale = 12,
        this.textStyle,
        this.onChanged,
        this.sizes,
        this.colors,
        this.entries,
        this.productionProgressOrders})
      : super(key: key);

  @override
  _ColorSizeReportDataTableState createState() =>
      _ColorSizeReportDataTableState();
}

class _ColorSizeReportDataTableState extends State<ColorSizeReportDataTable> {
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
              LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints boxConstraints) =>
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: headerScrollController,
                        child: DataTable(
                          columns: getColumnHeader(boxConstraints),
                          rows: [],
                        )),
              )
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
                    LayoutBuilder(
                      builder:
                          (BuildContext context,
                          BoxConstraints boxConstraints) =>
                          SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: bodyScrollController,
                              child: DataTable(
                                columns: generateDataColumn(boxConstraints),
                                rows: generateDataRow(boxConstraints),
                              )),
                    ),
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

  List<DataColumn> getColumnHeader(BoxConstraints boxConstraints) {
    return widget.sizes
        .map((size) =>
        DataColumn(
            label: Container(
                width: generateColumnWidth(boxConstraints),
                child: Center(
                  child: Text(
                    '${size.name}',
                    style: widget.textStyle,
                  ),
                ))))
        .toList();
  }

  List<DataColumn> generateDataColumn(BoxConstraints boxConstraints) {
    return widget.sizes.map((size) {
      //字符处理
      int actualSum = getActualSum(widget.colors[0].name, size.name);
      int need = getNeed(widget.colors[0].name, size.name);
      String value = '';
      if (need < 1) {
        if (actualSum > 0) {
          value = '+$actualSum';
        }
      } else {
        value = '$actualSum/$need';
      }
      return DataColumn(
          label: GestureDetector(
            onTap: () {
              // _handleTap(firstItem[widget.index]);
            },
            child: Container(
              width: generateColumnWidth(boxConstraints),
              child: Center(
                child: Text(
                  '$value',
                  style: widget.textStyle,
                ),
              ),
            ),
          ));
    }).toList();
  }

  List<DataRow> generateDataRow(BoxConstraints boxConstraints) {
    return widget.colors
        .skip(1)
        .map((color) =>
        DataRow(
            cells: widget.sizes.map((size) {
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
              return DataCell(GestureDetector(
                onTap: () {},
                child: Container(
                  width: generateColumnWidth(boxConstraints),
                  child: Center(
                      child: Text(
                        '$value',
                        style: widget.textStyle,
                      )),
                ),
              ));
            }).toList()))
        .toList();
  }

  ///获取第一行第一列数据
  DataColumn getR1C1() {
    return DataColumn(
        label: GestureDetector(
          onTap: () {
            // _handleTap(firstItem[widget.index]);
          },
          child: Container(
            child: Center(
              child: Text(
                '${widget.colors[0].name}',
                style: widget.textStyle,
              ),
            ),
          ),
        ));
  }

  ///获取第一列第一行之后
  List<DataRow> getC1() {
    return widget.colors
        .skip(1)
        .map((color) =>
        DataRow(cells: [
          DataCell(GestureDetector(
            onTap: () {
              // _handleTap(item[widget.index]);
            },
            child: Container(
              child: Text(
                '${color.name}',
                style: widget.textStyle,
              ),
            ),
          ))
        ]))
        .toList();
  }

  ///计算格子宽度
  double generateColumnWidth(BoxConstraints boxConstraints) {
    if (widget.sizes.length < 5) {
      return 0.9 * boxConstraints.maxWidth / widget.sizes.length;
    } else {
      return 0.9 * boxConstraints.maxWidth / 6;
    }
  }

  int getNeed(String color, String size) {
    //空处理替代对象
    PurchaseOrderEntryModel emptyObj = PurchaseOrderEntryModel(quantity: 0);
    return widget.entries
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
}
