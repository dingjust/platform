import 'package:b2b_commerce/src/business/orders/provider/requirement_order_bloc_provider.dart';
import 'package:b2b_commerce/src/business/search/requirement_order_search.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

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
  @override
  Widget build(BuildContext context) {
    return RequirementOrderBlocProvider(
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
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
                context: context, delegate: RequirementOrderSearchDelegate()),
          ),
        ],
      ),
      body: DefaultTabController(
        length: statuses.length,
        child: Scaffold(
          appBar: TabBar(
            unselectedLabelColor: Colors.black26,
            labelColor: Colors.black38,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: statuses.map((status) {
              return Tab(text: status.name);
            }).toList(),
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            isScrollable: false,
          ),
          body: TabBarView(
            children: <Widget>[
              RequirementOrderList(
                status: statuses[0],
              ),
              RequirementOrderList(
                status: statuses[1],
              ),
              RequirementOrderList(
                status: statuses[2],
              ),
              RequirementOrderList(
                status: statuses[3],
              )
            ],
          ),
        ),
      ),
      floatingActionButton: ToTopBtn(),
    ));
  }
}

class RequirementOrderList extends StatelessWidget {
  RequirementOrderList({Key key, this.status}) : super(key: key);

  final EnumModel status;

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    final bloc = RequirementOrderBlocProvider.of(context);

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
            StreamBuilder<List<RequirementOrderModel>>(
              stream: bloc.stream,
              initialData: null,
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
        ));
  }
}

class RequirementOrderItem extends StatelessWidget {
  const RequirementOrderItem({Key key, this.order}) : super(key: key);

  final RequirementOrderModel order;

  static Map<RequirementOrderStatus, MaterialColor> _statusColors = {
    RequirementOrderStatus.PENDING_QUOTE: Colors.green,
    RequirementOrderStatus.COMPLETED: Colors.orange,
    RequirementOrderStatus.CANCELLED: Colors.red
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.ROUTE_REQUIREMENT_ORDERS_DETAIL);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            Column(
              children: _buildEntries(),
            ),
            _buildSummary()
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
    var sd = _statusColors[order.status];
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text('需求订单号：' + order.code),
              ),
              Text(RequirementOrderStatusLocalizedMap[order.status],
                  style: TextStyle(color: _statusColors[order.status]))
            ],
          ),
          Text('发布时间: 1997-01-01'),
        ],
      ),
    );
  }

  List<Widget> _buildEntries() {
    return order.entries
        .map((entry) => Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: entry.product.thumbnail != null
                              ? NetworkImage(entry.product.thumbnail)
                              : AssetImage(
                                  'temp/picture.png',
                                  package: "assets",
                                ),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          entry.product.name != null
                              ? Text(
                                  entry.product.name,
                                  style: TextStyle(fontSize: 15),
                                )
                              : Text(
                                  '暂无产品',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red),
                                ),
                          entry.product.skuID != null
                              ? Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    '货号：' + entry.product.skuID,
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                )
                              : Container(),
                          Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                color: Colors.yellow[50],
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              "${entry.product.superCategories.first.name}   ${entry.product.majorCategory.name}   ${entry.entryNumber}件",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.orange),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ))
        .toList();
  }

  Widget _buildSummary() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            '已报价 6',
            style: TextStyle(color: Colors.red),
          )
        ],
      ),
    );
  }
}

class ToTopBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = RequirementOrderBlocProvider.of(context);

    return StreamBuilder<bool>(
        stream: bloc.toTopBtnStream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return snapshot.data
              ? FloatingActionButton(
                  child: Icon(Icons.arrow_upward,color: Colors.white,),
                  onPressed: () {
                    bloc.returnToTop();
                  },
                  backgroundColor: Colors.blue,
                )
              : Container();
        });
  }
}
