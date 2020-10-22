import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FabricRequirementListItem extends StatefulWidget {
  _FabricRequirementListItem createState() => _FabricRequirementListItem();
}
  
class _FabricRequirementListItem extends State<FabricRequirementListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildBody(),
          _buildFoot()
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white
      ),
    );
  }

  Widget _buildBody() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 80.0,
          height: 80.0,
          child: DecoratedBox(
            decoration: BoxDecoration(color: Colors.red)
          )
        ),
        Expanded(
          child: Container(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text("黑色女式T恤潮流个性动感高档")
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("130米"),
                )
              ],
            )
          ),
        )
      ],
    );
  }

  Widget _buildFoot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text("发布时间：2018-12-25"),
        Text("有效期：7天")
      ],
    );
  }
}