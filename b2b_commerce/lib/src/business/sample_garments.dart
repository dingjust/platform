import 'package:b2b_commerce/src/_shared/widgets/scrolled_to_end_tips.dart';
import 'package:b2b_commerce/src/business/products/sample_product_history_item.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

import '../_shared/widgets/business/product_search_delegate_page.dart';
import '../_shared/widgets/scrolled_to_end_tips.dart';

import './products/sample_product_history_item.dart';
import './products/sample_product_history_form.dart';
import './products/sample_products.dart';

List<EnumModel> _states = <EnumModel>[
  EnumModel('ALL', '全部'),
  EnumModel('NOT_RETURNED', '未还'),
  EnumModel('RETURNED', '已还'),
];

class SampleGarmentsPage extends StatefulWidget {
  SampleGarmentsPageState createState() => SampleGarmentsPageState();
}

class SampleGarmentsPageState extends State<SampleGarmentsPage> {
  SampleBorrowReturnHistoryModel model = SampleBorrowReturnHistoryModel();
  LendBorrowType _type = LendBorrowType.BORROW;

  List<SampleBorrowReturnHistoryModel> _sampleProductHistoryList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Widget> _createWidgets(String state){
    return [
      GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SampleProductsPage())),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '我的样衣',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            if (_type == LendBorrowType.BORROW) {
              _type = LendBorrowType.LEND;
            } else {
              _type = LendBorrowType.BORROW;
            }
          });

          SampleProductHistoryBLoC.instance.filterByStatuses(state, _type.toString());
        },
        child: Card(
          elevation: 0,
          margin: EdgeInsets.only(bottom: 5),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 5),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _type == LendBorrowType.BORROW ? '借入样衣' : '借出样衣',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
//                  Text(
//                    '3',
//                    style: TextStyle(color: Color.fromRGBO(255, 214, 12, 1)),
//                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return BLoCProvider<SampleProductHistoryBLoC>(
      bloc: SampleProductHistoryBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          centerTitle: true,
          title: Text(_type == LendBorrowType.BORROW ? '样衣借出' : '样衣借入'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                B2BIcons.search,
                size: 20,
              ),
              onPressed: () => showSearch(
                    context: context,
                    delegate: ProductSearchDelegatePage(),
                  ),
            ),
          ],
        ),
        body: DefaultTabController(
          length: _states.length,
          child: Scaffold(
            appBar: TabBar(
              unselectedLabelColor: Colors.black26,
//              labelColor: Color.fromRGBO(255,214,12, 1),
              labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: _states.map((status) {
                return Tab(text: status.name);
              }).toList(),
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
              isScrollable: false,
            ),
            body: TabBarView(
              children: _states.map((state) {
                return SampleProductHistoryList(state.code,_type.toString(),_createWidgets(state.code));
//                  ListView(
//                  children: <Widget>[
//                    GestureDetector(
//                      onTap: () => Navigator.push(
//                          context,
//                          MaterialPageRoute(
//                              builder: (context) => SampleProductsPage())),
//                      child: Card(
//                        elevation: 0,
//                        margin: EdgeInsets.symmetric(vertical: 5),
//                        child: Padding(
//                          padding: EdgeInsets.only(left: 15, right: 5),
//                          child: Padding(
//                            padding: const EdgeInsets.symmetric(vertical: 15.0),
//                            child: Row(
//                              children: <Widget>[
//                                Expanded(
//                                  child: Text(
//                                    '我的样衣',
//                                    style: TextStyle(fontSize: 16),
//                                  ),
//                                ),
//                                Icon(Icons.chevron_right, color: Colors.grey),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    GestureDetector(
//                      onTap: () {
//                        setState(() {
//                          if (_type == LendBorrowType.BORROW) {
//                            _type = LendBorrowType.LEND;
//                          } else {
//                            _type = LendBorrowType.BORROW;
//                          }
//                        });
//                      },
//                      child: Card(
//                        elevation: 0,
//                        margin: EdgeInsets.only(bottom: 5),
//                        child: Padding(
//                          padding: const EdgeInsets.only(left: 15, right: 5),
//                          child: Padding(
//                            padding: const EdgeInsets.symmetric(vertical: 15.0),
//                            child: Row(
//                              children: <Widget>[
//                                Expanded(
//                                  child: Text(
//                                    _type == LendBorrowType.BORROW
//                                        ? '借入样衣'
//                                        : '借出样衣',
//                                    style: TextStyle(fontSize: 16),
//                                  ),
//                                ),
//                                Text(
//                                  '3',
//                                  style: TextStyle(color: Color.fromRGBO(255,214,12, 1)),
//                                ),
//                                Icon(Icons.chevron_right, color: Colors.grey),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                    SampleProductHistoryList(state.code),
//                  ],
//                );
              }).toList(),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) => SampleProductHistoryFormPage(model,isCreated: true,))),
        ),
      ),
    );
  }
}

class SampleProductHistoryList extends StatelessWidget {
  String state;
  String type;
  List<Widget> widgets;

  SampleProductHistoryList(this.state,this.type,this.widgets);

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgets = [];
    var bloc = BLoCProvider.of<SampleProductHistoryBLoC>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.loadingStart();
        bloc.loadingMoreByStatuses(state,type);
      }
    });

    //监听滚动事件，打印滚动位置
    _scrollController.addListener(() {
      if (_scrollController.offset < 500) {
        bloc.hideToTopBtn();
      } else if (_scrollController.offset >= 500) {
        bloc.showToTopBtn();
      }
    });

    //状态管理触发的返回顶部
    bloc.returnToTopStream.listen((data) {
      //返回到顶部时执行动画
      if (data) {
        _scrollController.animateTo(.0, duration: Duration(milliseconds: 200), curve: Curves.ease);
      }
    });

    return Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
//        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: RefreshIndicator(
          onRefresh: () async {
            return await bloc.filterByStatuses(state,type);
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              StreamBuilder<List<SampleBorrowReturnHistoryModel>>(
                stream: bloc.stream,
                // initialData: null,
                builder: (BuildContext context, AsyncSnapshot<List<SampleBorrowReturnHistoryModel>> snapshot) {
                  if (snapshot.data == null) {
                    bloc.filterByStatuses(state,type);
                    return ProgressIndicatorFactory.buildPaddedProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    _widgets.clear();
                    _widgets.addAll(widgets);
                    _widgets.addAll(snapshot.data
                        .map((borrowHistory) => SampleProductHistoryItem(
                              item: borrowHistory,
                      state: state,
                              type: type,
                            ))
                        .toList());
                    return Column(
                      children: _widgets,
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
                  return ScrolledToEndTips(hasContent: snapshot.data);
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
