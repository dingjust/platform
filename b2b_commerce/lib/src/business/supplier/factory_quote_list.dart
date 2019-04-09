import 'package:b2b_commerce/src/_shared/orders/quote/quote_list.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class FactoryQuoteListPage extends StatefulWidget{
  FactoryQuoteListPage({
    Key key,
    @required this.factoryUid,
  }) : super(key: key);

  final String factoryUid;

  _FactoryQuoteListPageState createState() => _FactoryQuoteListPageState();
}

class _FactoryQuoteListPageState extends State<FactoryQuoteListPage>{
  final GlobalKey _globalKey = GlobalKey<_FactoryQuoteListPageState>();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<QuoteOrdersBLoC>(
      key: _globalKey,
      bloc: QuoteOrdersBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          title: Text('全部报价单'),
          elevation: 0.5,
          centerTitle: true,
        ),
        body: QuoteList(factoryUid: widget.factoryUid,),
        floatingActionButton: ScrollToTopButton<QuoteOrdersBLoC>(),
      ),
    );
  }
}
