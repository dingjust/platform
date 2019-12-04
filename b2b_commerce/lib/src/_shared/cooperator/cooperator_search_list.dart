import 'package:b2b_commerce/src/_shared/cooperator/cooperator_item.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CooperatorSearchList extends StatefulWidget {
  final CooperatorState cooperatorState;

  CooperatorSearchList({Key key, this.cooperatorState})
      : super(key: key);

  _CooperatorSearchListState createState() => _CooperatorSearchListState();
}

class _CooperatorSearchListState extends State<CooperatorSearchList>{
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
//
//    //监听滚动事件，打印滚动位置
//    _scrollController.addListener(() {
//      if (_scrollController.offset < 500) {
//        widget.cooperatorState.showTopBtn = false;
//      } else if (_scrollController.offset >= 500) {
//        widget.cooperatorState.showTopBtn = true;
//      }
//    });
//
//    //监听加载更多
//    _scrollController.addListener(() {
//      if (_scrollController.position.pixels ==
//          _scrollController.position.maxScrollExtent) {
//        widget.cooperatorState.loadMore();
//      }
//    });

    return Scaffold(
      body: RefreshIndicator(

        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            _buildItems(),
            ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
              opacity: widget.cooperatorState.loadingMore ? 1.0 : 0,
            ),
            _buildEnd(),
          ],
        ),
        onRefresh: () async {
          widget.cooperatorState.clear();
        },
      ),
      floatingActionButton: Opacity(
        opacity: widget.cooperatorState.showTopBtn ? 1 : 0,
        child: FloatingActionButton(
          child: Icon(
            Icons.arrow_upward,
            color: Colors.white,
          ),
          onPressed: () {
            _scrollController.animateTo(.0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildItems(){
    return Column(
      children: widget.cooperatorState.cooperatorModels != null ? widget.cooperatorState.cooperatorModels.map((cooperator){
        return CooperatorItem(model: cooperator);
      }).toList() : Center(
        child: CircularProgressIndicator(),
    )
    );
  }


  Widget _buildEnd() {
    return widget.cooperatorState.isEnd()
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