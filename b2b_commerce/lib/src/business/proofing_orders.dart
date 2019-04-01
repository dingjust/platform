import 'package:b2b_commerce/src/business/orders/form/proofing_order_form.dart';
import 'package:b2b_commerce/src/business/orders/proofing_order_detail.dart';
import 'package:b2b_commerce/src/business/search/proofing_search.dart';
import 'package:b2b_commerce/src/common/logistics_input_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

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
  GlobalKey _ProofingOrdersBLoCProviderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ProofingOrdersBLoC>(
        key: _ProofingOrdersBLoCProviderKey,
        bloc: ProofingOrdersBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text(
              '打样订单管理',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.search,
                  size: 20,
                ),
                onPressed: () => showSearch(
                    context: context, delegate: ProofingSearchDelegate()),
              ),
            ],
          ),
          body: DefaultTabController(
            length: statuses.length,
            child: Scaffold(
              appBar: TabBar(
                unselectedLabelColor: Colors.black26,
                labelColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.label,
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
                    .map((status) => ProofingOrdersList(
                          status: status,
                        ))
                    .toList(),
              ),
            ),
          ),
          floatingActionButton: _ToTopBtn(),
        ));
  }
}

class ProofingOrdersList extends StatelessWidget {
  ProofingOrdersList({Key key, this.status}) : super(key: key);

  final EnumModel status;

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ProofingOrdersBLoC>(context);

    //子组件刷新数据方法
    void _handleRefresh() {
      bloc.refreshData(status.code);
    }

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
              StreamBuilder<List<ProofingModel>>(
                stream: bloc.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProofingModel>> snapshot) {
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
                    _scrollController.animateTo(_scrollController.offset - 70,
                        duration: new Duration(milliseconds: 500),
                        curve: Curves.easeOut);
                  }
                  return snapshot.data
                      ? Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Center(
                            child: Text(
                              "(￢_￢)已经到底了",
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
                  return ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
                    opacity: snapshot.data ? 1.0 : 0,
                  );
                },
              ),
            ],
          ),
        ));
  }
}

class ProofingOrderItem extends StatelessWidget {
  const ProofingOrderItem(
      {Key key, @required this.model, this.onRefresh, this.pageContext})
      : super(key: key);

  final ProofingModel model;

  /// 更新方法
  final VoidCallback onRefresh;

  /// 顶级页面context
  final BuildContext pageContext;

