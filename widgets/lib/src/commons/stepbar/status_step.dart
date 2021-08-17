import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class StatusStep extends StatefulWidget {
  //状态数组
  final List<OrderStatusModel> list;

  //当前订单状态
  final String currentStatus;

  //是否能滚动
  final bool? isScroll;

  //主键宽度
  final double? width;

  //主键高度
  final double? height;

  //未完成颜色
  final Color notActiveColor;

  ///未完成边颜色
  final Color notActiveBorderColor;

  //已完成颜色
  final Color activeBorderColor;

  ///已完成边颜色
  final Color activeColor;

  //当前进度颜色
  final Color nowActiveColor;

  ///当前进度边颜色
  final Color nowActiveBorderColor;

  StatusStep(
      {required this.list,
      required this.currentStatus,
      this.isScroll,
      this.width,
      this.height,
      this.notActiveColor = const Color.fromRGBO(237, 237, 237, 1.0),
      this.activeColor = const Color.fromRGBO(255, 239, 221, 1.0),
      this.nowActiveColor = const Color.fromRGBO(255, 214, 12, 1),
      this.notActiveBorderColor = const Color.fromRGBO(180, 180, 180, 1.0),
      this.activeBorderColor = const Color.fromRGBO(255, 161, 71, 1.0),
      this.nowActiveBorderColor = Colors.deepOrange});

  _StatusStepStates createState() => _StatusStepStates();
}

class _StatusStepStates extends State<StatusStep> {
  final List<Widget> _widgetList = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width != null ? widget.width : double.infinity,
      height: widget.height != null ? widget.height : 80,
      padding: EdgeInsets.all(10),
      child: Center(
        child: ListView(
          //是否能滚动
          physics: widget.isScroll != null && widget.isScroll == false
              ? new NeverScrollableScrollPhysics()
              : null,
          padding: EdgeInsets.all(0),
          scrollDirection: Axis.horizontal,
          children: _bildStatusIcon(context),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  List<Widget> _bildStatusIcon(BuildContext context) {
    int _index = 0;
    for (int i = 0; i < widget.list.length; i++) {
      if (widget.list[i].name == widget.currentStatus) {
        _index = i;
      }
    }
    for (int i = 0; i < widget.list.length; i++) {
      _widgetList.add(Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        height: 75,
        width: 75,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 18,
                left: 55,
                child: widget.list.length == i + 1
                    ? Container(
                        margin: EdgeInsets.all(0),
                        height: 0,
                        width: 0,
                        color: _index > i
                            ? widget.activeColor
                            : widget.notActiveColor,
                      )
                    : Container(
                        margin: EdgeInsets.all(0),
                        height: 2,
                        width: 80,
                        color: _index > i
                            ? widget.activeColor
                            : widget.notActiveColor,
                      )),
            Positioned(
                top: _index == i ? 4 : 8,
                left: 10.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: _index == i ? 30 : 20.0,
                      width: _index == i ? 30 : 20.0,
                      child: Container(
                        height: _index == i ? 30 : 20.0,
                        width: _index == i ? 30 : 20.0,
                        decoration: _index == i
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.activeColor,
                                border:
                                    Border.all(color: widget.activeBorderColor))
                            : BoxDecoration(
                                shape: BoxShape.circle,
                                color: _index > i
                                    ? widget.activeColor
                                    : widget.notActiveColor,
                                border: Border.all(
                                    color: _index > i
                                        ? widget.activeBorderColor
                                        : widget.notActiveBorderColor)),
                        child: _index > i
                            ? Icon(
                                Icons.check,
                                color: widget.activeBorderColor,
                                size: 15,
                              )
                            : null,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          widget.list[i].name,
                          style: TextStyle(
                              fontSize: 14,
                              color: _index >= i
                                  ? widget.activeBorderColor
                                  : widget.notActiveBorderColor),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ));
    }
    return _widgetList;
  }
}
