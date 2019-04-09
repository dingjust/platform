import 'package:b2b_commerce/src/_shared/orders/quote/quote_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/orders/form/proofing_order_form.dart';
import 'package:b2b_commerce/src/home/pool/requirement_quote_order_form.dart';
import 'package:b2b_commerce/src/production/production_online_order_from.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FactoryQuoteListPage extends StatefulWidget{
  FactoryQuoteListPage({
    Key key,
    @required this.factoryUid,
  }) : super(key: key);

  final String factoryUid;

  _FactoryQuoteListPageState createState() => _FactoryQuoteListPageState();
}

class _FactoryQuoteListPageState extends State<FactoryQuoteListPage>{
  final GlobalKey _globalKey = GlobalKey<_FactoryQuoteListPageState>();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<QuoteOrdersBLoC>(
      key: _globalKey,
      bloc: QuoteOrdersBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          title: Text('全部报价单'),
          elevation: 0.5,
          centerTitle: true,
        ),
        body: FactoryQuoteList(factoryUid: widget.factoryUid,),
        floatingActionButton: ScrollToTopButton<QuoteOrdersBLoC>(),
      ),
    );
  }
}

class FactoryQuoteList extends StatefulWidget {
  FactoryQuoteList({
    Key key,
    @required this.factoryUid,
  }) : super(key: key);

  final String factoryUid;

  final ScrollController scrollController = ScrollController();
  final TextEditingController rejectController = TextEditingController();

  @override
  _FactoryQuoteListState createState() => _FactoryQuoteListState();
}

class _FactoryQuoteListState extends State<FactoryQuoteList> {


  @override
  void initState() {
    super.initState();

    QuoteOrdersBLoC bloc = BLoCProvider.of<QuoteOrdersBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.lodingMoreByFactory(widget.factoryUid);
      }
    });

    // 监听滚动事件，打印滚动位置
    widget.scrollController.addListener(() {
      if (widget.scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (widget.scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    // 状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      // 返回到顶部时执行动画
      if (data) {
        widget.scrollController.animateTo(
          .0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
    });
  }

  void _onQuoteRejecting(QuoteModel model) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text('请输入拒绝原因?'),
          content: TextField(
            controller: widget.rejectController,
            autofocus: true,
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('取消', style: const TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('确定', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                int statusCode = await QuoteOrderRepository().quoteReject(
                  model.code,
                  widget.rejectController.text,
                );
                Navigator.of(context).pop();
                if (statusCode == 200) {
                  // 触发刷新
                  _handleRefresh();
                } else {
                  _alertMessage('拒绝失败');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onQuoteConfirming(QuoteModel model) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          title: const Text('是否确认?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('否', style: const TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: const Text('是', style: const TextStyle(color: Colors.black)),
              onPressed: () async {
                int statusCode = await QuoteOrderRepository().quoteApprove(model.code);
                Navigator.of(context).pop();
                if (statusCode == 200) {
                  // 触发刷新
                  _handleRefresh();
                } else {
                  _alertMessage('确认失败');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onQuoteUpdating(QuoteModel model) async {
    //等待操作回调
    bool success = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RequirementQuoteOrderForm(
              model: model.requirementOrder,
              quoteModel: model,
              update: true,
            ),
      ),
    );

    //成功调用列表页传递的更新函数刷新页面
    if (success != null && success) {
      _handleRefresh();
    }
  }

  void _onProofingCreating(QuoteModel model) async {
    //查询明细
    QuoteModel detailModel = await QuoteOrderRepository().getQuoteDetails(model.code);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ProofingOrderForm(quoteModel: detailModel)),
    );
  }

  void _onProductionOrderCreating(QuoteModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductionOnlineOrderFrom(quoteModel: model)),
    );
  }

  void _onQuoteAgain(QuoteModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RequirementQuoteOrderForm(model: model.requirementOrder, quoteModel: model),
      ),
    );
  }

  // 子组件刷新数据方法
  void _handleRefresh() {
    QuoteOrdersBLoC bloc = BLoCProvider.of<QuoteOrdersBLoC>(context);
    bloc.getData(widget.factoryUid);
  }

  void _alertMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Text(message)],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<QuoteOrdersBLoC>(context);

    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: RefreshIndicator(
        onRefresh: () async {
          return await bloc.getData(widget.factoryUid);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
          children: <Widget>[
            StreamBuilder<List<QuoteModel>>(
              stream: bloc.stream,
              builder: (BuildContext context, AsyncSnapshot<List<QuoteModel>> snapshot) {
                if (snapshot.data == null) {
                  bloc.getData(widget.factoryUid);
                  return ProgressIndicatorFactory.buildPaddedProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((item) {
                      return QuoteListItem(
                        model: item,
                        onQuoteRejecting: () => _onQuoteRejecting(item),
                        onQuoteConfirming: () => _onQuoteConfirming(item),
                        onQuoteUpdating: () => _onQuoteUpdating(item),
                        onProofingCreating: () => _onProofingCreating(item),
                        onProductionOrderCreating: () => _onProductionOrderCreating(item),
                        onQuoteAgain: () => _onQuoteAgain(item),
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
                  widget.scrollController.animateTo(
                    widget.scrollController.offset - 70,
                    duration: const Duration(milliseconds: 500),
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
