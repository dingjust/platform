import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';

import '../plate_products_page.dart';
import 'hot_category_page.dart';

class ProductsButtonsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      padding: EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          _Button(
            image: B2BImage.products_spot(width: 50, height: 50),
            title: '现货批发',
            onTap: () =>
                _jumpToProductsPageByType(ProductType.SPOT_GOODS, context),
          ),
          _Button(
            image: B2BImage.products_future(width: 50, height: 50),
            title: '工厂期货',
            onTap: () =>
                _jumpToProductsPageByType(ProductType.FUTURE_GOODS, context),
          ),
          _Button(
            image: B2BImage.products_tail(width: 50, height: 50),
            title: '库存尾货',
            onTap: () =>
                _jumpToProductsPageByType(ProductType.TAIL_GOODS, context),
          ),
          _Button(
            image: B2BImage.products_category(width: 50, height: 50),
            title: '产品分类',
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HoteCategoryPage()));
            },
          ),
        ],
      ),
    );
  }

  void _jumpToProductsPageByType(ProductType type, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlateProductsPage(
              productType: type,
              condition: ProductCondition([], '', productTypes: [type]),
            )));
  }
}

class _Button extends StatelessWidget {
  final Image image;

  final String title;

  final VoidCallback onTap;

  const _Button(
      {Key key,
      @required this.image,
      @required this.title,
      @required this.onTap})
      : assert(image != null),
        assert(title != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Material(
          color: Colors.white,
          child: Ink(
            child: InkWell(
              onTap: onTap,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: image,
                    ),
                    Text('$title'),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
