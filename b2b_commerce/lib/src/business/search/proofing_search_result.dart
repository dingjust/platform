import 'package:b2b_commerce/src/_shared/orders/proofing/proofing_list.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class ProofingSearchResultPage extends StatefulWidget{
  ProofingSearchResultPage({
    Key key,
    @required this.keyword,
  }) : super(key: key);

  final String keyword;

  _ProofingSearchResultPageState createState() => _ProofingSearchResultPageState();
}

class _ProofingSearchResultPageState extends State<ProofingSearchResultPage>{
  final GlobalKey _globalKey = GlobalKey<_ProofingSearchResultPageState>();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<ProofingOrdersBLoC>(
      key: _globalKey,
      bloc: ProofingOrdersBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          title: Text('查询结果'),
          elevation: 0.5,
          centerTitle: true,
        ),
        body: ProofingList(keyword: widget.keyword,),
        floatingActionButton: ScrollToTopButton<ProofingOrdersBLoC>(),
      ),
    );
  }
}
