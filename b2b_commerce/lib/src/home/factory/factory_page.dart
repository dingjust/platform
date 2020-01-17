import 'dart:convert';

import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/_shared/widgets/category_selector.dart';
import 'package:b2b_commerce/src/_shared/widgets/filter_condition_selector.dart';
import 'package:b2b_commerce/src/_shared/widgets/region_city_selector.dart'
as yj;
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/home/factory/condition_page.dart';
import 'package:b2b_commerce/src/my/address/amap_search_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import 'factory_list.dart';

class FactoryPage extends StatefulWidget {
  FactoryPage(
    this.factoryCondition, {
    this.route,
    this.requirementCode,
    this.categories,
    this.labels,
  });

  final List<CategoryModel> categories;

  List<LabelModel> labels;

  String route;

  // 邀请工厂报价的需求订单号
  final String requirementCode;
  final FactoryCondition factoryCondition;

  _FactoryPageState createState() => _FactoryPageState();
}

class _FactoryPageState extends State<FactoryPage> {
  final GlobalKey _factoryBLoCProviderKey = GlobalKey();

  FactoryCondition factoryCondition;

  List<FilterConditionEntry> filterConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '综合', value: '', checked: true),
    FilterConditionEntry(label: '星级', value: 'starLevel'),
    FilterConditionEntry(label: '接单数', value: 'totalOrdersCount'),
  ];

  FilterConditionEntry currentCondition = FilterConditionEntry(
    label: '综合',
    value: '',
    checked: true,
  );

  FilterConditionEntry currentLocalCondition = FilterConditionEntry();

  List<FilterConditionEntry> cooperationfilterEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '全部', value: null, checked: true),
    FilterConditionEntry(
        label:
        '${CooperationModesLocalizedMap[CooperationModes.LIGHT_PROCESSING]}',
        value: CooperationModes.LIGHT_PROCESSING),
    FilterConditionEntry(
        label:
        '${CooperationModesLocalizedMap[CooperationModes.LABOR_AND_MATERIAL]}',
        value: CooperationModes.LABOR_AND_MATERIAL),
  ];

  bool isLocalFind = false;

  bool inited = false;

  AMapLocation aMapLocation;

  List<String> historyKeywords;

  bool lock = false;

  List<String> _dropDownHeaderItemStrings = ['综合', '全国', '品类', '筛选'];
  GZXDropdownMenuController _dropdownMenuController =
  GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    if (widget.factoryCondition != null) {
      if (widget.route == '就近找厂') {
        isLocalFind = true;
        factoryCondition = FactoryCondition(
          starLevel: 0,
          adeptAtCategories: [],
          labels: [],
          cooperationModes: [],
        );
      } else {
        factoryCondition = widget.factoryCondition;
      }
    } else {
      if (widget.route == '就近找厂') {
        isLocalFind = true;
        factoryCondition = FactoryCondition(
          starLevel: 0,
          adeptAtCategories: [],
          labels: [],
          cooperationModes: [],
        );
      } else {
        factoryCondition = FactoryCondition(
            starLevel: 0,
            adeptAtCategories: [],
            labels: [],
            cooperationModes: []);
      }
    }
    super.initState();
    if (widget.route == '就近找厂') {
      _dropDownHeaderItemStrings[1] = '加工方式';
    }
  }

  @override
  void dispose() {
    //注意这里关闭
    AMapLocationClient.shutdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<FactoryBLoC>(
        key: _factoryBLoCProviderKey,
        bloc: FactoryBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            automaticallyImplyLeading: false,
            elevation: 0.5,
            title: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      size: 32,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      String jsonStr = await LocalStorage.get(
                          GlobalConfigs.FACTORY_HISTORY_KEYWORD_KEY);
                      if (jsonStr != null && jsonStr != '') {
                        List<dynamic> list = json.decode(jsonStr);
                        historyKeywords =
                            list.map((item) => item as String).toList();
                      } else {
                        historyKeywords = [];
                      }
                      String result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchModelPage(
                            searchModel: SearchModel(
                              historyKeywords: historyKeywords,
                              keyword: factoryCondition.keyword,
                              searchModelType: SearchModelType.FACTORY,
                              factoryCondition: factoryCondition,
                              route: GlobalConfigs.FACTORY_HISTORY_KEYWORD_KEY,
                            ),
                          ),
                        ),
                      );
