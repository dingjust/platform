import 'dart:convert';

import 'package:amap_location/amap_location.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/home/factory/condition_page.dart';
import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:b2b_commerce/src/home/search/factory_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  AMapLocation aMapLocation;

  @override
  void initState() {
    print(isLocalFind);
    if (widget.factoryCondition != null) {
      if(widget.route == '就近找厂'){
        isLocalFind = true;
        _initLocation();
        factoryCondition = FactoryCondition(
            starLevel: 0,
            adeptAtCategories: [],
            labels: [],
            cooperationModes: [],
            longitude : 113.32106,
            latitude : 23.10625,
            distance : 50000);
      }else{
        factoryCondition = widget.factoryCondition;
      }
    } else {
      if(widget.route == '就近找厂'){
        isLocalFind = true;
        _initLocation();
        factoryCondition = FactoryCondition(
            starLevel: 0,
            adeptAtCategories: [],
            labels: [],
            cooperationModes: [],
            longitude : 113.32106,
            latitude : 23.10625,
            distance : 50000);
      }else{
        factoryCondition = FactoryCondition(
            starLevel: 0,
            adeptAtCategories: [],
            labels: [],
            cooperationModes: []);
      }
    }
    getCategories();

    super.initState();
  }

//  void _checkPersmission() async{
//    bool hasPermission = await SimplePermissions.checkPermission(Permission.WhenInUseLocation);
//    if(!hasPermission){
//      bool requestPermissionResult = await SimplePermissions.requestPermission(Permission.WhenInUseLocation);
//      if(!requestPermissionResult){
//        Alert.alert(context,title: "申请定位权限失败");
//        return;
//      }
//    }
//    AMapLocationClient.onLocationUpate.listen((AMapLocation loc) {
//      if (!mounted) return;
//      setState(() {
//        location = getLocationStr(loc);
//      });
//    });
//
//    AMapLocationClient.startLocation();
//  }

  //初始化定位监听，
  void _initLocation() async {
    aMapLocation = await AmapService.instance.location();
  }

  getCategories()async{
    _category = await ProductRepositoryImpl().cascadedCategories();
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
                    FactoryBLoC.instance.clear();
                  }),
            ],
          ),
          body: Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: RequirementFilterBar(
                  horizontalPadding: 20,
                  entries: [
                    FilterEntry('${labText}⇂', () {
                      setState(() {
                        showDateFilterMenu = !showDateFilterMenu;
                      });
                    }),
                    FilterEntry(_categorySelectText, () async{
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
                            factoryCondition.adeptAtCategories = _categorySelected;
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
                    widget.route == '就近找厂'?
                    FilterEntry(
                      _localSelectText,(){
                      setState(() {
                        showLocalFilterMenu = !showLocalFilterMenu;
                        showDateFilterMenu = true;
                      });
                    }
                    ):
                    FilterEntry(_areaSelectText, () {
                      setState(() {
                        showDateFilterMenu = false;
                      });
                      //获取所有省份
                      rootBundle.loadString('data/province.json').then((v) {
                        List data = json.decode(v);
                        _regions = data
                            .map<RegionModel>((region) => RegionModel.fromJson(region))
                            .toList();

                        showModalBottomSheet(context: context, builder: (context){
                          //地区选择器
                          return RegionCitySelector(
                            regions: _regions,
                            regionSelect: _regionSelect,
                            citySelects: _citySelects,
                          );
                        }).then((a){
                          setState(() {
                            if(_regionSelect.isocode != null){
                              _areaSelectText = _regionSelect.name;
                            }else{
                              _areaSelectText = '地区';
                            }

                            factoryCondition.productiveOrientations = _regionSelect;
                            factoryCondition.cities = _citySelects;
                            FactoryBLoC.instance.filterByCondition(
                              factoryCondition,
                              requirementCode: widget.requirementCode,
                            );
                          });
                        });
                      });

                    }
                    )
                  ],
                  action: Container(),
                ),
                automaticallyImplyLeading: false,
              ),
              endDrawer: Drawer(
                child: ConditionPage(
                  factoryCondition: factoryCondition,
                  categories: widget.categories,
                  labels: widget.labels,
                ),
              ),
              body: Column(
                children: <Widget>[
                  Offstage(
                    offstage: showDateFilterMenu,
                    child: FilterSelectMenu(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      height: 150,
                      entries: filterConditionEntries,
                      streamController:
                      RequirementPoolBLoC.instance.conditionController,
                      afterPressed: (String str) {
                        print(str);
                        setState(() {
                          labText = str;
                          FilterConditionEntry selected;
                          for(int i =0;i<filterConditionEntries.length;i++){
                            if(str == filterConditionEntries[i].label){
                              currentCondition = filterConditionEntries[i];
                            }
                          }
                          changeCondition(currentCondition);
//                        currentCondition
                          showDateFilterMenu = !showDateFilterMenu;
                        });
                      },
                    ),
                  ),
                  Offstage(
                    offstage: showLocalFilterMenu,
                    child: FilterSelectMenu(
                      color: Color.fromRGBO(255, 214, 12, 1),
                      height: 150,
                      entries: filterLocalEntries,
                      streamController:
                      RequirementPoolBLoC.instance.conditionController,
                      afterPressed: (String str) {
                        print(str);
                        setState(() {
                          if(str == '全部'){
                            _localSelectText = '距离';
                          }else{
                            _localSelectText = str;
                          }
                          FilterConditionEntry selected;
                          for(int i =0;i<filterLocalEntries.length;i++){
                            if(str == filterLocalEntries[i].label){
                              currentLocalCondition = filterLocalEntries[i];
                            }
                          }
                          factoryCondition.distance = double.parse(currentLocalCondition.value);
//                          print(currentLocalCondition.value);
//                          changeCondition(currentLocalCondition);
//                        currentCondition
                          showLocalFilterMenu = !showLocalFilterMenu;
                          FactoryBLoC.instance.filterByCondition(
                            factoryCondition,
                            requirementCode: widget.requirementCode,
                          );
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: FactoryListView(
                      factoryCondition: factoryCondition,
                      showButton: widget.requirementCode != null,
                      requirementCode: widget.requirementCode,
                      currentCondition: currentCondition,
                      currentLocalCondition: currentLocalCondition,
                      isLocalFind: isLocalFind,
                    )
                  )
                ],
              ),
              ),
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
        this.currentLocalCondition,
        this.isLocalFind = false,
      @required this.currentCondition});

  FactoryCondition factoryCondition;

  final String requirementCode;

  final bool showButton;

  bool isLocalFind;

  /// 当前选中头部排序条件
  FilterConditionEntry currentCondition;

  //距离排序
  FilterConditionEntry currentLocalCondition;

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
        if(widget.currentLocalCondition != null){
          bloc.loadingMoreByCondition(
            widget.factoryCondition,
            condition: widget.currentCondition.value,
            sort: widget.currentCondition.isDESC ? 'desc' : 'asc',
            requirementCode: widget.requirementCode,
          );
        }else{
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
                          )
                      ),
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
