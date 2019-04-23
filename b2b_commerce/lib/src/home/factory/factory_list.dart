import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/home/factory/condition_page.dart';
import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:b2b_commerce/src/home/search/factory_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FactoryPage extends StatefulWidget {
  FactoryPage(
      this.factoryCondition, {
    this.route,
    this.requirementCode,
    this.categories,
        this.labels,
  });

  final List<CategoryModel> categories ;

  List<LabelModel> labels;

  final String route;

  // 邀请工厂报价的需求订单号
  final String requirementCode;
  final FactoryCondition factoryCondition;

  _FactoryPageState createState() => _FactoryPageState();
}

class _FactoryPageState extends State<FactoryPage> {
  final GlobalKey _factoryBLoCProviderKey = GlobalKey();

  FactoryCondition factoryCondition;

  List<FilterConditionEntry> filterConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '综合', value: 'comprehensive', checked: true),
    FilterConditionEntry(label: '星级', value: 'starLevel'),
    FilterConditionEntry(label: '接单数', value: 'totalOrdersCount'),
  ];

  FilterConditionEntry currentCondition = FilterConditionEntry(
    label: '综合',
    value: 'comprehensive',
    checked: true,
  );

  @override
  void initState() {
    if (widget.factoryCondition != null) {
      factoryCondition = widget.factoryCondition;
    } else {
      factoryCondition = FactoryCondition(
          starLevel: 0,
          adeptAtCategories: [],
          labels: [],
          cooperationModes: []);
    }

    super.initState();

  }

  void changeCondition(FilterConditionEntry condition) {
    setState(() {
      currentCondition = condition;
    });
    FactoryBLoC.instance.clear();
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
              '${generateTitle()}',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    B2BIcons.search,
                    size: 22,
                  ),
                  onPressed: () async {
                    String keyword = await showSearch(
                      context: context,
                      delegate: FactorySearchDelegate(),
                    );

                    factoryCondition.setKeyword(keyword);

                    print(factoryCondition.keyword);
                    FactoryBLoC.instance.clear();
                  }),
            ],
          ),
          body: Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: FilterBar(
                  onChanged: (condition) => changeCondition(condition),
                  filterConditionEntries: filterConditionEntries,
                  action: [
//                    ConditionPageButton(
//                      factoryCondition: factoryCondition,
//                      requirementCode: widget.requirementCode,
//                    )
                  ],
                ),
                  automaticallyImplyLeading: false,
              ),
              endDrawer: Drawer(
                child:  ConditionPage(
                    factoryCondition: factoryCondition,
                    categories: widget.categories,
                    labels: widget.labels,
                ),
              ),
              body: FactoryListView(
                factoryCondition: factoryCondition,
                showButton: widget.requirementCode != null,
                requirementCode: widget.requirementCode,
                currentCondition: currentCondition,
              )),
        ));
  }

  String generateTitle() {
    if (factoryCondition.keyword == null || factoryCondition.keyword == '') {
      return widget.route ?? '全部工厂';
    } else {
      return '${factoryCondition.keyword}';
    }
  }
}

class ConditionPageButton extends StatelessWidget {
  final String requirementCode;
  const ConditionPageButton(
      {Key key, @required this.factoryCondition, this.requirementCode})
      : super(key: key);

  final FactoryCondition factoryCondition;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: () async {
        await ProductRepositoryImpl()
            .majorCategories()
            .then((categories) async {
          FactoryCondition newFactoryCondition =
              await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ConditionPage(
                    factoryCondition: factoryCondition,
                  ),
            ),
          );

          ///条件更新数据
          FactoryBLoC.instance.filterByCondition(
            newFactoryCondition,
            requirementCode: requirementCode,
          );
        });
      },
    );
  }
}

class FactoryListView extends StatefulWidget {
  FactoryListView(
      {this.showButton = false,
      this.factoryCondition,
      this.requirementCode,
      @required this.currentCondition});

  FactoryCondition factoryCondition;

  final String requirementCode;

  final bool showButton;

  /// 当前选中头部排序条件
  FilterConditionEntry currentCondition;

  @override
  State<StatefulWidget> createState() => _FactoryListViewState();
}

class _FactoryListViewState extends State<FactoryListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
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
        bloc.loadingMoreByCondition(
          widget.factoryCondition,
          condition: widget.currentCondition.value,
          sort: widget.currentCondition.isDESC ? 'desc' : 'asc',
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
