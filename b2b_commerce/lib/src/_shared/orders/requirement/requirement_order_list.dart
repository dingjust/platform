import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../../widgets/scrolled_to_end_tips.dart';

import './requirement_order_list_item.dart';

/// 需求订单列表
class RequirementOrderList extends StatefulWidget {
  RequirementOrderList({Key key, @required this.status,this.keyword}) : super(key: key);

  final EnumModel status;
  final String keyword;

  final ScrollController scrollController = ScrollController();

  @override
  _RequirementOrderListState createState() => _RequirementOrderListState();
}

class _RequirementOrderListState extends State<RequirementOrderList> {
  @override
  void initState() {
    super.initState();

    var bloc = BLoCProvider.of<RequirementOrderBLoC>(context);

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        if(widget.keyword != null){
          bloc.loadingMoreByKeyword(widget.keyword);
        }else{
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
      decoration: BoxDecoration(color: Colors.grey[100]),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: RefreshIndicator(
        onRefresh: () async {
          if (!bloc.lock) bloc.refreshData(widget.status.code);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: widget.scrollController,
          children: <Widget>[
            StreamBuilder<List<RequirementOrderModel>>(
              stream: bloc.stream,
              // initialData: null,
              builder: (BuildContext context, AsyncSnapshot<List<RequirementOrderModel>> snapshot) {
                if (snapshot.data == null) {
                  if (widget.keyword != null) {
                    bloc.filterByKeyword(widget.keyword);
                  } else {
                    bloc.filterByStatuses(widget.status.code);
                  }
                  return ProgressIndicatorFactory.buildPaddedProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((order) {
                      return RequirementOrderItem(model: order);
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
