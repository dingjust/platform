import 'package:b2b_commerce/src/_shared/orders/proofing/proofing_list_item.dart';
import 'package:b2b_commerce/src/_shared/orders/purchase/purchase_order_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/production/production.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProofingSearchResultPage extends StatefulWidget {
  ProofingSearchResultPage({Key key, this.keyword}) : super(key: key);

  _ProofingSearchResultPageState createState() => _ProofingSearchResultPageState();

  String keyword;
}

class _ProofingSearchResultPageState extends State<ProofingSearchResultPage> {
  GlobalKey _productionOrderBlocProviderKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ProofingOrdersBLoC>(
        key: _productionOrderBlocProviderKey,
        bloc: ProofingOrdersBLoC.instance,
        child: WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text('${widget.keyword}'),
              brightness: Brightness.dark,
            ),
            body: ProofListView(
              keyword: widget.keyword,
            ),
            floatingActionButton: ScrollToTopButton<ProofingOrdersBLoC>(),
          ),
          onWillPop: (){
            Navigator.of(context).pop();
            ProofingOrdersBLoC().refreshData('ALL');
          },
        ),
    );
  }
}

class ProofListView extends StatelessWidget {
  String keyword;

  ScrollController _scrollController = new ScrollController();

  ProofListView({Key key, @required this.keyword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ProofingOrdersBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByKeyword(keyword);
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
            StreamBuilder<List<ProofingModel>>(
                initialData: null,
                stream: bloc.stream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<ProofingModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.filterByKeyword(keyword);
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((order) {
                        return ProofingOrderItem(
                          model: order,
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
