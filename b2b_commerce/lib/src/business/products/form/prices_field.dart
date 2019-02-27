import 'package:flutter/material.dart';
import 'package:models/models.dart';
import '../apparel_product_prices_input.dart';
import 'package:widgets/widgets.dart';

class PricesField extends StatefulWidget {
  PricesField(this.item);

  final ApparelProductModel item;

  @override
  State<StatefulWidget> createState() => _PricesFieldState();
}

class _PricesFieldState extends State<PricesField> {
//  List<Object> prices = [];
  TextEditingController _priceController = TextEditingController();
  FocusNode _priceFocusNode = FocusNode();

  @override
  void initState() {
    _priceController.text = widget.item?.price?.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
//        InkWell(
//          onTap: () async {
//            List<Object> result = await Navigator.push(
//              context,
//              MaterialPageRoute(
//                builder: (context) => ApparelProductPricesInputPage(
//                  prices: prices,
//                ),
//              ),
//            );
//
//            if (result != null && result.length > 0) {
//              showDialog(
//                context: context,
//                builder: (context) => AlertDialog(
//                  title: Text(result.toString()),
//                ),
//              );
//            }
//          },
//          child: ListTile(
//            title: Text('价格'),
//            trailing: Icon(Icons.chevron_right),
//          ),
//        ),
        TextFieldComponent(
          focusNode: _priceFocusNode,
          controller: _priceController,
          leadingText: '供货价',
          hintText: '请输入供货价',
          onChanged: (value){
            widget.item.price = value;
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Divider(height: 0, color: Colors.grey[400]),
        ),
      ],
    );
  }
}

/*class ApparelProductPrices{
  double price;
  double suggestedPrice;
  double price1;
  double price2;
  double price3;

  ApparelProductPrices({
    this.price,
    this.suggestedPrice,
    this.price1,
    this.price2,
    this.price3,
  });
}*/
