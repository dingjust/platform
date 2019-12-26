import 'package:b2b_commerce/src/_shared/subcontract/subcontract_mine_list_item.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_mine_detail.dart';
import 'package:connectivity/connectivity.dart';
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
        widget.subcontractMineState.loadMoreMapData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return widget.subcontractMineState.subcontractModelsByMap != null ? RefreshIndicator(
      child: Container(
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          children: <Widget>[
            _buildItems(),
            ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
              opacity: widget.subcontractMineState.loadingMore ? 1.0 : 0,
            ),
            _buildEnd(),
          ],
        ),
      ),
      onRefresh: () async {
        widget.subcontractMineState.clearMapData();
      },
    ):Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildItems() {
    if(widget.subcontractMineState.subcontractModelsByMap.isEmpty){
      return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 200),
            child: Image.asset(
              'temp/logo2.png',
              package: 'assets',
              width: 80,
              height: 80,
            ),
          ),
          Container(
              child: Text(
                AppBLoC.instance.getConnectivityResult ==
                    ConnectivityResult.none
                    ? '网络链接不可用请重试'
                    : '没有相关转包数据',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )),
        ],
      );
    }else{
      return Column(
          children: widget.subcontractMineState.subcontractModelsByMap.map((model) {
            return _buildRow(model);
          }).toList());
    }
  }

  Widget _buildRow(dynamic model) {
    return Column(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => SubContractMineDetailPage(model.code,onCancle: () => onCancle(model.code),)));
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15.0),
            child: SubContractMineListItem(
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

  void onCancle(String code) async {
    String result =
    await SubContractRepositoryImpl().cancleSubContract(code);
//    if (result != null && result == 'success') {
//      //触发刷新
//      widget.subcontractMineState.clearMapData();
//    }
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




