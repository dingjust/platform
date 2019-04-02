import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/app_bar_factory.dart';
import '../_shared/widgets/scroll_to_top_button.dart';
import '../_shared/widgets/scrolled_to_end_tips.dart';
import '../_shared/widgets/tab_factory.dart';
import '../business/orders/purchase_order_detail.dart';
import '../common/logistics_input_page.dart';
import '../my/my_addresses.dart';
import '../production/production_search.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_PAYMENT', '待付款'),
  EnumModel('IN_PRODUCTION', '生产中'),
  EnumModel('WAIT_FOR_OUT_OF_STORE', '待出库'),
  EnumModel('OUT_OF_STORE', '已出库'),
];

class PurchaseOrdersPage extends StatefulWidget {
  _PurchaseOrdersPageState createState() => _PurchaseOrdersPageState();
}

class _PurchaseOrdersPageState extends State<PurchaseOrdersPage> with AutomaticKeepAliveClientMixin {
  String showText;
  String statusColor;
  String userType;

  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      icon: const Icon(B2BIcons.search, size: 20),
      onPressed: () => showSearch(context: context, delegate: ProductionSearchDelegate()),
    );
  }

  @override
  void initState() {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    if (bloc.isBrandUser) {
      userType = 'brand';
    } else {
      userType = 'factory';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<PurchaseOrderBLoC>(
      bloc: PurchaseOrderBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '生产订单',
          actions: <Widget>[_buildSearchButton(context)],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(statuses, scrollable: true),
            body: TabBarView(
              children: statuses.map((status) => PurchaseOrderList(status: status)).toList(),
            ),
          ),
        ),
        floatingActionButton: ScrollToTopButton<PurchaseOrderBLoC>(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class PurchaseOrderList extends StatefulWidget {
  final EnumModel status;

  PurchaseOrderList({Key key, this.status});

  _PurchaseOrderListState createState() => _PurchaseOrderListState();
}

class _PurchaseOrderListState extends State<PurchaseOrderList> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses(widget.status.code);
      }
    });

    // 监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (_scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    // 状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      // 返回到顶部时执行动画
      if (data) {
        _scrollController.animateTo(.0, duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: RefreshIndicator(
        onRefresh: () async {
          return await bloc.refreshData(widget.status.code);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          children: <Widget>[
            StreamBuilder<List<PurchaseOrderModel>>(
              stream: bloc.stream,
              // initialData: null,
              builder: (BuildContext context, AsyncSnapshot<List<PurchaseOrderModel>> snapshot) {
                if (snapshot.data == null) {
                  bloc.filterByStatuses(widget.status.code);
                  return ProgressIndicatorFactory.buildPaddedProgressIndicator();
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
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.data) {
                  _scrollController.animateTo(_scrollController.offset - 70,
                      duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                }
                return ScrolledToEndTips(hasContent: snapshot.data);
              },
            ),
            StreamBuilder<bool>(
              stream: bloc.loadingStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                  opacity: snapshot.data ? 1.0 : 0,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}

class PurchaseOrderItem extends StatefulWidget {
  PurchaseOrderItem({Key key, this.order}) : super(key: key);

  final PurchaseOrderModel order;

  _PurchaseOrderItemState createState() => _PurchaseOrderItemState();
}

class _PurchaseOrderItemState extends State<PurchaseOrderItem> with AutomaticKeepAliveClientMixin {
  static Map<PurchaseOrderStatus, Color> _statusColors = {
    PurchaseOrderStatus.PENDING_PAYMENT: Colors.red,
    PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE: Color(0xFFFFD600),
    PurchaseOrderStatus.OUT_OF_STORE: Color(0xFFFFD600),
    PurchaseOrderStatus.IN_PRODUCTION: Color(0xFFFFD600),
    PurchaseOrderStatus.COMPLETED: Colors.green,
    PurchaseOrderStatus.CANCELLED: Colors.grey,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BLoCProvider.of<UserBLoC>(context);
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
        child: Column(
          children: <Widget>[
            _buildHeader(context),
            _buildContent(context),
            bloc.isBrandUser ? _buildBrandButton(context) : _buildFactoryButton(context),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onTap: () async {
        //根据code查询
        PurchaseOrderModel model = await PurchaseOrderRepository().getPurchaseOrderDetail(widget.order.code);

        if (model != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PurchaseOrderDetailPage(order: model)),
          );
        }
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              (widget.order.salesApplication == SalesApplication.ONLINE &&
                          widget.order.depositPaid == false && widget.order.deposit != null && widget.order.deposit != 0 &&
                          widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT) ||
                      (widget.order.salesApplication == SalesApplication.ONLINE &&
                          widget.order.balancePaid == false && widget.order.balance != null && widget.order.balance != 0 &&
                          widget.order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE)
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '￥',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${widget.order.salesApplication == SalesApplication.ONLINE && widget.order.depositPaid == false && widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT ? widget.order.deposit == null ? '' : widget.order.deposit : widget.order.balance == null ? '' : widget.order.balance}',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildHeaderText(context),
                      ],
                    )
                  : Container(
                      child: widget.order.delayed
                          ? Text('已延期',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ))
                          : Container()),
              widget.order.status == null
                  ? Container()
                  : Expanded(
                      flex: 3,
                      child: Container(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${PurchaseOrderStatusLocalizedMap[widget.order.status]}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 18,
                              color: _statusColors[widget.order.status],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Text(
                    '${widget.order.belongTo == null ? widget.order.companyOfSeller : widget.order.belongTo.name}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Text(
                '${widget.order.salesApplication == null ? '' : SalesApplicationLocalizedMap[widget.order.salesApplication]}',
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 16),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeaderText(BuildContext context) {
    if (widget.order.salesApplication == SalesApplication.ONLINE &&
        widget.order.depositPaid == false && (widget.order.deposit != null || widget.order.deposit > 0) &&
        widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT) {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        color: const Color.fromRGBO(255, 243, 243, 1),
        child: Text(
          '待付定金',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else if (widget.order.salesApplication == SalesApplication.ONLINE &&
        widget.order.balancePaid == false && (widget.order.balance != null || widget.order.balance > 0 )&&
        widget.order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      return Container(
        margin: const EdgeInsets.only(left: 5),
        color: const Color.fromRGBO(255, 243, 243, 1),
        child: Text(
          '待付尾款',
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }else{
      return Container();
    }
  }

  Widget _buildContent(BuildContext context) {
    //计算总数
    int sum = 0;
    widget.order.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: widget.order.product == null || widget.order.product.thumbnail == null
                      ? AssetImage(
                          'temp/picture.png',
                          package: "assets",
                        )
                      : NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${widget.order.product.thumbnail.url}'),
                  fit: BoxFit.cover,
                )),
          ),
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: widget.order.product == null || widget.order.product.name == null
                            ? Container()
                            : Text(
                                '${widget.order.product.name}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            '货号：${widget.order.product == null ? '' : widget.order.product.skuID}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                      widget.order.product == null || widget.order.product.category == null
                          ? Container()
                          : Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 243, 243, 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${widget.order.product.category.name}  $sum件",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: const Color.fromRGBO(255, 133, 148, 1),
                                ),
                              ),
                            )
                    ],
                  )))
        ],
      ),
    );
  }

  Widget _buildBrandButton(BuildContext context) {
    if (widget.order.salesApplication == SalesApplication.ONLINE) {
      if (widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT) {
        if (widget.order.depositPaid == false && widget.order.deposit != null && widget.order.deposit > 0) {
          return Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Container(
                      width: 100,
                      margin: const EdgeInsets.fromLTRB(45, 0, 30, 0),
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT
                          ? RaisedButton(
                              color: Colors.red,
                              child: Text(
                                '取消订单',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              shape: const RoundedRectangleBorder(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              onPressed: () async {
                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: true, // user must tap button!
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        '提示',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      content: Text('是否要取消订单？'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            '取消',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(
                                            '确定',
                                            style: TextStyle(color: Colors.black),
                                          ),
                                          onPressed: () async {
                                            bool result = await PurchaseOrderRepository()
                                                .purchaseOrderCancelling(widget.order.code);
                                            _showMessage(context, result, '订单取消');
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              })
                          : Container()),
                ),
                Expanded(
                  child: Container(
                      width: 100,
                      padding: const EdgeInsets.fromLTRB(45, 0, 20, 0),
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                          color: Color(0xFFFFD600),
                          child: Text(
                            '去支付',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              // user must tap button!
                              builder: (context) {
                                return widget.order.deliveryAddress == null
                                    ? SimpleDialog(
                                        title: const Text(
                                          '提示',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        children: <Widget>[
                                          SimpleDialogOption(
                                            child: const Text('送货地址为空，请先添加'),
                                          ),
                                        ],
                                      )
                                    : AlertDialog(
                                        title: Text('您的当前收货地址为：'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              GestureDetector(
                                                child: ListTile(
                                                  title: Text(
                                                    '${widget.order.deliveryAddress.fullname == null ? '' : widget.order.deliveryAddress.fullname}  '
                                                        '${widget.order.deliveryAddress.cellphone == null ? '' : widget.order.deliveryAddress.cellphone}',
                                                  ),
                                                  subtitle: Text(
                                                    '${widget.order.deliveryAddress == null ? '' : widget.order.deliveryAddress.region.name} ${widget.order.deliveryAddress.city.name} '
                                                        '${widget.order.deliveryAddress.cityDistrict.name} ${widget.order.deliveryAddress.line1}',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontSize: 16),
                                                  ),
                                                  trailing: const Icon(Icons.keyboard_arrow_right),
                                                ),
                                                onTap: () async {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => MyAddressesPage(isJumpSource: true),
                                                    ),
                                                    //接收返回数据并处理
                                                  ).then((value) async {
                                                    if (value != null) {
                                                      widget.order.deliveryAddress = value;
                                                      bool result = await PurchaseOrderRepository()
                                                          .updateAddress(widget.order.code, widget.order);
                                                      Navigator.of(context).pop();
                                                      _showMessage(context, result, '地址修改');
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              margin: const EdgeInsets.all(10),
                                              width: 100,
                                              child: RaisedButton(
                                                child: const Text("不，在看看"),
                                                textTheme: ButtonTextTheme.normal,
                                                textColor: const Color(0xFFFFD600),
                                                color: Colors.white,
                                                // 主题
                                                // RaisedButton 才起效
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                  side: const BorderSide(
                                                    color: const Color(0xFFFFD600),
                                                    style: BorderStyle.solid,
                                                    width: 1,
                                                  ),
                                                ),
                                                materialTapTargetSize: MaterialTapTargetSize.padded,
                                                animationDuration: const Duration(seconds: 1),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ),
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                margin: const EdgeInsets.all(10),
                                                width: 100,
                                                child: RaisedButton(
                                                    child: const Text("是"),
                                                    textTheme: ButtonTextTheme.normal,
                                                    textColor: Colors.black,
                                                    color: const Color(0xFFFFD600),
                                                    // 主题
                                                    // RaisedButton 才起效
                                                    shape: const RoundedRectangleBorder(
                                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                    ),
                                                    materialTapTargetSize: MaterialTapTargetSize.padded,
                                                    animationDuration: const Duration(seconds: 1),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    }),
                                              ))
                                        ],
                                      );
                              },
                            );
                          })),
                ),
              ],
            ),
          );
        } else {
          return Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.only(right: 30),
                width: 150,
                child: FlatButton(
                  color: Color(0xFFFFD600),
                  child: const Text(
                    '确认',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                  onPressed: () async {
                    bool result = await PurchaseOrderRepository().confirmProduction(widget.order.code, widget.order);
                    _showMessage(context, result, '确认生产');
                  },
                ),
              ),
            ),
          );
        }
      }
      //支付尾款
      else if (widget.order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
        if (widget.order.balancePaid == false && widget.order.balance != null && widget.order.balance > 0) {
          return Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.only(right: 30),
                width: 150,
                child: FlatButton(
                  color: const Color(0xFFFFD600),
                  child: const Text(
                    '去支付',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                  onPressed: (){

                  },
                ),
              ),
            ),
          );
        }
      }
      //确认收货
      if (widget.order.status == PurchaseOrderStatus.OUT_OF_STORE) {
        return Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.only(right: 30),
              width: 150,
              child: FlatButton(
                color: const Color(0xFFFFD600),
                child: const Text(
                  '确认收货',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                onPressed: () async {
                  bool result = false;
                  result = await PurchaseOrderRepository().purchaseOrderShipped(widget.order.code, widget.order);
                  _showMessage(context, result, '确认收货');
                },
              ),
            ),
          ),
        );
      }
    }else{
      //确认收货
      if (widget.order.status == PurchaseOrderStatus.OUT_OF_STORE) {
        return Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.only(right: 30),
              width: 150,
              child: FlatButton(
                color: const Color(0xFFFFD600),
                child: const Text(
                  '确认收货',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                onPressed: () async {
                  bool result = false;
                  result = await PurchaseOrderRepository().purchaseOrderShipped(widget.order.code, widget.order);
                  _showMessage(context, result, '确认收货');
                },
              ),
            ),
          ),
        );
      }
    }

    return Container();
  }

  Widget _buildFactoryButton(BuildContext context) {
    //流程是待付款状态并定金未付的情况下能修改订单金额
    if (widget.order.status == PurchaseOrderStatus.PENDING_PAYMENT && widget.order.depositPaid == false) {
      return Container(
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: const EdgeInsets.only(right: 30),
            width: 150,
            child: FlatButton(
                color: Colors.red,
                child: const Text(
                  '修改金额',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  _showDepositDialog(context, widget.order);
                }),
          ),
        ),
      );
    }
    //流程是生产中时，显示验货完成按钮