  static Map<ProofingStatus, MaterialColor> _statusColors = {
    ProofingStatus.PENDING_DELIVERY: Colors.green,
    ProofingStatus.SHIPPED: Colors.blue,
    ProofingStatus.PENDING_PAYMENT: Colors.red,
    ProofingStatus.COMPLETED: Colors.orange,
    ProofingStatus.CANCELLED: Colors.grey
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //查询明细
        ProofingModel detailModel =
            await ProofingOrderRepository().proofingDetail(model.code);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProofingOrderDetailPage(
                  model: detailModel,
                )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildEntries(),
            Row(
              children: <Widget>[
                Container(
                  width: 80,
                ),
                Expanded(
                  flex: 1,
                  child: _buildSummary(context),
                )
              ],
            )
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
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: '￥',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(255, 45, 45, 1)),
                    children: <TextSpan>[
                      TextSpan(
                          text: '${model.totalPrice}',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromRGBO(255, 45, 45, 1))),
                    ]),
              ),
              Text(ProofingStatusLocalizedMap[model.status],
                  style: TextStyle(
                      color: _statusColors[model.status], fontSize: 18))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //TODO 公司信息字段后续待修改
                Container(
                  width: 200,
                  child: Text(
                    '${model.supplier.name}',
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${DateFormatUtil.format(model.creationTime)}',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
    //计算总数
    int sum = 0;
    model.entries.forEach((entry) {
      sum = sum + entry.quantity;
    });

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          model.product?.thumbnail != null
              ? Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                        image: NetworkImage(
                            '${GlobalConfigs.IMAGE_BASIC_URL}${model.product.thumbnail.url}'),
                        fit: BoxFit.cover,
                      )),
                )
              : Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromRGBO(243, 243, 243, 1)),
                  child: Icon(
                    B2BIcons.noPicture,
                    color: Color.fromRGBO(200, 200, 200, 1),
                    size: 25,
                  ),
                ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model.product.name,
                    style: TextStyle(fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  model.product.skuID != null
                      ? Container(
                          padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            '货号：${model.product.skuID}',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        )
                      : Container(),
                  Container(
                    padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 243, 243, 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "${model.product.category.name}   ${sum}件",
                      style: TextStyle(
                          fontSize: 15,
                          color: Color.fromRGBO(255, 133, 148, 1)),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    List<Widget> buttons;
    //品牌端显示
    if (UserBLoC.instance.currentUser.type == UserType.BRAND) {
      if (model.status == ProofingStatus.PENDING_PAYMENT) {
        buttons = <Widget>[
          FlatButton(
              onPressed: onCancelling,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 70, 70, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '取消订单',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )),
          FlatButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 214, 12, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '  去支付  ',
                style: TextStyle(
                    color: Color.fromRGBO(36, 38, 41, 1), fontSize: 16),
              )),
        ];
      } else if (model.status == ProofingStatus.SHIPPED) {
        buttons = <Widget>[
          // FlatButton(
          //     onPressed: () {},
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(20)),
          //     color: Color.fromRGBO(150, 150, 150, 1),
          //     padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          //     child: Text(
          //       '查看物流',
          //       style: TextStyle(
          //           color: Color.fromRGBO(150, 150, 150, 1), fontSize: 16),
          //     )),
          Container(),
          FlatButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color(0xFFFFD600),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '确认收货',
                style: TextStyle(
                    color: Colors.black, fontSize: 16),
              )),
        ];
      } else {
        return Container();
      }
    } //工厂端显示
    else if (UserBLoC.instance.currentUser.type == UserType.FACTORY) {
      if (model.status == ProofingStatus.PENDING_PAYMENT) {
        buttons = [
          Container(),
          FlatButton(
              onPressed: onUpdate,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color.fromRGBO(255, 45, 45, 1)),
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '修改订单',
                style: TextStyle(
                    color: Color.fromRGBO(255, 45, 45, 1), fontSize: 16),
              )),
        ];
      } else if (model.status == ProofingStatus.PENDING_DELIVERY) {
        buttons = <Widget>[
          Container(),
          FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LogisticsInputPage(isProductionOrder: false,proofingModel: model,))
                );
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Color.fromRGBO(255, 245, 193, 1),
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              child: Text(
                '确认发货',
                style: TextStyle(
                    color: Color.fromRGBO(255, 169, 0, 1), fontSize: 16),
              )),
        ];
      }
      // else if (model.status == ProofingStatus.SHIPPED) {
      //   buttons = [
      //     Container(),
      //     FlatButton(
      //         onPressed: () {},
      //         shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(20)),
      //         color: Color.fromRGBO(150, 150, 150, 1),
      //         padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      //         child: Text(
      //           '查看物流',
      //           style: TextStyle(
      //               color: Color.fromRGBO(150, 150, 150, 1), fontSize: 16),
      //         )),
      //   ];
      // }
      else {
        return Container();
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, children: buttons),
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
                String response = await ProofingOrderRepository()
                    .proofingCancelling(model.code);
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
    ProofingModel detailModel =
        await ProofingOrderRepository().proofingDetail(model.code);

    QuoteModel quoteModel =
        await QuoteOrderRepository().getquoteDetail(detailModel.quoteRef);

    Navigator.of(pageContext).push(MaterialPageRoute(
        builder: (context) => ProofingOrderForm(
              quoteModel: quoteModel,
              model: detailModel,
              update: true,
            )));
  }
}

class _ToTopBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ProofingOrdersBLoC>(context);

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
