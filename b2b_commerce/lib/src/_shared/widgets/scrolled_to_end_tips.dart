import 'package:flutter/material.dart';

/// 滚动到列表的最后的提示信息
class ScrolledToEndTips extends StatefulWidget {
  final bool hasContent;

  final ScrollController scrollController;

  const ScrolledToEndTips({Key key, this.hasContent, this.scrollController})
      : super(key: key);

  @override
  _ScrolledToEndTipsState createState() => _ScrolledToEndTipsState();
}

class _ScrolledToEndTipsState extends State<ScrolledToEndTips> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollAction());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // scrollAction();
    if (widget.hasContent == null) {
      return Container();
    }
    return widget.hasContent
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

  void scrollAction() {
    if (widget.hasContent) {
      Future.delayed(Duration(milliseconds: 200)).then((e) {
        widget.scrollController.animateTo(widget.scrollController.offset - 40,
            duration: new Duration(milliseconds: 500), curve: Curves.easeOut);
      });
    }
  }
}
