import 'package:b2b_commerce/src/production/production_search_result.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:widgets/widgets.dart';

/// 生产搜索页
class ProductionSearchDelegate extends SearchDelegate<PurchaseOrderModel> {
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
    // TODO: 结果集
    return Container();
  }

  // @override
  void showResults(BuildContext context) {
    // TODO: implement showResults
    super.showResults(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductionResultPage(
                  keyword: query,
                )));
  }

  @override
  void showSuggestions(BuildContext context) {
    // TODO: implement showSuggestions
    super.showSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: 输入提示信息
    return Container(
      child: query == ''
          ? _buildHistoryListView(context)
          : _buildSuggestionsListView(context),
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
            children: <Widget>[
              HistoryTag(
                value: 'NA12314412313',
                onTap: () {},
              ),
              HistoryTag(
                  value: '鸭绒羽绒服',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductionResultPage()));
                  }),
              HistoryTag(value: '潮流', onTap: () {}),
              HistoryTag(value: 'ＡＩＯＪＯＪＩＯＡ', onTap: () {}),
              HistoryTag(value: '冬季款', onTap: () {}),
              HistoryTag(value: '女装', onTap: () {}),
              HistoryTag(value: '男装', onTap: () {}),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSuggestionsListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        SuggestionsRow(
          value: query,
          onIconPressed: () {
            query = query;
          },
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductionResultPage(
                          keyword: query,
                        )));
          },
        ),
        SuggestionsRow(
          value: '${query} 1',
          onIconPressed: () {
            query = '${query} 1';
          },
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductionResultPage(
                          keyword: '${query} 1',
                        )));
          },
        ),
        SuggestionsRow(
          value: '${query} 2',
          onIconPressed: () {
            query = '${query} 2';
          },
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductionResultPage(
                          keyword: '${query} 2',
                        )));
          },
        ),
        SuggestionsRow(
          value: '${query} 3',
          onIconPressed: () {
            query = '${query} 3';
          },
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductionResultPage(
                          keyword: '${query} 3',
                        )));
          },
        )
      ],
    );
  }
}
