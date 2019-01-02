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
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Container(
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[ApparelProductStockInputItem()],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: RaisedButton(
          onPressed: () {},
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

  SizeStockItem({this.size, this.available = 0, this.maxPreOrder = 0});
}

class ApparelProductStockInputItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<ColorModel, List<SizeStockItem>> items = <ColorModel, List<SizeStockItem>>{
      ColorModel(code: 'C01', name: '红色'): <SizeStockItem>[
        SizeStockItem(size: SizeModel(code: 'S01', name: 'XL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL'))
      ],
      ColorModel(code: 'C02', name: '绿色'): <SizeStockItem>[
        SizeStockItem(size: SizeModel(code: 'S01', name: 'XL')),
        SizeStockItem(size: SizeModel(code: 'S012', name: 'XXL'))
      ],
    };

    Widget buildRow(BuildContext context, MapEntry<ColorModel, List<SizeStockItem>> row) {
      final List<TableRow> _subRows = row.value.map((item) {
        return TableRow(children: <TableCell>[
          TableCell(
            child: Center(child: Text(item.size.name)),
          ),
          TableCell(
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '实际库存',
              ),
            ),
          ),
          TableCell(
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '平台库存',
              ),
            ),
          )
        ]);
      }).toList();

      return Card(
        child: Column(
          children: <Widget>[
            Text(row.key.name),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: new TableBorder.all(width: 1.0, color: Colors.black12),
              children: _subRows,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return buildRow(context, items.entries.toList()[index]);
      },
    );
  }
}
