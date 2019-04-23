import 'package:b2b_commerce/src/_shared/orders/requirement/requirement_order_list.dart';
import 'package:b2b_commerce/src/_shared/widgets/scroll_to_top_button.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';

class RequirementSearchResultPage extends StatefulWidget{
  RequirementSearchResultPage({
    Key key,
    @required this.keyword,
  }) : super(key: key);

  final String keyword;

  _RequirementSearchResultPageState createState() => _RequirementSearchResultPageState();
}

class _RequirementSearchResultPageState extends State<RequirementSearchResultPage>{
  final GlobalKey _globalKey = GlobalKey<_RequirementSearchResultPageState>();

  @override
  Widget build(BuildContext context) {
    return BLoCProvider<RequirementOrderBLoC>(
      key: _globalKey,
      bloc: RequirementOrderBLoC.instance,
      child: Scaffold(
        appBar: AppBar(
          title: Text('查询结果'),
          elevation: 0.5,
          centerTitle: true,
        ),
        body: RequirementOrderList(keyword: widget.keyword,),
        floatingActionButton: ScrollToTopButton<RequirementOrderBLoC>(),
      ),
    );
  }
}
