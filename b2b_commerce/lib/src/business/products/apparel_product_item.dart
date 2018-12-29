import 'package:b2b_commerce/src/business/products/apparel_product_form.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ApparelProductItem extends StatelessWidget {
  ApparelProductItem(this.item);

  final ApparelProductModel item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: null,
              leading: Text('TODO: 缩略图'),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    children: <Widget>[Text('${item.name}')],
                  ),
                  Text('供应商商品编号：${item.skuID} '),
                  Text('￥${item.price}'),
                  Row(
                    children: <Widget>[
                      Text('库存：300'),
                      Text(' '),
                      Text('在架：200'),
                    ],
                  ),
                  Text('总销量：0'),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text('生产'),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ApparelProductFormPage(item: item)),
                      );
                    },
                    child: Text('编辑'),
                  ),
                ),
                /*RaisedButton(
                  onPressed: () {},
                  child: Text('上架'),
                ),*/
                Expanded(
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text('下架'),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text('删除'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
