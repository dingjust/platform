import 'package:b2b_commerce/src/_shared/cooperator/cooperator_item.dart';
import 'package:b2b_commerce/src/_shared/cooperator/cooperator_selected_item.dart';
import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_item.dart';
import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_selected_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class PurchaseOrderSelectList extends StatefulWidget {
  final PurchaseOrderListState purchaseOrderState;
  List<PurchaseOrderModel> models;

  PurchaseOrderSelectList({Key key, this.purchaseOrderState,this.models}) : super(key: key);

  _PurchaseOrderSelectListState createState() => _PurchaseOrderSelectListState();
}

class _PurchaseOrderSelectListState extends State<PurchaseOrderSelectList> {
  ScrollController _scrollController = ScrollController();
  List<String> _selectCodes = List();

  @override
  void initState() {
    if(widget.models != null){
      _selectCodes = widget.models.map((model) => model.code).toList();
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        widget.purchaseOrderState.showTopBtn = false;
      } else if (_scrollController.offset >= 500) {
        widget.purchaseOrderState.showTopBtn = true;
      }
    });

    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.purchaseOrderState.loadMore();
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
                opacity: widget.purchaseOrderState.loadingMore ? 1.0 : 0,
              ),
              _buildEnd(),
            ],
          ),
        ),
        onRefresh: () async {
          widget.purchaseOrderState.clear();
        },
      ),
      floatingActionButton: Opacity(
        opacity: widget.purchaseOrderState.showTopBtn ? 1 : 0,
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
        children: widget.purchaseOrderState.purchaseOrderModels != null
            ? widget.purchaseOrderState.purchaseOrderModels.map((purchaseOrder) {
                return _selectCodes.contains(purchaseOrder.code) ? _buildSelectedRow(purchaseOrder) : _buildRow(purchaseOrder);
              }).toList()
            : Center(
                child: CircularProgressIndicator(),
              ));
  }

  Row _buildSelectedRow(PurchaseOrderModel purchaseOrderModel) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            if(_selectCodes.contains(purchaseOrderModel.code)){
                              widget.models.removeWhere((model) => model.code == purchaseOrderModel.code);
                              _selectCodes.remove(purchaseOrderModel.code);
                            }else{
                              widget.models.add(purchaseOrderModel);
                              _selectCodes.add(purchaseOrderModel.code);
                            }
                          });
                        },
                        child: PurchaseOrderSelectedItem(
                          order: purchaseOrderModel,
                        ),
                      ),
                    ),
                  ),
//                  IconButton(icon: Icon(Icons.check_circle,color: Color(0xffffd60c),), onPressed: () {}),
                ],
              );
  }
  Widget _buildRow(PurchaseOrderModel purchaseOrderModel) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: (){
          setState(() {
            if(_selectCodes.contains(purchaseOrderModel.code)){
              widget.models.removeWhere((model) => model.code == purchaseOrderModel.id);
              _selectCodes.remove(purchaseOrderModel.code);
            }else{
              widget.models.add(purchaseOrderModel);
              _selectCodes.add(purchaseOrderModel.code);
            }
          });
        },
        child: PurchaseOrderItem(
          order: purchaseOrderModel,
        ),
      ),
    );
  }

  Widget _buildEnd() {
    return widget.purchaseOrderState.isDownEnd
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
