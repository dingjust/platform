import 'package:b2b_commerce/src/_shared/widgets/image_factory.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/_shared/widgets/text_factory.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/scroll_to_top_button.dart';

import './orders/requirement_order_detail.dart';
import './search/requirement_order_search.dart';

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
  GlobalKey _globalKey = GlobalKey<_RequirementOrdersPageState>();

  Widget _buildTitle() {
    return const Text('需求订单管理', style: TextStyle(color: Colors.black));
  }

  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      icon: Icon(B2BIcons.search, size: 20),
      onPressed: () => showSearch(context: context, delegate: RequirementOrderSearchDelegate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<RequirementOrderBLoC>(
      key: _globalKey,
      bloc: RequirementOrderBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.5,
          title: _buildTitle(),
          actions: <Widget>[
            _buildSearchButton(context),
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
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
              isScrollable: false,
            ),
            body: TabBarView(
              children: statuses
                  .map(
                    (status) => RequirementOrderList(status: status),
                  )
                  .toList(),
            ),
          ),
        ),
        floatingActionButton: ScrollToTopButton<RequirementOrderBLoC>(),
      ),
    );
  }
}

class RequirementOrderList extends StatelessWidget {
  RequirementOrderList({Key key, @required this.status}) : super(key: key);

  final EnumModel status;

  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<RequirementOrderBLoC>(context);

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
      //返回到顶部时执行动画
      if (data) {
        _scrollController.animateTo(.0, duration: Duration(milliseconds: 200), curve: Curves.ease);
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
              builder: (BuildContext context, AsyncSnapshot<List<RequirementOrderModel>> snapshot) {
                if (snapshot.data == null) {
                  bloc.filterByStatuses(status.code);
                  return ProgressIndicatorFactory.buildPaddedProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((order) {
                      return RequirementOrderItem(
                        item: order,
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
                    duration: new Duration(milliseconds: 500),
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

class RequirementOrderItem extends StatelessWidget {
  const RequirementOrderItem({Key key, @required this.item}) : super(key: key);

  final RequirementOrderModel item;

  static Map<RequirementOrderStatus, MaterialColor> _statusColors = {
    RequirementOrderStatus.PENDING_QUOTE: Colors.green,
    RequirementOrderStatus.COMPLETED: Colors.orange,
    RequirementOrderStatus.CANCELLED: Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // 根据code查询明
        RequirementOrderModel model = await RequirementOrderRepository().getRequirementOrderDetail(item.code);

        List<QuoteModel> quotes = await RequirementOrderRepository().getRequirementOrderQuotes(
          code: model.code,
          page: 0,
          size: 1,
        );

        if (model != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RequirementOrderDetailPage(order: model, quotes: quotes),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: <Widget>[
            _buildHeader(),
            _buildEntries(),
            _buildSummary(item.totalQuotesCount),
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
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '需求订单号：${item.code}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                RequirementOrderStatusLocalizedMap[item.status],
                style: TextStyle(color: _statusColors[item.status], fontSize: 18),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              '发布时间: ${DateFormatUtil.format(item.creationTime)}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntries() {
    Widget _buildProductName(String productName) {
      if (productName == null) {
        return TextFactory.buildEmptyText();
      }

      return Text(productName, style: TextStyle(fontSize: 15), overflow: TextOverflow.ellipsis);
    }

    Widget _buildProductSkuID(String productSkuID) {
      if (productSkuID == null) {
        return Container();
      }

      return Container(
        padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('货号：$productSkuID', style: TextStyle(fontSize: 12, color: Colors.grey)),
      );
    }

    Widget _buildCategoriesAndQuantity({
      String majorCategory = '',
      String category = '',
      int expectedMachiningQuantity = 0,
    }) {
      return Container(
        padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 243, 243, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "$majorCategory   $category   $expectedMachiningQuantity件",
          style: TextStyle(fontSize: 15, color: Color.fromRGBO(255, 133, 148, 1)),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          ImageFactory.buildThumbnailImageForList(item.details.pictures, fit: BoxFit.cover),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildProductName(item.details.productName),
                  _buildProductSkuID(item.details.productSkuID),
                  _buildCategoriesAndQuantity(
                    majorCategory: item.details.majorCategoryName(),
                    category: item.details.category?.name,
                    expectedMachiningQuantity: item.details.expectedMachiningQuantity,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummary(int totalQuotesCount) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[Text('已报价 $totalQuotesCount', style: TextStyle(color: Colors.red))],
      ),
    );
  }
}
