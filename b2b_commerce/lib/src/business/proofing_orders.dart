import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/app_bar_factory.dart';
import '../_shared/widgets/scrolled_to_end_tips.dart';
import '../_shared/widgets/tab_factory.dart';
import '../_shared/widgets/scroll_to_top_button.dart';
import '../business/orders/form/proofing_order_form.dart';
import '../business/orders/proofing_order_detail.dart';
import '../business/search/proofing_search.dart';
import '../common/logistics_input_page.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_PAYMENT', '待付款'),
  EnumModel('PENDING_DELIVERY', '待发货'),
  EnumModel('SHIPPED', '已发货'),
  EnumModel('COMPLETED', '已完成'),
  EnumModel('CANCELLED', '已取消')
];

class ProofingOrdersPage extends StatefulWidget {
  _ProofingOrdersPageState createState() => _ProofingOrdersPageState();
}

class _ProofingOrdersPageState extends State<ProofingOrdersPage> {
  final GlobalKey _globalKey = GlobalKey<_ProofingOrdersPageState>();

  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      icon: Icon(B2BIcons.search, size: 20),
      onPressed: () => showSearch(context: context, delegate: ProofingSearchDelegate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ProofingOrdersBLoC>(
        key: _globalKey,
        bloc: ProofingOrdersBLoC.instance,
        child: Scaffold(
          appBar: AppBarFactory.buildDefaultAppBar(
            '打样订单管理',
            actions: <Widget>[_buildSearchButton(context)],
          ),
          body: DefaultTabController(
            length: statuses.length,
            child: Scaffold(
              appBar: TabFactory.buildDefaultTabBar(statuses, scrollable: true),
              body: TabBarView(
                children: statuses
                    .map(
                      (status) => ProofingOrdersList(status: status),
                    )
                    .toList(),
              ),
            ),
          ),
          floatingActionButton: ScrollToTopButton<ProofingOrdersBLoC>(),
        ));
  }
}

class ProofingOrdersList extends StatelessWidget {
  ProofingOrdersList({Key key, this.status}) : super(key: key);

  final EnumModel status;

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ProofingOrdersBLoC>(context);

