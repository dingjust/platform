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
      builder: (context, ProductState state, _) => Container(
        child: state.products != null
            ? ProductStaggeredGridView(
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
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
        child: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 5),
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: state.products.length + 1,
            itemBuilder: (context, index) {
              if (index == (state.products.length)) {
                return ProgressIndicatorFactory
                    .buildPaddedOpacityProgressIndicator(
                  opacity: state.loadingMore ? 1.0 : 0,
                );
              } else {
                return ProductStaggeredGridItem(
                  model: state.products[index],
                );
              }
            },
            staggeredTileBuilder: (index) => StaggeredTile.fit(2)));
  }
}

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductState>(
      builder: (context, ProductState state, _) => Container(
        child: state.products != null
            ? ProductGridView(
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
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
