import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProgressOrdersTable extends StatelessWidget {
  final List<ProductionProgressOrderModel> productionProgressOrders;

  final ValueChanged<ProductionProgressOrderModel> onDetail;

  const ProgressOrdersTable(
      {Key key, this.productionProgressOrders, this.onDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (productionProgressOrders.isEmpty) {
      return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Text('暂无上报单据'),
          ));
    }

    //表头
    List<TableRow> dataRows = [
      TableRow(children: <TableCell>[
        TableCell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('单号'),
              )),
        ),
        TableCell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('时间'),
              )),
        ),
        TableCell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('上报数量'),
              )),
        ),
        TableCell(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Text('状态'),
              )),
        )
      ])
    ];

    dataRows.addAll(
        productionProgressOrders.map((order) => TableRow(children: <TableCell>[
              TableCell(
                  child: FlatButton(
                onPressed: () {
                  onDetail(order);
                },
                child: Container(
                    child: Center(
                  child: Text(
                    '${order.id}',
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                )),
              )),
              TableCell(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child:
                          Text('${DateFormatUtil.formatYMD(order.reportTime)}'),
                    )),
              ),
              TableCell(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text('${order.amount}'),
                    )),
              ),
              TableCell(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text(
                          '${ProductionProgressOrderStatusLocalizedMap[order.status]}'),
                    )),
              )
            ])));

    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(
          color: Colors.grey, width: 0.5, style: BorderStyle.solid),
      children: dataRows,
    );
  }
}
