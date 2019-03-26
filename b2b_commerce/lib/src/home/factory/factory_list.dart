import 'package:b2b_commerce/src/home/factory/condition_page.dart';
import 'package:b2b_commerce/src/home/factory/factory.dart';
import 'package:b2b_commerce/src/home/search/quick_reaction_factory_search.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FactoryPage extends StatefulWidget {
  String route;

  /// 邀请工厂报价的需求订单号
  String requirementCode;

  FactoryPage({this.route});

  _FactoryPageState createState() => _FactoryPageState();
}

class _FactoryPageState extends State<FactoryPage> {
  GlobalKey _FactoryBLoCProviderKey = GlobalKey();

  List<FilterConditionEntry> filterConditionEntries = <FilterConditionEntry>[
    FilterConditionEntry(label: '综合', value: 'comprehensive', checked: true),
    FilterConditionEntry(label: '星级', value: 'starLevel'),
    FilterConditionEntry(label: '接单数', value: 'orderNum'),
  ];

  FilterConditionEntry currentCondition =
      FilterConditionEntry(label: '综合', value: 'comprehensive', checked: true);

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<FactoryBLoC>(
        key: _FactoryBLoCProviderKey,
        bloc: FactoryBLoC.instance,
        child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            centerTitle: true,
            elevation: 0.5,
            title: Text(
              widget.route ?? '全部工厂',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  B2BIcons.search,
                  size: 22,
                ),
                onPressed: () => showSearch(
                    context: context,
                    delegate: QuickReactionFactorySearchDelegate()),
              ),
            ],
          ),
          body: Scaffold(
              appBar: AppBar(
                elevation: 0,
                bottom: FilterBar(
                  onChanged: (condition) => changeCondition(condition),
                  filterConditionEntries: filterConditionEntries,
                  action: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () async {
                      await ProductRepositoryImpl()
                          .majorCategories()
                          .then((categories) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CondtionPage(
                                  categories: categories,
                                )));
                      });
                    },
                  ),
                ),
              ),
              body: FactoriesListView()),
        ));
  }

  void changeCondition(FilterConditionEntry condition) {
    setState(() {
      currentCondition = condition;
    });
  }
}

class FactoriesListView extends StatelessWidget {
  ScrollController _scrollController = ScrollController();

  ///当前选中条件
  FilterConditionEntry currentCondition =
      FilterConditionEntry(label: '综合', value: 'comprehensive', checked: true);

  @override
  Widget build(BuildContext context) {
    var bloc = BLoCProvider.of<FactoryBLoC>(context);

    //监听筛选条件更改
    bloc.conditionStream.listen((condition) {
      this.currentCondition = condition;
      //清空数据
      bloc.clear();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByCondition(
            condition: currentCondition.value, isDESC: currentCondition.isDESC);
      }
    });

    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: RefreshIndicator(
          onRefresh: () async {
            return await bloc.refreshData(
                condition: currentCondition.value,
                isDESC: currentCondition.isDESC);
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
                    //默认条件查询
                    bloc.filterByCondition(
                        condition: this.currentCondition.value,
                        isDESC: this.currentCondition.isDESC);
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 200),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data.map((item) {
                        return FactoryItem(
                          model: item,
                          showButton: true,
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
                        duration: new Duration(milliseconds: 500),
                        curve: Curves.easeOut);
                  }
                  return snapshot.data
                      ? Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                          child: Center(
                            child: Text(
                              "┑(￣Д ￣)┍ 已经到底了",
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
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Opacity(
                        opacity: snapshot.data ? 1.0 : 0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
