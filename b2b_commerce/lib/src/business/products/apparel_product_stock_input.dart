import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductStockInputPage extends StatelessWidget {
  static Map<ColorModel, List<SizeStockItem>> items =
      <ColorModel, List<SizeStockItem>>{
    ColorModel(code: 'C01', name: '红色', colorCode: 'FF0033'): <SizeStockItem>[
      SizeStockItem(
          size: SizeModel(code: 'S01', name: 'XL'),
          available: 35,
          maxPreOrder: 55),
      SizeStockItem(
        size: SizeModel(code: 'S012', name: 'XXL'),
      ),
    ],
    ColorModel(code: 'C02', name: '海军蓝', colorCode: '0066FF'): <SizeStockItem>[
      SizeStockItem(size: SizeModel(code: 'S01', name: 'XL')),
      SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL')),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('库存'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.done,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Card(
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
              ApparelProductStockInputItem(items: items),
//            ApparelProductStockInputItem(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RaisedButton(
          onPressed: () {
            items.values.forEach((item) {
              item.forEach((it) {
                print(it.availableController.text);
              });
            });
          },
          child: Text('批量调整'),
        ),
      ),
    );
  }
}

class SizeStockItem {
  SizeModel size;
  int available;
  int maxPreOrder;
  TextEditingController availableController;
  TextEditingController maxPreOrderController;

  SizeStockItem({
    this.size,
    this.available = 0,
    this.maxPreOrder = 0,
  }) {
    this.availableController = new TextEditingController(
        text: this.available == 0 ? null : this.available.toString());
    this.maxPreOrderController = new TextEditingController(
        text: this.maxPreOrder == 0 ? null : this.maxPreOrder.toString());
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
//      print(index);
      final List<TableRow> _subRows = row.value.map((item) {
        return TableRow(children: <TableCell>[
          TableCell(
            child: Center(
                child: Text(
              '${item.size.name}',
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
