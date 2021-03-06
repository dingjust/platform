import 'package:b2b_commerce/src/production/production_search.dart';
import 'package:flutter/material.dart';
import 'package:widgets/widgets.dart';

/// 生产搜索框
class ProductionSearchInputBox extends StatelessWidget {
  // final
  final double width;
  final double height;
  final String tips;

  const ProductionSearchInputBox(
      {Key key, this.width = 400, this.height = 30, this.tips})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          showSearch(context: context, delegate: ProductionSearchDelegate()),
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(242, 242, 242, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              B2BIcons.search,
              color: Colors.grey,
              size: 18,
            ),
            Text(
              tips == null ? '   找点什么...' : tips,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
