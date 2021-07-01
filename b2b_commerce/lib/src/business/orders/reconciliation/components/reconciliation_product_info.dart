import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

class ReconciliationProductInfo extends StatelessWidget {
  final ProductModel product;

  final double height;

  ReconciliationProductInfo({this.product, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      color: Colors.grey[100],
      child: Row(
        children: [
          ImageFactory.buildThumbnailImage(product?.thumbnail,
              containerSize: height),
          Expanded(
            child: Container(
              height: height,
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${product.name}',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      // Text(
                      //     '交货：${DateFormatUtil.formatYMD(entry.deliveryDate)}')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '货号：${product.skuID}',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReconciliationInfoRow extends StatelessWidget {
  final String title;
  final String val;
  final TextStyle valStryle;

  const ReconciliationInfoRow(
      {Key key, this.title, this.val, this.valStryle = const TextStyle()})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (val == null || val == '') {
      return Container();
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$title'),
          Text(
            '$val',
            style: valStryle,
          )
        ],
      ),
    );
  }
}

class ReconciliationEditRow extends StatelessWidget {
  final String title;

  final TextStyle titleStyle;

  final TextEditingController controller;

  final FocusNode node;

  final ValueChanged<String> onChaged;

  final List<TextInputFormatter> formatters;

  const ReconciliationEditRow(
      {Key key,
      this.title,
      this.controller,
      this.node,
      this.onChaged,
      this.titleStyle = const TextStyle(),
      this.formatters = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Container(
              width: 200,
              child: Text(
                '$title',
                style: titleStyle,
              ),
            ),
            Expanded(
              child: TextFieldBorderComponent(
                padding: EdgeInsets.all(0),
                hideDivider: true,
                isRequired: true,
                textAlign: TextAlign.right,
                // hintText: '请输入内容',
                inputFormatters: formatters,
                controller: controller,
                focusNode: node,
                onChanged: (value) {
                  onChaged?.call(value);
                },
              ),
            )
          ],
        ));
  }
}
