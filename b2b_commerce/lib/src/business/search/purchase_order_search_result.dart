import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/production/production.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class PurchaseOrderSearchResultPage extends StatefulWidget {
  PurchaseOrderSearchResultPage({Key key, this.keyword}) : super(key: key);

  _PurchaseOrderSearchResultPageState createState() => _PurchaseOrderSearchResultPageState();

  String keyword;
}

class _PurchaseOrderSearchResultPageState extends State<PurchaseOrderSearchResultPage> {
  GlobalKey _productionOrderBlocProviderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ProductionSearchResultBLoC>(
        key: _productionOrderBlocProviderKey,
        bloc: ProductionSearchResultBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('${widget.keyword}'),
            brightness: Brightness.dark,
          ),
          body: ProductionListView(
            keyword: widget.keyword,
          ),
          floatingActionButton: ScrollToTopButton<ProductionSearchResultBLoC>(),
        ));
  }
}

class ProductionListView extends StatelessWidget {
  String keyword;

  ScrollController _scrollController = new ScrollController();

  ///当前选中条件
  FilterConditionEntry currentCondition = FilterConditionEntry(
      label: '当前生产', value: 'comprehensive', checked: true);

  ProductionListView({Key key, @required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ProductionSearchResultBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMore(keyword);
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
        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
        color: Colors.grey[200],
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            StreamBuilder<List<PurchaseOrderModel>>(
                initialData: null,
                stream: bloc.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PurchaseOrderModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.getData(keyword);
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
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
                }),
            StreamBuilder<bool>(
              stream: bloc.bottomStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                // if (snapshot.data) {
                //   _scrollController.animateTo(_scrollController.offset - 70,
                //       duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                // }
                return ScrolledToEndTips(
                  hasContent: snapshot.data,
                  scrollController: _scrollController,
                );
              },
            ),
            StreamBuilder<bool>(
              stream: bloc.loadingStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ProgressIndicatorFactory
                    .buildPaddedOpacityProgressIndicator(
                        opacity: snapshot.data ? 1.0 : 0);
              },
            ),
          ],
        ));
  }
}
