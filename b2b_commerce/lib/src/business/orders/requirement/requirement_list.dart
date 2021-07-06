import 'package:b2b_commerce/src/business/orders/requirement/requirement_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

///需求列表
class RequirementList<T extends RequirementState> extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, T state, _) => Container(
        child: state.requirements != null
            ? RequirementListView(
                state: state,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class RequirementListView extends StatelessWidget {
  final RequirementState state;

  RequirementListView({Key key, this.state}) : super(key: key);

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
            padding: EdgeInsets.only(top: 5),
            itemCount: state.requirements.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == (state.requirements.length)) {
                return ProgressIndicatorFactory
                    .buildPaddedOpacityProgressIndicator(
                  opacity: state.loadingMore ? 1.0 : 0,
                );
              } else {
                return RequirementListItem(
                  model: state.requirements[index],
                );
              }
            }));
  }
}
