import 'dart:convert';

import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/home/factory/condition_page.dart';
import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:b2b_commerce/src/my/address/amap_search_page.dart';
import 'package:b2b_commerce/src/my/company/_shared/factory_list_item.dart';
import 'package:b2b_commerce/src/my/company/_shared/factory_no_selected_list_item.dart';
import 'package:b2b_commerce/src/my/company/_shared/factory_selected_list_item.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FactorySelectPage extends StatefulWidget {
  FactorySelectPage({
    this.factoryCondition,
    this.categories,
    this.labels,
    this.factoryModels,
  });

  List<FactoryModel> factoryModels;

  final List<CategoryModel> categories;

  List<LabelModel> labels;

  final FactoryCondition factoryCondition;

  _FactorySelectPageState createState() => _FactorySelectPageState();
}

class _FactorySelectPageState extends State<FactorySelectPage> {
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

  bool isLocalFind = false;

  bool inited = false;

  List<String> historyKeywords;

  bool lock = false;

  List<CategoryModel> _majorCategories;
  List<LabelModel> _labels;
  List<FactoryModel> _factorySelectModels = [];

  @override
  void initState() {
    if(widget.factoryModels != null){
      _factorySelectModels = List.from(widget.factoryModels);
    }

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
  void dispose() {
    //注意这里关闭
//    AMapLocationClient.shutdown();
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
                      String jsonStr = await LocalStorage.get(GlobalConfigs.FACTORY_HISTORY_KEYWORD_KEY);
                        if (jsonStr != null && jsonStr != '') {
                          List<dynamic> list = json.decode(jsonStr);
                          historyKeywords = list.map((item) => item as String).toList();
                        } else {
                          historyKeywords = [];
                        }
                        String result=await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchModelPage(
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
            ],
          ),
          bottomNavigationBar: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 50,
            child: RaisedButton(
              color: Color.fromRGBO(255, 214, 12, 1),
              child: Text(
                '确定',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              onPressed: (){
                Navigator.pop(context,_factorySelectModels);
              },
            ),
          ),
          body: FutureBuilder<bool>(
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (inited) {
                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    title: RequirementFilterBar(
                      horizontalPadding: 10,
                      entries: [
                        FilterEntry('${labText}⇂', () {
                          setState(() {
                            showDateFilterMenu = !showDateFilterMenu;
                          });
                        }),
                        FilterEntry(_areaSelectText, () {
                          //获取所有省份
                          rootBundle
                              .loadString('data/province.json')
                              .then((v) {
                            List data = json.decode(v);
                            _regions = data
                                .map<RegionModel>((region) =>
                                RegionModel.fromJson(region))
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
                  endDrawer: Drawer(
                    child: ConditionPage(
                      factoryCondition: factoryCondition,
                      categories: _majorCategories,
                      labels: _labels,
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
                              for (int i = 0;
                              i < filterConditionEntries.length;
                              i++) {
                                if (str == filterConditionEntries[i].label) {
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
                              for (int i = 0;
                              i < filterLocalEntries.length;
                              i++) {
                                if (str == filterLocalEntries[i].label) {
                                  currentLocalCondition = filterLocalEntries[i];
                                }
                              }
                              factoryCondition.distance =
                                  double.parse(currentLocalCondition.value);
//                          print(currentLocalCondition.value);
//                          changeCondition(currentLocalCondition);
//                        currentCondition
                              showLocalFilterMenu = !showLocalFilterMenu;
                              FactoryBLoC.instance.filterByCondition(
                                factoryCondition,
                              );
                            });
                          },
                        ),
                      ),
                      Expanded(
                          child: FactorySelectListView(
                            factoryCondition: factoryCondition,
                            currentCondition: currentCondition,
                            currentLocalCondition: currentLocalCondition,
                            factoryModels: _factorySelectModels,
                          ))
                    ],
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
        ));
  }

  Future<bool> _initData() async {
    _majorCategories = await ProductRepositoryImpl().majorCategories();
    _labels = await UserRepositoryImpl().labels();
    _labels = _labels
        .where((label) =>
    label.group == 'FACTORY' || label.group == 'PLATFORM')
        .toList();

    if (!inited && !lock) {
      lock = true;
      print('----------------------');
      _category = await ProductRepositoryImpl().cascadedCategories();
      print(isLocalFind);
      if (widget.factoryCondition != null) {
        factoryCondition = widget.factoryCondition;
      } else {
          factoryCondition = FactoryCondition(
              starLevel: 0,
              adeptAtCategories: [],
              labels: [],
              cooperationModes: []);
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
      return '全部工厂';
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

class FactorySelectListView extends StatefulWidget {
  FactorySelectListView({
        this.factoryCondition,
        this.factoryModels,
        this.currentLocalCondition,
        @required this.currentCondition});

  FactoryCondition factoryCondition;
  List<FactoryModel> factoryModels;


  /// 当前选中头部排序条件
  FilterConditionEntry currentCondition;

  //距离排序
  FilterConditionEntry currentLocalCondition;

  @override
  State<StatefulWidget> createState() => _FactorySelectListViewState();
}

class _FactorySelectListViewState extends State<FactorySelectListView> {
  final ScrollController _scrollController = ScrollController();

  List<String> _factoryUids = [];

  @override
  void initState() {
    // TODO: implement initState
    if(widget.factoryModels != null){
      _factoryUids = widget.factoryModels.map((model) => model.uid).toList();
    }

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
        if (widget.currentLocalCondition != null) {
          bloc.loadingMoreByCondition(
            widget.factoryCondition,
            condition: widget.currentCondition.value,
            sort: widget.currentCondition.isDESC ? 'desc' : 'asc',
          );
        } else {
          bloc.loadingMoreByCondition(
            widget.factoryCondition,
            condition: widget.currentCondition.value,
            sort: widget.currentCondition.isDESC ? 'desc' : 'asc',
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
                          )),
                    ],
                  );
                }
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.map((item) {
                      return Container(
                        margin: EdgeInsets.all(15),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              if(_factoryUids.contains(item.uid)){
                                _factoryUids.remove(item.uid);
                                widget.factoryModels.removeWhere((model) => model.uid == item.uid);
                              }else{
                                widget.factoryModels.add(item);
                                _factoryUids.add(item.uid);
                              }
                            });
                            print('${_factoryUids}------');
                            print(widget.factoryModels);
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: ShapeDecoration(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),color: Colors.white,),
                            child: _factoryUids .contains(item.uid) ? FactorySelectedListItem(
                              model: item,
                            ) : FactoryNoSelectedListItem(
                              model: item,
                            ),
                          ),
                        ),
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
//                if (snapshot.data) {
//                  _scrollController.animateTo(
//                    _scrollController.offset - 70,
//                    duration: new Duration(milliseconds: 500),
//                    curve: Curves.easeOut,
//                  );
//                }

                return ScrolledToEndTips(hasContent: snapshot.data,scrollController: _scrollController,);
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