//                      String keyword = await showSearch(
//                        context: context,
//                        delegate: FactorySearchDelegate(),
//                      );
//                      factoryCondition.setKeyword(keyword);
//                      FactoryBLoC.instance.clear();
                    },
                    child: Container(
                      height: 28,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey[300], width: 0.5),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(B2BIcons.search,
                              color: Colors.grey, size: 18),
                          Text(
                            '   ${generateTitle()}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              GestureDetector(
                child: widget.route == '就近找厂'
                    ? Consumer<AmapState>(
                        builder: (context, state, _) => Container(
                            width: state.city != null &&
                                    state.city != '' &&
                                    state.city.length < 5
                                ? (15 * state.city.length + 5).toDouble()
                                : 80,
                            child: Center(
                                child: Text(
                              '${state.city != null ? state.city : ''}',
                              overflow: TextOverflow.ellipsis,
                            ))),
                      )
                    : Container(),
                onTap: () {
                  if (widget.route == '就近找厂') {
                    onLocation();
                  }
                },
              ),
              GestureDetector(
                child: widget.route == '就近找厂'
                    ? Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.location_on,
                        ),
                      )
                    : Container(),
                onTap: () {
                  if (widget.route == '就近找厂') {
                    onLocation();
                  }
                },
              ),
            ],
          ),
          body: FutureBuilder<bool>(
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (inited) {
                return Scaffold(
                    key: _scaffoldKey,
                    endDrawer: Drawer(
                      child: ConditionPage(
                        factoryCondition: factoryCondition,
                        categories: widget.categories,
                        labels: widget.labels,
                      ),
                    ),
                    body: Stack(
                      key: _stackKey,
                      fit: StackFit.expand,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GZXDropDownHeader(
                              items: [
                                GZXDropDownHeaderItem(
                                    _dropDownHeaderItemStrings[0]),
                                GZXDropDownHeaderItem(
                                    _dropDownHeaderItemStrings[1]),
                                GZXDropDownHeaderItem(
                                    _dropDownHeaderItemStrings[2]),
                                GZXDropDownHeaderItem(
                                    _dropDownHeaderItemStrings[3],
                                    iconData: Icons.menu,
                                    iconSize: 18),
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
                                child: FactoryListView(
                                  factoryCondition: factoryCondition,
                                  showButton: widget.requirementCode != null,
                                  requirementCode: widget.requirementCode,
                                  currentCondition: currentCondition,
                                  currentLocalCondition: currentLocalCondition,
                                  isLocalFind: isLocalFind,
                                ))
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
                                    dropDownHeight:
                                    40.0 * filterConditionEntries.length + 20,
                                    dropDownWidget: FilterConditionSelector(
                                      // cancell: () {},
                                        entries: filterConditionEntries,
                                        callBack: (entry) =>
                                            _onConditionSelect(entry)),
                                  ),
                                  widget.route == '就近找厂'
                                      ? GZXDropdownMenuBuilder(
                                    dropDownHeight:
                                    40.0 * filterConditionEntries.length +
                                        20,
                                    dropDownWidget: FilterConditionSelector(
                                      // cancell: () {},
                                        entries: cooperationfilterEntries,
                                        callBack: (entry) =>
                                            _cooperationModeSelect(entry)),
                                  )
                                      : GZXDropdownMenuBuilder(
                                    dropDownHeight: 40 * 8.0,
                                    dropDownWidget: yj.RegionCitySelector(
                                        cancell: () {},
                                        maximum: 1,
                                        callBack: (region, cities) =>
                                            _onCitySelect(region, cities)),
                                  ),
                                  GZXDropdownMenuBuilder(
                                      dropDownHeight: 40 * 8.0,
                                      dropDownWidget: Builder(
                                        builder: (selectContext) =>
                                            CategorySelector(
                                                callBack: (category) =>
                                                    _onCategorySelect(
                                                        category)),
                                      )),
                                ],
                              ),
                        )
                      ],
                    ));
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
            // initialData: null,
            future: _initData(),
          ),
        ));
  }

  void onLocation() async {
    AmapState amapState = Provider.of<AmapState>(context);
    // Tip tip = await showSearch(context: context, delegate: AmapSearchDelegatePage());
    Tip tip = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
    setState(() {
      factoryCondition.longitude = amapState.longitude;
      factoryCondition.latitude = amapState.latitude;

      FactoryBLoC.instance.filterByCondition(
        factoryCondition,
        requirementCode: widget.requirementCode,
      );
    });
  }

  Future<bool> _initData() async {
    AmapState amapState = Provider.of<AmapState>(context);

    if (!inited && !lock) {
      lock = true;
      if (widget.factoryCondition != null) {
        if (widget.route == '就近找厂') {
          isLocalFind = true;
          // _initLocation();
          factoryCondition = FactoryCondition(
            starLevel: 0,
            adeptAtCategories: [],
            labels: [],
            cooperationModes: [],
            longitude: amapState.longitude,
            latitude: amapState.latitude,
          );
        } else {
          factoryCondition = widget.factoryCondition;
        }
      } else {
        if (widget.route == '就近找厂') {
          isLocalFind = true;
          // _initLocation();
          factoryCondition = FactoryCondition(
            starLevel: 0,
            adeptAtCategories: [],
            labels: [],
            cooperationModes: [],
            longitude: amapState.longitude,
            latitude: amapState.latitude,
          );
        } else {
          factoryCondition = FactoryCondition(
              starLevel: 0,
              adeptAtCategories: [],
              labels: [],
              cooperationModes: []);
        }
      }
      setState(() {
        inited = true;
      });
      lock = false;
    }
    return inited;
  }

  String generateTitle() {
    if (factoryCondition.keyword == null || factoryCondition.keyword == '') {
      return widget.route ?? '全部工厂';
    } else {
      return '${factoryCondition.keyword}';
    }
  }

  void _onConditionSelect(FilterConditionEntry entry) {
    _dropdownMenuController.hide();
    setState(() {
      currentCondition = entry;
      _dropDownHeaderItemStrings[0] = entry.label;
    });
    FactoryBLoC.instance.clear();
  }

  void _onCitySelect(RegionModel region, List<CityModel> cities) {
    _dropdownMenuController.hide();
    setState(() {
      factoryCondition.productiveOrientations = region;
      if (region != null) {
        if (cities != null && cities.length > 0) {
          _dropDownHeaderItemStrings[1] = cities.first.name;
        } else
          _dropDownHeaderItemStrings[1] = region.name;
      } else {
        _dropDownHeaderItemStrings[1] = '全国';
      }
      factoryCondition.cities = cities;
    });
    FactoryBLoC.instance.clear();
  }

  void _onCategorySelect(CategoryModel category) {
    _dropdownMenuController.hide();

    setState(() {
      if (category == null) {
        _dropDownHeaderItemStrings[2] = '品类';
        factoryCondition.adeptAtCategories = null;
      } else {
        factoryCondition.adeptAtCategories = [category];
        _dropDownHeaderItemStrings[2] = category.name;
      }
    });
    FactoryBLoC.instance.clear();
  }

  void _cooperationModeSelect(FilterConditionEntry entry) {
    _dropdownMenuController.hide();
    setState(() {
      if (entry.value == null) {
        _dropDownHeaderItemStrings[1] = '加工方式';
        factoryCondition.cooperationModes = [];
      } else {
        _dropDownHeaderItemStrings[1] = '${entry.label}';
        factoryCondition.cooperationModes = [entry.value];
      }
    });
    FactoryBLoC.instance.clear();
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
