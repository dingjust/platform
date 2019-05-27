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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ApparelProductPricesInputPage(widget.item)));
          },
          child: ShowSelectTile(
            isRequired: true,
            leadingText: '价格',
            tralingText: widget.item.minPrice == null && widget.item.maxPrice == null ? '' : '￥${widget.item.minPrice ?? ''} ~ ￥${widget.item.maxPrice ?? ''}',
          ),
        ),
      ],
    );
  }
}