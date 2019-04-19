import 'package:b2b_commerce/src/_shared/orders/quote/quote_list.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class QuoteSearchResultPage extends StatefulWidget{
  QuoteSearchResultPage({
    Key key,
    @required this.keyword,
  }) : super(key: key);

  final String keyword;

  _QuoteSearchResultPageState createState() => _QuoteSearchResultPageState();
}

class _QuoteSearchResultPageState extends State<QuoteSearchResultPage>{
  final GlobalKey _globalKey = GlobalKey<_QuoteSearchResultPageState>();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<QuoteOrdersBLoC>(
      key: _globalKey,
      bloc: QuoteOrdersBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          title: Text('查询结果'),
          elevation: 0.5,
          centerTitle: true,
        ),
        body: QuoteList(keyword: widget.keyword,),
        floatingActionButton: ScrollToTopButton<QuoteOrdersBLoC>(),
      ),
    );
  }
}
