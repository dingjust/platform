import 'package:b2b_commerce/src/business/search/sales_order_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'orders/sales_order_detail.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_PAYMENT', '待付款'),
  EnumModel('PENDING_DELIVERY', '待发货'),
  EnumModel('SHIPPED', '已发货'),
  EnumModel('COMPLETED', '已完成'),
];

class SalesOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BLoCProvider<SalesOrderBLoC>(
      bloc: SalesOrderBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: Text('销售订单'),
          actions: <Widget>[
            IconButton(
              icon: Icon(B2BIcons.search,size: 20,),
              onPressed: () => showSearch(
                  context: context, delegate: SalesOrderSearchDelegate()),
            ),
          ],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabBar(
              unselectedLabelColor: Colors.black26,
              labelColor: Colors.black38,
              tabs: statuses.map((status) {
                return Tab(text: status.name);
              }).toList(),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black),
              isScrollable: true,
            ),
            body: TabBarView(
              children: statuses
                  .map((status) => SalesOrderList(
                        status: status,
                      ))
                  .toList(),
            ),
          ),
        ),
        floatingActionButton: _ToTopBtn(),
      ),
    );
  }
}

class SalesOrderList extends StatelessWidget {
  SalesOrderList({Key key, this.status}) : super(key: key);

  final EnumModel status;

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<SalesOrderBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses(status.code);
      }
    });

    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (_scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        _scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return RefreshIndicator(
      onRefresh: () async {
        return await bloc.refreshData(status.code);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        children: <Widget>[
          StreamBuilder<List<SalesOrderModel>>(
            stream: bloc.stream,
            initialData: null,
            builder: (BuildContext context,
                AsyncSnapshot<List<SalesOrderModel>> snapshot) {
              if (snapshot.data == null) {
                bloc.filterByStatuses(status.code);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 200),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.map((order) {
                    return SalesOrderItem(order);
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            },
          ),
          StreamBuilder<bool>(
            stream: bloc.loadingStream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Center(
                  child: new Opacity(
                    opacity: snapshot.data ? 1.0 : 0,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          ),
          StreamBuilder<bool>(
            stream: bloc.bottomStream,
            initialData: false,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              return snapshot.data
                  ? Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Center(
                        child: Text(
                          "┑(￣Д ￣)┍ 已经到底了",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : Container();
            },
          )
        ],
      ),
    );
  }
}

class SalesOrderItem extends StatelessWidget {
  final SalesOrderModel order;

  SalesOrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context),
          Column(
            children: _buildEntries(context),
          ),
          _buildSummary(context),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Color(0xFFFFFFFF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '销售订单号：${order.code}',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                SalesOrderStatusLocalizedMap[order.status],
                style: TextStyle(color: Color(0xFF56C275), fontSize: 16.0),
              )
            ],
          ),
          Text(
            '订单创建时间：${order.creationTime}',
            style: TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEntries(BuildContext context) {
    return order.entries.map((entry) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SaleOrderDetail(),
            ),
          );
        },
        child: Container(
          color: Color(0xFFFAFAFA),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("${entry.product.thumbnail}"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 0, 0),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${entry.product.name}',
                        style:
                            TextStyle(fontSize: 16.0, color: Color(0xFF323232)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                        child: Text(
                          '货号：${entry.product.skuID}',
                          style: TextStyle(
                              fontSize: 14.0, color: Color(0xFF969696)),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildSummary(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '共${order.totalQuantity}件商品，合计：${order.totalPrice}',
          style: TextStyle(color: Color(0xFFFF4444), fontSize: 16.0),
        ),
        RaisedButton(
          child: Text('支付',style: TextStyle(color: Colors.white),),
          color: Colors.blue,
          onPressed: () {
            WechatServiceImpl.instance.pay(order.code);
          },
        )
      ],
    );
  }
}

class _ToTopBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<SalesOrderBLoC>(context);

    return StreamBuilder<bool>(
        stream: bloc.toTopBtnStream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return snapshot.data
              ? FloatingActionButton(
                  child: Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    bloc.returnToTop();
                  },
                  backgroundColor: Colors.blue,
                )
              : Container();
        });
  }
}
