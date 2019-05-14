import 'package:b2b_commerce/src/common/customize_dialog.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './proofing_list_item.dart';
import '../../../business/orders/form/proofing_order_form.dart';
import '../../../common/logistics_input_page.dart';
import '../../../common/order_payment.dart';
import '../../widgets/scrolled_to_end_tips.dart';

class ProofingList extends StatefulWidget {
  ProofingList({Key key, this.status, this.keyword}) : super(key: key);

  final String keyword;
  final EnumModel status;
  final ScrollController scrollController = ScrollController();

  @override
  _ProofingListState createState() => _ProofingListState();
}

class _ProofingListState extends State<ProofingList> {
  @override
  void initState() {
    super.initState();

    var bloc = BLoCProvider.of<ProofingOrdersBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        if (widget.keyword != null) {
          bloc.loadingMoreByKeyword(widget.keyword);
        } else {
          bloc.loadingMoreByStatuses(widget.status.code);
        }
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
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
    });
  }

  void _onProofingPaying(ProofingModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => OrderPaymentPage(order: model)),
    );
  }

  void _onProofingCanceling(ProofingModel model) {
    // 取消订单
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialogPage(
            dialogType: DialogType.CONFIRM_DIALOG,
            dialogHeight: 200,
            contentText2: '是否取消订单？',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmAction: (){
              Navigator.of(context).pop();
              cancelOrder(model);
            },
          );
        }
    );
  }

  void cancelOrder(ProofingModel model) async{
    String response = await ProofingOrderRepository()
        .proofingCancelling(model.code);
    if (response != null) {
      _handleRefresh();
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return CustomizeDialogPage(
              dialogType: DialogType.RESULT_DIALOG,
              failTips: '取消失败',
              callbackResult: false,
              confirmAction: (){
                Navigator.of(context).pop();
              },
            );
          }
      );
    }
  }

  void _onProofingConfirmReceived(ProofingModel model) async {
    bool result = false;
    result = await ProofingOrderRepository().shipped(model.code);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialogPage(
            dialogType: DialogType.RESULT_DIALOG,
            successTips: '确认收货成功',
            failTips: '确认收货失败',
            callbackResult: result,
            confirmAction: (){
              Navigator.of(context).pop();
            },
          );
        }
    );
    _handleRefresh();
  }

  void _onProofingUpdating(ProofingModel model) async {
    //查询明细
    ProofingModel detailModel =
        await ProofingOrderRepository().proofingDetail(model.code);

    QuoteModel quoteModel =
        await QuoteOrderRepository().getQuoteDetails(detailModel.quoteRef);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProofingOrderForm(
            quoteModel: quoteModel, model: detailModel, update: true),
      ),
    );
  }

  void _onProofingConfirmDelivered(ProofingModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            LogisticsInputPage(isProductionOrder: false, proofingModel: model),
      ),
    );
  }

  void _onProofingConfirm(ProofingModel model) async {
    bool result =
        await ProofingOrderRepository().proofingConfirm(model.code, model);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialogPage(
            dialogType: DialogType.RESULT_DIALOG,
            successTips: '确认成功',
            failTips: '确认成功',
            callbackResult: result,
            confirmAction: (){
              Navigator.of(context).pop();
            },
          );
        }
    );
    _handleRefresh();
  }

  // 子组件刷新数据方法
  void _handleRefresh() {
    var bloc = BLoCProvider.of<ProofingOrdersBLoC>(context);
    if (widget.keyword != null) {
      bloc.filterByKeyword(widget.keyword);
    } else {
      bloc.refreshData(widget.status.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<ProofingOrdersBLoC>(context);

    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: RefreshIndicator(
        onRefresh: () async {
          if (widget.keyword != null) {
            return await bloc.filterByKeyword(widget.keyword);
          } else {
            return await bloc.refreshData(widget.status.code);
          }
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
          children: <Widget>[
            StreamBuilder<List<ProofingModel>>(
              stream: bloc.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ProofingModel>> snapshot) {
                if (snapshot.data == null) {
                  if (widget.keyword != null) {
                    bloc.filterByKeyword(widget.keyword);
                  } else {
                    bloc.filterByStatuses(widget.status.code);
                  }
                  return ProgressIndicatorFactory
                      .buildPaddedProgressIndicator();
                }
                if (snapshot.data.length <= 0) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 200),
                        child: Image.asset(
                          'temp/logo2.png',
                          package: 'assets',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Container(
                          child: Text(
                        '没有相关订单数据',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      )),
                    ],
                  );
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((order) {
                      return ProofingOrderItem(
                        model: order,
                        onProofingPaying: () => _onProofingPaying(order),
                        onProofingCanceling: () => _onProofingCanceling(order),
                        onProofingConfirmReceived: () =>
                            _onProofingConfirmReceived(order),
                        onProofingUpdating: () => _onProofingUpdating(order),
                        onProofingConfirmDelivered: () =>
                            _onProofingConfirmDelivered(order),
                        onProofingConfirm: () => _onProofingConfirm(order),
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
                // if (snapshot.data) {
                //   widget.scrollController.animateTo(
                //     widget.scrollController.offset - 70,
                //     duration: const Duration(milliseconds: 500),
                //     curve: Curves.easeOut,
                //   );
                // }
                return ScrolledToEndTips(
                  hasContent: snapshot.data,
                  scrollController: widget.scrollController,
                );
              },
            ),
            StreamBuilder<bool>(
              stream: bloc.loadingStream,
              initialData: false,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                return ProgressIndicatorFactory
                    .buildPaddedOpacityProgressIndicator(
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
