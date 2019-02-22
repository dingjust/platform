import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/business/search/purchase_order_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('WAIT_FOR_PROCESSING', '待处理'),
  EnumModel('PENDING_APPROVAL', '待确认'),
  EnumModel('IN_PRODUCTION', '生产中'),
  EnumModel('OUT_OF_STORE', '已出库'),
  EnumModel('COMPLETED', '已完成'),
];

class PurchaseOrdersPage extends StatefulWidget {
  _PurchaseOrdersPageState createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends State<PurchaseOrdersPage> {
  @override
  Widget build(BuildContext context) {
    return BLoCProvider<PurchaseOrderBLoC>(
        bloc: PurchaseOrderBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text('采购订单'),
            actions: <Widget>[
              IconButton(
                icon: Icon(B2BIcons.search,size: 20,),
                onPressed: () => showSearch(
                    context: context, delegate: PurchaseOrderSearchDelegate()),
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
                children: <Widget>[
                  PurchaseOrderList(statuses[0]),
                  PurchaseOrderList(statuses[1]),
                  PurchaseOrderList(statuses[2]),
                  PurchaseOrderList(statuses[3]),
                  PurchaseOrderList(statuses[4]),
                  PurchaseOrderList(statuses[5]),
                ],
              ),
            ),
          ),
          floatingActionButton: ToTopBtn(),
        ));
  }
}

class PurchaseOrderList extends StatelessWidget {
  final EnumModel status;

  ScrollController _scrollController = new ScrollController();

  PurchaseOrderList(this.status);

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);

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

    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RefreshIndicator(
            onRefresh: () async {
              return await bloc.refreshData(status.code);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              children: <Widget>[
                StreamBuilder<List<PurchaseOrderModel>>(
                  stream: bloc.stream,
                  initialData: null,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PurchaseOrderModel>> snapshot) {
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
                          return PurchaseOrderItem(
                            order,
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  },
                ),
                StreamBuilder<bool>(
                  stream: bloc.bottomStream,
                  initialData: false,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.data) {
                      _scrollController.animateTo(_scrollController.offset - 70,
                          duration: new Duration(milliseconds: 500),
                          curve: Curves.easeOut);
                    }
                    return snapshot.data
                        ? Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                            child: Center(
                              child: Text(
                                "人家可是有底线的。。。",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : Container();
                  },
                ),
                StreamBuilder<bool>(
                  stream: bloc.loadingStream,
                  initialData: false,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
              ],
            )));
  }
}

class PurchaseOrderItem extends StatelessWidget {
  final PurchaseOrderModel order;

  PurchaseOrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: EdgeInsets.fromLTRB(0, 0, 5, 10),
        child: Column(
          children: <Widget>[
            _buildOrderHeader(context),
            Column(
              children: _buildContent(context),
            ),
            _buildOrderBottom(context),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseOrderDetailPage(order: order),
          ),
        );
      },
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  '采购订单号：' + order.code,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
                Text(
                  PurchaseOrderStatusLocalizedMap[order.status],
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 18, color: Colors.green),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  '创建时间：${DateFormatUtil.formatYMD(order.creationTime)}',
                  style: TextStyle(fontSize: 14),
                )
              ],
            )
          ],
        ));
  }

  List<Widget> _buildContent(BuildContext context) {
    return order.entries.map((entry) {
      return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(entry.product.thumbnail),
                      fit: BoxFit.cover,
                    )),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.all(5),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                entry.product.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              )),
                          Align(
                              alignment: Alignment.topLeft,
                              // child: Text(
                              //   '货号：' + entry.product.skuID,
                              //   style: TextStyle(
                              //       fontSize: 14, fontWeight: FontWeight.w500),
                              // ))
                              child: Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  '货号：' + entry.product.skuID,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ))
                        ],
                      )))
            ],
          ));
    }).toList();
  }

  Widget _buildOrderBottom(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '共' +
                order.totalQuantity.toString() +
                '件商品   合计： ￥' +
                order.totalPrice.toString(),
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        )
      ],
    );
  }
}

class ToTopBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);

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
