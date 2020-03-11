import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ContractSingleSelectList extends StatefulWidget {
  ContractListState contractListState;
  ContractModel model;

  ContractSingleSelectList({this.contractListState,this.model});
  _ContractSingleSelectListState createState() => _ContractSingleSelectListState();
}

class _ContractSingleSelectListState extends State<ContractSingleSelectList>{
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        widget.contractListState.showTopBtn = false;
      } else if (_scrollController.offset >= 500) {
        widget.contractListState.showTopBtn = true;        
      }
    });

    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.contractListState.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body: RefreshIndicator(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSlivers(),
              SliverToBoxAdapter(
                child:  ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                  opacity: widget.contractListState.loadingMore ? 1.0 : 0,
                ),
              ),
              SliverToBoxAdapter(
                child: _buildEnd(),
              )
            ],
          ),
        ),
        onRefresh: () async {
          widget.contractListState.clear();
        },
      ),
      floatingActionButton: Opacity(
        opacity: widget.contractListState.showTopBtn ? 1 : 0,
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

  Widget _buildSlivers(){
    if (widget.contractListState.contractModels != null && widget.contractListState.contractModels.isNotEmpty) {

      return SliverPadding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        sliver: SliverGrid(
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              //纵轴间距
              mainAxisSpacing: 10.0,
              //横轴间距
              crossAxisSpacing: 0.0,
              //子组件宽高长度比例
              childAspectRatio: 0.95,
          ),
          delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: _buildItems(
                      context, widget.contractListState.contractModels[index]),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }, childCount: widget.contractListState.contractModels.length),
        ),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
      );
    }
  }

  Widget _buildItems(BuildContext context, ContractModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(model);
      },
      child: Stack(
        children: <Widget>[
          Offstage(
            offstage: widget.model == null || widget.model.code != model.code,
            child: Align(child: Icon(Icons.check),alignment: Alignment.topRight,),
          ),
          Column(
            children: <Widget>[
              Expanded(child: _buildItemImage(context,model),flex: 5,),
              Expanded(child: _buildItemTitle(context,model),flex: 1,),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildItemImage(BuildContext context,ContractModel model){
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Image.asset(
          'temp/word.png',
          package: 'assets',
          width: 140,
          height: 140,
          fit: BoxFit.fill,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ));
  }

  Widget _buildItemTitle(BuildContext context,ContractModel model){
    return Container(
      height: 35,
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
      alignment: Alignment.centerLeft,
      child: Center(
        child: Text(
          '${model.title == null? '':model.title}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  Widget _buildEnd() {
    return widget.contractListState.isDownEnd
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