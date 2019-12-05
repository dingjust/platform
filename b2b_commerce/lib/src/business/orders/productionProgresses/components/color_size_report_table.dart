import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ColorSizeReportDataTable extends StatefulWidget {
  final List<SizeModel> sizes;

  final List<ColorModel> colors;

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
        this.colors})
      : super(key: key);

  @override
  _ColorSizeReportDataTableState createState() =>
      _ColorSizeReportDataTableState();
}

class _ColorSizeReportDataTableState extends State<ColorSizeReportDataTable> {
  ScrollController headerScrollController;
  ScrollController bodyScrollController;

  List<String> columnsHeaderKeys;
  List<TableCell> columnsHeaders = [];

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
          // border: TableBorder.all(color: Colors.grey, width: 0.5),
          columnWidths: <int, TableColumnWidth>{
            0: FlexColumnWidth(0.1),
            1: FlexColumnWidth(0.9),
          },
          children: [
            TableRow(children: [
              Table(
                children: [
                  TableRow(children: [
                    TableCell(
                        child: Container(
                          width: 50,
                          child: Center(
                            child: Text(
                              '${widget.index}',
                              style: widget.textStyle,
                            ),
                          ),
                        ))
                  ])
                ],
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // dragStartBehavior: widget.dragStartBehavior,
                  controller: headerScrollController,
                  child: Container(
                    // constraints: BoxConstraints.expand(),
                    // width: 500,
                    // width: double.infinity,
                    child: Table(
                      children: [
                        TableRow(
                            children: widget.sizes
                                .map((size) =>
                                TableCell(
                                  child: Container(
                                    width: 100,
                                    child: Text(
                                      '${size.name}',
                                      style: widget.textStyle,
                                    ),
                                  ),
                                ))
                                .toList())
                      ],
                    ),
                  )),
            ])
          ],
        ),
        // Expanded(
        //   flex: 1,
        //   child: SingleChildScrollView(
        //       child: Table(
        //     // border: TableBorder.all(color: Colors.grey, width: 0.5),
        //     columnWidths: <int, TableColumnWidth>{
        //       0: FlexColumnWidth(0.1),
        //       1: FlexColumnWidth(0.9),
        //     },
        //     children: [
        //       TableRow(children: [
        //         Table(
        //           children: widget.colors
        //               .map((color) => TableRow(children: [
        //                     TableCell(
        //                       child: Container(
        //                         child: Center(
        //                           child: Text(
        //                             '${color.name}',
        //                             style: widget.textStyle,
        //                           ),
        //                         ),
        //                       ),
        //                     )
        //                   ]))
        //               .toList(),
        //         ),
        //         SingleChildScrollView(
        //             scrollDirection: Axis.horizontal,
        //             // dragStartBehavior: widget.dragStartBehavior,
        //             controller: bodyScrollController,
        //             child: Table(
        //               children: widget.colors
        //                   .map((color) => TableRow(
        //                       children: widget.sizes
        //                           .map((size) => TableCell(
        //                                 child: Center(
        //                                   child: Text(
        //                                     '${size.name}/${color.name}',
        //                                     style: widget.textStyle,
        //                                   ),
        //                                 ),
        //                               ))
        //                           .toList()))
        //                   .toList(),
        //             )),
        //       ])
        //     ],
        //   )),
        // )
      ],
    );
  }

  void _handleTap(dynamic value) {
    widget.onChanged(value);
  }

  void initColumnHeader() {
    columnsHeaders = widget.sizes
        .map((size) =>
        TableCell(
          child: Container(
            // width: generateColumnWidth(size.name),
              child: Center(
                child: Text(
                  '${size.name}',
                  style: widget.textStyle,
                ),
              )),
        ))
        .toList();
  }

  List<DataColumn> generateDataColumn() {
    return widget.sizes
        .map((size) =>
        DataColumn(
            label: GestureDetector(
              onTap: () {
                // _handleTap(firstItem[widget.index]);
              },
              child: Container(
                width: generateColumnWidth(size.name),
                child: Center(
                  child: Text(
                    '${size.name}',
                    style: widget.textStyle,
                  ),
                ),
              ),
            )))
        .toList();
  }

  List<DataRow> generateDataRow() {
    return widget.colors
        .map((color) =>
        DataRow(
            cells: widget.sizes
                .map((size) =>
                DataCell(GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: generateColumnWidth(size.name),
                    child: Center(
                        child: Text(
                          '${color.name}/${size.name}',
                          style: widget.textStyle,
                        )),
                  ),
                )))
                .toList()))
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
  double generateColumnWidth(String key) {
    if (key.length < 4) {
      return 50;
    } else {
      return key
          .toString()
          .length * widget.cellWidthScale;
    }
  }
}
