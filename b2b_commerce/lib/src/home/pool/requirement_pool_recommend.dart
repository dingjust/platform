import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/search/requirement_order_search.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class RequirementPoolRecommend extends StatefulWidget {
  final List<CategoryModel> categories;

  RequirementPoolRecommend({this.categories});

  ///当前选中条件
  final RequirementFilterCondition currentCodition = RequirementFilterCondition(
      categories: [],
      dateRange: RequirementOrderDateRange.ALL,
      machiningType: null);

  _RequirementPoolRecommendState createState() =>
      _RequirementPoolRecommendState();
}

class _RequirementPoolRecommendState extends State<RequirementPoolRecommend> {
  GlobalKey _FactoryBLoCProviderKey = GlobalKey();

  bool showDateFilterMenu = false;
  bool showMachineTypeFilterMenu = false;
  bool showCategoriesFilterMenu = false;

  List<CategoryModel> _minCategorySelect = [];

  String filterBarLabel = '综合排序';

  List<FilterConditionEntry> dateRangeConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(
        label: '全部', value: RequirementOrderDateRange.ALL, checked: true),
    FilterConditionEntry(
        label: '3天内', value: RequirementOrderDateRange.RANGE_3),
    FilterConditionEntry(
        label: '7天内', value: RequirementOrderDateRange.RANGE_7),
    FilterConditionEntry(
        label: '15天内', value: RequirementOrderDateRange.RANGE_15),
  ];

  List<FilterConditionEntry> machiningTypeConditionEntries =
      <FilterConditionEntry>[
    FilterConditionEntry(label: '全部', value: "ALL1", checked: true),
    FilterConditionEntry(
        label: '包工包料', value: MachiningType.LABOR_AND_MATERIAL),
    FilterConditionEntry(label: '清加工', value: MachiningType.LIGHT_PROCESSING),
  ];

  List<FilterConditionEntry> categoriesConditionEntries =
      <FilterConditionEntry>[
    FilterConditionEntry(label: '全部', value: "ALL2", checked: true),
  ];

  @override
  void initState() {
    // TODO: implement initState
    categoriesConditionEntries.addAll(widget.categories
        .map((category) =>
            FilterConditionEntry(label: category.name, value: category))
        .toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<RequirementPoolBLoC>(
        key: _FactoryBLoCProviderKey,
        bloc: RequirementPoolBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text(
              '推荐需求',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.search,
                  size: 22,
                ),
                onPressed: () => showSearch(
                    context: context,
                    delegate: RequirementOrderSearchDelegate()),
              ),
            ],
          ),
          body: Scaffold(
            appBar: AppBar(
              elevation: 0,
              bottom: RequirementFilterBar(
                entries: [
                  FilterEntry('最新发布', () {
                    setState(() {
                      showDateFilterMenu = !showDateFilterMenu;
                      showCategoriesFilterMenu = false;
                      showMachineTypeFilterMenu = false;
                    });
                  }),
                  FilterEntry('加工方式', () {
                    setState(() {
                      showMachineTypeFilterMenu = !showMachineTypeFilterMenu;
                      showCategoriesFilterMenu = false;
                      showDateFilterMenu = false;
                    });
                  }),
                  FilterEntry('面料类别', () {
                    setState(() {
                      showCategoriesFilterMenu = !showCategoriesFilterMenu;
                      showDateFilterMenu = false;
                      showMachineTypeFilterMenu = false;
                    });
                  })
                ],
                action: IconButton(
                  icon: Icon(
                    B2BIcons.menu,
                    size: 15,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            body: Column(
              children: <Widget>[
                FilterSelectMenu(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  height: showDateFilterMenu ? 150 : 0,
                  entries: dateRangeConditionEntries,
                  streamController:
                      RequirementPoolBLoC.instance.conditionController,
                  afterPressed: (String str) {
                    setState(() {
                      showDateFilterMenu = !showDateFilterMenu;
                    });
                  },
                ),
                FilterSelectMenu(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  height: showMachineTypeFilterMenu ? 150 : 0,
                  entries: machiningTypeConditionEntries,
                  streamController:
                      RequirementPoolBLoC.instance.conditionController,
                  afterPressed: (String str) {
                    setState(() {
                      showMachineTypeFilterMenu = !showMachineTypeFilterMenu;
                    });
                  },
                ),
                FilterSelectMenu(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  height: showCategoriesFilterMenu ? 250 : 0,
                  entries: categoriesConditionEntries,
                  multipeSelect: true,
                  streamController:
                      RequirementPoolBLoC.instance.conditionController,
                  afterPressed: (String str) {
                    setState(() {
                      showCategoriesFilterMenu = !showCategoriesFilterMenu;
                    });
                  },
                ),
                Expanded(
                  child: OrdersListView(
                    currentCodition: widget.currentCodition,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class OrdersListView extends StatelessWidget {
  ScrollController _scrollController = ScrollController();

  final RequirementFilterCondition currentCodition;

  OrdersListView({Key key, this.currentCodition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<RequirementPoolBLoC>(context);

    //监听筛选条件更改
    bloc.conditionStream.listen((condition) {
      if (condition.value is RequirementOrderDateRange && condition.checked) {
        currentCodition.dateRange = condition.value;
      }

      if (condition.value is MachiningType && condition.checked) {
        currentCodition.machiningType = condition.value;
      }

      if (condition.value is CategoryModel) {
        if (condition.checked) {
          if (!currentCodition.categories.contains(condition.value)) {
            currentCodition.categories.add(condition.value);
          }
        } else {
          currentCodition.categories.remove(condition.value);
        }
      }

      if (condition.value == "ALL2") {
        currentCodition.categories.clear();
      }

      if (condition.value == "ALL1") {
        currentCodition.machiningType = null;
      }

      // bloc.filterByCondition(currentCodition);
      bloc.clear();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByCondition(currentCodition, true);
      }
    });

    return Container(
        decoration: BoxDecoration(color: Colors.white),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RefreshIndicator(
          onRefresh: () async {
            bloc.clear();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              StreamBuilder<List<RequirementOrderModel>>(
                stream: bloc.stream,
                initialData: null,
                builder: (BuildContext context,
                    AsyncSnapshot<List<RequirementOrderModel>> snapshot) {
                  if (snapshot.data == null) {
                    //默认条件查询
                    bloc.filterByCondition(currentCodition, true);
                    return ProgressIndicatorFactory
                        .buildPaddedProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((item) {
                        return RequirementPoolOrderItem(
                          order: item,
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
                    _scrollController.animateTo(_scrollController.offset - 70,
                        duration: new Duration(milliseconds: 500),
                        curve: Curves.easeOut);
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
        ));
  }
}
