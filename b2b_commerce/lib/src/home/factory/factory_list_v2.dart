import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'factory_item_v2.dart';

///工厂列表v 22021年3月22日
class FactoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FactoriesState>(
      builder: (context, FactoriesState state, _) => Container(
        child: state.factories != null
            ? FactoryListView(
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class FactoryListView extends StatelessWidget {
  final FactoriesState state;

  FactoryListView({Key key, this.state}) : super(key: key);

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
        child: ListView.builder(
            itemCount: state.factories.length + 1,
            // itemExtent: 50.0,
            itemBuilder: (BuildContext context, int index) {
              if (index == (state.factories.length)) {
                return ProgressIndicatorFactory
                    .buildPaddedOpacityProgressIndicator(
                  opacity: state.loadingMore ? 1.0 : 0,
                );
              }

              return FactoryItem(
                model: state.factories[index],
              );
            }));
  }
}
