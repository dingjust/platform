import 'package:b2b_commerce/src/business/orders/fabric/fabric_requirement_list_item.dart';
import 'package:flutter/cupertino.dart';

class FabricRequirementListPage extends StatefulWidget {
  _FabricRequirementListPage createState() => _FabricRequirementListPage();
}

class _FabricRequirementListPage extends State<FabricRequirementListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FabricRequirementList(),
    );
  }
}

class FabricRequirementList extends StatelessWidget {

  FabricRequirementList({Key key}) : super(key: key);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    //监听加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("--------------------------------------");
      }
    });

    return Container(
      child: ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Column(
            children: <Widget>[
              FabricRequirementListItem(),
              FabricRequirementListItem()
            ],
          ),
          // _buildEnd()
        ],
      ),
    );
  }

  Widget _buildEnd() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('已经到底了')]
      ),
    );
  }
}
  