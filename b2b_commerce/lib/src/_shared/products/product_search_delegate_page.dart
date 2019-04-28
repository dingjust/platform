import 'dart:convert';

import 'package:b2b_commerce/src/business/apparel_products.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 产品搜索页
class ProductSearchDelegatePage extends SearchDelegate<ApparelProductModel> {
  List<String> history_keywords;
  bool isSelectOption;

  ProductSearchDelegatePage({
    this.isSelectOption,
  }){
    getHistory();
  }

  //获取本地搜索历史记录
  void getHistory() async {
    //解析
    String jsonStr =
        await LocalStorage.get(GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY);
    if (jsonStr != null && jsonStr != '') {
      List<dynamic> list = json.decode(jsonStr);
      history_keywords = list.map((item) => item as String).toList();
      print(history_keywords);
    } else {
      history_keywords = [];
    }
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // IconButton(
      //   icon: Icon(Icons.done),
      //   onPressed: () => close(context, null), //TODO: 选中的数据返回到前一页
      // ),
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
      if (history_keywords.contains(query)) {
        history_keywords.remove(query);
      }
      history_keywords.add(query);
      LocalStorage.save(GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY,
          json.encode(history_keywords));
    }
    Navigator.pop(context,ApparelProductModel(name: query));
  }

  @override
  void showSuggestions(BuildContext context) {
    super.showSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(child: _buildHistoryListView(context));
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
                          Navigator.pop(context,ApparelProductModel(name: keyword));
                        },
                      ))
                  .toList()),
        )
      ],
    );
  }

  /// 提示
  // Widget _buildSuggestionsListView(BuildContext context) {
  //   return ListView(
  //     children: <Widget>[
  //       SuggestionsRow(
  //         value: query,
  //         onIconPressed: () {
  //           query = query;
  //         },
  //         onTap: () {
  //           Navigator.pop(context);
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => ProductSearchResultPage(
  //                         keyword: query,
  //                       )));
  //         },
  //       ),
  //       SuggestionsRow(
  //         value: '${query} 1',
  //         onIconPressed: () {
  //           query = '${query} 1';
  //         },
  //         onTap: () {
  //           Navigator.pop(context);
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => ProductSearchResultPage(
  //                         keyword: '${query} 1',
  //                       )));
  //         },
  //       ),
  //       SuggestionsRow(
  //         value: '${query} 2',
  //         onIconPressed: () {
  //           query = '${query} 2';
  //         },
  //         onTap: () {
  //           Navigator.pop(context);
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => ProductSearchResultPage(
  //                         keyword: '${query} 2',
  //                       )));
  //         },
  //       ),
  //       SuggestionsRow(
  //         value: '${query} 3',
  //         onIconPressed: () {
  //           query = '${query} 3';
  //         },
  //         onTap: () {
  //           Navigator.pop(context);
  //           Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                   builder: (context) => ProductSearchResultPage(
  //                         keyword: '${query} 3',
  //                       )));
  //         },
  //       )
  //     ],
  //   );
  // }
}
