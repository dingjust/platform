import 'package:b2b_commerce/src/business/orders/requirement/requirement_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///需求瀑布流
class RequirementStaggeredGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RequirementState>(
      builder: (context, RequirementState state, _) => Container(
        child: state.requirements != null
            ? RequirementStaggeredGridView(
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class RequirementStaggeredGridView extends StatelessWidget {
  final RequirementState state;

  RequirementStaggeredGridView({Key key, this.state}) : super(key: key);

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
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            itemCount: state.requirements.length + 1,
            itemBuilder: (context, index) {
              if (index == (state.requirements.length)) {
                return ProgressIndicatorFactory
                    .buildPaddedOpacityProgressIndicator(
                  opacity: state.loadingMore ? 1.0 : 0,
                );
              } else {
                return RequirementGridItem(
                  model: state.requirements[index],
                );
              }
            },
            staggeredTileBuilder: (index) => StaggeredTile.fit(2)));
  }
}