    // 子组件刷新数据方法
    void _handleRefresh() {
      bloc.refreshData(status.code);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses(status.code);
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
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: RefreshIndicator(
        onRefresh: () async {
          return await bloc.refreshData(status.code);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          children: <Widget>[
            StreamBuilder<List<ProofingModel>>(
              stream: bloc.stream,
              builder: (BuildContext context, AsyncSnapshot<List<ProofingModel>> snapshot) {
                if (snapshot.data == null) {
                  bloc.filterByStatuses(status.code);
                  return ProgressIndicatorFactory.buildPaddedProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((order) {
                      return ProofingOrderItem(
                        model: order,
                        onRefresh: _handleRefresh,
                        pageContext: context,
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
                  _scrollController.animateTo(
                    _scrollController.offset - 70,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
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
}

class ProofingOrderItem extends StatelessWidget {
  const ProofingOrderItem({
    Key key,
    @required this.model,
    this.onRefresh,
    this.pageContext,
  }) : super(key: key);

  final ProofingModel model;

  /// 更新方法
  final VoidCallback onRefresh;

  /// 顶级页面context
  final BuildContext pageContext;

  static Map<ProofingStatus, Color> _statusColors = {
    ProofingStatus.PENDING_PAYMENT: Colors.red,
    ProofingStatus.PENDING_DELIVERY: const Color(0xFFFFD600),
    ProofingStatus.SHIPPED: const Color(0xFFFFD600),
    ProofingStatus.COMPLETED: Colors.green,
    ProofingStatus.CANCELLED: Colors.grey
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // 查询明细
        ProofingModel detailModel = await ProofingOrderRepository().proofingDetail(model.code);

        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProofingOrderDetailPage(model: detailModel)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildEntries(),
            _buildSummary(context),
          ],
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: '￥',
                  style: const TextStyle(fontSize: 16, color: Color.fromRGBO(255, 45, 45, 1)),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${model.totalPrice}',
                      style: const TextStyle(fontSize: 20, color: Color.fromRGBO(255, 45, 45, 1)),
                    ),
                  ],
                ),
              ),
              Text(
                ProofingStatusLocalizedMap[model.status],
                style: TextStyle(color: _statusColors[model.status], fontSize: 18),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // TODO 公司信息字段后续待修改
                Container(
                  width: 200,
                  child: Text(
                    '${model.supplier.name}',
                    style: const TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('${DateFormatUtil.format(model.creationTime)}', style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
    // 计算总数
    int sum = 0;
    model.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });

    Widget _buildProductName(String name) {
      return Text(name, style: const TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis);
    }

    Widget _buildProductSkuID(String skuID) {
      if (skuID == null) {
        return Container();
      }

      return Container(
        padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('货号：$skuID', style: const TextStyle(fontSize: 12, color: Colors.grey)),
      );
    }

    Widget _buildCategoryAndCount(String category, int sum) {
      return Container(
        padding: const EdgeInsets.fromLTRB(3, 1, 3, 1),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(255, 243, 243, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "$category   $sum 件",
          style: const TextStyle(fontSize: 15, color: const Color.fromRGBO(255, 133, 148, 1)),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImage(model.product?.thumbnail, size: 25),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildProductName(model.product.name),
                  _buildProductSkuID(model.product.skuID),
                  _buildCategoryAndCount(model.product.category?.name, sum)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    Widget _buildCancelButton(BuildContext context) {
      return FlatButton(
        onPressed: onCancelling,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color.fromRGBO(255, 70, 70, 1),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: const Text('取消订单', style: const TextStyle(color: Colors.white, fontSize: 16)),
      );
    }

    Widget _buildPayButton(BuildContext context) {
      return FlatButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color.fromRGBO(255, 214, 12, 1),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text('  去支付  ', style: const TextStyle(color: const Color.fromRGBO(36, 38, 41, 1), fontSize: 16)),
      );
    }

    /*Widget _buildTrackingButton(BuildContext context) {
      return FlatButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color.fromRGBO(150, 150, 150, 1),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text(
          '查看物流',
          style: const TextStyle(color: const Color.fromRGBO(150, 150, 150, 1), fontSize: 16),
        ),
      );
    }*/

    Widget _buildConfirmReceivedButton(BuildContext context) {
      return FlatButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: const Color(0xFFFFD600),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text(
          '确认收货',
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      );
    }

    Widget _buildUpdateButton(BuildContext context) {
      return FlatButton(
        onPressed: onUpdate,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: const Color.fromRGBO(255, 45, 45, 1)),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Text(
          '修改订单',
          style: const TextStyle(color: const Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
        ),
      );
    }

    Widget _buildConfirmDeliveryButton(BuildContext context) {
      return FlatButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LogisticsInputPage(isProductionOrder: false, proofingModel: model),
            ),
          );
        },
        color: const Color(0xFFFFD600),
        child: Text(
          '确认发货',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(20))),
      );
    }

    bool _isBrand() {
      return UserBLoC.instance.currentUser.type == UserType.BRAND;
    }

    List<Widget> buttons;
    // 品牌端显示
    if (_isBrand()) {
      if (model.status == ProofingStatus.PENDING_PAYMENT) {
        buttons = <Widget>[
          _buildCancelButton(context),
          _buildPayButton(context),
        ];
      } else if (model.status == ProofingStatus.SHIPPED) {
        buttons = <Widget>[
          // _buildTrackingButton(context),
          // Container(),
          _buildConfirmReceivedButton(context),
        ];
      } else {
        return Container();
      }
    } else {
      //工厂端显示
      if (model.status == ProofingStatus.PENDING_PAYMENT) {
        buttons = [Container(), _buildUpdateButton(context)];
      } else if (model.status == ProofingStatus.PENDING_DELIVERY) {
        buttons = <Widget>[Container(), _buildConfirmDeliveryButton(context)];
      }
      /*else if (model.status == ProofingStatus.SHIPPED) {
        buttons = [
          Container(),
          _buildTrackingButton(context),
        ];
      }*/
      else {
        return Container();
      }
    }

    return Row(
      children: <Widget>[
        Container(width: 80),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: buttons),
          ),
        )
      ],
    );
  }

  void onCancelling() {
    showDialog<void>(
      context: pageContext,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: Text('确认取消？'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () async {
                String response = await ProofingOrderRepository().proofingCancelling(model.code);
                if (response != null) {
                  onRefresh();
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[Text('取消失败')],
                          ),
                        ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void onUpdate() async {
    //查询明细
    ProofingModel detailModel = await ProofingOrderRepository().proofingDetail(model.code);

    QuoteModel quoteModel = await QuoteOrderRepository().getquoteDetail(detailModel.quoteRef);

    Navigator.of(pageContext).push(
      MaterialPageRoute(
        builder: (context) => ProofingOrderForm(quoteModel: quoteModel, model: detailModel, update: true),
      ),
    );
  }
}
