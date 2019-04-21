import 'dart:convert';

import 'package:b2b_commerce/src/home/factory/factory_list.dart';
import 'package:b2b_commerce/src/home/product/order_product.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 品牌首页搜索
class BrandIndexSearchDelegatePage extends SearchDelegate<String> {
  List<String> history_keywords;

  BrandIndexSearchDelegatePage() {
    getHistory();
  }

  List<FilterConditionEntry> entries = <FilterConditionEntry>[
    FilterConditionEntry(label: '工厂', value: 'factory', checked: true),
    FilterConditionEntry(
      label: '款式',
      value: 'product',
    )
  ];

  //获取本地搜索历史记录
  void getHistory() async {
    //解析
    String jsonStr =
        await LocalStorage.get(GlobalConfigs.BRAND_INDEX_HISTORY_KEYWORD_KEY);
    if (jsonStr != null && jsonStr != '') {
      List<dynamic> list = json.decode(jsonStr);
      history_keywords = list.map((item) => item as String).toList();
    } else {
      history_keywords = [];
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query != ''
          ? IconButton(
              icon: Icon(
                B2BIcons.del_blank_card,
                size: 15,
              ),
              onPressed: () {
                query = '';
              },
            )
          : Container(),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  // @override
  void showResults(BuildContext context) {
    super.showResults(context);
    //记录搜索关键字
    if (query != '' && query.isNotEmpty) {
      history_keywords.add(query);
      LocalStorage.save(GlobalConfigs.BRAND_INDEX_HISTORY_KEYWORD_KEY,
          json.encode(history_keywords));
    }

    _jumpToResult(context, query);
  }

  @override
  void showSuggestions(BuildContext context) {
    super.showSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Scaffold(
      appBar: IndexSearchBar(entries: entries),
      body: Container(child: _buildHistoryListView(context)),
    );
  }

  Widget _buildHistoryListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
          child: Text(
            '历史搜索',
            style: TextStyle(
                color: Color.fromRGBO(100, 100, 100, 1), fontSize: 18),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
          child: Wrap(
              spacing: 8.0, // 主轴(水平)方向间距
              runSpacing: 4.0, // 纵轴（垂直）方向间距
              alignment: WrapAlignment.start, //沿主轴方向居中
              children: history_keywords
                  .map((keyword) => HistoryTag(
                        value: keyword,
                        onTap: () {
                          _jumpToResult(context, keyword);
                        },
                      ))
                  .toList()),
        )
      ],
    );
  }

  void _jumpToResult(BuildContext context, String keyword) async {
    entries.forEach((entry) {
      if (entry.checked) {
        if (entry.value == 'factory') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FactoryPage(
                    FactoryCondition(
                        starLevel: 0,
                        adeptAtCategories: [],
                        labels: [],
                        cooperationModes: [],
                        keyword: keyword),
                    route: '全部工厂',
                  ),
            ),
          );
        } else {
          // 加载条
          showDialog(
            context: context,
            builder: (context) =>
                ProgressIndicatorFactory.buildDefaultProgressIndicator(),
          );
          jumpToProducts(context,keyword);
        }
      }
    });
  }

  void jumpToProducts(BuildContext context,String keyword) async {
    await ProductRepositoryImpl().cascadedCategories().then((categories) {
      Navigator.of(context).pop();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProductsPage(keyword: keyword,),
        ),
      );
    });
  }
}
