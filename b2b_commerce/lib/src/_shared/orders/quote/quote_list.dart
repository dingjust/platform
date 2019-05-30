import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './quote_list_item.dart';
import '../../../business/orders/form/proofing_order_form.dart';
import '../../../home/pool/requirement_quote_order_form.dart';
import '../../../production/production_online_order_from.dart';
import '../../widgets/scrolled_to_end_tips.dart';

class QuoteList extends StatefulWidget {
  QuoteList({
    Key key,
    this.status,
    this.companyUid,
    this.keyword,
  }) : super(key: key);

  final EnumModel status;
  final String companyUid;
  final String keyword;

  final ScrollController scrollController = ScrollController();
  final TextEditingController rejectController = TextEditingController();

  @override
  _QuoteListState createState() {
    return _QuoteListState();
  }
}

class _QuoteListState extends State<QuoteList> {
  @override
  void initState() {
    super.initState();

    var bloc = BLoCProvider.of<QuoteOrdersBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        if (widget.companyUid != null) {
          bloc.lodingMoreByCompany(widget.companyUid);
        } else if (widget.keyword != null) {
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
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
    });
  }

  void _onQuoteRejecting(QuoteModel model) {
    TextEditingController inputController = TextEditingController();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.INPUTS_DIALOG,
            inputController1: inputController,
            title: '填写拒绝原因',
            focusNode1: FocusNode(),
          );
        }).then((value) {
      if (value != null && value != '') {
        rejectQuote(model, value);
      }
    });
  }

  rejectQuote(QuoteModel model, String rejectText) async {
    int statusCode = await QuoteOrderRepository().quoteReject(
      model.code,
      rejectText,
    );
    if (statusCode == 200) {
      // 触发刷新
      _handleRefresh();
    } else {
      _alertMessage('拒绝失败');
    }
  }

  void _onQuoteConfirming(QuoteModel model) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.CONFIRM_DIALOG,
            contentText2: '是否确认该工厂报价?',
            isNeedConfirmButton: true,
            isNeedCancelButton: true,
            confirmButtonText: '是',
            cancelButtonText: '否',
            dialogHeight: 180,
            confirmAction: () {
              Navigator.of(context).pop();
              confirmFactory(model);
            },
          );
        });
  }

  confirmFactory(QuoteModel model) async {
    int statusCode = await QuoteOrderRepository().quoteApprove(model.code);
    if (statusCode == 200) {
      //触发刷新
      _handleRefresh();
    } else {
      _alertMessage('确认失败');
    }
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
    QuoteModel detailModel =
    await QuoteOrderRepository().getQuoteDetails(model.code);

    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => ProofingOrderForm(quoteModel: detailModel)),
    );
  }

  void _onProductionOrderCreating(QuoteModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProductionOnlineOrderFrom(quoteModel: model)),
    );
  }

  void _onQuoteAgain(QuoteModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RequirementQuoteOrderForm(
            model: model.requirementOrder, quoteModel: model),
      ),
    );
  }

  // 子组件刷新数据方法
  void _handleRefresh() {
    var bloc = BLoCProvider.of<QuoteOrdersBLoC>(context);
    if (widget.companyUid != null) {
      bloc.getQuoteDataByCompany(widget.companyUid);
    } else if (widget.keyword != null) {
      bloc.filterByKeyword(widget.keyword);
    } else {
      bloc.refreshData(widget.status.code);
    }
  }

  void _alertMessage(String message) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomizeDialog(
            dialogType: DialogType.RESULT_DIALOG,
            failTips: '${message}',
            callbackResult: false,
            confirmAction: () {
              Navigator.of(context).pop();
            },
          );
        });
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
              builder: (BuildContext context,
                  AsyncSnapshot<List<QuoteModel>> snapshot) {
                if (snapshot.data == null) {
                  if (widget.companyUid != null) {
                    bloc.getQuoteDataByCompany(widget.companyUid);
                  } else if (widget.keyword != null) {
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
                      Container(
                        child: FlatButton(
                          color: Color.fromRGBO(255, 214, 12, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyHelpPage()));
                          },
                          child: Text('如何获取报价？'),
                        ),
                      )
                    ],
                  );
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
                        onProductionOrderCreating: () =>
                            _onProductionOrderCreating(item),
                        onQuoteAgain: () => _onQuoteAgain(item),
                        companyUid:widget.companyUid,
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
