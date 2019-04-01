import 'package:flutter/material.dart';

/// 滚动到列表的最后的提示信息
class ScrolledToEndTips extends StatelessWidget {
  const ScrolledToEndTips({Key key, this.hasContent = false});

  final bool hasContent;

  @override
  Widget build(BuildContext context) {
    return hasContent
        ? Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
            child: Center(
              child: Text(
                "(￢_￢)已经到底了",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        : Container();
  }
}
