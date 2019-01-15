import 'package:b2b_commerce/src/business/orders/provider/purchase_order_bloc_provider.dart';
import 'package:b2b_commerce/src/business/orders/purchase_detail.dart';
import 'package:b2b_commerce/src/business/search/purchase_order_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

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
    return PurchaseOrderBlocProvider(
        child:Scaffold(
      appBar: AppBar(
        title: Text('采购订单'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: PurchaseOrderSearchDelegate()),
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
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
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
    ));
  }
}

class PurchaseOrderList extends StatelessWidget{
  final EnumModel status;

  ScrollController _scrollController = new ScrollController();

  PurchaseOrderList(this.status);

  @override
  Widget build(BuildContext context) {
    final bloc = PurchaseOrderBlocProvider.of(context);

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
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
          ],
        ));
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
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchaseDetailPage(order: order),
          ),
        );
      },
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child:Column(
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
                    )
                ),
                Text(
                  PurchaseOrderStatusLocalizedMap[order.status],
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.green
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  '创建时间：' + order.creationTime.toString(),
                  style: TextStyle(
                      fontSize: 14
                  ),
                )
              ],
            )
          ],
        )
    );
  }

  List<Widget> _buildContent(BuildContext context){
    return order.entries.map((entry) {
      return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Image.network(
                entry.product.thumbnail,
                width: 110,
                height: 110,
                fit: BoxFit.fill,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child:
                        Text(
                          entry.product.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:FontWeight.w500
                          ),
                        )
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child:
                        Text(
                          '货号：' + entry.product.skuID,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight:FontWeight.w500
                          ),
                        )
                      )
                    ],
                  )
                )
              )
            ],
          )
      );
    }).toList();
  }


  Widget _buildOrderBottom(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '共'+order.totalQuantity.toString()+'件商品   合计： ￥'+ order.totalPrice.toString(),
            style: TextStyle(
              fontSize: 16,
              color: Colors.red
            ),
          ),
        )
      ],
    );
  }

}

