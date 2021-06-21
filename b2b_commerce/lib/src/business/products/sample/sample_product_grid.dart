import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'sample_product_item.dart';

class SampleProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SampleProductsState>(
      builder: (context, SampleProductsState state, _) => Container(
        child: state.data != null
            ? SampleProductGridView(
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class SampleProductGridView extends StatelessWidget {
  final SampleProductsState state;

  SampleProductGridView({Key key, this.state}) : super(key: key);

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
              itemCount: state.data.length + 1,
              itemBuilder: (context, index) {
                if (index == (state.data.length)) {
                  return ProgressIndicatorFactory
                      .buildPaddedOpacityProgressIndicator(
                    opacity: state.loadingMore ? 1.0 : 0,
                  );
                } else {
                  return SampleProductGridItem(
                    model: state.data[index],
                  );
                }
              }),
        ));
  }
}
