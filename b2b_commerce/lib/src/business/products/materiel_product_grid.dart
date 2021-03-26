import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'materiel_product_item.dart';

///面辅料瀑布流
class MaterielProductStaggeredGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MaterielProductState>(
      builder: (context, MaterielProductState state, _) => Container(
        child: state.products != null
            ? MaterielProductStaggeredGridView(
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class MaterielProductStaggeredGridView extends StatelessWidget {
  final MaterielProductState state;

  MaterielProductStaggeredGridView({Key key, this.state}) : super(key: key);

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
            child: StaggeredGridView.countBuilder(
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
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
                    return MaterielProductStaggeredGridItem(
                      model: state.products[index],
                    );
                  }
                },
                staggeredTileBuilder: (index) => StaggeredTile.fit(2))));
  }
}

///面辅料管理
class MaterielProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MaterielProductState>(
      builder: (context, MaterielProductState state, _) => Container(
        child: state.products != null
            ? MaterielProductGridView(
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class MaterielProductGridView extends StatelessWidget {
  final MaterielProductState state;

  MaterielProductGridView({Key key, this.state}) : super(key: key);

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
          child: GridView.builder(
              padding: EdgeInsets.only(top: 10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //每行三列
                  childAspectRatio: 1.0, //显示区域宽高相等
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0),
              itemCount: state.products.length + 1,
              itemBuilder: (context, index) {
                if (index == (state.products.length)) {
                  return ProgressIndicatorFactory
                      .buildPaddedOpacityProgressIndicator(
                    opacity: state.loadingMore ? 1.0 : 0,
                  );
                } else {
                  return MaterielProductGridItem(
                    model: state.products[index],
                  );
                }
              }),
        ));
  }
}
