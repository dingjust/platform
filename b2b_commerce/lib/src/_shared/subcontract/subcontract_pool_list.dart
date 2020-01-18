import 'package:b2b_commerce/src/_shared/subcontract/subcontract_pool_list_item.dart';
import 'package:b2b_commerce/src/_shared/widgets/filter_condition_selector.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_pool_detail.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_pool_filter.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class SubContractPoolList extends StatefulWidget {
  final SubContractPoolState subContractPoolState;

  SubContractPoolList({Key key, this.subContractPoolState}) : super(key: key);

  _SubContractPoolListState createState() => _SubContractPoolListState();
}

class _SubContractPoolListState extends State<SubContractPoolList> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<RegionModel> _regionSelects = [];
  List<RegionModel> _regions = [];

  bool showDateFilterMenu = false;

  List<FilterConditionEntry> sortConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '综合', value: 'ALL0', checked: true),
    FilterConditionEntry(label: '订单数量', value: 'subContractQuantity'),
    FilterConditionEntry(label: '交货时间', value: 'expectedDeliveryDate'),
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

  List<String> historyKeywords;

  List<String> _dropDownHeaderItemStrings = ['综合', '加工方式', '商品大类', '筛选'];
  GZXDropdownMenuController _dropdownMenuController =
  GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, SubContractPoolState subContractPoolState, _) =>
          Scaffold(
              key: _scaffoldKey,
              endDrawer: Drawer(
                child: SubContractFilterPage(
                    subContractPoolState: subContractPoolState),
              ),
              body: Stack(key: _stackKey, fit: StackFit.expand, children: <
                  Widget>[
                Column(
                  children: <Widget>[
                    GZXDropDownHeader(
                      items: [
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0]),
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[1]),
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[2]),
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[3],
                            iconData: Icons.menu, iconSize: 18),
                      ],
                      stackKey: _stackKey,
                      controller: _dropdownMenuController,
                      onItemTap: (index) {
                        if (index == 3) {
                          _scaffoldKey.currentState.openEndDrawer();
                        }
                      },
                      dividerHeight: 0,
                      color: Colors.grey[100],
                      dropDownStyle:
                      TextStyle(fontSize: 13, color: Colors.orange),
                      iconDropDownColor: Colors.orange,
                    ),
                    Expanded(
                      flex: 1,
                      child: subContractPoolState.subcontractModels != null
                          ? SubContractListView(
                          subContractPoolState: subContractPoolState)
                          : Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ],
                ),
                FutureBuilder(
                  future: Provider.of<MajorCategoryState>(context)
                      .getMajorCategories(),
                  builder: (BuildContext dropMenuContext,
                      AsyncSnapshot<List<CategoryModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (categoriesConditionEntries.length == 1) {
                        categoriesConditionEntries.addAll(snapshot.data
                            .map((category) =>
                            FilterConditionEntry(
                                label: category.name, value: category))
                            .toList());
                      }
                      return Consumer(
                        builder: (BuildContext dropMenuContext,
                            MajorCategoryState majorCategoryState, _) =>
                            GZXDropDownMenu(
                              controller: _dropdownMenuController,
                              // 下拉菜单显示或隐藏动画时长
                              animationMilliseconds: 0,
                              menus: [
                                GZXDropdownMenuBuilder(
                                  dropDownHeight:
                                  40.0 * sortConditionEntries.length + 20,
                                  dropDownWidget: FilterConditionSelector(
                                      entries: sortConditionEntries,
                                      callBack: (entry) =>
                                          _onSortConditionSelect(
                                              entry, subContractPoolState)),
                                ),
                                GZXDropdownMenuBuilder(
                                  dropDownHeight:
                                  40.0 * machiningTypeConditionEntries.length +
                                      20,
                                  dropDownWidget: FilterConditionSelector(
                                      entries: machiningTypeConditionEntries,
                                      callBack: (entry) =>
                                          _onSortConditionSelect(
                                              entry, subContractPoolState)),
                            ),
                                GZXDropdownMenuBuilder(
                                  dropDownHeight:
                                  40.0 * categoriesConditionEntries.length + 20,
                                  dropDownWidget: FilterConditionSelector(
                                      entries: categoriesConditionEntries,
                                      callBack: (entry) =>
                                          _onSortConditionSelect(
                                              entry, subContractPoolState)),
                                ),
                              ],
                            ),
                      );
                    }
                  },
                ),
              ])),
    );
  }

  void _onSortConditionSelect(FilterConditionEntry condition,
      SubContractPoolState subContractPoolState) {
    _dropdownMenuController.hide();

    // if (condition.value is RequirementOrderDateRange && condition.checked) {
    //   currentCondition.dateRange = condition.value;
    //   _dropDownHeaderItemStrings[0] = condition.label;
    // }

    if (condition.value == "ALL1") {
      subContractPoolState.machiningType = null;
      _dropDownHeaderItemStrings[1] = '加工方式';
    }

    if (condition.value is MachiningType) {
      subContractPoolState.machiningType = EnumUtil.getCode(condition.value);
      _dropDownHeaderItemStrings[1] = condition.label;
    }
    // subContractPoolState.majorCategory = snapshot.data[index];

    if (condition.value == "ALL2") {
      subContractPoolState.majorCategory = null;
      _dropDownHeaderItemStrings[2] = '商品大类';
    }

    if (condition.value is CategoryModel) {
      subContractPoolState.majorCategory = condition.value;
      _dropDownHeaderItemStrings[2] = condition.label;
    }

    if (condition.value == "ALL0") {
      subContractPoolState.setSortCondition(null);
      _dropDownHeaderItemStrings[0] = '综合';
    }

    if (condition.value == "subContractQuantity" ||
        condition.value == "expectedDeliveryDate") {
      subContractPoolState.setSortCondition(condition.value);
      _dropDownHeaderItemStrings[0] = '${condition.label}';
    }
    //刷新
    subContractPoolState.clear();
    setState(() {});
  }
}

class SubContractListView extends StatefulWidget {
  SubContractPoolState subContractPoolState;
  SubContractListView({this.subContractPoolState});
  _SubCOntractListViewState createState() => _SubCOntractListViewState();
}

class _SubCOntractListViewState extends State<SubContractListView> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        widget.subContractPoolState.showTopBtn = false;
      } else if (_scrollController.offset >= 500) {
        widget.subContractPoolState.showTopBtn = true;
      }
    });

    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.subContractPoolState.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.subContractPoolState.clear();
      },
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        children: <Widget>[
          _buildItems(),
          ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
            opacity: widget.subContractPoolState.loadingMore ? 1.0 : 0,
          ),
          _buildEnd(),
        ],
      ),
    );
  }

  Widget _buildItems() {
    return Column(
        children: widget.subContractPoolState.subcontractModels.map((model) {
          return _buildRow(model);
        }).toList());
  }

  Widget _buildRow(SubContractModel model) {
    return Column(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SubContractPoolDetailPage(model.code)));
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15.0),
            child: SubContractPoolListItem(
              model: model,
            ),
          ),
        ),
        Divider(
          height: 0,
        )
      ],
    );
  }

  Widget _buildEnd() {
    return widget.subContractPoolState.isDownEnd
        ? Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '(￢_￢)已经到底了',
            style: TextStyle(color: Colors.grey),
          )
        ],
      ),
    )
        : Container();
  }
}
