import 'dart:convert';

import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_search_delegate_page.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/home/pool/requirement_pool_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class RequirementPoolRecommend extends StatefulWidget {
  final List<CategoryModel> categories;

  RequirementPoolRecommend({this.categories, this.requirementFilterCondition});

  final RequirementFilterCondition requirementFilterCondition;

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

  ///当前选中条件
  RequirementFilterCondition currentCodition;

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
    FilterConditionEntry(
        label: '全部',
        value: "ALL1",
        type: FilterConditionEntryType.ALL,
        checked: true),
    FilterConditionEntry(
        label: '包工包料', value: MachiningType.LABOR_AND_MATERIAL),
    FilterConditionEntry(label: '清加工', value: MachiningType.LIGHT_PROCESSING),
  ];

  List<FilterConditionEntry> categoriesConditionEntries =
      <FilterConditionEntry>[
    FilterConditionEntry(
        label: '全部',
        value: "ALL2",
        type: FilterConditionEntryType.ALL,
        checked: true),
  ];

  List<RegionModel> _regionSelects = [];
  List<String> _regionCodeSelects = [];
  List<RegionModel> _regions = [];

  @override
  void initState() {
    //获取所有省份
    rootBundle.loadString('data/province.json').then((v) {
      List data = json.decode(v);
      _regions = data
          .map<RegionModel>((region) => RegionModel.fromJson(region))
          .toList();
    });
    // TODO: implement initState
    categoriesConditionEntries.addAll(widget.categories
        .map((category) =>
            FilterConditionEntry(label: category.name, value: category))
        .toList());

    if (widget.requirementFilterCondition != null) {
      currentCodition = widget.requirementFilterCondition;
    } else {
      currentCodition = RequirementFilterCondition(
          categories: [],
          dateRange: RequirementOrderDateRange.ALL,
          machiningType: null);
    }
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
              '${generateTitle()}',
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
                    delegate:
                        RequirementOrderSearchDelegatePage(isRecommend: true)),
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
                  }),
                  FilterEntry('生产地区', () {
                    setState(() {
//                      showAreaFilterMenu = !showAreaFilterMenu;
                      showDateFilterMenu = false;
                      showMachineTypeFilterMenu = false;
                      showCategoriesFilterMenu = false;
                    });
                    //获取所有省份
                    rootBundle.loadString('data/province.json').then((v) {
                      List data = json.decode(v);
                      _regions = data
                          .map<RegionModel>(
                              (region) => RegionModel.fromJson(region))
                          .toList();

                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(builder: (context, mSetState) {
                            return Container(
                              color: Colors.white,
                              height: 360,
                              child: Column(
                                children: <Widget>[
                                  Card(
                                    elevation: 2,
                                    margin: EdgeInsets.only(bottom: 3),
//                        color: Colors.grey[300],
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            mSetState(() {
                                              _regionCodeSelects.clear();
                                              _regionSelects.clear();
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Text('重置'),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: ActionChip(
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            ),
                                            label: Text('确定'),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 300,
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      children: _regions.map((region) {
                                        return InkWell(
                                          onTap: () {
                                            mSetState(() {
                                              if (_regionCodeSelects
                                                  .contains(region.isocode)) {
                                                _regionCodeSelects
                                                    .remove(region.isocode);
                                                _regionSelects.removeWhere(
                                                    (reg) =>
                                                        region.isocode ==
                                                        reg.isocode);
                                              } else {
                                                _regionSelects.add(region);
                                                _regionCodeSelects
                                                    .add(region.isocode);
                                              }
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 1),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: _regionCodeSelects
                                                      .contains(region.isocode)
                                                  ? Color.fromRGBO(
                                                      255, 214, 12, 1)
                                                  : Colors.white,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 0, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(region.name),
//                                    Offstage(
//                                      offstage: !_regionCodeSelects
//                                          .contains(region.isocode),
//                                      child: Icon(
//                                        Icons.done,
//                                        size: 12,
//                                      ),
//                                    )
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        },
                      ).then((val) {
                        setState(() {
                          if (_regionSelects.length > 0) {
                            currentCodition.productiveOrientations =
                                _regionSelects;
                          } else {
                            currentCodition.productiveOrientations = null;
                          }
                          RequirementPoolBLoC.instance.clear();
                        });
                      });
                    });
                  }),
                ],
                action: Container(),
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
                    currentCodition: currentCodition,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  String generateTitle() {
    if (currentCodition.keyword == null || currentCodition.keyword == '') {
      return '推荐需求';
    } else {
      return '${currentCodition.keyword}';
    }
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
                  if (snapshot.data.length >= 0) {
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
                            child: Text('您还没有收到推荐的需求')
                        ),
                        Container(
                            child: Text('小钉正在拼命为您寻找')
                        ),
                      ],
                    );
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
