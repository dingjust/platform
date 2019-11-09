import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '_shared/capacity_matching_appbar.dart';
import '_shared/capacity_matching_item.dart';

class CapacityMatchingPage extends StatefulWidget
    implements PreferredSizeWidget {
  _CapacityMatchingPageState createState() => _CapacityMatchingPageState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => null;
}

class _CapacityMatchingPageState extends State<CapacityMatchingPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CapacityMatchingState>(
      builder: (context) => CapacityMatchingState(),
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          automaticallyImplyLeading: false,
          elevation: 0.5,
          title: CapacitySearch(),
          bottom: PreferredSize(
              preferredSize: Size(75, 20), child: CapacityCondition()),
        ),
        endDrawer: Drawer(child: Container()),
        body: CapacityMatchingListPage(),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class CapacityMatchingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CapacityMatchingState>(
      builder: (context, CapacityMatchingState capacityMatchingState, _) =>
          Container(
        child: capacityMatchingState.factoryCapacityModels != null
            ? CapacityMatchingListView(
                capacityMatchingState: capacityMatchingState,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class CapacityMatchingListView extends StatelessWidget {
  final CapacityMatchingState capacityMatchingState;
  final ScrollController _scrollController = ScrollController();

  CapacityMatchingListView({Key key, this.capacityMatchingState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        capacityMatchingState.loadMore();
      }
    });

    return Container(
      child: RefreshIndicator(
        child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Column(
                children: capacityMatchingState.factoryCapacityModels
                    .map((model) => CapacityMatchingItem(
                          model: model,
                        ))
                    .toList(),
              ),
              ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                opacity: capacityMatchingState.loadingMore ? 1.0 : 0,
              ),
              _buildEnd()
            ]),
        onRefresh: () async {
          capacityMatchingState.clear();
        },
      ),
    );
  }

  Widget _buildEnd() {
    return capacityMatchingState.isEnd()
        ? Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('已经到底了')],
            ),
          )
        : Container();
  }
}
