import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/home/factory/condition_page.dart';
import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:b2b_commerce/src/home/search/quick_reaction_factory_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FactoryPage extends StatefulWidget {
  FactoryPage(
    this.factoryCondition, {
    this.route,
    this.requirementCode,
  });

  final String route;

  // 邀请工厂报价的需求订单号
  final String requirementCode;
  final FactoryCondition factoryCondition;

  _FactoryPageState createState() => _FactoryPageState();
}

class _FactoryPageState extends State<FactoryPage> {
  final GlobalKey _factoryBLoCProviderKey = GlobalKey();

  List<FilterConditionEntry> filterConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '综合', value: 'comprehensive', checked: true),
    FilterConditionEntry(label: '星级', value: 'starLevel'),
    FilterConditionEntry(label: '接单数', value: 'orderNum'),
  ];

  FilterConditionEntry currentCondition = FilterConditionEntry(
    label: '综合',
    value: 'comprehensive',
    checked: true,
  );

  void changeCondition(FilterConditionEntry condition) {
    setState(() {
      currentCondition = condition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<FactoryBLoC>(
        key: _factoryBLoCProviderKey,
        bloc: FactoryBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text(
              widget.route ?? '全部工厂',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              QuickReactionFactoryButton(),
            ],
          ),
          body: Scaffold(
              appBar: AppBar(
                elevation: 0,
                bottom: FilterBar(
                  onChanged: (condition) => changeCondition(condition),
                  filterConditionEntries: filterConditionEntries,
                  action: ConditionPageButton(
                    factoryCondition: widget.factoryCondition,
                    requirementCode: widget.requirementCode,
                  ),
                ),
              ),
              body: FactoryListView(
                factoryCondition: widget.factoryCondition,
                showButton: widget.requirementCode != null,
                requirementCode: widget.requirementCode,
              )),
        ));
  }
}

class QuickReactionFactoryButton extends StatelessWidget {
  const QuickReactionFactoryButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        B2BIcons.search,
        size: 22,
      ),
      onPressed: () => showSearch(
            context: context,
            delegate: QuickReactionFactorySearchDelegate(),
          ),
    );
  }
}

class ConditionPageButton extends StatelessWidget {
  final String requirementCode;
  const ConditionPageButton({Key key, @required this.factoryCondition,this.requirementCode}) : super(key: key);

  final FactoryCondition factoryCondition;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () async {
        await ProductRepositoryImpl().majorCategories().then((categories) async {
          FactoryCondition newFactoryCondition = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ConditionPage(
                    categories: categories,
                    factoryCondition: factoryCondition,
                  ),
            ),
          );

          ///条件更新数据
          FactoryBLoC.instance.filterByCondition(newFactoryCondition,requirementCode: requirementCode,);
        });
      },
    );
  }
}

class FactoryListView extends StatefulWidget {
  FactoryListView({this.showButton = false, this.factoryCondition,this.requirementCode});

  final FactoryCondition factoryCondition;

  final String requirementCode;

  final bool showButton;

  @override
  State<StatefulWidget> createState() => _FactoryListViewState();
}

class _FactoryListViewState extends State<FactoryListView> {
  final ScrollController _scrollController = ScrollController();

  /// 当前选中条件
  FilterConditionEntry currentCondition = FilterConditionEntry(
    label: '综合',
    value: 'comprehensive',
    checked: true,
  );

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<FactoryBLoC>(context);

    // 监听筛选条件更改
    bloc.conditionStream.listen((condition) {
      currentCondition = condition;
      // 清空数据
      bloc.clear();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByCondition(
          widget.factoryCondition,
          condition: currentCondition.value,
          isDESC: currentCondition.isDESC,
          requirementCode: widget.requirementCode,
        );
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
              builder: (BuildContext context, AsyncSnapshot<List<FactoryModel>> snapshot) {
                if (snapshot.data == null) {
                  // 默认条件查询
                  bloc.filterByCondition(
                    widget.factoryCondition,
                    condition: this.currentCondition.value,
                    isDESC: this.currentCondition.isDESC,
                    requirementCode: widget.requirementCode,
                  );

                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 200),
                    child: ProgressIndicatorFactory.buildDefaultProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((item) {
                      return FactoryItem(
                        model: item,
                        requirementCode: widget.requirementCode,
                        showButton: widget.showButton,
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
                  _scrollController.animateTo(
                    _scrollController.offset - 70,
                    duration: new Duration(milliseconds: 500),
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
