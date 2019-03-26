import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:b2b_commerce/src/business/search/requirement_order_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

const statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('PENDING_QUOTE', '报价中'),
  EnumModel('COMPLETED', '已完成'),
  EnumModel('CANCELLED', '已失效')
];

class RequirementOrdersPage extends StatefulWidget {
  _RequirementOrdersPageState createState() => _RequirementOrdersPageState();
}

class _RequirementOrdersPageState extends State<RequirementOrdersPage> {
  GlobalKey _requirementOrderBlocProviderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<RequirementOrderBLoC>(
        key: _requirementOrderBlocProviderKey,
        bloc: RequirementOrderBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text(
              '需求订单管理',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.search,
                  size: 20,
                ),
                onPressed: () => showSearch(
                    context: context,
                    delegate: RequirementOrderSearchDelegate()),
              ),
            ],
          ),
          body: DefaultTabController(
            length: statuses.length,
            child: Scaffold(
              appBar: TabBar(
                unselectedLabelColor: Colors.black26,
                labelColor: Colors.orange,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: statuses.map((status) {
                  return Tab(text: status.name);
                }).toList(),
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
                isScrollable: false,
              ),
              body: TabBarView(
                children: statuses
                    .map((status) => RequirementOrderList(
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

class RequirementOrderList extends StatelessWidget {
  RequirementOrderList({Key key, this.status}) : super(key: key);

  final EnumModel status;

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<RequirementOrderBLoC>(context);

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
            if (!bloc.lock) bloc.refreshData(status.code);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              StreamBuilder<List<RequirementOrderModel>>(
                stream: bloc.stream,
                // initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<RequirementOrderModel>> snapshot) {
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
                        return RequirementOrderItem(
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
                        duration: new Duration(milliseconds: 500),
                        curve: Curves.easeOut);
                  }
                  return snapshot.data
                      ? Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Center(
                            child: Text(
                              "┑(￣Д ￣)┍ 已经到底了",
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
          ),
        ));
  }
}

class RequirementOrderItem extends StatelessWidget {
  const RequirementOrderItem({Key key, this.order}) : super(key: key);

  final RequirementOrderModel order;

  static Map<RequirementOrderStatus, MaterialColor> _statusColors = {
    RequirementOrderStatus.PENDING_QUOTE: Colors.green,
    RequirementOrderStatus.COMPLETED: Colors.orange,
    RequirementOrderStatus.CANCELLED: Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //根据code查询明
        RequirementOrderModel model = await RequirementOrderRepository()
            .getRequirementOrderDetail(order.code);

        List<QuoteModel> quotes = await RequirementOrderRepository()
            .getRequirementOrderQuotes(code: model.code, page: 0, size: 1);

        if (model != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RequirementOrderDetailPage(
                    order: model,
                    quotes: quotes,
                  )));
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[_buildHeader(), _buildEntries(), _buildSummary()],
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
            children: <Widget>[
              Expanded(
                flex: 1,
                child:
                    Text('需求订单号：' + order.code, style: TextStyle(fontSize: 16)),
              ),
              Text(RequirementOrderStatusLocalizedMap[order.status],
                  style: TextStyle(
                      color: _statusColors[order.status], fontSize: 18))
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Text(
              '发布时间: ${DateFormatUtil.format(order.creationTime)}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
    Widget _pictureWidget;

    if (order.details.pictures == null) {
      _pictureWidget = Container(
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
      );
    } else {
      if (order.details.pictures.isEmpty) {
        _pictureWidget = Container(
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
        );
      } else {
        _pictureWidget = Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage(
                    '${GlobalConfigs.IMAGE_BASIC_URL}${order.details.pictures[0].url}'),
                fit: BoxFit.cover,
              )),
        );
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          _pictureWidget,
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  order.details.productName != null
                      ? Text(
                          order.details.productName,
                          style: TextStyle(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          ' ',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                        ),
                  order.details.productSkuID != null
                      ? Container(
                          padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '货号：${order.details.productSkuID}',
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
                      "${order.details.majorCategoryName()}   ${order.details.category?.name}   ${order.details.expectedMachiningQuantity}件",
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

  Widget _buildSummary() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            '已报价 ${order.totalQuotesCount}',
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    );
  }
}

class _ToTopBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<RequirementOrderBLoC>(context);

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
