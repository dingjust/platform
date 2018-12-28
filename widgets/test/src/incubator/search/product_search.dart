import 'package:flutter/material.dart';
import 'package:models/models.dart';

/// 查询示例
class ProductSearchPage extends StatefulWidget {
  @override
  _ProductSearchPageState createState() => new _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('查询'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(context: context, delegate: ProductSearchDelegate()),
          ),
        ],
      ),
    );
  }
}

class ProductSearchDelegate extends SearchDelegate<ProductModel> {
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
    return Container(child: Text(query));
  }
}
