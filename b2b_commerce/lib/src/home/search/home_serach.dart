import 'dart:convert';

import 'package:b2b_commerce/src/common/app_image.dart';
import 'package:b2b_commerce/src/common/app_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
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

  //TODO:写死
  List<String> _recommendKeywords;

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
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: true,
          title: Row(
            children: <Widget>[
              Expanded(
                  child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  width: constraints.maxWidth,
                  height: 50,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        height: 32,
                        decoration: BoxDecoration(
                          // color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: Color(0xFFFED800), width: 1),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          width: constraints.maxWidth,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  autofocus: true,
                                  style: TextStyle(
                                      color: Color(0xff222222),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
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
                                    child:
                                        B2BV2Image.del1(width: 15, height: 15)),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              )),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                width: 64,
                height: 32,
                child: FlatButton(
                    child: Text(
                      '搜索',
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    color: Color(0xFFFED800),
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
          color: Color(0xffF7F7F7),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '历史搜索',
                        style: TextStyle(
                            color: Color(0xff222222),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                        icon: B2BV2Image.del2(width: 15, height: 16),
                        onPressed: onDel)
                  ],
                ),
              ),
              FutureBuilder<List<String>>(
                  future: getLocalHistory(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        _historyKeywords != null) {
                      return Container(
                        // padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        child: Wrap(
                            spacing: 8.0, // 主轴(水平)方向间距
                            runSpacing: 0, // 纵轴（垂直）方向间距
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
                  }),
              Container(
                margin: EdgeInsets.only(top: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '热门推荐',
                        style: TextStyle(
                            color: Color(0xff222222),
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                  future: getRecommendWords(),
                  builder: (context, snapshot) {
                    if (_recommendKeywords != null) {
                      return Container(
                        child: Wrap(
                            spacing: 8.0, // 主轴(水平)方向间距
                            runSpacing: 0, // 纵轴（垂直）方向间距
                            alignment: WrapAlignment.start, //沿主轴方向居中
                            children: _recommendKeywords
                                .map((keyword) => HistoryTag(
                                      value: keyword,
                                      onTap: () {
                                        onSearch(keyword);
                                      },
                                    ))
                                .toList()),
                      );
                    }
                    return Container();
                  }),
            ],
          ),
        ));
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

  ///获取推荐关键字
  Future<List<String>> getRecommendWords() async {
    if (_recommendKeywords == null) {
      List<String> words = await RecommendWordsRepository.get();
      if (words != null) {
        setState(() {
          _recommendKeywords = words;
        });
      }
    }
    return _recommendKeywords;
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

  void onDel() {
    showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text('确认删除全部历史记录？'),
          // content: Text('我是content'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('确认'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  List<String> historyKeywords = [];
                  _historyKeywords = historyKeywords;
                  LocalStorage.save(_key, json.encode(_historyKeywords));
                });
              },
            ),
          ],
        ));
  }
}
