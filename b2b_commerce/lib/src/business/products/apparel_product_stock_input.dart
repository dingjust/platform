import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'apparel_product_size_stock_item.dart';

class ApparelProductStockInputPage extends StatefulWidget {
  Map<ColorModel, List<SizeStockItem>> items;

  ApparelProductStockInputPage({this.items});

  ApparelProductStockInputPageState createState() =>
      ApparelProductStockInputPageState();
}

class ApparelProductStockInputPageState
    extends State<ApparelProductStockInputPage> {
  Map<ColorModel, List<SizeStockItem>> _beforeItems = Map();

  @override
  void initState() {
    widget.items.forEach((color, sizeStockItems) {
      _beforeItems[color] = sizeStockItems.map((item) {
        return SizeStockItem(
          size: item.size,
          available: int.parse(item.availableController.text == '' ? '0' : item.availableController.text),
          maxPreOrder: int.parse(item.maxPreOrderController.text == '' ? '0' : item.maxPreOrderController.text),
        );
      }).toList();
    });
    // TODO: implement initState
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
          title: Text('库存'),
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
                      width: 85,
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
                      width: 85,
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
                      width: 85,
                      height: 15,
                      child: Center(
                        child: Text(
                          '实际库存',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 85,
                      height: 15,
                      child: Center(
                        child: Text(
                          '平台库存',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ApparelProductStockInputItem(items: widget.items),
//            ApparelProductStockInputItem(),
            ],
          ),
        ),
      ),
    );
  }
}

class ApparelProductStockInputItem extends StatefulWidget {
  final Map<ColorModel, List<SizeStockItem>> items;

  ApparelProductStockInputItem({@required this.items});

  ApparelProductStockInputItemState createState() =>
      ApparelProductStockInputItemState();
}

class ApparelProductStockInputItemState
    extends State<ApparelProductStockInputItem> {
  Map<ColorModel, List<SizeStockItem>> items;

  @override
  void initState() {
    items = widget.items;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildRow(BuildContext context,
        MapEntry<ColorModel, List<SizeStockItem>> row, int index) {
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
              controller: item.availableController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
//                hintText: '实际库存',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
              ),
              autofocus: true,
            ),
          ),
          TableCell(
            child: TextField(
              controller: item.maxPreOrderController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
//                hintText: '平台库存',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
              ),
            ),
          )
        ]);
      }).toList();

      return Table(
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(85),
          1: FixedColumnWidth(255),
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

//    return ListView(
//      children: items.entries.map((entry){
//        return buildRow(context, entry);
//      }).toList(),
//    ) ;
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
