import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProofingOrderQuantityInputPage extends StatefulWidget {
  Map<ColorModel, List<SizeQuantityItem>> items;

  ProofingOrderQuantityInputPage({this.items});

  ProofingOrderQuantityInputPageState createState() =>
      ProofingOrderQuantityInputPageState();
}

class ProofingOrderQuantityInputPageState
    extends State<ProofingOrderQuantityInputPage> {
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
          title: Text('样衣数量'),
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
              ProofingOrderQuantityInputItem(items: widget.items),
//            ApparelProductStockInputItem(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProofingOrderQuantityInputItem extends StatefulWidget {
  final Map<ColorModel, List<SizeQuantityItem>> items;

  ProofingOrderQuantityInputItem({@required this.items});

  ProofingOrderQuantityInputItemState createState() =>
      ProofingOrderQuantityInputItemState();
}

class ProofingOrderQuantityInputItemState
    extends State<ProofingOrderQuantityInputItem> {
  Map<ColorModel, List<SizeQuantityItem>> items;

  @override
  void initState() {
    items = widget.items;

    // TODO: implement initState
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
              autofocus: true,
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

class SizeQuantityItem {
  SizeModel size;
  int quantity;
  TextEditingController quantityController;

  SizeQuantityItem({
    this.size,
    this.quantity = 0,
  }) {
    this.quantityController = new TextEditingController(
      text: this.quantity == 0 ? null : this.quantity.toString(),
    );
  }
}
