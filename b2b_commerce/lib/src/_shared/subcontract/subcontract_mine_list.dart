import 'package:b2b_commerce/src/_shared/subcontract/subcontract_list_item.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_mine_detail.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_pool_detail.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SubContractMineList extends StatefulWidget {
  final SubContractMineState subcontractMineState;

  SubContractMineList({Key key, this.subcontractMineState}) : super(key: key);

  _SubContractMineListState createState() => _SubContractMineListState();
}

class _SubContractMineListState extends State<SubContractMineList> {
  ScrollController _scrollController = ScrollController();
  List<int> _selectIds = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        widget.subcontractMineState.showTopBtn = false;
      } else if (_scrollController.offset >= 500) {
        widget.subcontractMineState.showTopBtn = true;
      }
    });

    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.subcontractMineState.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      child: Container(
        color: Colors.grey[100],
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: _buildItems(),
            ),
            ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
              opacity: widget.subcontractMineState.loadingMore ? 1.0 : 0,
            ),
            _buildEnd(),
          ],
        ),
      ),
      onRefresh: () async {
        widget.subcontractMineState.clear();
      },
    );
  }

  Widget _buildItems() {
    return Column(
        children: widget.subcontractMineState.subcontractModels != null
            ? widget.subcontractMineState.subcontractModels.map((model) {
                return _buildRow(model);
              }).toList()
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Widget _buildRow(dynamic model) {
    return Column(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => SubContractMineDetailPage(model.code)));
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SubContractListItem(
              model: model,
            ),
          ),
        ),
        Divider(
          height: 0,
        ),
      ],
    );
  }

  Widget _buildEnd() {
    return widget.subcontractMineState.isDownEnd
        ? Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text('(￢_￢)已经到底了',style: TextStyle(color: Colors.grey),)],
            ),
          )
        : Container();
  }
}


