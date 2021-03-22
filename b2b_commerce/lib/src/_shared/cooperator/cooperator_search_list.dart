import 'package:b2b_commerce/src/_shared/cooperator/cooperator_item.dart';
import 'package:b2b_commerce/src/_shared/cooperator/cooperator_selected_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CooperatorSearchList extends StatefulWidget {
  final CooperatorState cooperatorState;
  List<CooperatorModel> models;

  CooperatorSearchList({Key key, this.cooperatorState, this.models})
      : super(key: key);

  _CooperatorSearchListState createState() => _CooperatorSearchListState();
}

class _CooperatorSearchListState extends State<CooperatorSearchList> {
  ScrollController _scrollController = ScrollController();
  List<int> _selectIds = List();

  @override
  void initState() {
    if (widget.models != null) {
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
        widget.cooperatorState.showTopBtn = false;
      } else if (_scrollController.offset >= 500) {
        widget.cooperatorState.showTopBtn = true;
      }
    });

    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.cooperatorState.loadMore();
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
                opacity: widget.cooperatorState.loadingMore ? 1.0 : 0,
              ),
              _buildEnd(),
            ],
          ),
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

  Widget _buildItems() {
    return Column(
        children: widget.cooperatorState.cooperatorModels != null
            ? widget.cooperatorState.cooperatorModels.map((cooperator) {
                return _selectIds.contains(cooperator.id)
                    ? _buildSelectedRow(cooperator)
                    : _buildRow(cooperator);
              }).toList()
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Row _buildSelectedRow(CooperatorModel cooperator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (_selectIds.contains(cooperator.id)) {
                    widget.models
                        .removeWhere((model) => model.id == cooperator.id);
                    _selectIds.remove(cooperator.id);
                  } else {
                    widget.models.add(cooperator);
                    _selectIds.add(cooperator.id);
                  }
                });
              },
              child: CooperatorSelectedItem(
                model: cooperator,
              ),
            ),
          ),
        ),
//                  IconButton(icon: Icon(Icons.check_circle,color: Color(0xffffd60c),), onPressed: () {}),
      ],
    );
  }

  Widget _buildRow(CooperatorModel cooperator) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: CooperatorItem(
        model: cooperator,
        onTap: () {
          setState(() {
            if (_selectIds.contains(cooperator.id)) {
              widget.models.removeWhere((model) => model.id == cooperator.id);
              _selectIds.remove(cooperator.id);
            } else {
              widget.models.add(cooperator);
              _selectIds.add(cooperator.id);
            }
          });
        },
      ),
    );
  }

  Widget _buildEnd() {
    return widget.cooperatorState.isDownEnd
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
