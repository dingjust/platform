import 'dart:convert';

import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_search_delegate_page.dart';
import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/orders/quote_order_detail.dart';
import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:b2b_commerce/src/business/search/search_model.dart';
import 'package:b2b_commerce/src/home/factory/factory_item.dart';
import 'package:b2b_commerce/src/home/pool/requirement_quote_order_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

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

  bool showDateFilterMenu = false;
  bool showMachineTypeFilterMenu = false;
  bool showCategoriesFilterMenu = false;

  List<CategoryModel> _minCategorySelect = [];

  String filterBarLabel = '综合排序';
  String _newReleaseSelectText = '最新发布';
  String _machineTypeSelectText = '加工方式';
  String _majorCategorySelectText = '面料类别';
  String _productionAreaSelectText = '生产地区';

  ///当前选中条件
  RequirementFilterCondition currentCondition;

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

  List<String> historyKeywords;

  @override
  void initState() {
    // TODO: implement initState
    categoriesConditionEntries.addAll(widget.categories
        .map((category) =>
            FilterConditionEntry(label: category.name, value: category))
        .toList());

    if (widget.requirementFilterCondition != null) {
      currentCondition = widget.requirementFilterCondition;
    } else {
      currentCondition = RequirementFilterCondition(
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
                onPressed: (){
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return RequestDataLoading(
                          requestCallBack: LocalStorage.get(GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY),
                          outsideDismiss: false,
                          loadingText: '加载中。。。',
                          entrance: '',
                        );
                      }
                  ).then((value){
                    if (value != null && value != '') {
                      List<dynamic> list = json.decode(value);
                      historyKeywords = list.map((item) => item as String).toList();

                    } else {
                      historyKeywords = [];
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchModelPage(historyKeywords: historyKeywords,
                          searchModel: SearchModel.REQUIREMENT_QUOTE,requirementCondition: currentCondition,),
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
            appBar: AppBar(
              elevation: 0,
              bottom: RequirementFilterBar(
                entries: [
                  FilterEntry(_newReleaseSelectText, () {
                    setState(() {
                      showDateFilterMenu = !showDateFilterMenu;
                      showCategoriesFilterMenu = false;
                      showMachineTypeFilterMenu = false;
                    });
                  }),
                  FilterEntry(_machineTypeSelectText, () {
                    setState(() {
                      showMachineTypeFilterMenu = !showMachineTypeFilterMenu;
                      showCategoriesFilterMenu = false;
                      showDateFilterMenu = false;
                    });
                  }),
                  FilterEntry(_majorCategorySelectText, () {
                    setState(() {
                      showCategoriesFilterMenu = !showCategoriesFilterMenu;
                      showDateFilterMenu = false;
                      showMachineTypeFilterMenu = false;
                    });
                  }),
                  FilterEntry(_productionAreaSelectText, () {
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
//                          return StatefulBuilder(builder: (context, mSetState) {
                            return RegionSelector(
                              regions: _regions,
                              regionSelects: _regionSelects,
                            );
//                          });
                        },
                      ).then((val) {
                        setState(() {
                          if (_regionSelects.length > 0) {
                            _productionAreaSelectText = _regionSelects[0].name;
                            currentCondition.productiveOrientations =
                                _regionSelects;
                          } else {
                            _productionAreaSelectText = '生产地区';
                            currentCondition.productiveOrientations = null;
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
                  height: showDateFilterMenu ? 200 : 0,
                  entries: dateRangeConditionEntries,
                  streamController:
                      RequirementPoolBLoC.instance.conditionController,
                  afterPressed: (String str) {
                    setState(() {
                      if(str == '全部'){
                        _newReleaseSelectText = '最新发布';
                      }else{
                        _newReleaseSelectText = str;
                      }
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
                      if(str == '全部'){
                        _machineTypeSelectText = '加工方式';
                      }else{
                        _machineTypeSelectText = str;
                      }
                      showMachineTypeFilterMenu = !showMachineTypeFilterMenu;
                    });
                  },
                ),
                FilterSelectMenu(
                  color: Color.fromRGBO(255, 214, 12, 1),
                  height: showCategoriesFilterMenu ? 350 : 0,
                  entries: categoriesConditionEntries,
                  multipeSelect: false,
                  streamController:
                      RequirementPoolBLoC.instance.conditionController,
                  afterPressed: (String str) {
                    setState(() {
                      if(str == '全部'){
                        _majorCategorySelectText = '面料类别';
                      }else{
                        _majorCategorySelectText = str;
                      }

                      showCategoriesFilterMenu = !showCategoriesFilterMenu;
                    });
                  },
                ),
                Expanded(
                  child: OrdersListView(
                    currentCondition: currentCondition,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  String generateTitle() {
    if (currentCondition.keyword == null || currentCondition.keyword == '') {
      return '全部需求';
    } else {
      return '${currentCondition.keyword}';
    }
  }
}

class OrdersListView extends StatelessWidget {
  ScrollController _scrollController = ScrollController();

  final RequirementFilterCondition currentCondition;

  OrdersListView({Key key, this.currentCondition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<RequirementPoolBLoC>(context);

    //监听筛选条件更改
    bloc.conditionStream.listen((condition) {
      if (condition.value is RequirementOrderDateRange && condition.checked) {
        currentCondition.dateRange = condition.value;
      }

      if (condition.value is MachiningType && condition.checked) {
        currentCondition.machiningType = condition.value;
      }

      if (condition.value is CategoryModel) {
        if (condition.checked) {
          if (!currentCondition.categories.contains(condition.value)) {
            currentCondition.categories.add(condition.value);
          }
        } else {
          currentCondition.categories.remove(condition.value);
        }
      }

      if (condition.value == "ALL2") {
        currentCondition.categories.clear();
      }

      if (condition.value == "ALL1") {
        currentCondition.machiningType = null;
      }

      // bloc.filterByCondition(currentCondition);
      bloc.clear();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByCondition(currentCondition, false);
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
                    bloc.filterByCondition(currentCondition, false);
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
                  // if (snapshot.data) {
                  //   _scrollController.animateTo(_scrollController.offset - 70,
                  //       duration: new Duration(milliseconds: 500),
                  //       curve: Curves.easeOut);
                  // }
                  return ScrolledToEndTips(
                    hasContent: snapshot.data,
                    scrollController: _scrollController,
                  );
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

class RequirementPoolOrderItem extends StatelessWidget {
  const RequirementPoolOrderItem({Key key, this.order, this.pageContext})
      : super(key: key);

  final RequirementOrderModel order;

  final BuildContext pageContext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //根据code查询明
        RequirementOrderModel model = await RequirementOrderRepository()
            .getRequirementOrderDetail(order.code);

        List<QuoteModel> quotes = await RequirementOrderRepository()
            .getRequirementOrderQuotes(code: model.code, page: 0, size: 1);

        if (model != null) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RequirementOrderDetailPage(
                    order: model,
                    quotes: quotes,
                  )));
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: <Widget>[_buildEntries(context)],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
      ),
    );
  }

  Widget _buildEntries(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildRow1(),
                  _buildRow2(context),
                  _buildRow3()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: _buildTag(order.labels ?? []),
        ),
        Text(
          '${order.details.productName ?? order.details.category?.name}',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildRow2(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  '${order.details.category?.name}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  '${order.details.expectedMachiningQuantity ?? 0}件',
                  style: TextStyle(
                      fontSize: 15, color: Color.fromRGBO(255, 149, 22, 1)),
                ),
              ),
              // Text(
              //   '${DateExpressUtil.express(order.modifiedTime)}',
              //   style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
              // ),
            ],
          ),
        ),
        // order.details.maxExpectedPrice != null
        //     ? RichText(
        //         text: TextSpan(
        //             text: '￥',
        //             style: TextStyle(color: Color.fromRGBO(255, 45, 45, 1)),
        //             children: <TextSpan>[
        //               TextSpan(
        //                   text: '${order.details.maxExpectedPrice}',
        //                   style: TextStyle(fontSize: 18))
        //             ]),
        //       )
        //     : Container(),

        GestureDetector(
          onTap: () async {
            QuoteModel newQuote =
                await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RequirementQuoteOrderForm(
                          model: order,
                          quoteModel: QuoteModel(attachments: []),
                        )));

            if (newQuote != null) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QuoteOrderDetailPage(item: newQuote)));
            }
          },
          child: Container(
            height: 25,
            width: 65,
            margin: EdgeInsets.only(left: 50),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(255, 214, 12, 1)),
            child: Center(
              child: Text('去报价'),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRow3() {
    return Row(
      children: <Widget>[
        Logo(
          order: order,
        ),
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${order.belongTo.name}',
                  overflow: TextOverflow.ellipsis,
                ),
                order.belongTo.approvalStatus == ArticleApprovalStatus.approved
                    ? Tag(
                        label: '  已认证  ',
                        color: Color.fromRGBO(255, 133, 148, 1),
                        backgroundColor: Color.fromRGBO(255, 243, 243, 1),
                      )
                    : Container(),
                Text(
                  '${DateExpressUtil.express(order.modifiedTime)}',
                  style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
                ),
              ],
            )),
        // Container(
        //   margin: EdgeInsets.only(left: 10),
        //   padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
        //   decoration: BoxDecoration(
        //       color: Color.fromRGBO(255, 243, 243, 1),
        //       borderRadius: BorderRadius.circular(10)),
        //   child: Text(
        //     "已认证",
        //     style: TextStyle(
        //         fontSize: 15, color: Color.fromRGBO(255, 133, 148, 1)),
        //   ),
        // )
      ],
    );
  }

  List<Widget> _buildTag(List<LabelModel> labels) {
    List<Widget> tags = [];
    labels.where((label) => label.group == 'ORDER').forEach((label) {
      tags.add(Tag(
        label: '${label.name}',
        color: Colors.black,
        backgroundColor: Color.fromRGBO(255, 214, 12, 1),
      ));
    });
    return tags;
  }
}

class Logo extends StatelessWidget {
  final RequirementOrderModel order;

  const Logo({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _logo;
    if (order.belongTo.profilePicture == null) {
      _logo = Container(
        width: 20,
        height: 20,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Color.fromRGBO(243, 243, 243, 1)),
        child: Icon(
          B2BIcons.noPicture,
          color: Color.fromRGBO(200, 200, 200, 1),
          size: 10,
        ),
      );
    } else {
      _logo = Container(
        width: 20,
        height: 20,
        child: CachedNetworkImage(
            imageUrl: '${order.belongTo.profilePicture.previewUrl()}',
            fit: BoxFit.cover,
            placeholder: (context, url) => SpinKitRing(
                  color: Colors.black12,
                  lineWidth: 2,
                  size: 30,
                ),
            errorWidget: (context, url, error) => SpinKitRing(
                  color: Colors.black12,
                  lineWidth: 2,
                  size: 30,
                )),
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
      );
    }
    return _logo;
  }
}
