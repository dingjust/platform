import 'package:b2b_commerce/src/business/orders/fabric/fabric_requirement_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FabricRequirementListPage extends StatefulWidget {
  _FabricRequirementListPage createState() => _FabricRequirementListPage();
}

class _FabricRequirementListPage extends State<FabricRequirementListPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FabricRequirementState>(
        builder: (context, FabricRequirementState state, _) => Container(
              child: state.fabricRequirements != null
                  ? FabricRequirementList(state)
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ));
  }
}

class FabricRequirementList extends StatelessWidget {
  final FabricRequirementState state;

  FabricRequirementList(
    this.state, {
    Key key,
  }) : super(key: key);

  final ScrollController _scrollController = ScrollController();

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
      child: ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          state.fabricRequirements.isNotEmpty
              ? Column(
            children: state.fabricRequirements
                .map((e) => FabricRequirementListItem())
                .toList(),
          )
              : _NoDataInfoRow(),
          ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
            opacity: state.loadingMore ? 1.0 : 0,
          ),
          _buildEnd()
        ],
      ),
    );
  }

  Widget _buildEnd() {
    return (state.currentPage + 1 == state.totalPages && !state.loadingMore)
        ? Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text('已经到底了')]),
    )
        : Container();
  }
}

class _NoDataInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
