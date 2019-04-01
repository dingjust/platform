import 'package:b2b_commerce/src/business/orders/requirement_order_detail.dart';
import 'package:b2b_commerce/src/business/search/requirement_order_search.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class RequirementPoolAllPage extends StatefulWidget {
  final List<CategoryModel> categories;

  RequirementPoolAllPage({
    Key key,
    this.categories,
  });

  ///当前选中条件
  final RequirementFilterCondition currentCodition =
      RequirementFilterCondition(categories: [], dateRange: RequirementOrderDateRange.ALL, machiningType: null);

  _RequirementPoolAllPageState createState() => _RequirementPoolAllPageState();
}

class _RequirementPoolAllPageState extends State<RequirementPoolAllPage> {
  GlobalKey _FactoryBLoCProviderKey = GlobalKey();

  bool showDateFilterMenu = false;
  bool showMachineTypeFilterMenu = false;
  bool showCategoriesFilterMenu = false;

  List<CategoryModel> _minCategorySelect = [];

  String filterBarLabel = '综合排序';

  List<FilterConditionEntry> dateRangeConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '全部', value: RequirementOrderDateRange.ALL, checked: true),
    FilterConditionEntry(label: '3天内', value: RequirementOrderDateRange.RANGE_3),
    FilterConditionEntry(label: '7天内', value: RequirementOrderDateRange.RANGE_7),
    FilterConditionEntry(label: '15天内', value: RequirementOrderDateRange.RANGE_15),
  ];

  List<FilterConditionEntry> machiningTypeConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '全部', value: "ALL1", checked: true),
    FilterConditionEntry(label: '包工包料', value: MachiningType.LABOR_AND_MATERIAL),
    FilterConditionEntry(label: '清加工', value: MachiningType.LIGHT_PROCESSING),
  ];

  List<FilterConditionEntry> categoriesConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '全部', value: "ALL2", checked: true),
  ];

  @override
  void initState() {
    // TODO: implement initState
    categoriesConditionEntries.addAll(
        widget.categories.map((category) => FilterConditionEntry(label: category.name, value: category)).toList());
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
              '全部需求',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.search,
                  size: 22,
                ),
                onPressed: () => showSearch(context: context, delegate: RequirementOrderSearchDelegate()),
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
                  FilterEntry('商品大类', () {
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
                  streamController: RequirementPoolBLoC.instance.conditionController,
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
                  streamController: RequirementPoolBLoC.instance.conditionController,
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
                  streamController: RequirementPoolBLoC.instance.conditionController,
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
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByCondition(currentCodition);
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
                builder: (BuildContext context, AsyncSnapshot<List<RequirementOrderModel>> snapshot) {
                  if (snapshot.data == null) {
                    //默认条件查询
                    bloc.filterByCondition(currentCodition);
                    return ProgressIndicatorFactory.buildPaddedProgressIndicator();
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
                        duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
                  }
                  return snapshot.data
                      ? Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Center(
                            child: Text(
                              "(￢_￢) 已经到底了",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : Container();
                },
              ),
              StreamBuilder<bool>(
                stream: bloc.loadingStream,
                initialData: false,
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  return ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
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
  const RequirementPoolOrderItem({Key key, this.order}) : super(key: key);

  final RequirementOrderModel order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //根据code查询明
        RequirementOrderModel model = await RequirementOrderRepository().getRequirementOrderDetail(order.code);

        List<QuoteModel> quotes =
            await RequirementOrderRepository().getRequirementOrderQuotes(code: model.code, page: 0, size: 1);

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
          children: <Widget>[_buildEntries()],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(200, 200, 200, 1)))),
      ),
    );
  }

  Widget _buildEntries() {
    Widget _pictureWidget;

    if (order.details.pictures == null) {
      _pictureWidget = Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromRGBO(243, 243, 243, 1)),
        child: Icon(
          B2BIcons.noPicture,
          color: Color.fromRGBO(200, 200, 200, 1),
          size: 60,
        ),
      );
    } else {
      if (order.details.pictures.isEmpty) {
        _pictureWidget = Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Color.fromRGBO(243, 243, 243, 1)),
          child: Icon(
            B2BIcons.noPicture,
            color: Color.fromRGBO(200, 200, 200, 1),
            size: 60,
          ),
        );
      } else {
        _pictureWidget = Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: NetworkImage('${GlobalConfigs.IMAGE_BASIC_URL}${order.details.pictures[0].url}'),
                fit: BoxFit.cover,
              )),
        );
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: <Widget>[
          _pictureWidget,
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[_buildRow1(), _buildRow2(), _buildRow3()],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRow1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 140,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Text(
                  '${order.details.category?.name}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, color: Color.fromRGBO(50, 50, 50, 1)),
                ),
              ),
              Text(
                '${order.details.expectedMachiningQuantity ?? 0}件',
                style: TextStyle(fontSize: 15, color: Color.fromRGBO(255, 149, 22, 1)),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(text: '￥', style: TextStyle(color: Color.fromRGBO(255, 45, 45, 1)), children: <TextSpan>[
            TextSpan(text: '${order.details.maxExpectedPrice ?? 0}', style: TextStyle(fontSize: 18))
          ]),
        )
      ],
    );
  }

  Widget _buildRow2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '交货日期: ${DateFormatUtil.formatYMD(order.details.expectedDeliveryDate)}',
          style: TextStyle(color: Color.fromRGBO(150, 150, 150, 1)),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 25,
            width: 65,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color.fromRGBO(255, 214, 12, 1)),
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
        Container(
          width: 20,
          height: 20,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                    'https://img.alicdn.com/imgextra/i2/33675276/O1CN01Y6p4Bt1oqS9FLTcm3_!!0-saturn_solar.jpg_220x220.jpg_.webp'),
                fit: BoxFit.cover,
              )),
        ),
        Expanded(
          flex: 1,
          child: Text(
            '${order.belongTo.name}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          padding: EdgeInsets.fromLTRB(3, 1, 3, 1),
          decoration: BoxDecoration(color: Color.fromRGBO(255, 243, 243, 1), borderRadius: BorderRadius.circular(10)),
          child: Text(
            "已认证",
            style: TextStyle(fontSize: 15, color: Color.fromRGBO(255, 133, 148, 1)),
          ),
        )
      ],
    );
  }
}
