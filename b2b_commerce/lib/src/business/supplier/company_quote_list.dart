import 'package:b2b_commerce/src/_shared/orders/quote/quote_list.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class CompanyQuoteListPage extends StatefulWidget{
  CompanyQuoteListPage({
    Key key,
    @required this.companyUid,
  }) : super(key: key);

  final String companyUid;

  _CompanyQuoteListPageState createState() => _CompanyQuoteListPageState();
}

class _CompanyQuoteListPageState extends State<CompanyQuoteListPage>{
  final GlobalKey _globalKey = GlobalKey<_CompanyQuoteListPageState>();

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
        body: QuoteList(companyUid: widget.companyUid),
        floatingActionButton: ScrollToTopButton<QuoteOrdersBLoC>(),
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
  }
}
