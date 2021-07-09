import 'dart:convert';

import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

class HomeSearchPage extends StatefulWidget {
  final String keyword;

  const HomeSearchPage({Key key, this.keyword}) : super(key: key);

  @override
  _HomeSearchPageState createState() => _HomeSearchPageState();
}

class _HomeSearchPageState extends State<HomeSearchPage> {
  final String _key = GlobalConfigs.Requirement_HISTORY_KEYWORD_KEY;
  TextEditingController controller;
  FocusNode focusNode;
  List<String> _historyKeywords;

  @override
  void initState() {
    controller = TextEditingController(text: widget?.keyword ?? '');
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.5,
          automaticallyImplyLeading: true,
          title: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: LayoutBuilder(
                    builder: (context, constraints) => Container(
                      width: constraints.maxWidth,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.grey[300], width: 0.5),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              width: constraints.maxWidth,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: TextField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: '搜索关键字',
                                        hintStyle: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                        contentPadding: EdgeInsets.all(0),
                                        disabledBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                  Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          controller.text = '';
                                        });
                                      },
                                      child: Icon(
                                        Icons.clear,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  )),
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                width: 70,
                height: 32,
                child: FlatButton(
                    child: Text(
                      '搜索',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    onPressed: () {
                      String keyword = controller.text;
                      if (_historyKeywords == null) {
                        _historyKeywords = [];
                      }
                      if (keyword != null &&
                          keyword != '' &&
                          (!_historyKeywords.contains(keyword))) {
                        //记录
                        _historyKeywords.add(keyword);
                        LocalStorage.save(_key, json.encode(_historyKeywords));
                      }

                      onSearch(keyword ?? '');
                    }),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              _buildHistoryListView(),
            ],
          ),
        ));
  }

  //历史搜索部分
  Widget _buildHistoryListView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '历史记录',
                  style: TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1), fontSize: 18),
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    List<String> historyKeywords = [];
                    _historyKeywords = historyKeywords;
                    LocalStorage.save(_key, json.encode(_historyKeywords));
                  });
                },
              )
            ],
          ),
        ),
        FutureBuilder<List<String>>(
            future: getLocalHistory(),
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  _historyKeywords != null) {
                return Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                  child: Wrap(
                      spacing: 8.0, // 主轴(水平)方向间距
                      runSpacing: 4.0, // 纵轴（垂直）方向间距
                      alignment: WrapAlignment.start, //沿主轴方向居中
                      children: _historyKeywords
                          .map((keyword) => HistoryTag(
                                value: keyword,
                                onTap: () {
                                  onSearch(keyword);
                                },
                              ))
                          .toList()),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            })
      ],
    );
  }

  Future<List<String>> getLocalHistory() async {
    if (_historyKeywords == null) {
      dynamic value = await LocalStorage.get(_key);
      if (value != null && value != '') {
        List<dynamic> list = json.decode(value);
        if (list != null) {
          _historyKeywords = list.map((item) => item as String).toList();
        }
      } else {
        _historyKeywords = [];
      }
    }
    return _historyKeywords;
  }

  void onSearch(String keyword) {
    Navigator.of(context).pushNamed(AppRoutes.ROUTE_HOME_SEARCH_RESULT,
        arguments: {'keyword': keyword}).then((value) {
      //刷新历史记录
      setState(() {
        _historyKeywords = null;
      });
    });
  }
}
