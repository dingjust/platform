import 'package:b2b_commerce/src/business/products/apparel_product_size_stock_item.dart';
import 'package:b2b_commerce/src/business/products/apparel_product_stock_input.dart';
import 'package:b2b_commerce/src/home/product/product_color_size_select.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductNumSelectPage extends StatefulWidget {
  List<ColorSelectEntry> colorEntries;
  List<SizeSelectEntry> sizeEntries;

  ProductNumSelectPage(
      {Key key, @required this.colorEntries, @required this.sizeEntries})
      : super(key: key);

  _ProductNumSelectPageState createState() => _ProductNumSelectPageState();
}

class _ProductNumSelectPageState extends State<ProductNumSelectPage> {

void initState() { 
  super.initState();
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.5,
        title: Text('选择数量'),
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
        color: Color.fromRGBO(248, 248, 248, 1),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Color.fromRGBO(248, 248, 248, 1),
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
              ApparelProductStockInputItem(
                items: apparelProductStockInputItems,
              )
            ],
          ),
        ),
      ),
    );
  }

  Map<ColorModel, List<SizeStockItem>> get apparelProductStockInputItems {
    Map<ColorModel, List<SizeStockItem>> result =
        Map<ColorModel, List<SizeStockItem>>();
    widget.colorEntries.where((entry) => entry.selected).forEach((color) {
      result[color.colorModel] = widget.sizeEntries
          .where((entry) => entry.selected)
          .map((size) => SizeStockItem(size: size.sizeModel))
          .toList();
    });
    return result;
  }
}
