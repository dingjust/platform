import 'package:b2b_commerce/src/home/product/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class PlateProductsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlateProductState>(
      builder: (context, PlateProductState state, _) => Container(
        child: state.products != null
            ? ProductsListView(
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class ProductsListView extends StatelessWidget {
  final PlateProductState state;
  final ScrollController _scrollController = ScrollController();

  ProductsListView({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        state.loadMore();
      }
    });

    return Container(
      child: RefreshIndicator(
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            Builder(builder: (context) {
              if (state.products.isNotEmpty) {
                List<RecommendProductItem> recommendProductItems =
                    state.products
                        .map((product) => RecommendProductItem(
                              model: product,
                              showAddress: true,
                            ))
                        .toList();

                return SliverPadding(
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
                      return recommendProductItems[index];
                    }, childCount: state.products.length),
                  ),
                );
              } else {
                return _NoDataInfoRow(
                  state: state,
                );
              }
            }),
            SliverToBoxAdapter(
              child:
                  ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                      opacity: state.loadingMore ? 1.0 : 0,
                      padding: state.loadingMore ? 8 : 0),
            ),
            _buildEnd(),
            _buildRecommendText(),
            _buildRecommendProducts()
          ],
        ),
        onRefresh: () async {
          state.clear();
        },
      ),
    );
  }

  Widget _buildEnd() {
    return state.isEnd()
        ? SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.orange,
                  ),
                  Text('已经到底了')
                ],
              ),
            ),
    )
        : SliverToBoxAdapter(
      child: Container(),
    );
  }

  Widget _buildRecommendText() {
    return (state.recommendProducts != null &&
        state.recommendProducts.isNotEmpty)
        ? SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.grey[300], width: 0.5))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('为你推荐')],
              ),
            ),
          )
        : SliverToBoxAdapter(
            child: Container(),
          );
  }

  Widget _buildRecommendProducts() {
    return Builder(builder: (context) {
      if (state.recommendProducts != null) {
        List<RecommendProductItem> recommendProductItems =
        state.recommendProducts
            .map((product) =>
            RecommendProductItem(
              model: product,
              showAddress: true,
            ))
            .toList();

        return SliverPadding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //Grid按两列显示
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.62,
            ),
            delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
              return recommendProductItems[index];
            }, childCount: state.recommendProducts.length),
          ),
        );
      } else {
        return SliverToBoxAdapter();
      }
    });
  }
}

class _NoDataInfoRow extends StatelessWidget {
  final PlateProductState state;

  const _NoDataInfoRow({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.lightbulb_outline,
              color: Colors.orange,
            ),
            Text('暂无相关数据,您可以更换条件试试')
          ],
        ),
      ),
    );
  }
}
