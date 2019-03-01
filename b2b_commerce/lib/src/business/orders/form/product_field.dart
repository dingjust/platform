import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductField extends StatefulWidget {
  ApparelProductModel item;

  ProductField(this.item);

  ProductFieldState createState() => ProductFieldState();
}

class ProductFieldState extends State<ProductField> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Text(
            '商品名称',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Container(
            width: 235,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(widget.item?.name ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        Divider(height: 0,),
        ListTile(
          leading: Text(
            '商品货号',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Container(
            width: 150,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(widget.item?.skuID ?? '',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        Divider(height: 0,),
      ],
    );
  }
}
