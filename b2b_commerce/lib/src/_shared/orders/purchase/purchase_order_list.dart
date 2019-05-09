import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import './purchase_order_list_item.dart';
import '../../widgets/scrolled_to_end_tips.dart';

class PurchaseOrderList extends StatefulWidget {
  PurchaseOrderList({Key key, this.status, this.companyUid, this.keyword});

  final String keyword;
  final EnumModel status;
  final String companyUid;

  final ScrollController scrollController = ScrollController();

  _PurchaseOrderListState createState() => _PurchaseOrderListState();
}

class _PurchaseOrderListState extends State<PurchaseOrderList>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    var bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        if (widget.companyUid != null) {
          bloc.lodingMoreByCompany(widget.companyUid);
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
        widget.scrollController.animateTo(.0,
            duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);

    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: RefreshIndicator(
        onRefresh: () async {
          if (widget.companyUid != null) {
            return await bloc.getPurchaseDataByCompany(widget.companyUid);
          } else {
            return await bloc.refreshData(widget.status.code);
          }
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
          children: <Widget>[
            StreamBuilder<List<PurchaseOrderModel>>(
              stream: bloc.stream,
              // initialData: null,
              builder: (BuildContext context,
                  AsyncSnapshot<List<PurchaseOrderModel>> snapshot) {
                if (snapshot.data == null) {
                  if (widget.companyUid != null) {
                    bloc.getPurchaseDataByCompany(widget.companyUid);
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
                      return PurchaseOrderItem(
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

  @override
  bool get wantKeepAlive => false;
}
