import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/app_bar_factory.dart';
import '../_shared/widgets/tab_factory.dart';
import '../_shared/widgets/scrolled_to_end_tips.dart';
import '../_shared/widgets/scroll_to_top_button.dart';
import '../business/orders/quote_item.dart';
import '../business/search/quotes_search.dart';

List<EnumModel> statuses = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('SELLER_SUBMITTED', '待处理'),
  EnumModel('BUYER_APPROVED', '通过'),
  EnumModel('BUYER_REJECTED', '拒绝'),
];

class QuoteOrdersPage extends StatefulWidget {
  _QuoteOrdersPageState createState() => _QuoteOrdersPageState();
}

class _QuoteOrdersPageState extends State<QuoteOrdersPage> {
  final GlobalKey _globalKey = GlobalKey<_QuoteOrdersPageState>();

  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        B2BIcons.search,
        size: 20,
      ),
      onPressed: () => showSearch(context: context, delegate: QuotesSearchDelegate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<QuoteOrdersBLoC>(
      key: _globalKey,
      bloc: QuoteOrdersBLoC.instance,
      child: Scaffold(
        appBar: AppBarFactory.buildDefaultAppBar(
          '报价管理',
          actions: <Widget>[
            _buildSearchButton(context),
          ],
        ),
        body: DefaultTabController(
          length: statuses.length,
          child: Scaffold(
            appBar: TabFactory.buildDefaultTabBar(statuses),
            body: TabBarView(
              children: statuses
                  .map(
                    (status) => QuoteOrdersList(status: status, pageContext: context),
                  )
                  .toList(),
            ),
          ),
        ),
        floatingActionButton: ScrollToTopButton<QuoteOrdersBLoC>(),
      ),
    );
  }
}

class QuoteOrdersList extends StatelessWidget {
  QuoteOrdersList({
    Key key,
    @required this.status,
    @required this.pageContext,
  }) : super(key: key);

  final EnumModel status;

  final BuildContext pageContext;

  final ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<QuoteOrdersBLoC>(context);

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
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: RefreshIndicator(
        onRefresh: () async {
          return await bloc.refreshData(status.code);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          children: <Widget>[
            StreamBuilder<List<QuoteModel>>(
              stream: bloc.stream,
              builder: (BuildContext context, AsyncSnapshot<List<QuoteModel>> snapshot) {
                if (snapshot.data == null) {
                  bloc.filterByStatuses(status.code);
                  return ProgressIndicatorFactory.buildPaddedProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((order) {
                      return QuoteManageItem(
                        model: order,
                        onRefresh: _handleRefresh,
                        pageContext: pageContext,
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
