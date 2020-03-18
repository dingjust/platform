import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/orders/sale/sale_order_list_item.dart';
import 'package:b2b_commerce/src/my/my_help.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SaleOrderList extends StatefulWidget {
  SaleOrderList({Key key, this.status, this.companyUid, this.keyword});

  final String keyword;
  final EnumModel status;
  final String companyUid;

  final ScrollController scrollController = ScrollController();

  _SaleOrderListState createState() => _SaleOrderListState();
}

class _SaleOrderListState extends State<SaleOrderList>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();

    var bloc = BLoCProvider.of<PurchaseOrderBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        if (widget.status == null) {
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
            StreamBuilder<PurchaseData>(
              stream: widget.status == null
                  ? bloc.stream
                  : bloc.stream.where((purchaseData) =>
                      purchaseData.status == widget.status.code),
              // initialData: null,
              builder:
                  (BuildContext context, AsyncSnapshot<PurchaseData> snapshot) {
                if (snapshot.data == null) {
                  if (widget.companyUid != null) {
                    bloc.getPurchaseDataByCompany(widget.companyUid);
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
                                child: Text('如何创建订单？'),
                              ),
                            )
                          : Container()
                    ],
                  );
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.data.map((order) {
                      return SaleOrderListItem(
                        model: order,
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
  bool get wantKeepAlive => true;
}
