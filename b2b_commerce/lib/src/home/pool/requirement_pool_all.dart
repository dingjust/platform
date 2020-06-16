import 'dart:convert';

import 'package:b2b_commerce/src/_shared/widgets/filter_condition_selector.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_umplus/flutter_umplus.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'requirement_pool_order_list.dart';

class RequirementPoolAllPage extends StatefulWidget {
  final List<CategoryModel> categories;

  RequirementPoolAllPage({
    Key key,
    this.categories,
    this.requirementFilterCondition,
  });

  final RequirementFilterCondition requirementFilterCondition;

  _RequirementPoolAllPageState createState() => _RequirementPoolAllPageState();
}

class _RequirementPoolAllPageState extends State<RequirementPoolAllPage> {
  GlobalKey _FactoryBLoCProviderKey = GlobalKey();

  ///当前选中条件
  RequirementFilterCondition currentCondition;

  List<FilterConditionEntry> sortConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '综合', value: 'ALL0', checked: true),
    FilterConditionEntry(label: '订单数量', value: 'expectedMachiningQuantity'),
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

  List<String> _dropDownHeaderItemStrings = ['综合', '加工方式', '商品大类'];
  GZXDropdownMenuController _dropdownMenuController =
  GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    if (widget.categories != null) {
      categoriesConditionEntries.addAll(widget.categories
          .map((category) =>
          FilterConditionEntry(label: category.name, value: category))
          .toList());
    }

    if (widget.requirementFilterCondition != null) {
      currentCondition = widget.requirementFilterCondition;
    } else {
      currentCondition = RequirementFilterCondition(
          categories: [],
          dateRange: RequirementOrderDateRange.ALL,
          machiningType: null);
    }

    //埋点>>>需求中心
    FlutterUmplus.event(
      "requirement_center",
    );

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
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return RequestDataLoading(
                          requestCallBack: LocalStorage.get(
                              GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY),
                          outsideDismiss: false,
                          loadingText: '加载中。。。',
                          entrance: '',
                        );
                      }).then((value) {
                    if (value != null && value != '') {
                      List<dynamic> list = json.decode(value);
                      historyKeywords =
                          list.map((item) => item as String).toList();
                    } else {
                      historyKeywords = [];
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchModelPage(
                          searchModel: SearchModel(
                              historyKeywords: historyKeywords,
                              searchModelType:
                              SearchModelType.REQUIREMENT_QUOTE,
                              requirementCondition: currentCondition,
                              route: GlobalConfigs
                                  .Requirement_HISTORY_KEYWORD_KEY),
                        ),
                      ),
                    );
                  });
                },
//                onPressed: () => showSearch(
//                    context: context,
//                    delegate: RequirementOrderSearchDelegatePage()),
              ),
            ],
          ),
          body: Scaffold(
              key: _scaffoldKey,
              body: Stack(key: _stackKey, fit: StackFit.expand, children: <
                  Widget>[
                Column(
                  children: <Widget>[
                    GZXDropDownHeader(
                      items: [
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0]),
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[1]),
                        GZXDropDownHeaderItem(_dropDownHeaderItemStrings[2]),
                      ],
                      stackKey: _stackKey,
                      controller: _dropdownMenuController,
                      // onItemTap: (index) {
                      // },
                      dividerHeight: 0,
                      color: Colors.grey[100],
                      dropDownStyle:
                      TextStyle(fontSize: 13, color: Colors.orange),
                      iconDropDownColor: Colors.orange,
                    ),
                    Expanded(
                      flex: 1,
                      child: OrdersListView(
                        currentCondition: currentCondition,
                      ),
                    )
                  ],
                ),
                Builder(
                  builder: (dropMenuContext) =>
                      GZXDropDownMenu(
                        controller: _dropdownMenuController,
                        // 下拉菜单显示或隐藏动画时长
                        animationMilliseconds: 0,
                        menus: [
                          GZXDropdownMenuBuilder(
                            dropDownHeight: 40.0 * sortConditionEntries.length +
                                20,
                            dropDownWidget: FilterConditionSelector(
                              // cancell: () {},
                                entries: sortConditionEntries,
                                callBack: (entry) =>
                                    _onSortConditionSelect(entry)),
                          ),
                          GZXDropdownMenuBuilder(
                            dropDownHeight:
                            40.0 * machiningTypeConditionEntries.length + 20,
                            dropDownWidget: FilterConditionSelector(
                              // cancell: () {},
                                entries: machiningTypeConditionEntries,
                                callBack: (entry) =>
                                    _onSortConditionSelect(entry)),
                          ),
                          GZXDropdownMenuBuilder(
                            dropDownHeight:
                            40.0 * categoriesConditionEntries.length + 20,
                            dropDownWidget: FilterConditionSelector(
                              // cancell: () {},
                                entries: categoriesConditionEntries,
                                callBack: (entry) =>
                                    _onSortConditionSelect(entry)),
                          ),
                        ],
                      ),
                )
              ])),
        ));
  }

  void _onSortConditionSelect(FilterConditionEntry condition) {
    _dropdownMenuController.hide();

    if (condition.value is RequirementOrderDateRange) {
      currentCondition.dateRange = condition.value;
      _dropDownHeaderItemStrings[0] = condition.label;
    }

    if (condition.value is MachiningType) {
      currentCondition.machiningType = condition.value;
      _dropDownHeaderItemStrings[1] = condition.label;
    }

    if (condition.value is CategoryModel) {
      currentCondition.categories = [condition.value];
      _dropDownHeaderItemStrings[2] = condition.label;
    }

    if (condition.value == "ALL2") {
      currentCondition.categories.clear();
      _dropDownHeaderItemStrings[2] = '商品大类';
    }

    if (condition.value == "ALL1") {
      currentCondition.machiningType = null;
      _dropDownHeaderItemStrings[1] = '加工方式';
    }

    if (condition.value == "ALL0") {
      currentCondition.sortCondition = null;
      _dropDownHeaderItemStrings[0] = '综合';
    }

    if (condition.value == "expectedMachiningQuantity" ||
        condition.value == "expectedDeliveryDate") {
      currentCondition.sortCondition = condition.value;
      _dropDownHeaderItemStrings[0] = '${condition.label}';
    }

    setState(() {});
    RequirementPoolBLoC.instance.clear();
  }

  String generateTitle() {
    if (currentCondition.keyword == null || currentCondition.keyword == '') {
      return '全部需求';
    } else {
      return '${currentCondition.keyword}';
    }
  }
}
