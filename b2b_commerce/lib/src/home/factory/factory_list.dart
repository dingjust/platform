import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FactoryListView extends StatefulWidget {
  FactoryListView({this.showButton = false,
    this.factoryCondition,
    this.requirementCode,
    this.currentLocalCondition,
    this.isLocalFind = false,
    @required this.currentCondition,
    this.scrollController});

  FactoryCondition factoryCondition;

  final String requirementCode;

  final bool showButton;

  bool isLocalFind;

  /// 当前选中头部排序条件
  FilterConditionEntry currentCondition;

  //距离排序
  FilterConditionEntry currentLocalCondition;

  ///滚动控制器
  ScrollController scrollController;

  @override
  State<StatefulWidget> createState() => _FactoryListViewState();
}

class _FactoryListViewState extends State<FactoryListView> {
  ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController;
    } else {
      _scrollController = ScrollController();
    }
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<FactoryBLoC>(context);

    // 监听筛选条件更改
    bloc.conditionStream.listen((condition) {
      widget.currentCondition = condition;
      // 清空数据
      bloc.clear();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        if (widget.currentLocalCondition != null) {
          bloc.loadingMoreByCondition(
            widget.factoryCondition,
            condition: widget.currentCondition.value,
            sort: widget.currentCondition.isDESC ? 'desc' : 'asc',
            requirementCode: widget.requirementCode,
          );
        } else {
          bloc.loadingMoreByCondition(
            widget.factoryCondition,
            condition: widget.currentCondition.value,
            sort: widget.currentCondition.isDESC ? 'desc' : 'asc',
            requirementCode: widget.requirementCode,
          );
        }
      }
    });

    return Container(
      decoration: BoxDecoration(color: Colors.grey[100]),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: RefreshIndicator(
        onRefresh: () async {
          bloc.clear();
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          children: <Widget>[
            StreamBuilder<List<FactoryModel>>(
              stream: bloc.stream,
              initialData: null,
              builder: (BuildContext context,
                  AsyncSnapshot<List<FactoryModel>> snapshot) {
                if (snapshot.data == null) {
                  // 默认条件查询
                  bloc.filterByCondition(
                    widget.factoryCondition,
                    condition: widget.currentCondition.value,
                    sort: widget.currentCondition.isDESC ? 'desc' : 'asc',
                    requirementCode: widget.requirementCode,
                  );

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 200),
                    child: ProgressIndicatorFactory
                        .buildDefaultProgressIndicator(),
                  );
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
                            '未找到符合要求的工厂',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )),
                    ],
                  );
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((item) {
                      return FactoryItem(
                        model: item,
                        requirementCode: widget.requirementCode,
                        showButton: widget.showButton,
                        isLocalFind: widget.isLocalFind,
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
//                if (snapshot.data) {
//                  _scrollController.animateTo(
//                    _scrollController.offset - 70,
//                    duration: new Duration(milliseconds: 500),
//                    curve: Curves.easeOut,
//                  );
//                }

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
