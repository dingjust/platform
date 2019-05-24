import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

/// 产品搜索页
class AmapSearchDelegatePage extends SearchDelegate<Tip> {
  final String city;

  AmapSearchDelegatePage({this.city});

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return super.appBarTheme(context);
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
    // if (query != '' && query.isNotEmpty) {
    //   if (history_keywords.contains(query)) {
    //     history_keywords.remove(query);
    //   }
    //   history_keywords.add(query);
    //   LocalStorage.save(GlobalConfigs.PRODUCT_HISTORY_KEYWORD_KEY,
    //       json.encode(history_keywords));
    // }
    // Navigator.pop(context,ApparelProductModel(name: query));
  }

  @override
  void showSuggestions(BuildContext context) {
    super.showSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(child: _buildSuggestionsListView(context));
  }

  /// 提示
  Widget _buildSuggestionsListView(BuildContext context) {
    return FutureBuilder<AmapResponse>(
      builder: (BuildContext context, AsyncSnapshot<AmapResponse> snapshot) {
        if (snapshot.data != null) {
          return ListView(
              children: snapshot.data.tips
                  .map(
                    (tip) => SuggestionsRow(
                  value: tip.name,
                  address: tip.address,
                  location: tip.location,
                  onIconPressed: () {
                    query = tip.name;
                  },
                  onTap: () {
                    Navigator.of(context).pop(tip);
                  },
                ),
              )
                  .toList());
        } else {
          return Container();
        }
      },
      initialData: null,
      future: AmapService.instance.inputtips(query, city: city),
    );
  }
}
