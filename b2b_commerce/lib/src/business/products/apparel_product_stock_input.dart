import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductStockInputPage extends StatelessWidget {
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    child: Text(
                      '实际库存',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      '平台库存',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              ApparelProductStockInputItem(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RaisedButton(
          onPressed: () {

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
    this.availableController = TextEditingController();
    this.maxPreOrderController = TextEditingController();
  }
}

class ApparelProductStockInputItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<ColorModel, List<SizeStockItem>> items =
        <ColorModel, List<SizeStockItem>>{
      ColorModel(code: 'C01', name: '红色', colorCode: 'FF0033'): <SizeStockItem>[
        SizeStockItem(size: SizeModel(code: 'S01', name: 'XL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL')),
      ],
      ColorModel(code: 'C02', name: '海军蓝', colorCode: '0066FF'):
          <SizeStockItem>[
        SizeStockItem(size: SizeModel(code: 'S01', name: 'XL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL')),
      ],
      ColorModel(code: 'C02', name: '浅紫色', colorCode: 'CC99CC'):
          <SizeStockItem>[
        SizeStockItem(size: SizeModel(code: 'S01', name: 'XL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL'))
      ],
      ColorModel(code: 'C02', name: '浅紫色', colorCode: 'CC99CC'):
          <SizeStockItem>[
        SizeStockItem(size: SizeModel(code: 'S01', name: 'XL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL'))
      ],
      ColorModel(code: 'C02', name: '浅紫色', colorCode: 'CC99CC'):
          <SizeStockItem>[
        SizeStockItem(size: SizeModel(code: 'S01', name: 'XL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL'))
      ],
    };

    Widget buildRow(
        BuildContext context, MapEntry<ColorModel, List<SizeStockItem>> row) {
      final List<TableRow> _subRows = row.value.map((item) {
        return TableRow(children: <TableCell>[
          TableCell(
            child: Center(
                child: Text(
              item.size.name,
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
        border: new TableBorder.all(width: 1.0, color: Colors.black12),
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
//                          border: Border.all(
//                            color: Colors.grey,
//                          ),
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
                border: new TableBorder.all(
                  width: 1.0,
                  color: Colors.black12,
                ),
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
    return Expanded(child: ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return buildRow(context, items.entries.toList()[index]);
      },
    ),);
  }
}
