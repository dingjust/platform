import 'dart:convert';

import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/my/address/amap_search_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:provider/provider.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FindingFactoryPage extends StatefulWidget {
  FindingFactoryPage(
    this.factoryCondition, {
    this.route,
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
  String _categorySelectText = '分类';
  String _areaSelectText = '地区';
  String _localSelectText = '50公里内';

  List<CategoryModel> _category;
  List<CategoryModel> _categorySelected = [];

  List<RegionModel> _regions = [];
  RegionModel _regionSelect = RegionModel();
  List<CityModel> _citySelects = [];

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

  ScrollController _scrollController = ScrollController();

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
  }

  void changeCondition(FilterConditionEntry condition) {
    setState(() {
      currentCondition = condition;
    });
    FactoryBLoC.instance.clear();
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
              backgroundColor: Constants.THEME_COLOR_MAIN,
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
                            builder: (context) =>
                                SearchModelPage(
                                  searchModel: SearchModel(
                                    historyKeywords: historyKeywords,
                                    keyword: factoryCondition.keyword,
                                    searchModelType: SearchModelType.FACTORY,
                                    factoryCondition: factoryCondition,
                                    route:
                                    GlobalConfigs.FACTORY_HISTORY_KEYWORD_KEY,
                                  ),
                                ),
                          ),
                        );
                      },
                      child: Container(
                        height: 28,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border:
                          Border.all(color: Colors.grey[300], width: 0.5),
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
            ),
            body: DefaultTabController(
              length: 1,
              child: FutureBuilder<bool>(
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (inited) {
                    return Scaffold(
                      // endDrawer: Drawer(
                      //   child: ConditionPage(
                      //     factoryCondition: factoryCondition,
                      //     categories: majorCategories,
                      //     labels: labels,
                      //   ),
                      // ),
                      body: NestedScrollView(
                        headerSliverBuilder: _sliverBuilder,
                        controller: _scrollController,
                        body: FactoryListView(
                          factoryCondition: factoryCondition,
                          showButton: widget.requirementCode != null,
                          requirementCode: widget.requirementCode,
                          currentCondition: currentCondition,
                          currentLocalCondition: currentLocalCondition,
                          isLocalFind: isLocalFind,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                // initialData: null,
                future: _initData(),
              ),
            )));
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
          backgroundColor: Colors.grey[100],
          expandedHeight: 130,
          leading: Container(),
          pinned: false,
          flexibleSpace: _BtnsBar()),
      SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            AppBar(
              elevation: 0,
              title: RequirementFilterBar(
                horizontalPadding: 10,
                entries: [
                  FilterEntry('${labText}⇂', () {
                    setState(() {
                      showDateFilterMenu = !showDateFilterMenu;
                    });
                  }),
                  widget.route == '就近找厂'
                      ? FilterEntry(_localSelectText, () {
                    setState(() {
                      showLocalFilterMenu = !showLocalFilterMenu;
                      showDateFilterMenu = true;
                    });
                  })
                      : FilterEntry(_areaSelectText, () {
                    //获取所有省份
                    rootBundle.loadString('data/province.json').then((v) {
                      List data = json.decode(v);
                      _regions = data
                          .map<RegionModel>(
                              (region) => RegionModel.fromJson(region))
                          .toList();

                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            //地区选择器
                            return RegionCitySelector(
                              regions: _regions,
                              regionSelect: _regionSelect,
                              citySelects: _citySelects,
                            );
                          }).then((a) {
                        setState(() {
                          if (_regionSelect.isocode != null) {
                            _areaSelectText = _regionSelect.name;
                          } else {
                            _areaSelectText = '地区';
                          }

                          factoryCondition.productiveOrientations =
                              _regionSelect;
                          factoryCondition.cities = _citySelects;
                          FactoryBLoC.instance.filterByCondition(
                            factoryCondition,
                            requirementCode: widget.requirementCode,
                          );
                        });
                      });
                    });
                  }),
                  FilterEntry(_categorySelectText, () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          child: CategorySelect(
                            categories: _category,
                            multiple: false,
                            verticalDividerOpacity: 1,
                            categorySelect: _categorySelected,
                            categoryActionType: CategoryActionType.TO_POP,
                          ),
                        );
                      },
                    ).then((a) {
                      setState(() {
                        if (_categorySelected.isEmpty) {
                          factoryCondition.categories = null;
                          _categorySelectText = '分类';
                        } else {
                          _categorySelectText = _categorySelected[0].name;
                          factoryCondition.adeptAtCategories =
                              _categorySelected;
                        }
                        FactoryBLoC.instance.filterByCondition(
                          factoryCondition,
                          requirementCode: widget.requirementCode,
                        );
                      });
                    });
                    setState(() {
                      showDateFilterMenu = true;
                      showLocalFilterMenu = true;
                    });
                  }),
                ],
                action: Container(),
              ),
              automaticallyImplyLeading: false,
            ),
          )),
    ];
  }

  void onLocation() async {
    // Tip tip = await showSearch(context: context, delegate: AmapSearchDelegatePage());
    AmapState amapState = Provider.of<AmapState>(context);

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
      majorCategories = await ProductRepositoryImpl().majorCategories();
      labels = await UserRepositoryImpl().labels();
      labels = labels
          .where(
              (label) => label.group == 'FACTORY' || label.group == 'PLATFORM')
          .toList();
      aMapLocation = await AmapService.instance.location();
      _category = await ProductRepositoryImpl().cascadedCategories();
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
              distance: 50000);
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
              distance: 50000);
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
      return widget.route ?? '全部工厂';
    } else {
      return '${factoryCondition.keyword}';
    }
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._appBar);

  final AppBar _appBar;

  @override
  double get minExtent => _appBar.preferredSize.height + 10;

  @override
  double get maxExtent => _appBar.preferredSize.height + 10;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: _appBar,
        ),
        SizedBox(
          height: 10,
          child: Container(
            color: Colors.grey[Constants.SIZEDBOX_COLOR],
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _BtnsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildFree(context),
            _buildAuthentication(context),
            _buildFast(context),
            _buildAll(context)
          ],
        ),
      ),
    );
  }

  Widget _buildAll(BuildContext context) {
    return _IconButton(
      icon: Icon(
        B2BIcons.factory_all,
        color: Color.fromRGBO(148, 161, 246, 1.0),
        size: 30,
      ),
      title: '全部工厂',
      onPressed: () async {
        List<CategoryModel> categories =
        await Provider.of<MajorCategoryState>(context).getMajorCategories();
        List<LabelModel> labels =
        await Provider.of<LabelState>(context).getLabels();
        labels = labels
            .where((label) =>
        label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();
//        labels.add(LabelModel(name: '已认证', id: 1000000));
        if (categories != null && labels != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FactoryPage(
                    FactoryCondition(
                        starLevel: 0,
                        adeptAtCategories: [],
                        labels: [],
                        cooperationModes: []),
                    route: '全部工厂',
                    categories: categories,
                    labels: labels,
                  ),
            ),
          );
        }
      },
    );
  }

  Widget _buildFree(BuildContext context) {
    return _IconButton(
      icon: Icon(
        B2BIcons.clothes,
        color: Colors.lightBlue,
        size: 30,
      ),
      title: '免费打样',
      onPressed: () async {
        List<CategoryModel> categories =
        await Provider.of<MajorCategoryState>(context).getMajorCategories();
        List<LabelModel> labels =
        await Provider.of<LabelState>(context).getLabels();
        labels = labels
            .where((label) =>
        label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();
//        labels.add(LabelModel(name: '已认证', id: 1000000));
        if (categories != null && labels != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FactoryPage(
                    FactoryCondition(
                        starLevel: 0,
                        adeptAtCategories: [],
                        labels: [],
                        cooperationModes: []),
                    route: '免费打样',
                    categories: categories,
                    labels: labels,
                  ),
            ),
          );
        }
      },
    );
  }

  Widget _buildAuthentication(BuildContext context) {
    return _IconButton(
      icon: Icon(
        B2BIcons.authentication,
        color: Colors.lightGreen,
        size: 30,
      ),
      title: '认证工厂',
      onPressed: () async {
        List<CategoryModel> categories =
        await Provider.of<MajorCategoryState>(context).getMajorCategories();
        List<LabelModel> labels =
        await Provider.of<LabelState>(context).getLabels();
        labels = labels
            .where((label) =>
        label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();
//        labels.add(LabelModel(name: '已认证', id: 1000000));
        if (categories != null && labels != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FactoryPage(
                    FactoryCondition(
                        starLevel: 0,
                        adeptAtCategories: [],
                        labels: [],
                        cooperationModes: []),
                    route: '认证工厂',
                    categories: categories,
                    labels: labels,
                  ),
            ),
          );
        }
      },
    );
  }

  Widget _buildFast(BuildContext context) {
    return _IconButton(
      icon: Icon(
        B2BIcons.thunder,
        color: Color.fromRGBO(212, 35, 122, 1.0),
        size: 30,
      ),
      title: '快反工厂',
      onPressed: () async {
        List<CategoryModel> categories =
        await Provider.of<MajorCategoryState>(context).getMajorCategories();
        List<LabelModel> labels =
        await Provider.of<LabelState>(context).getLabels();
        labels = labels
            .where((label) =>
        label.group == 'FACTORY' || label.group == 'PLATFORM')
            .toList();
//        labels.add(LabelModel(name: '已认证', id: 1000000));
        if (categories != null && labels != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  FactoryPage(
                    FactoryCondition(
                        starLevel: 0,
                        adeptAtCategories: [],
                        labels: [],
                        cooperationModes: []),
                    route: '快反工厂',
                    categories: categories,
                    labels: labels,
                  ),
            ),
          );
        }
      },
    );
  }
}

class _IconButton extends StatelessWidget {
  @required
  final VoidCallback onPressed;

  @required
  final String title;

  @required
  final Icon icon;

  const _IconButton({Key key, this.onPressed, this.title, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: FlatButton(
        onPressed: onPressed,
        child: Column(
          children: <Widget>[
            Expanded(flex: 1, child: icon),
            Container(
              child: Text(
                '$title',
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