//   else if(order.status == PurchaseOrderStatus.IN_PRODUCTION && order.currentPhase == ProductionProgressPhase.INSPECTION){
//       return Container(
//         child: Align(
//           alignment: Alignment.bottomRight,
//           child: Container(
//             padding: EdgeInsets.only(right: 30),
//             width: 150,
//             child: FlatButton(
//                 color: Color(0xFFFFD600),
//                 child: Text(
//                   '验货完成',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                   ),
//                 ),
//                 shape: RoundedRectangleBorder(
//                     borderRadius:
//                     BorderRadius.all(Radius.circular(20))),
//                 onPressed: () {
//                   _showBalanceDialog(context, order);
//                 }
//             ),
//           ),
//         )
//     );
//   }
    //当流程是待出库状态下

    else if (widget.order.status == PurchaseOrderStatus.WAIT_FOR_OUT_OF_STORE) {
      //尾款已付时，出现确认发货
      if (widget.order.balancePaid ||  widget.order.balance == 0 || widget.order.salesApplication == SalesApplication.BELOW_THE_LINE) {
        return Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.only(right: 30),
              width: 150,
              child: FlatButton(
                color: const Color(0xFFFFD600),
                child: const Text(
                  '确认发货',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LogisticsInputPage(isProductionOrder: true, purchaseOrderModel: widget.order),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      } else if (widget.order.salesApplication == SalesApplication.ONLINE && !widget.order.balancePaid) {
        //未付尾款时可以修改金额
        return Container(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.only(right: 20),
              width: 150,
              child: FlatButton(
                color: Colors.red,
                child: const Text(
                  '修改金额',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                onPressed: () {
                  _showBalanceDialog(context, widget.order);
                },
              ),
            ),
          ),
        );
      }
    }
    //当流程是已出库时，可以查看物流
    else if (widget.order.status == PurchaseOrderStatus.OUT_OF_STORE) {
      return Container(
//          child: Align(
//            alignment: Alignment.bottomRight,
//            child: Container(
//              padding: EdgeInsets.only(right: 30),
//              width: 150,
//              child: FlatButton(
//                  color: Color(0xFFFFD600),
//                  child: Text(
//                    '查看物流',
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontWeight: FontWeight.w500,
//                      fontSize: 18,
//                    ),
//                  ),
//                  shape: RoundedRectangleBorder(
//                      borderRadius:
//                      BorderRadius.all(Radius.circular(20))),
//                  onPressed: () {
//                    //todo 接通查看物流信息页面
//                  }
//              ),
//            ),
//          )
          );
    }

    return Container();
  }

  //修改金额按钮方法
  Future<void> _neverUpdateBalance(BuildContext context, PurchaseOrderModel model) async {
    TextEditingController dialogText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text('提示', style: const TextStyle(fontSize: 16)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '订单总额：￥${model.totalPrice}',
                ),
                Text(
                  '已付定金：￥${model.deposit}',
                ),
                Text(
                  '应付尾款：￥${model.totalPrice != null && model.deposit != null ? model.totalPrice - model.deposit : ''}',
                  style: const TextStyle(color: Colors.red),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller: dialogText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '请输入尾款',
                    ),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(right: 30),
                  width: 230,
                  child: FlatButton(
                      color: const Color(0xFFFFD600),
                      child: const Text(
                        '确定',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                      onPressed: () async {
                        bool result = false;
                        if (dialogText.text != null && dialogText.text != '') {
                          double balance = dialogText.text == null ||
                              dialogText.text == ''
                              ? model.balance
                              : double.parse(dialogText.text);
                          model.balance = balance;
                          model.skipPayBalance = false;
                          try {
                            result = await PurchaseOrderRepository()
                                .purchaseOrderBalanceUpdate(model.code, model);
                          } catch (e) {
                            print(e);
                          }
                          if (model.status ==
                              PurchaseOrderStatus.IN_PRODUCTION) {
                            try {
                              for (int i = 0; i <
                                  widget.order.progresses.length; i++) {
                                if (widget.order.currentPhase ==
                                    widget.order.progresses[i].phase) {
                                  result = await PurchaseOrderRepository()
                                      .productionProgressUpload(
                                      widget.order.code,
                                      widget.order.progresses[i].id.toString(),
                                      widget.order.progresses[i]);
                                }
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                          Navigator.of(context).pop();
                          _showMessage(context, result, '修改尾款');
                        }
                      }),
                ),
                FlatButton(
                  child: Text(
                    '无需付款直接跳过>>',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showTips(context, model);
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  //修改定金
  Future<void> _neverUpdateDeposit(BuildContext context, PurchaseOrderModel model) async {
    final TextEditingController depositText = TextEditingController();
    final TextEditingController unitText = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text('提示', style: const TextStyle(fontSize: 16)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('订单总额：￥${model.totalPrice}'),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller: depositText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: '定金：￥${model.deposit}'),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  color: Colors.black12,
                  child: TextField(
                    controller: unitText,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: '单价：￥${model.unitPrice}'),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 30),
              width: 230,
              child: FlatButton(
                  color: const Color(0xFFFFD600),
                  child: const Text(
                    '确定',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
                  onPressed: () async {
                    bool result = false;
                    double unit =
                        unitText.text == null || unitText.text == '' ? model.unitPrice : double.parse(unitText.text);
                    double deposit = depositText.text == null || depositText.text == ''
                        ? model.deposit
                        : double.parse(depositText.text);
                    model.deposit = deposit;
                    model.unitPrice = unit;
                    model.skipPayBalance = false;
                    try {
                      result = await PurchaseOrderRepository().purchaseOrderDepositUpdate(model.code, model);
                    } catch (e) {
                      print(e);
                    }
                    Navigator.of(context).pop();
                    _showMessage(context, result, '修改定金');
                  }),
            ),
          ],
        );
      },
    );
  }

  //打开修改尾款金额弹框
  void _showBalanceDialog(BuildContext context, PurchaseOrderModel model) {
    _neverUpdateBalance(context, model);
  }

  //打开修改定金金额弹框
  void _showDepositDialog(BuildContext context, PurchaseOrderModel model) {
    _neverUpdateDeposit(context, model);
  }

  void _showTips(BuildContext context, PurchaseOrderModel model) {
    _neverComplete(context, model);
  }

  void _showMessage(BuildContext context, bool result, String message) {
    _requestMessage(context, result ? '$message成功' : '$message失败');
    PurchaseOrderBLoC.instance.refreshData('ALL');
  }

  //确认跳过按钮
  Future<void> _neverComplete(BuildContext context, PurchaseOrderModel model) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text(
            '提示',
            style: const TextStyle(fontSize: 16),
          ),
          content: Text('是否无需付款直接跳过？'),
          actions: <Widget>[
            FlatButton(
              child: const Text('取消',style: TextStyle(
                  color: Colors.grey
              )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('确定',style: TextStyle(
                  color: Colors.black
              )),
              onPressed: () async {
                bool result = false;
                model.balance = 0;
                model.skipPayBalance = true;
                try {
                  result = await PurchaseOrderRepository().purchaseOrderBalanceUpdate(model.code, model);
                  if (model.status == PurchaseOrderStatus.IN_PRODUCTION) {
                    try {
                      for (int i = 0; i < widget.order.progresses.length; i++) {
                        if (widget.order.currentPhase == widget.order.progresses[i].phase) {
                          result = await PurchaseOrderRepository().productionProgressUpload(
                              widget.order.code, widget.order.progresses[i].id.toString(), widget.order.progresses[i]);
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  }
                } catch (e) {
                  result = false;
                  print(e);
                }finally{
                  Navigator.of(context).pop();
                  _showMessage(context, result, '操作');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _requestMessage(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (context) {
        return SimpleDialog(
          title: const Text('提示', style: const TextStyle(fontSize: 16)),
          children: <Widget>[SimpleDialogOption(child: Text('$message'))],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => false;
}
