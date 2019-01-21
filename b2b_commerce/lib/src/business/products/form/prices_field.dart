import 'package:flutter/material.dart';
import 'package:models/models.dart';
import '../apparel_product_prices_input.dart';

class PricesField extends StatefulWidget {
  PricesField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _PricesFieldState();
}

class _PricesFieldState extends State<PricesField> {
  Map<String, double> priceMap = Map();

  @override
  void initState() {
    super.initState();
    priceMap['price'] = widget.item?.price;
    priceMap['suggestedPrice'] = widget.item?.suggestedPrice;
    priceMap['price1'] = widget.item?.price1;
    priceMap['price2'] = widget.item?.price2;
    priceMap['price3'] = widget.item?.price3;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () async {
            Map<String, double> result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApparelProductPricesInputPage(
                  priceMap: priceMap,
                ),
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
            title: Text('价格'),
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
