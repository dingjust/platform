import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 产品搜索页
class QuotesSearchDelegate extends SearchDelegate<QuoteEntryModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.done),
        onPressed: () => close(context, null), //TODO: 选中的数据返回到前一页
      ),
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
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
    return Container(child: Text(query));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: 输入提示信息
    return Container(child: Text(''));
  }
}
