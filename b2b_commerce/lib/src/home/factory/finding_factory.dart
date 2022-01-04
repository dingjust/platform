import 'dart:convert';

import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/_shared/widgets/category_selector.dart';
import 'package:b2b_commerce/src/_shared/widgets/filter_condition_selector.dart';
import 'package:b2b_commerce/src/_shared/widgets/region_city_selector.dart'
    as yj;
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/home/factory/condition_page.dart';
import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/my/address/amap_search_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '_shared/finding_factory_btns.dart';

class FindingFactoryPage extends StatefulWidget {
  FindingFactoryPage({
    this.factoryCondition,
    this.route = '输入工厂名称',
    this.requirementCode,
  });

  String route;

  // 邀请工厂报价的需求订单号
  final String requirementCode;
  final FactoryCondition factoryCondition;

  _FindingFactoryPageState createState() => _FindingFactoryPageState();
}

class _FindingFactoryPageState extends State<FindingFactoryPage> {
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

  bool showDateFilterMenu = true;
  bool showLocalFilterMenu = true;
  bool showMachineTypeFilterMenu = false;
  bool showCategoriesFilterMenu = false;

  String labText = '综合';

  List<FilterConditionEntry> filterLocalEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '50公里内', value: '50000', checked: true),
    FilterConditionEntry(label: '100公里内', value: '100000'),
    FilterConditionEntry(label: '200公里内', value: '200000'),
  ];
  double xLocal;
  double yLocal;

  bool isLocalFind = false;

  bool inited = false;

  AMapLocation aMapLocation;

  String addressLine;

  List<String> historyKeywords;

  bool lock = false;

  List<CategoryModel> majorCategories;

  List<LabelModel> labels;

  ScrollController _scrollController;
  ScrollController _factoryScrollController;

  List<String> _dropDownHeaderItemStrings = ['综合', '全国', '品类', '筛选'];
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    //页面统计
    // UmengPlugin.onPageStart('生产找厂');

    factoryCondition = FactoryCondition(
        starLevel: 0, adeptAtCategories: [], labels: [], cooperationModes: []);
    super.initState();

    //初始化滚动控制器
    _scrollController = ScrollController();
    _factoryScrollController = ScrollController();
    _factoryScrollController.addListener(() {
      _scrollController.jumpTo(_factoryScrollController.offset);
    });
  }

  @override
  void dispose() {
    //注意这里关闭
    AMapLocationClient.shutdown();
    //页面统计
    // UmengPlugin.onPageEnd('生产找厂');
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
                elevation: 0,
                title: _buildSearchBar()),
            body: DefaultTabController(
              length: 1,
              child: FutureBuilder<bool>(
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (inited) {
                    return Scaffold(
                        key: _scaffoldKey,
                        endDrawer: Drawer(
                          child: ConditionPage(
                            factoryCondition: factoryCondition,
                            categories: majorCategories,
                            labels: labels,
                          ),
                        ),
                        body: Stack(
                          key: _stackKey,
                          fit: StackFit.expand,
                          children: <Widget>[
                            NestedScrollView(
                                headerSliverBuilder: _sliverBuilder,
                                controller: _scrollController,
                                body: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  color: Color(0xffF7F7F7),
                                  child: FactoryListView(
                                    factoryCondition: factoryCondition,
                                    scrollController: _factoryScrollController,
                                    showButton: widget.requirementCode != null,
                                    requirementCode: widget.requirementCode,
                                    currentCondition: currentCondition,
                                    currentLocalCondition:
                                        currentLocalCondition,
                                    isLocalFind: isLocalFind,
                                  ),
                                )),
                            Builder(
                              builder: (dropMenuContext) => GZXDropDownMenu(
                                controller: _dropdownMenuController,
                                // 下拉菜单显示或隐藏动画时长
                                animationMilliseconds: 0,
                                menus: [
                                  GZXDropdownMenuBuilder(
                                    dropDownHeight:
                                        40.0 * filterConditionEntries.length +
                                            20,
                                    dropDownWidget: FilterConditionSelector(
                                        // cancell: () {},
                                        entries: filterConditionEntries,
                                        callBack: (entry) =>
                                            _onConditionSelect(entry)),
                                  ),
                                  GZXDropdownMenuBuilder(
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
                future: _initData(),
              ),
            )));
  }

  Widget _buildSearchBar() {
    return Row(
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
                historyKeywords = list.map((item) => item as String).toList();
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
            },
            child: Container(
              height: 28,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Color(0xffF0F0F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(B2BIconsV2.search,
                      color: Color(0xff999999), size: 16),
                  Text(
                    '   ${generateTitle()}',
                    style:
                    const TextStyle(color: Color(0xff999999), fontSize: 13),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
          backgroundColor: Colors.white,
          expandedHeight: 80,
          leading: Container(),
          actions: <Widget>[Container()],
          pinned: false,
          flexibleSpace: FindingFactoryBtnsBar()),
      SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            GZXDropDownHeader(
              items: [
                GZXDropDownHeaderItem(_dropDownHeaderItemStrings[0]),
                GZXDropDownHeaderItem(_dropDownHeaderItemStrings[1]),
                GZXDropDownHeaderItem(_dropDownHeaderItemStrings[2]),
                GZXDropDownHeaderItem(_dropDownHeaderItemStrings[3],
                    iconData: B2BIconsV2.filter, iconSize: 18),
              ],
              stackKey: _stackKey,
              controller: _dropdownMenuController,
              onItemTap: (index) {
                if (index == 3) {
                  _scaffoldKey.currentState.openEndDrawer();
                }
              },
              dividerHeight: 0,
              color: Colors.white,
              dropDownStyle: TextStyle(fontSize: 13, color: Colors.orange),
              iconDropDownColor: Colors.orange,
              borderWidth: 0,
            ),
          )),
    ];
  }

  void onLocation() async {
    // Tip tip = await showSearch(context: context, delegate: AmapSearchDelegatePage());
    Tip tip = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AmapSearchPage()));
    print(tip.name);
    setState(() {
      List<String> locationArray = tip.location.split(',');
      addressLine = tip.name;

      factoryCondition.longitude = double.parse(locationArray[0]);
      factoryCondition.latitude = double.parse(locationArray[1]);

      FactoryBLoC.instance.filterByCondition(
        factoryCondition,
        requirementCode: widget.requirementCode,
      );
    });
  }

  Future<bool> _initData() async {
    if (!inited && !lock) {
      lock = true;
      majorCategories =
      await Provider.of<MajorCategoryState>(context, listen: false)
          .getMajorCategories();
      labels =
      await Provider.of<LabelState>(context, listen: false).getLabels();
      labels = labels
          .where(
              (label) => label.group == 'FACTORY' || label.group == 'PLATFORM')
          .toList();

      if (widget.route == '就近找厂') {
        aMapLocation = await AmapService.instance.location();
      }

      if (widget.factoryCondition != null) {
        if (widget.route == '就近找厂') {
          isLocalFind = true;
          factoryCondition = FactoryCondition(
            starLevel: 0,
            adeptAtCategories: [],
            labels: [],
            cooperationModes: [],
            longitude: aMapLocation.longitude,
            latitude: aMapLocation.latitude,
          );
          addressLine = aMapLocation.AOIName ?? '广州';
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
            longitude: aMapLocation.longitude,
            latitude: aMapLocation.latitude,
          );
          addressLine = aMapLocation.AOIName ?? '广州';
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
      return widget.route ?? '输入工厂名称';
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
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this.child);

  final Widget child;

  @override
  double get minExtent => 40;

  @override
  double get maxExtent => 40;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
