import 'package:b2b_commerce/src/home/product/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';

class ProductsRecommendSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RecommendProductState>(
        builder: (context, RecommendProductState state, _) =>
        state.products != null
            ? SliverPadding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //Grid按两列显示
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.62,
            ),
            delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  List<RecommendProductItem> recommendProductItems =
                  state.products
                      .map((product) =>
                      RecommendProductItem(
                        model: product,
                        showAddress: true,
                      ))
                      .toList();
                  return recommendProductItems[index];
                }, childCount: state.products.length),
          ),
        )
            : SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.only(top: 100),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ));
  }
}
