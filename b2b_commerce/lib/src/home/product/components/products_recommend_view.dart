import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'products_recommend_section.dart';

class ProductsRecommendView extends StatelessWidget {
  final PlateProductState plateProductState;

  ScrollController _scrollController = ScrollController();

  ProductsRecommendView(this.plateProductState, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        plateProductState.loadMore();
      }
    });

    return Container(
        child: CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverToBoxAdapter(
            child: Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '为你推荐',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )),
        plateProductState.products != null
            ? ProductsRecommendSection(
                products: plateProductState.products,
              )
            : SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
        SliverToBoxAdapter(
          child: ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
            opacity: plateProductState.loadingMore ? 1.0 : 0,
          ),
        )
      ],
    ));
  }
}
