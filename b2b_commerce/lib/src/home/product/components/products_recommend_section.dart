import 'package:b2b_commerce/src/home/product/product.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class ProductsRecommendSection extends StatelessWidget {
  final List<ApparelProductModel> products;

  const ProductsRecommendSection({Key key, this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //Grid按两列显示
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.62,
        ),
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          List<RecommendProductItem> recommendProductItems = products
              .map((product) => RecommendProductItem(
                    model: product,
                    showAddress: true,
                  ))
              .toList();
          return recommendProductItems[index];
        }, childCount: products.length),
      ),
    );
  }
}
