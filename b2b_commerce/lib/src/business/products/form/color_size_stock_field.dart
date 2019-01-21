import 'package:flutter/material.dart';
import 'package:models/models.dart';
import '../apparel_product_stock_input.dart';
import '../apparel_product_variants_input.dart';

class ColorSizeStockField extends StatefulWidget {
  ColorSizeStockField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _ColorSizeStockFieldState();
}

class _ColorSizeStockFieldState extends State<ColorSizeStockField> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () async {
            dynamic result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ApparelProductVariantsInputPage(),
              ),
            );

            if (result != null && result.length > 0) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(result.toString()),
                ),
              );
            }
          },
          child: ListTile(
            title: Text('颜色/尺码'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(height: 0, color: Colors.grey[400]),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductStockInputPage(),
              ),
            );
          },
          child: ListTile(
            title: Text('库存'),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(height: 0, color: Colors.grey[400]),
        ),
      ],
    );
  }
}