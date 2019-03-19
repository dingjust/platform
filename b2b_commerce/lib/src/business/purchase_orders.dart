import 'package:b2b_commerce/src/business/orders/purchase_order_detail.dart';
import 'package:b2b_commerce/src/business/search/purchase_order_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_PAYMENT', '待付款'),
  EnumModel('IN_PRODUCTION', '生产中'),
  EnumModel('WAIT_FOR_OUT_OF_STORE', '待出库'),
  EnumModel('OUT_OF_STORE', '已出库'),
  EnumModel('COMPLETED', '已完成'),
  EnumModel('CANCELLED','已取消'),
];

class PurchaseOrdersPage extends StatefulWidget {
  _PurchaseOrdersPageState createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends State<PurchaseOrdersPage> {
  String showText;
  String statusColor;

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<PurchaseOrderBLoC>(
        bloc: PurchaseOrderBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text('生产订单'),
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
                children: statuses
                    .map((status) => PurchaseOrderList(
                  status: status,
                )).toList(),
              ),
            ),
          ),
          floatingActionButton: ToTopBtn(),
        ));
  }

  @override
  void initState() {

    super.initState();
  }
}

class PurchaseOrderList extends StatelessWidget {
  PurchaseOrderList({Key key, this.status}) : super(key: key);

  final EnumModel status;

  ScrollController _scrollController = new ScrollController();


  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);

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
                  // initialData: null,
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
                            order: order,
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
  const PurchaseOrderItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;

  static Map<PurchaseOrderStatus, MaterialColor> _statusColors = {
    PurchaseOrderStatus.PENDING_PAYMENT: Colors.red,
    PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: Colors.yellow,
    PurchaseOrderStatus.OUT_OF_STORE: Colors.yellow,
    PurchaseOrderStatus.IN_PRODUCTION: Colors.yellow,
    PurchaseOrderStatus.COMPLETED: Colors.green,
    PurchaseOrderStatus.CANCELLED: Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: EdgeInsets.fromLTRB(0, 0, 5, 10),
        child: Column(
          children: <Widget>[
            _buildOrderHeader(context),
            _buildContent(context),
            order.balancePaid == false|| order.depositPaid == false?
            _buildPaymentButton(context):
            _buildOrderBottom(context),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        //根据code查询明
        PurchaseOrderModel model = await PurchaseOrderRepository().getPurchaseOrderDetail(order.code);

        if (model != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PurchaseOrderDetailPage(
                order: model,
              ))
          );
        }
      },
    );
  }

  Widget _buildOrderHeader(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                order.balancePaid == false || order.depositPaid == false ?
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '￥',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${order.balancePaid == false ? order.deposit : order.balance}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ):
                Container(
                  child: Text(
                    '已延期',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      fontWeight: FontWeight.w500,
                    )
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: order.status == null ? Container() :
                    Text(
                      order.status == PurchaseOrderStatus.PENDING_PAYMENT ||
                          order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE ?
                      '${order.balancePaid == false
                          ? '（待付尾款）'
                          : '（待付定金）'}':'${PurchaseOrderStatusLocalizedMap[order.status]}',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ),
                order.status == null ? Container() :
                Text(
                  '${PurchaseOrderStatusLocalizedMap[order.status]}',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontSize: 18,
                      color:  _statusColors[order.status],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      '${order.belongTo == null ? order.companyOfSeller : order
                          .belongTo.name}',
                      style: TextStyle(
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
                Text(
                  '${order.salesApplication == null ? '' : SalesApplicationLocalizedMap[order.salesApplication]}',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 16),
                )
              ],
            )
          ],
        ));
  }

  Widget _buildContent(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10,0,10,0),
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image:  order.product == null ||  order.product.thumbnail == null?
                    AssetImage(
                      'temp/picture.png',
                      package: "assets",
                    ):
                    NetworkImage('${order.product.thumbnail.url}'),
                    fit: BoxFit.cover,
                  )),
            ),
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: order.product == null || order.product.name == null?
                            Container():
                            Text(
                              '${order.product.name}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                '货号：${order.product == null ? '' : order.product.skuID}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            )),
                        order.product == null || order.product.superCategories == null?
                        Container() :
                        Container(
                            padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 243, 243, 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "${order.product.superCategories.name} ${order.totalQuantity==null?'':order.totalQuantity}件",
                            style: TextStyle(
                                fontSize: 15,
                                color: Color.fromRGBO(255, 133, 148, 1)),
                          ),
                        )
                      ],
                    )))
          ],
        ));
  }

  Widget _buildOrderBottom(BuildContext context) {
    return order.status == PurchaseOrderStatus.OUT_OF_STORE?_buildLogisticsButton(context):Container();

  }

  Widget _buildPaymentButton(BuildContext context){
    return Container(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.only(right: 30),
            width: 150,
            child: FlatButton(
                color: Color(0xFFFFD600),
                child: Text(
                  '去支付',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(20))),
                onPressed: () {}
            ),
          ),
        )
    );
  }


  Widget _buildLogisticsButton(BuildContext context){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            width: 150,
            child: FlatButton(
                color: Colors.white,
                child: Text(
                  '查看物流',
                  style: TextStyle(
                    color: Color(0xFF969696),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(
                        color: Color(0xFF969696),
                        style: BorderStyle.solid,
                        width: 2)),
                clipBehavior: Clip.antiAlias,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                onPressed: () {}
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            width: 150,
            child: FlatButton(
                color: Colors.white,
                child: Text(
                  '确认收货',
                  style: TextStyle(
                    color: Color(0xFFFFD600),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(
                      color: Color(0xFFFFD600),
                      style: BorderStyle.solid,
                      width: 2),
                ),
                onPressed: () {}
            ),
          ),
        ],
      ),
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
