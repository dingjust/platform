import 'package:b2b_commerce/src/business/orders/proofing_order_quantity_input.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class OfflineOrderQuantityInputPage extends StatefulWidget {
  Map<ColorModel, List<SizeQuantityItem>> items;

  OfflineOrderQuantityInputPage({this.items});

  OfflineOrderQuantityInputPageState createState() =>
      OfflineOrderQuantityInputPageState();
}

class OfflineOrderQuantityInputPageState
    extends State<OfflineOrderQuantityInputPage> {
  Map<ColorModel, List<SizeQuantityItem>> _beforeItems = Map();

  @override
  void initState() {
    widget.items.forEach((color, SizeQuantityItems) {
      _beforeItems[color] = SizeQuantityItems.map((item) {
        return SizeQuantityItem(
          size: item.size,
          quantity: int.parse(item.quantityController.text == ''
              ? '0'
              : item.quantityController.text),
        );
      }).toList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _beforeItems);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text('数量'),
          leading: IconButton(
              icon: Text('取消'),
              onPressed: () {
                widget.items.clear();
                Navigator.pop(context, _beforeItems);
              }),
          actions: <Widget>[
            IconButton(
              icon: Text('确定'),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      width: 113,
                      height: 15,
                      child: Center(
                        child: Text(
                          '颜色',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 113,
                      height: 15,
                      child: Center(
                        child: Text(
                          '尺码',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 113,
                      height: 15,
                      child: Center(
                        child: Text(
                          '数量',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              OfflineOrderQuantityInputItem(items: widget.items),
//            ApparelProductStockInputItem(),
            ],
          ),
        ),
      ),
    );
  }
}

class OfflineOrderQuantityInputItem extends StatefulWidget {
  final Map<ColorModel, List<SizeQuantityItem>> items;

  OfflineOrderQuantityInputItem({@required this.items});

  OfflineOrderQuantityInputItemState createState() =>
      OfflineOrderQuantityInputItemState();
}

class OfflineOrderQuantityInputItemState
    extends State<OfflineOrderQuantityInputItem> {
  Map<ColorModel, List<SizeQuantityItem>> items;

  @override
  void initState() {
    items = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildRow(BuildContext context,
        MapEntry<ColorModel, List<SizeQuantityItem>> row, int index) {
      final List<TableRow> _subRows = row.value.map((item) {
        return TableRow(children: <TableCell>[
          TableCell(
            child: Center(
                child: Text(
                  '${item.size?.name}',
                  style: TextStyle(fontSize: 14),
                )),
          ),
          TableCell(
            child: TextField(
              controller: item.quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
              ),
              autofocus: false,
            ),
          ),
        ]);
      }).toList();

      return Table(
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(113),
          1: FixedColumnWidth(226),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: new TableBorder.all(width: 0.5, color: Colors.grey[300]),
        children: <TableRow>[
          TableRow(children: <Widget>[
            TableCell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 20,
                    decoration: BoxDecoration(
                      color: Color(int.parse('0xff' + row.key.colorCode)),
                      shape: BoxShape.circle,
                    ),
                    child: Text(''),
                  ),
                  Text(row.key.name),
                ],
              ),
            ),
            TableCell(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: _subRows,
                border:
                new TableBorder.all(width: 0.5, color: Colors.grey[200]),
              ),
            ),
          ]),
        ],
      );
    }

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return buildRow(context, items.entries.toList()[index], index);
        },
      ),
    );
  }
}
