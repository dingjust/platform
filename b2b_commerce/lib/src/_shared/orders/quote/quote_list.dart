import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../widgets/scrolled_to_end_tips.dart';

import '../../../business/orders/form/proofing_order_form.dart';
import '../../../home/pool/requirement_quote_order_form.dart';
import '../../../production/production_online_order_from.dart';

import './quote_list_item.dart';

class QuoteList extends StatefulWidget {
  QuoteList({
    Key key,
    @required this.status,
  }) : super(key: key);

  final EnumModel status;

  final ScrollController scrollController = ScrollController();
  final TextEditingController rejectController = TextEditingController();

  @override
  _QuoteListState createState() => _QuoteListState();
}

class _QuoteListState extends State<QuoteList> {
  @override
  void initState() {
    super.initState();

    var bloc = BLoCProvider.of<QuoteOrdersBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses(widget.status.code);
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
    var bloc = BLoCProvider.of<QuoteOrdersBLoC>(context);
    bloc.refreshData(widget.status.code);
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
          return await bloc.refreshData(widget.status.code);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
          children: <Widget>[
            StreamBuilder<List<QuoteModel>>(
              stream: bloc.stream,
              builder: (BuildContext context, AsyncSnapshot<List<QuoteModel>> snapshot) {
                if (snapshot.data == null) {
                  bloc.filterByStatuses(widget.status.code);
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
