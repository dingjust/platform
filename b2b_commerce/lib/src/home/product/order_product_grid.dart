import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'product_grid_item.dart';

///产品瀑布流
class ProductStaggeredGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductState>(
      builder: (context, ProductState state, _) =>
          Container(child: Builder(builder: (_) {
        if (state.products != null) {
          if (state.products.isNotEmpty) {
            return ProductStaggeredGridView(
              state: state,
            );
          }
          return Center(
            child: Text('暂无数据'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      })),
    );
  }
}

class ProductStaggeredGridView extends StatelessWidget {
  final ProductState state;

  ProductStaggeredGridView({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            state.loadMore();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            state.clear();
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 2,
                    crossAxisSpacing: 13,
                    mainAxisSpacing: 12,
                    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      if (index == 0 || index == 1) {
                        //第一行有上边距
                        return Container(
                          margin: EdgeInsets.only(top: 12),
                          child: ProductStaggeredGridItem(
                            model: state.products[index],
                          ),
                        );
                      }
                      return ProductStaggeredGridItem(
                        model: state.products[index],
                      );
                    },
                    itemCount: state.products.length),
              ),
              SliverToBoxAdapter(
                child: ProgressIndicatorFactory
                    .buildPaddedOpacityProgressIndicator(
                  opacity: state.loadingMore ? 1.0 : 0,
                ),
              )
            ],
          ),
        ));
  }
}

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductState>(builder: (context, ProductState state, _) {
      if (state.products != null) {
        if (state.products.length > 0) {
          return ProductGridView(
            state: state,
          );
        } else {
          return NoDataInfoRow();
        }
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}

class ProductGridView extends StatelessWidget {
  final ProductState state;

  ProductGridView({Key key, this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels ==
            notification.metrics.maxScrollExtent) {
          state.loadMore();
        }
        return false;
      },
      child: RefreshIndicator(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, //每行三列
                    childAspectRatio: 0.68, //显示区域宽高相等
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0),
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return ProductGridItem(
                    model: state.products[index],
                  );
                }, childCount: state.products.length),
              ),
            ),
            SliverToBoxAdapter(
              child:
                  ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                opacity: state.loadingMore ? 1.0 : 0,
              ),
            )
          ],
        ),
        onRefresh: () async {
          state.clear();
        },
      ),
    );
  }
}
