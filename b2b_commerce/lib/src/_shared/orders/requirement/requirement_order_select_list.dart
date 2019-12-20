import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_no_selected_list_item.dart';
import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class RequirementOrderSelectList extends StatefulWidget {
  final RequirementOrderSelectState requirementSelectState;
  List<RequirementOrderModel> models;

  RequirementOrderSelectList({Key key, this.requirementSelectState,this.models}) : super(key: key);

  _RequirementOrderSelectListState createState() => _RequirementOrderSelectListState();
}

class _RequirementOrderSelectListState extends State<RequirementOrderSelectList> {
  ScrollController _scrollController = ScrollController();
  List<int> _selectIds = List();

  @override
  void initState() {
    if(widget.models != null){
      _selectIds = widget.models.map((model) => model.id).toList();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        widget.requirementSelectState.showTopBtn = false;
      } else if (_scrollController.offset >= 500) {
        widget.requirementSelectState.showTopBtn = true;
      }
    });

    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.requirementSelectState.loadMore();
      }
    });

    return Scaffold(
      body: RefreshIndicator(
        child: Container(
          color: Colors.grey[100],
          child: ListView(
            physics: AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              _buildItems(),
              ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                opacity: widget.requirementSelectState.loadingMore ? 1.0 : 0,
              ),
              _buildEnd(),
            ],
          ),
        ),
        onRefresh: () async {
          widget.requirementSelectState.clear();
        },
      ),
      floatingActionButton: Opacity(
        opacity: widget.requirementSelectState.showTopBtn ? 1 : 0,
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

  Widget _buildItems() {
    return Column(
        children: widget.requirementSelectState.requiremenOrderModels != null
            ? widget.requirementSelectState.requiremenOrderModels.map((cooperator) {
                return _selectIds.contains(cooperator.id) ? _buildSelectedRow(cooperator) : _buildRow(cooperator);
              }).toList()
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Row _buildSelectedRow(RequirementOrderModel requirementModel) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            if(_selectIds.contains(requirementModel.id)){
                              widget.models.removeWhere((model) => model.id == requirementModel.id);
                              _selectIds.remove(requirementModel.id);
                            }else{
                              widget.models.add(requirementModel);
                              _selectIds.add(requirementModel.id);
                            }
                          });
                        },
                        child: RequirementOrderSelectedListItem(
                          model: requirementModel,
                        ),
                      ),
                    ),
                  ),
//                  IconButton(icon: Icon(Icons.check_circle,color: Color(0xffffd60c),), onPressed: () {}),
                ],
              );
  }
  Widget _buildRow(RequirementOrderModel requirementModel) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: (){
          setState(() {
            if(_selectIds.contains(requirementModel.id)){
              widget.models.removeWhere((model) => model.id == requirementModel.id);
              _selectIds.remove(requirementModel.id);
            }else{
              widget.models.add(requirementModel);
              _selectIds.add(requirementModel.id);
            }
          });
        },
        child: RequirementOrderNoSelectedListItem(
          model: requirementModel,
        ),
      ),
    );
  }

  Widget _buildEnd() {
    return widget.requirementSelectState.isDownEnd
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
