import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './requirement_order_list_item.dart';
import '../../widgets/scrolled_to_end_tips.dart';

/// 需求订单列表
class RequirementOrderList extends StatefulWidget {
  RequirementOrderList({Key key, @required this.status, this.keyword})
      : super(key: key);

  final EnumModel status;
  final String keyword;

  final ScrollController scrollController = ScrollController();

  @override
  _RequirementOrderListState createState() => _RequirementOrderListState();
}

class _RequirementOrderListState extends State<RequirementOrderList>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    var bloc = BLoCProvider.of<RequirementOrderBLoC>(context);

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
      //返回到顶部时执行动画
      if (data) {
        widget.scrollController.animateTo(
          .0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<RequirementOrderBLoC>(context);

    return Container(
      decoration: BoxDecoration(color: Color(0xffF7F7F7)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: RefreshIndicator(
        onRefresh: () async {
          // if (!bloc.lock)
          await bloc.refreshData(widget.status.code);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
          children: <Widget>[
            StreamBuilder<RequirementData>(
              stream: bloc.stream.where((requirementData) =>
                  requirementData.status == widget.status.code),
              // initialData: null,
              builder: (BuildContext context,
                  AsyncSnapshot<RequirementData> snapshot) {
                if (snapshot.data == null) {
                  if (widget.keyword != null) {
                    bloc.filterByKeyword(widget.keyword);
                  } else {
                    bloc.filterByStatuses(widget.status.code);
                  }
                  return ProgressIndicatorFactory
                      .buildPaddedProgressIndicator();
                }
                if (snapshot.data.data.length <= 0) {
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
                            AppBLoC.instance.getConnectivityResult ==
                                ConnectivityResult.none
                                ? '网络链接不可用请重试'
                                : '没有相关订单数据',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )),
                      AppBLoC.instance.getConnectivityResult !=
                          ConnectivityResult.none
                          ? Container(
                        child: FlatButton(
                          color: Color.fromRGBO(255, 214, 12, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyHelpPage()));
                          },
                          child: Text('如何发布需求？'),
                        ),
                      )
                          : Container()
                    ],
                  );
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.data.map((order) {
                      return RequirementOrderItem(
                        model: order,
                        onRequirementCancle: () => onOrderCancle(order.code),
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

  void onOrderCancle(String code) async {
    String result =
    await RequirementOrderRepository().requirementOrderCancle(code);
    if (result != null && result == 'success') {
      //触发刷新
      _handleRefresh();
    }
  }

  // 子组件刷新数据方法
  void _handleRefresh() {
    var bloc = BLoCProvider.of<RequirementOrderBLoC>(context);
    //全部数据重置
    bloc.reset();
    //当前状态订单刷新
    bloc.refreshData(widget.status.code);
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
