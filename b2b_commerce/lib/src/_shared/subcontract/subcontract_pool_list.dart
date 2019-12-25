import 'dart:convert';

import 'package:b2b_commerce/src/_shared/subcontract/subcontract_list_item.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_pool_detail.dart';
import 'package:b2b_commerce/src/business/subcontract/subcontract_pool_filter.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<RegionModel> _regionSelects = [];
  List<RegionModel> _regions = [];

  bool showDateFilterMenu = false;

  List<FilterConditionEntry> dateRangeConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(
        label: '全部', value: null, checked: true),
    FilterConditionEntry(
        label: '3天内', value: 3),
    FilterConditionEntry(
        label: '7天内', value: 7),
    FilterConditionEntry(
        label: '15天内', value: 15),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building------------');
    return Consumer(
      builder: (context, SubContractPoolState subContractPoolState,_) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.5,
          leading: Container(),
          bottom: PreferredSize(
              preferredSize: Size(double.infinity, 0),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            subContractPoolState.showDateFilterMenu = !subContractPoolState.showDateFilterMenu;
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  subContractPoolState.newDate == null ? '最新发布' : '${subContractPoolState.newDate}天内',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                subContractPoolState.newDate == null
                                    ? Icon(Icons.keyboard_arrow_down)
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  ObjectUtil.isEmptyList(subContractPoolState.regions) ? '地区' : subContractPoolState.regions[0]?.name ?? '',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          onTap: (){
                            subContractPoolState.showDateFilterMenu = false;
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
                                  return RegionSelector(
                                    regions: _regions,
                                    regionSelects: _regionSelects,
                                  );
                                },
                              ).then((val) {
                                print('${subContractPoolState.regions}');
                                subContractPoolState.regions = _regionSelects;
                              });
                            });
                          },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Consumer(
                        builder: (context,
                            CategoryState categoryState,_) =>GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            subContractPoolState.showDateFilterMenu = false;
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return FutureBuilder(
                                          future: categoryState
                                              .getCascadedCategories(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<CategoryModel>>
                                              snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                  child:
                                                  CircularProgressIndicator());
                                            } else {
                                              return SingleCategorySelect(
                                                  selectLeft: subContractPoolState.category != null ? subContractPoolState.category?.parent?.code : null,
                                                  categories: snapshot.data,
                                                  categorySelect: subContractPoolState.category,
                                                  onItemTap: (categoryModel) {
                                                    if(subContractPoolState.category != null && subContractPoolState.category.code == categoryModel.code){
                                                      subContractPoolState.category = null;
                                                    }else{
                                                      subContractPoolState.category = categoryModel;
                                                    }

                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                            }
                                          },
                                  );
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  subContractPoolState.category?.name ?? '品类',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: (){
                            subContractPoolState.showDateFilterMenu = false;
                            _scaffoldKey.currentState.openEndDrawer();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '筛选',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Icon(Icons.menu),
                              ],
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              )),
        ),
        endDrawer: Drawer(
          child:  SubContractFilterPage(subContractPoolState:subContractPoolState),
        ),
        body: Column(
          children: <Widget>[
            Container(
                color: Colors.white,
                height: subContractPoolState.showDateFilterMenu ? 200 : 0,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: dateRangeConditionEntries
                      .map((entry) => GestureDetector(
                    onTap: () {
                      dateRangeConditionEntries.forEach((dateEntry){
                        dateEntry.checked = false;
                      });
                      entry.checked = true;
                      subContractPoolState.newDate = entry.value;
//                      subContractPoolState.showDateFilterMenu = !subContractPoolState.showDateFilterMenu;
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(40, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${entry.label}',
                            style: TextStyle(
                                fontSize: 15,
                                color: entry.checked
                                    ? Color.fromRGBO(255, 214, 12, 1)
                                    : Colors.black),
                          ),
                          entry.checked
                              ? Icon(
                            Icons.done,
                            color: Color.fromRGBO(255, 214, 12, 1),
                            size: 18,
                          )
                              : Container()
                        ],
                      ),
                    ),
                  ))
                  .toList(),
              )),
            Divider(height: 0,),
            Expanded(
              child: SubContractListView(subContractPoolState:subContractPoolState),
            )
          ],
        ),


      ),
    );
  }


}

class SubContractListView extends StatefulWidget {
  SubContractPoolState subContractPoolState;
  SubContractListView({this.subContractPoolState});
  _SubCOntractListViewState createState() => _SubCOntractListViewState();
}

class _SubCOntractListViewState extends State<SubContractListView>{
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
    return Center(child:RefreshIndicator(
        onRefresh: () async {
          widget.subContractPoolState.clear();
        },
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: _buildItems(),
            ),
            ProgressIndicatorFactory.buildPaddedOpacityProgressIndicator(
              opacity: widget.subContractPoolState.loadingMore ? 1.0 : 0,
            ),
            _buildEnd(),
          ],
        ),
      ),
    );

  }

  Widget _buildItems() {
    return Column(
        children: widget.subContractPoolState.subcontractModels != null
            ? widget.subContractPoolState.subcontractModels.map((model) {
          return _buildRow(model);
        }).toList()
            : [Center(
          child: CircularProgressIndicator(),
        )]);
  }

  Widget _buildRow(SubContractModel model) {
    return Column(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            Navigator.push(context,MaterialPageRoute(builder: (context) => SubContractPoolDetailPage(model.code)));

          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SubContractListItem(
              model: model,
            ),
          ),
        ),
        Divider(height: 0,)
      ],
    );
  }

  Widget _buildEnd() {
    return widget.subContractPoolState.isDownEnd
        ? Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('已经到底了')],
      ),
    )
        : Container();
  }
}


