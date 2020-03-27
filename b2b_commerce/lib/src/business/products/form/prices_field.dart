import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

import '../apparel_product_prices_input.dart';

class PricesField extends StatefulWidget {
  PricesField(this.item,{this.enabled = false});

  final ApparelProductModel item;
  final bool enabled;

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
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ApparelProductPricesInputPage(
                  widget.item, enabled: widget.enabled,)));
          },
          child: ShowSelectTile(
//            isRequired: true,
//            isShowIcon: widget.enabled,
            leadingText: '价格明细',
//            tralingText: widget.item.minPrice == null && widget.item.maxPrice == null ? '' : '￥${widget.item.minPrice ?? ''} ~ ￥${widget.item.maxPrice ?? ''}',
          ),
        ),
      ],
    );
  }
}